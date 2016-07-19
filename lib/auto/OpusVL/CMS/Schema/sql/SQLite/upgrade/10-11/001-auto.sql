-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/10/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/11/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE attachment_attribute_details_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  code text,
  name text,
  type text,
  active boolean NOT NULL DEFAULT 1,
  site_id integer NOT NULL,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO attachment_attribute_details_temp_alter( id, code, name, type, active, site_id) SELECT id, code, name, type, active, site_id FROM attachment_attribute_details;

;
DROP TABLE attachment_attribute_details;

;
CREATE TABLE attachment_attribute_details (
  id INTEGER PRIMARY KEY NOT NULL,
  code text,
  name text,
  type text,
  active boolean NOT NULL DEFAULT 1,
  site_id integer NOT NULL,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX attachment_attribute_detail00 ON attachment_attribute_details (site_id);

;
INSERT INTO attachment_attribute_details SELECT id, code, name, type, active, site_id FROM attachment_attribute_details_temp_alter;

;
DROP TABLE attachment_attribute_details_temp_alter;

;

COMMIT;

