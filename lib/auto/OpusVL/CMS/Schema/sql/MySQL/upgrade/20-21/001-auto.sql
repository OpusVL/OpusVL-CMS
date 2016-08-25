-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/20/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/21/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE templates DROP INDEX templates_name,
                      ADD UNIQUE templates_name_site (name, site);

;

COMMIT;

