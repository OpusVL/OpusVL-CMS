-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/20/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/21/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE templates DROP CONSTRAINT templates_name;

;
ALTER TABLE templates ADD CONSTRAINT templates_name_site UNIQUE (name, site);

;

COMMIT;

