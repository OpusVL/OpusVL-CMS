-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/34/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/35/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE entity_cache DROP CONSTRAINT entity_cache_pkey;

;
ALTER TABLE entity_cache ADD PRIMARY KEY (hash, site_id);

;

COMMIT;

