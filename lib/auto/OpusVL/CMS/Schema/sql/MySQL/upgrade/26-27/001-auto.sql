-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/26/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/27/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE attachment_attribute_values CHANGE COLUMN priority priority integer NULL DEFAULT 50;

;

COMMIT;

