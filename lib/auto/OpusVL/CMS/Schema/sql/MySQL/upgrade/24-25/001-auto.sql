-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/24/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/25/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE attachment_attribute_values ADD COLUMN site_id integer NULL,
                                        ADD INDEX attachment_attribute_values_idx_site_id (site_id),
                                        ADD CONSTRAINT attachment_attribute_values_fk_site_id FOREIGN KEY (site_id) REFERENCES sites (id) ON DELETE CASCADE ON UPDATE CASCADE;

;
ALTER TABLE page_attribute_values ADD COLUMN site_id integer NULL,
                                  ADD INDEX page_attribute_values_idx_site_id (site_id),
                                  ADD CONSTRAINT page_attribute_values_fk_site_id FOREIGN KEY (site_id) REFERENCES sites (id) ON DELETE CASCADE ON UPDATE CASCADE;

;

COMMIT;

