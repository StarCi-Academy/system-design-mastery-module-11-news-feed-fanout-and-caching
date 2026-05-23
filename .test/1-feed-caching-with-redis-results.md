# 1-feed-caching-with-redis — e2e results

## 2026-05-23T02:47:30Z — Re-verified by audit session

Stack: db + redis + api (host port 3014 → container 3000). en.md commands again show :3000 but compose publishes :3014; used 3014.

| Flow | Result | Stdout summary |
|---|---|---|
| 2.1.4.1 Seed cache (POST /api/feed/cache/seed?userId=usr_1) | PASS | `{cacheKey:"feed:usr_1", source:"postgres", cachedPosts:3, maxCachedItems:500}` |
| 2.1.4.2 Read cached feed (GET /api/feed/cache?userId=usr_1) | PASS | model `redis-zset-feed-cache`, timeline=[post_103, post_102, post_101] newest-first |

Verified 2/2 flows.

## 2026-05-23 — Re-verified after content fix

Content URL drift fixed: `localhost:3000` → `localhost:3014`.

| Flow | Status | First 200 chars |
|---|---|---|
| POST /api/feed/cache/seed?userId=usr_1 | 201 | `{"userId":"usr_1","cacheKey":"feed:usr_1","source":"postgres","cachedPosts":3,"maxCachedItems":500}` |
| GET /api/feed/cache?userId=usr_1 | 200 | `{"model":"redis-zset-feed-cache","userId":"usr_1","cacheKey":"feed:usr_1",...,"timeline":[{"postId":"post_103","score":1748390440000},...` |

2/2 PASS.
