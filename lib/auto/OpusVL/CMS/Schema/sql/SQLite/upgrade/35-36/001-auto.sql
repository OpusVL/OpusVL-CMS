-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/35/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/36/001-auto.yml':;

;
BEGIN;

;
CREATE UNIQUE INDEX form_name_site_id02 ON forms (name, site_id);

;

COMMIT;

