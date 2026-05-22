# L2 — Hybrid Fanout & Hotkey Mitigation: E2E Test Results

**Stack:** NestJS + PostgreSQL 16 + Redis 7 (salted keys for KOL)
**Port:** 3015 (host) → 3000 (container)
**Date:** 2026-05-22

## Setup fixes

- Image → `starciacademy/system-design-hybrid-fanout-and-hotkey-mitigation-hybrid-feed-service:latest`.
- Port 3000 → 3015; `synchronize: false`; bỏ host port mapping DB/Redis.

## Flow 1 — GET /api/feed/hybrid?userId=usr_1

```json
{"model":"hybrid-fanout",
 "strategy":{"regularUsers":"fanout-on-write","celebrityUsers":"fanout-on-read"},
 "hotkeyMitigation":{"technique":"key-salting","saltedKey":"feed:kol:kol_1:salt:1","reason":"..."},
 "celebrityAuthors":["kol_1"],
 "timeline":[{"id":"post_301","authorId":"kol_1",...},{"id":"post_201","authorId":"author_1",...}]}
```
✅ Merge timeline materialized (author_1 push) + KOL pull (kol_1).
✅ Key salting `feed:kol:kol_1:salt:1` chống hotkey trên Redis.

## Flow 2 — GET /api/feed/hybrid/route?authorId=author_1

```json
{"authorId":"author_1","isCelebrity":false,"route":"push-to-followers","expectedWrites":"number_of_followers"}
```
✅ Author thường → push (fan-out on write).

## Flow 3 — GET /api/feed/hybrid/route?authorId=kol_1

```json
{"authorId":"kol_1","isCelebrity":true,"route":"pull-at-read-time","expectedWrites":1}
```
✅ KOL → pull at read time (1 write thay vì million writes).

## Verdict

✅ **L2 PASS** — hybrid routing đúng theo trạng thái celebrity; key salting chống hotkey rõ ràng.
