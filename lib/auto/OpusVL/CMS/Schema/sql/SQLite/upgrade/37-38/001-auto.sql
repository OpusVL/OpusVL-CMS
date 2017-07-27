-- Convert schema '/opt/local/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/37/001-auto.yml' to '/opt/local/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/38/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE forms ADD COLUMN redirect_id integer;

;
CREATE INDEX forms_idx_redirect_id02 ON forms (redirect_id);

;

;

COMMIT;

