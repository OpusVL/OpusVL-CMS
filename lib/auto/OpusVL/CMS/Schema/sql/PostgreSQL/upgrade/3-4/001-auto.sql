-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/3/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE assets DROP COLUMN global;

;
ALTER TABLE elements DROP COLUMN global;

;
ALTER TABLE templates DROP COLUMN global;

;

COMMIT;

