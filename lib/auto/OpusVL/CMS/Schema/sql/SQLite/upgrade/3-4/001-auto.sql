-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/3/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE assets_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  status text NOT NULL DEFAULT 'published',
  filename text NOT NULL,
  description text,
  mime_type text NOT NULL,
  site integer NOT NULL,
  priority integer DEFAULT 10,
  slug text NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO assets_temp_alter( id, status, filename, description, mime_type, site, priority, slug) SELECT id, status, filename, description, mime_type, site, priority, slug FROM assets;

;
DROP TABLE assets;

;
CREATE TABLE assets (
  id INTEGER PRIMARY KEY NOT NULL,
  status text NOT NULL DEFAULT 'published',
  filename text NOT NULL,
  description text,
  mime_type text NOT NULL,
  site integer NOT NULL,
  priority integer DEFAULT 10,
  slug text NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX assets_idx_site03 ON assets (site);

;
INSERT INTO assets SELECT id, status, filename, description, mime_type, site, priority, slug FROM assets_temp_alter;

;
DROP TABLE assets_temp_alter;

;
CREATE TEMPORARY TABLE elements_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  status text NOT NULL DEFAULT 'published',
  name text NOT NULL,
  site integer NOT NULL,
  slug text NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO elements_temp_alter( id, status, name, site, slug) SELECT id, status, name, site, slug FROM elements;

;
DROP TABLE elements;

;
CREATE TABLE elements (
  id INTEGER PRIMARY KEY NOT NULL,
  status text NOT NULL DEFAULT 'published',
  name text NOT NULL,
  site integer NOT NULL,
  slug text NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX elements_idx_site03 ON elements (site);

;
INSERT INTO elements SELECT id, status, name, site, slug FROM elements_temp_alter;

;
DROP TABLE elements_temp_alter;

;
CREATE TEMPORARY TABLE templates_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL,
  site integer NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
INSERT INTO templates_temp_alter( id, name, site) SELECT id, name, site FROM templates;

;
DROP TABLE templates;

;
CREATE TABLE templates (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL,
  site integer NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX templates_idx_site03 ON templates (site);

;
CREATE UNIQUE INDEX templates_name03 ON templates (name);

;
INSERT INTO templates SELECT id, name, site FROM templates_temp_alter;

;
DROP TABLE templates_temp_alter;

;

COMMIT;

