DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id uuid,
  name varchar(50),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  primary key(id)
) STRICT;
