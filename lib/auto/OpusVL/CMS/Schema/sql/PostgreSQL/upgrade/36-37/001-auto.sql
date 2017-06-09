-- Convert schema 'lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/36/001-auto.yml' to 'lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/37/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "default_attribute_values" (
  "id" serial NOT NULL,
  "field_id" integer NOT NULL,
  "value" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "default_attribute_values_idx_field_id" on "default_attribute_values" ("field_id");

;
CREATE TABLE "default_attributes" (
  "id" serial NOT NULL,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "value" text,
  "type" text NOT NULL,
  "field_type" text,
  PRIMARY KEY ("id")
);

;
CREATE TABLE "plugins" (
  "id" serial NOT NULL,
  "name" text NOT NULL,
  "action" text NOT NULL,
  "code" text NOT NULL,
  "author" text NOT NULL,
  "description" text NOT NULL,
  "status" text DEFAULT 'disabled' NOT NULL,
  PRIMARY KEY ("id")
);

;
ALTER TABLE "default_attribute_values" ADD CONSTRAINT "default_attribute_values_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "default_attributes" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE aclfeature DROP COLUMN feature_description;

;
ALTER TABLE forms DROP CONSTRAINT form_name_site_id;

;
ALTER TABLE forms ADD CONSTRAINT form_name_site_id UNIQUE (name, site_id);

;
ALTER TABLE pages DROP CONSTRAINT pages_url_site;

;
ALTER TABLE pages ADD CONSTRAINT pages_url_site UNIQUE (url, site);

;
ALTER TABLE site_attributes ADD COLUMN description text;

;
ALTER TABLE templates DROP CONSTRAINT templates_name_site;

;
ALTER TABLE templates ADD CONSTRAINT templates_name_site UNIQUE (name, site);

;
ALTER TABLE users DROP CONSTRAINT user_index;

;
ALTER TABLE users ADD CONSTRAINT user_index UNIQUE (username);

;

COMMIT;

