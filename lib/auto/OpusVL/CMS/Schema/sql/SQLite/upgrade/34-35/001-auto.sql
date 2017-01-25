-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/34/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/35/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE entity_cache_temp_alter (
  hash varchar NOT NULL,
  value text NOT NULL,
  created timestamp without time zone NOT NULL DEFAULT now(),
  site_id integer NOT NULL,
  PRIMARY KEY (hash, site_id),
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO entity_cache_temp_alter( hash, value, created, site_id) SELECT hash, value, created, site_id FROM entity_cache;

;
DROP TABLE entity_cache;

;
CREATE TABLE entity_cache (
  hash varchar NOT NULL,
  value text NOT NULL,
  created timestamp without time zone NOT NULL DEFAULT now(),
  site_id integer NOT NULL,
  PRIMARY KEY (hash, site_id),
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX entity_cache_idx_site_id03 ON entity_cache (site_id);

;
INSERT INTO entity_cache SELECT hash, value, created, site_id FROM entity_cache_temp_alter;

;
DROP TABLE entity_cache_temp_alter;

;

COMMIT;

