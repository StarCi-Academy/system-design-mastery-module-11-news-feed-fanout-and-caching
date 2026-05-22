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

## Verdict

✅ **L1 PASS** — Redis ZSET timeline cache hoạt động đúng, demo trade-off cache vs DB read.
