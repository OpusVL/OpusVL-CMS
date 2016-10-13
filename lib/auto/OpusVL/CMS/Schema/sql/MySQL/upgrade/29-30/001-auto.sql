-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/29/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/30/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE asset_attribute_values ADD COLUMN site_id integer NULL;

;

COMMIT;

