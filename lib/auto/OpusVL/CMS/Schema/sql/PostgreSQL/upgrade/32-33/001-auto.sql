-- Convert schema '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/32/001-auto.yml' to '/opt/cms/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/33/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE forms_fields ADD COLUMN constraint_id integer;

;
CREATE INDEX forms_fields_idx_constraint_id on forms_fields (constraint_id);

;
ALTER TABLE forms_fields ADD CONSTRAINT forms_fields_fk_constraint_id FOREIGN KEY (constraint_id)
  REFERENCES forms_constraints (id) DEFERRABLE;

;

COMMIT;

