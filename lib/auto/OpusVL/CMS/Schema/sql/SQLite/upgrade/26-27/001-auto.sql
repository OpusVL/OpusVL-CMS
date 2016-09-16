-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/26/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/27/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE attachment_attribute_values_temp_alter (
  id serial NOT NULL,
  value text,
  priority integer DEFAULT 50,
  field_id integer NOT NULL,
  site_id integer,
  PRIMARY KEY (id),
  FOREIGN KEY (field_id) REFERENCES attachment_attribute_details(id) ON UPDATE CASCADE,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO attachment_attribute_values_temp_alter( id, value, priority, field_id, site_id) SELECT id, value, priority, field_id, site_id FROM attachment_attribute_values;

;
DROP TABLE attachment_attribute_values;

;
CREATE TABLE attachment_attribute_values (
  id serial NOT NULL,
  value text,
  priority integer DEFAULT 50,
  field_id integer NOT NULL,
  site_id integer,
  PRIMARY KEY (id),
  FOREIGN KEY (field_id) REFERENCES attachment_attribute_details(id) ON UPDATE CASCADE,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX attachment_attribute_values00 ON attachment_attribute_values (field_id);

;
CREATE INDEX attachment_attribute_values00 ON attachment_attribute_values (site_id);

;
INSERT INTO attachment_attribute_values SELECT id, value, priority, field_id, site_id FROM attachment_attribute_values_temp_alter;

;
DROP TABLE attachment_attribute_values_temp_alter;

;

COMMIT;

