-- Convert schema '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/33/001-auto.yml' to '/opt/pulsar/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/34/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE pages DROP CONSTRAINT pages_url_site;

;
ALTER TABLE pages ADD CONSTRAINT pages_url_site UNIQUE (url, site);

;
ALTER TABLE templates DROP CONSTRAINT templates_name_site;

;
ALTER TABLE templates ADD CONSTRAINT templates_name_site UNIQUE (name, site);

;
ALTER TABLE users DROP CONSTRAINT user_index;

;
ALTER TABLE users ALTER COLUMN email TYPE citext;

;
ALTER TABLE users ADD CONSTRAINT user_index UNIQUE (username);

;

COMMIT;

