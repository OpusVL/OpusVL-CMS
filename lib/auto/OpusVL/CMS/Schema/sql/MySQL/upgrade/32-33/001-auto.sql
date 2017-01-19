-- Convert schema '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/32/001-auto.yml' to '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/33/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE forms_fields ADD COLUMN constraint_id integer NULL,
                         ADD INDEX forms_fields_idx_constraint_id (constraint_id),
                         ADD CONSTRAINT forms_fields_fk_constraint_id FOREIGN KEY (constraint_id) REFERENCES forms_constraints (id);

;
ALTER TABLE pages DROP INDEX pages_url_site,
                  ADD UNIQUE pages_url_site (url, site);

;
ALTER TABLE templates DROP INDEX templates_name_site,
                      ADD UNIQUE templates_name_site (name, site);

;
ALTER TABLE users DROP INDEX user_index,
                  CHANGE COLUMN email email citext NOT NULL,
                  ADD UNIQUE user_index (username);

;

COMMIT;

