-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/33/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/34/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE entity_cache (
  hash varchar NOT NULL,
  value text NOT NULL,
  created timestamp without time zone NOT NULL DEFAULT now(),
  site_id integer NOT NULL,
  PRIMARY KEY (hash),
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX entity_cache_idx_site_id ON entity_cache (site_id);

;

COMMIT;

