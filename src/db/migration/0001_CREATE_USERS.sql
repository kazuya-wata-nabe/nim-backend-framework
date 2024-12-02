DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id uuid,
  name varchar(50),
  birthday varchar(8),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  primary key(id)
) STRICT;
