      
CREATE DATABASE social_network_db;
USE social_network_db;

-- TABLE USERS
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLE POSTS
CREATE TABLE Posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- TABLE COMMENTS
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id)
        REFERENCES Posts(post_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

-- TABLE FRIENDS
CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20)
        CHECK (status IN ('pending', 'accepted')),

    PRIMARY KEY (user_id, friend_id),

    CONSTRAINT fk_friends_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_friends_friend
        FOREIGN KEY (friend_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_not_self_friending
        CHECK (user_id <> friend_id)
);

-- TABLE LIKES
CREATE TABLE Likes (
    user_id INT,
    post_id INT,

    PRIMARY KEY (user_id, post_id),

    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_likes_post
        FOREIGN KEY (post_id)
        REFERENCES Posts(post_id)
        ON DELETE CASCADE
);

CREATE INDEX idx_posts_created_at
ON Posts(created_at);

CREATE VIEW view_user_info AS
SELECT
    user_id,
    username,
    email,
    created_at
FROM Users;

CREATE VIEW view_post_statistics AS
SELECT
    p.post_id,
    u.username,
    p.content,
    p.created_at,

    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments

FROM Posts p

LEFT JOIN Users u
    ON p.user_id = u.user_id

LEFT JOIN Likes l
    ON p.post_id = l.post_id

LEFT JOIN Comments c
    ON p.post_id = c.post_id

GROUP BY
    p.post_id,
    u.username,
    p.content,
    p.created_at;

DELIMITER //

CREATE PROCEDURE sp_add_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE email_count INT;

    SELECT COUNT(*)
    INTO email_count
    FROM Users
    WHERE email = p_email;

    IF email_count > 0 THEN
        SELECT 'Email đã được sử dụng' AS message;
    ELSE
        INSERT INTO Users(username, password, email)
        VALUES (p_username, p_password, p_email);

        SELECT 'Đăng ký thành công' AS message;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT,
    OUT p_new_post_id INT
)
BEGIN
    INSERT INTO Posts(user_id, content)
    VALUES (p_user_id, p_content);

    SET p_new_post_id = LAST_INSERT_ID();
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_get_friends(
    IN p_user_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT
        u.user_id,
        u.username,
        u.email,
        u.created_at
    FROM Friends f

    JOIN Users u
        ON f.friend_id = u.user_id

    WHERE f.user_id = p_user_id
        AND f.status = 'accepted'

    LIMIT p_limit OFFSET p_offset;
END //

DELIMITER ;

-- USERS
INSERT INTO Users(username, password, email)
VALUES
('alice', '123456', 'alice@gmail.com'),
('bob', '123456', 'bob@gmail.com'),
('charlie', '123456', 'charlie@gmail.com');

-- POSTS
INSERT INTO Posts(user_id, content)
VALUES
(1, 'Xin chào mọi người'),
(2, 'Hôm nay trời đẹp'),
(3, 'Tôi đang học MySQL');

-- COMMENTS
INSERT INTO Comments(post_id, user_id, content)
VALUES
(1, 2, 'Bài viết hay'),
(1, 3, 'Chào bạn'),
(2, 1, 'Đúng vậy');

-- LIKES
INSERT INTO Likes(user_id, post_id)
VALUES
(1, 2),
(2, 1),
(3, 1);

-- FRIENDS
INSERT INTO Friends(user_id, friend_id, status)
VALUES
(1, 2, 'accepted'),
(2, 1, 'accepted'),
(1, 3, 'pending');


SELECT * FROM view_user_info;

SELECT * FROM view_post_statistics;

CALL sp_add_user(
    'david',
    '123456',
    'alice@gmail.com'
);

CALL sp_add_user(
    'david',
    '123456',
    'david@gmail.com'
);

SET @new_post_id = 0;

CALL sp_create_post(
    1,
    'Bài viết mới từ Alice',
    @new_post_id
);

SELECT @new_post_id AS new_post_id;

CALL sp_get_friends(1, 10, 0);


    