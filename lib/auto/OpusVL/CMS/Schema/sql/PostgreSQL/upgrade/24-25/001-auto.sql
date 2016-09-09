-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/24/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/25/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE attachment_attribute_values ADD COLUMN site_id integer;

;
CREATE INDEX attachment_attribute_values_idx_site_id on attachment_attribute_values (site_id);

;
ALTER TABLE attachment_attribute_values ADD CONSTRAINT attachment_attribute_values_fk_site_id FOREIGN KEY (site_id)
  REFERENCES sites (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE page_attribute_values ADD COLUMN site_id integer;

;
CREATE INDEX page_attribute_values_idx_site_id on page_attribute_values (site_id);

;
ALTER TABLE page_attribute_values ADD CONSTRAINT page_attribute_values_fk_site_id FOREIGN KEY (site_id)
  REFERENCES sites (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

COMMIT;

