-- Tạo bảng và seed dữ liệu demo cho lesson feed caching with redis.
-- (EN: Create tables and seed demo data for feed caching with redis lesson.)

-- Tạo bảng posts nếu chưa tồn tại.
-- (EN: Create posts table if it does not exist.)
CREATE TABLE IF NOT EXISTS posts (
    "id"       TEXT   NOT NULL PRIMARY KEY,
    "authorId" TEXT   NOT NULL,
    "content"  TEXT   NOT NULL,
    "scoreMs"  BIGINT NOT NULL
);

-- Chèn dữ liệu posts demo với scoreMs tăng dần (bỏ qua nếu đã tồn tại).
-- (EN: Insert demo post rows with ascending scoreMs (skip on conflict).)
INSERT INTO posts ("id", "authorId", "content", "scoreMs") VALUES
    ('post_101', 'author_1', 'Cached post 101 — older timeline item.',   1748390400000),
    ('post_102', 'author_1', 'Cached post 102 — mid timeline item.',     1748390420000),
    ('post_103', 'author_1', 'Cached post 103 — newest timeline item.',  1748390440000)
ON CONFLICT DO NOTHING;
