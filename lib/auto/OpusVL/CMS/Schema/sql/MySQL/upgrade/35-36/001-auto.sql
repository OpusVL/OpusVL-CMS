-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/35/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/36/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE forms ADD UNIQUE form_name_site_id (name, site_id);

;

COMMIT;

