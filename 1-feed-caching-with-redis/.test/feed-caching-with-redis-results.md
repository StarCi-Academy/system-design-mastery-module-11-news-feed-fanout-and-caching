# L1 — Feed Caching with Redis: E2E Test Results

**Stack:** NestJS + PostgreSQL 16 + Redis 7 (ZSET timeline cache)
**Port:** 3014 (host) → 3000 (container)
**Date:** 2026-05-22

## Setup fixes

- Image → `starciacademy/system-design-feed-caching-with-redis-feed-cache-service:latest`.
- Port 3000 → 3014; `synchronize: false`; bỏ host port mapping DB/Redis.

## Flow 1 — POST /api/feed/cache/seed?userId=usr_1

```json
{"userId":"usr_1","cacheKey":"feed:usr_1","source":"postgres","cachedPosts":3,"maxCachedItems":500}
```
✅ Seed 3 posts từ Postgres vào Redis ZSET `feed:usr_1` với score = unix timestamp.

## Flow 2 — GET /api/feed/cache?userId=usr_1

```json
{"model":"redis-zset-feed-cache","cacheKey":"feed:usr_1",
 "readPattern":"ZREVRANGE returns the newest cached feed items first.",
 "timeline":[{"postId":"post_103","score":1748390440000},{"postId":"post_102",...},{"postId":"post_101",...}]}
```
✅ ZREVRANGE trả về newest-first; score = epoch ms để sort ổn định.

## Edge case — ZREMRANGEBYRANK trim 500

Inject 600 posts vào Postgres:
```sql
INSERT INTO posts SELECT 'post_'||g, 'author_1', 'bulk '||g, 1748000000000+g FROM generate_series(1, 600) g;
```
Gọi `POST /api/feed/cache/seed?userId=usr_edge`:
```json
{"userId":"usr_edge","cacheKey":"feed:usr_edge","source":"postgres","cachedPosts":600,"maxCachedItems":500}
```
Redis `ZCARD feed:usr_edge` → **500** ✅

Demo: dù DB có 600 posts, ZREMRANGEBYRANK 0..-501 đã trim chính xác về 500 mới nhất → chống unbounded growth.

## Verdict

✅ **L1 PASS** — Redis ZSET timeline cache hoạt động đúng, demo trade-off cache vs DB read + cap 500 đã verify với 600-post stress.
