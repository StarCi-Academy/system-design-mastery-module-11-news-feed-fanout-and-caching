# 2-hybrid-fanout-and-hotkey-mitigation — e2e results

## 2026-05-23T02:49:00Z — Re-verified by audit session

Stack: db + redis + api (host port 3015 → container 3000). en.md uses :3000; actual published port 3015.

| Flow | Result | Stdout summary |
|---|---|---|
| 2.1.4.1 Hybrid feed (GET /api/feed/hybrid?userId=usr_1) | PASS | model `hybrid-fanout`, hotkeyMitigation `key-salting` on `feed:kol:kol_1:salt:1`, merged timeline (kol post + materialized posts) |
| 2.1.4.2 Routing decision (GET /api/feed/hybrid/route?authorId=kol_1) | PASS | `{isCelebrity:true, route:"pull-at-read-time", expectedWrites:1}` |

Verified 2/2 flows.

## 2026-05-23 — Re-verified after content fix

Content URL drift fixed: `localhost:3000` → `localhost:3015`.

| Flow | Status | First 200 chars |
|---|---|---|
| GET /api/feed/hybrid?userId=usr_1 | 200 | `{"model":"hybrid-fanout","userId":"usr_1","strategy":{"regularUsers":"fanout-on-write","celebrityUsers":"fanout-on-read"},"hotkeyMitigation":{"technique":"key-salting","saltedKey":"feed:kol:kol_1:salt:1",...` |
| GET /api/feed/hybrid/route?authorId=kol_1 | 200 | `{"authorId":"kol_1","isCelebrity":true,"route":"pull-at-read-time","expectedWrites":1}` |

2/2 PASS.
