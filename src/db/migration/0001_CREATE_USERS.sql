DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id integer primary key AUTOINCREMENT,
  name varchar(50),
  birthday varchar(8),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
