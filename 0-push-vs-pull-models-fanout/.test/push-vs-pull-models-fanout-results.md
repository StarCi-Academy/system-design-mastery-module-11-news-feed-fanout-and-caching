# L0 — Push vs Pull Models Fanout: E2E Test Results

**Stack:** NestJS + PostgreSQL 16 (seeded via `.sql/seed.sql`) + Redis 7
**Port:** 3013 (host) → 3000 (container)
**Date:** 2026-05-22

## Setup fixes

- Đổi image name → `starciacademy/system-design-push-vs-pull-models-fanout-feed-service:latest` (canonical pattern).
- Bump port host `3000 → 3013` (tránh conflict).
- `synchronize: true → false` (seed.sql là authoritative schema; tránh TypeORM tự ALTER xung đột).
- `pushed_timeline.sortOrder` `INTEGER → BIGINT` (Date.now() vượt INT32 range).
- Bỏ host-port mapping của Postgres/Redis (internal-only).

## Flow 1 — GET /api/feed/pull?userId=usr_1 (fanout-on-read)

```json
{"model":"fanout-on-read","userId":"usr_1","followedAuthors":["author_1","kol_1"],
 "timeline":[{"id":"post_2","authorId":"kol_1",...},{"id":"post_1","authorId":"author_1",...}]}
```
✅ 2 post từ 2 author đang follow, sort DESC theo createdAt.

## Flow 2 — GET /api/feed/push?userId=usr_1 (fanout-on-write)

```json
{"model":"fanout-on-write","userId":"usr_1","materializedPostIds":["post_1"],
 "timeline":[{"id":"post_1",...}]}
```
✅ Chỉ trả post đã materialize trong `pushed_timeline`.

## Flow 3 — POST /api/feed/post (fanout-on-write at write time)

```bash
POST {"authorId":"author_1","content":"Test post"}
→ {"model":"fanout-on-write","post":{"id":"post_3",...},"followerIds":["usr_1","usr_2"],"fanoutWrites":2}
```
✅ Tạo post + ghi 2 dòng `pushed_timeline` cho 2 follower của author_1.

## Edge cases

- **Cold user (no follows)** — `GET /pull?userId=usr_999` → `followedAuthors:[], timeline:[]` ✅
- **Cold user push feed** — `GET /push?userId=usr_999` → `materializedPostIds:[], timeline:[]` ✅
- **Author không có follower** — `POST /post {"authorId":"nobody_following"}` → `followerIds:[], fanoutWrites:0` ✅ (post vẫn được lưu, chỉ không fanout)

## Verdict

✅ **L0 PASS** — pull/push trade-off thể hiện rõ qua 3 endpoint + 3 edge case xử lý đúng.
