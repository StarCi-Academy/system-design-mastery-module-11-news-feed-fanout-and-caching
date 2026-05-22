-- Tạo bảng và seed dữ liệu demo cho lesson hybrid fanout and hotkey mitigation.
-- (EN: Create tables and seed demo data for hybrid fanout and hotkey mitigation lesson.)

-- Tạo bảng authors nếu chưa tồn tại.
-- (EN: Create authors table if it does not exist.)
CREATE TABLE IF NOT EXISTS authors (
    "id"          TEXT    NOT NULL PRIMARY KEY,
    "isCelebrity" BOOLEAN NOT NULL DEFAULT FALSE
);

-- Tạo bảng posts nếu chưa tồn tại.
-- (EN: Create posts table if it does not exist.)
CREATE TABLE IF NOT EXISTS posts (
    "id"        TEXT NOT NULL PRIMARY KEY,
    "authorId"  TEXT NOT NULL,
    "content"   TEXT NOT NULL,
    "createdAt" TEXT NOT NULL
);

-- Chèn dữ liệu authors demo (bỏ qua nếu đã tồn tại).
-- (EN: Insert demo author rows (skip on conflict).)
INSERT INTO authors ("id", "isCelebrity") VALUES
    ('author_1', FALSE),
    ('kol_1',    TRUE)
ON CONFLICT DO NOTHING;

-- Chèn dữ liệu posts demo (bỏ qua nếu đã tồn tại).
-- (EN: Insert demo post rows (skip on conflict).)
INSERT INTO posts ("id", "authorId", "content", "createdAt") VALUES
    ('post_201', 'author_1', 'Regular author post was pushed into the user feed.', '2026-05-20T08:30:00.000Z'),
    ('post_301', 'kol_1',    'KOL post is pulled and merged at read time.',         '2026-05-20T09:30:00.000Z')
ON CONFLICT DO NOTHING;
