CREATE TABLE `user` (
  id            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  username      VARCHAR(30) NOT NULL,
  password      TEXT NOT NULL,
  email         VARCHAR(50) NOT NULL,
  email_visible INT UNSIGNED,
  firstname     VARCHAR(30),
  lastname      VARCHAR(30),
  location      VARCHAR(100),
  about_me      TEXT,
  PRIMARY KEY (id)
) ENGINE=InnoDB;
CREATE TABLE role (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  -- Careful, don't create role's larger than 28 characters to be safe.
  role        VARCHAR(30) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;
CREATE TABLE user_role (
  userid INT UNSIGNED NOT NULL,
  roleid INT UNSIGNED NOT NULL,
  -- Delete user_role record or update userid when `user`(id) is deleted or updated.
  FOREIGN KEY (userid) REFERENCES `user`(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (roleid) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (userid, roleid)
) ENGINE=InnoDB;
--
-- Add blog and blog_comment tables
--
CREATE TABLE blog (
  id      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  userid  INT UNSIGNED NOT NULL,
  title   TEXT NOT NULL,
  content TEXT NOT NULL,
  created TIMESTAMP NOT NULL,
  FOREIGN KEY (userid) REFERENCES `user`(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (id)
) ENGINE=InnoDB;
CREATE TABLE blog_comment (
  id      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  blogid  INT UNSIGNED NOT NULL,
  -- userid of the commenter (NOT THE userid OF THE BLOG ENTRY)
  userid  INT UNSIGNED NOT NULL,
  content TEXT NOT NULL,
  created TIMESTAMP NOT NULL,
  FOREIGN KEY (blogid) REFERENCES blog(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (userid) REFERENCES `user`(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (id) 
) ENGINE=InnoDB;
INSERT INTO `user` (id, username, password, email) VALUES (1, 'yogeshc', 'yogeshc','yogeshc@cybage.com');
INSERT INTO role (id, role) VALUES (1, 'user');
INSERT INTO role (id, role) VALUES (2, 'admin');
INSERT INTO user_role (userid, roleid) VALUES (1, 1); -- Assign user role to yogeshc
INSERT INTO user_role (userid, roleid) VALUES (1, 2); -- Assign admin role to yogeshc
INSERT INTO blog (userid, title, content) VALUES (1, 'title', 'content'); 