-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/20/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/21/001-auto.yml':;

;
BEGIN;

;
DROP INDEX templates_name;

;
CREATE UNIQUE INDEX templates_name_site02 ON templates (name, site);

;

COMMIT;

