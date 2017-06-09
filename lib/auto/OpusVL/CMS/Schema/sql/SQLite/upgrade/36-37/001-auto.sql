-- Convert schema 'lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/36/001-auto.yml' to 'lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/37/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE default_attribute_values (
  id INTEGER PRIMARY KEY NOT NULL,
  field_id integer NOT NULL,
  value text NOT NULL,
  FOREIGN KEY (field_id) REFERENCES default_attributes(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX default_attribute_values_idx_field_id ON default_attribute_values (field_id);

;
CREATE TABLE default_attributes (
  id INTEGER PRIMARY KEY NOT NULL,
  code text NOT NULL,
  name text NOT NULL,
  value text,
  type text NOT NULL,
  field_type text
);

;
CREATE TABLE plugins (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL,
  action text NOT NULL,
  code text NOT NULL,
  author text NOT NULL,
  description text NOT NULL,
  status text NOT NULL DEFAULT 'disabled'
);

;
CREATE TEMPORARY TABLE aclfeature_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  feature text NOT NULL
);

;
INSERT INTO aclfeature_temp_alter( id, feature) SELECT id, feature FROM aclfeature;

;
DROP TABLE aclfeature;

;
CREATE TABLE aclfeature (
  id INTEGER PRIMARY KEY NOT NULL,
  feature text NOT NULL
);

;
INSERT INTO aclfeature SELECT id, feature FROM aclfeature_temp_alter;

;
DROP TABLE aclfeature_temp_alter;

;
DROP INDEX form_name_site_id;

;
CREATE UNIQUE INDEX form_name_site_id02 ON forms (name, site_id);

;
DROP INDEX pages_url_site;

;
CREATE UNIQUE INDEX pages_url_site02 ON pages (url, site);

;
ALTER TABLE site_attributes ADD COLUMN description text;

;
DROP INDEX templates_name_site;

;
CREATE UNIQUE INDEX templates_name_site02 ON templates (name, site);

;
DROP INDEX user_index;

;
CREATE UNIQUE INDEX user_index02 ON users (username);

;

COMMIT;

