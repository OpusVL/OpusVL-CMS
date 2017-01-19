-- Convert schema '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/32/001-auto.yml' to '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/33/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE forms_fields ADD COLUMN constraint_id integer;

;
CREATE INDEX forms_fields_idx_constraint00 ON forms_fields (constraint_id);

;

;
DROP INDEX pages_url_site;

;
CREATE UNIQUE INDEX pages_url_site02 ON pages (url, site);

;
DROP INDEX templates_name_site;

;
CREATE UNIQUE INDEX templates_name_site02 ON templates (name, site);

;
CREATE TEMPORARY TABLE users_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  username text NOT NULL,
  password text NOT NULL,
  email citext NOT NULL,
  name text NOT NULL,
  tel text,
  status text NOT NULL DEFAULT 'active',
  last_login timestamp,
  last_failed_login timestamp
);

;
INSERT INTO users_temp_alter( id, username, password, email, name, tel, status, last_login, last_failed_login) SELECT id, username, password, email, name, tel, status, last_login, last_failed_login FROM users;

;
DROP TABLE users;

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username text NOT NULL,
  password text NOT NULL,
  email citext NOT NULL,
  name text NOT NULL,
  tel text,
  status text NOT NULL DEFAULT 'active',
  last_login timestamp,
  last_failed_login timestamp
);

;
CREATE UNIQUE INDEX user_index03 ON users (username);

;
INSERT INTO users SELECT id, username, password, email, name, tel, status, last_login, last_failed_login FROM users_temp_alter;

;
DROP TABLE users_temp_alter;

;

COMMIT;

