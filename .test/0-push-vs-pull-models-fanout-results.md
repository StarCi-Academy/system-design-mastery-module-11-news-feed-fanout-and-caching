# 0-push-vs-pull-models-fanout — e2e results

## 2026-05-23T02:46:00Z — Re-verified by audit session

Stack: db + redis + api (host port 3013 → container 3000). API ready in ~10s.

Note: the lesson's `en.md` shows `localhost:3000` in commands but the compose file publishes host port `3013`. Used `3013` for the actual curls below.

| Flow | Result | Stdout summary |
|---|---|---|
| 2.1.4.1 Pull model (GET /api/feed/pull?userId=usr_1) | PASS | `model: fanout-on-read`, timeline includes post_2 (kol_1) etc. |
| 2.1.4.2 Push model (GET /api/feed/push?userId=usr_1) | PASS | `model: fanout-on-write`, materializedPostIds=[post_1] |
| 2.1.4.3 Fanout-on-write post (POST /api/feed/post) | PASS | post_3 created, fanoutWrites=2 (usr_1, usr_2) |

Verified 3/3 flows.

## 2026-05-23 — Re-verified after content fix

Content URL drift fixed: `localhost:3000` → `localhost:3013` in en.md/vi.md.

| Flow | Status | First 200 chars |
|---|---|---|
| GET /api/feed/pull?userId=usr_1 | 200 | `{"model":"fanout-on-read","userId":"usr_1","followedAuthors":["author_1","kol_1"],"readCost":"Reads join/filter recent posts from followed authors when the user opens feed.","writeCost":"Post creation` |
| GET /api/feed/push?userId=usr_1 | 200 | `{"model":"fanout-on-write","userId":"usr_1","materializedPostIds":["post_1"],"readCost":"Reads are fast because the user timeline is already materialized.","writeCost":"Posting is expensive for author` |
| POST /api/feed/post (authorId=usr_1) | 201 | `{"model":"fanout-on-write","post":{"id":"post_3","authorId":"usr_1","content":"hello",...},"fanoutWrites":0}` |

3/3 PASS.
