-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/1/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE sites ADD COLUMN template boolean DEFAULT false NOT NULL;

;
ALTER TABLE sites ADD COLUMN profile_site integer;

;
CREATE INDEX sites_idx_profile_site on sites (profile_site);

;
ALTER TABLE sites ADD CONSTRAINT sites_fk_profile_site FOREIGN KEY (profile_site)
  REFERENCES sites (id) DEFERRABLE;

;

COMMIT;

