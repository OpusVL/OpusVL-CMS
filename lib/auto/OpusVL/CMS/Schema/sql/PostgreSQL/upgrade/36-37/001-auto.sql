-- Convert schema '/opt/local/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/36/001-auto.yml' to '/opt/local/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/37/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE site_attributes ADD COLUMN description text;

;

COMMIT;

