-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/1/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE sites ADD COLUMN template boolean NOT NULL DEFAULT false;

;
ALTER TABLE sites ADD COLUMN profile_site integer;

;
CREATE INDEX sites_idx_profile_site02 ON sites (profile_site);

;

;

COMMIT;

