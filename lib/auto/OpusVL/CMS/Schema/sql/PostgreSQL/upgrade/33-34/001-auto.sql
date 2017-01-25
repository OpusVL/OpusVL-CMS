-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/33/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/34/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "entity_cache" (
  "hash" character varying NOT NULL,
  "value" text NOT NULL,
  "created" timestamp without time zone DEFAULT now() NOT NULL,
  "site_id" integer NOT NULL,
  PRIMARY KEY ("hash")
);
CREATE INDEX "entity_cache_idx_site_id" on "entity_cache" ("site_id");

;
ALTER TABLE "entity_cache" ADD CONSTRAINT "entity_cache_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

COMMIT;

