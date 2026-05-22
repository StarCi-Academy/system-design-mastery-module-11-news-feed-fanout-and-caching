-- Tạo bảng và seed dữ liệu demo cho lesson push vs pull models fanout.
-- (EN: Create tables and seed demo data for push vs pull models fanout lesson.)

-- Tạo bảng follows nếu chưa tồn tại.
-- (EN: Create follows table if it does not exist.)
CREATE TABLE IF NOT EXISTS follows (
    "userId"   TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    PRIMARY KEY ("userId", "authorId")
);

-- Tạo bảng posts nếu chưa tồn tại.
-- (EN: Create posts table if it does not exist.)
CREATE TABLE IF NOT EXISTS posts (
    "id"        TEXT NOT NULL PRIMARY KEY,
    "authorId"  TEXT NOT NULL,
    "content"   TEXT NOT NULL,
    "createdAt" TEXT NOT NULL
);

-- Tạo bảng pushed_timeline nếu chưa tồn tại.
-- (EN: Create pushed_timeline table if it does not exist.)
CREATE TABLE IF NOT EXISTS pushed_timeline (
    "userId"    TEXT    NOT NULL,
    "postId"    TEXT    NOT NULL,
    "sortOrder" BIGINT  NOT NULL DEFAULT 0,
    PRIMARY KEY ("userId", "postId")
);

-- Chèn dữ liệu follows demo (bỏ qua nếu đã tồn tại).
-- (EN: Insert demo follow rows (skip on conflict).)
INSERT INTO follows ("userId", "authorId") VALUES
    ('usr_1', 'author_1'),
    ('usr_1', 'kol_1'),
    ('usr_2', 'author_1')
ON CONFLICT DO NOTHING;

-- Chèn dữ liệu posts demo (bỏ qua nếu đã tồn tại).
-- (EN: Insert demo post rows (skip on conflict).)
INSERT INTO posts ("id", "authorId", "content", "createdAt") VALUES
    ('post_1', 'author_1', 'Designing feeds starts with fanout trade-offs.',  '2026-05-20T08:00:00.000Z'),
    ('post_2', 'kol_1',    'KOL posts are usually pulled at read time.',       '2026-05-20T09:00:00.000Z')
ON CONFLICT DO NOTHING;

-- Chèn dữ liệu pushed_timeline demo (bỏ qua nếu đã tồn tại).
-- (EN: Insert demo pushed timeline rows (skip on conflict).)
INSERT INTO pushed_timeline ("userId", "postId", "sortOrder") VALUES
    ('usr_1', 'post_1', 0),
    ('usr_2', 'post_1', 0)
ON CONFLICT DO NOTHING;
