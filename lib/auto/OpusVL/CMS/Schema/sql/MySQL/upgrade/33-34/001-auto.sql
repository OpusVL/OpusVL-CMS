-- Convert schema '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/33/001-auto.yml' to '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/34/001-auto.yml':;

;
BEGIN;

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

