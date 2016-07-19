-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/10/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/11/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE aclfeature (
  id INTEGER PRIMARY KEY NOT NULL,
  feature text NOT NULL,
  feature_description text
);

;
CREATE TABLE aclfeature_role (
  aclfeature_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (aclfeature_id, role_id),
  FOREIGN KEY (aclfeature_id) REFERENCES aclfeature(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX aclfeature_role_idx_aclfeature_id ON aclfeature_role (aclfeature_id);

;
CREATE INDEX aclfeature_role_idx_role_id ON aclfeature_role (role_id);

;
CREATE TABLE aclrule (
  id INTEGER PRIMARY KEY NOT NULL,
  actionpath text NOT NULL
);

;
CREATE TABLE aclrule_role (
  aclrule_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (aclrule_id, role_id),
  FOREIGN KEY (aclrule_id) REFERENCES aclrule(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX aclrule_role_idx_aclrule_id ON aclrule_role (aclrule_id);

;
CREATE INDEX aclrule_role_idx_role_id ON aclrule_role (role_id);

;
CREATE TABLE aliases (
  id INTEGER PRIMARY KEY NOT NULL,
  page_id integer NOT NULL,
  url text NOT NULL,
  FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX aliases_idx_page_id ON aliases (page_id);

;
CREATE TABLE alternate_domains (
  id INTEGER PRIMARY KEY NOT NULL,
  port integer NOT NULL DEFAULT 80,
  secure boolean NOT NULL DEFAULT false,
  master_domain integer NOT NULL,
  domain varchar NOT NULL,
  FOREIGN KEY (master_domain) REFERENCES master_domains(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX alternate_domains_idx_master_domain ON alternate_domains (master_domain);

;
CREATE TABLE asset_attribute_data (
  id INTEGER PRIMARY KEY NOT NULL,
  value text,
  date_value date,
  field_id integer NOT NULL,
  asset_id integer NOT NULL,
  FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (field_id) REFERENCES asset_attribute_details(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX asset_attribute_data_idx_asset_id ON asset_attribute_data (asset_id);

;
CREATE INDEX asset_attribute_data_idx_field_id ON asset_attribute_data (field_id);

;
CREATE TABLE asset_attribute_details (
  id INTEGER PRIMARY KEY NOT NULL,
  code text NOT NULL,
  name text NOT NULL,
  type text NOT NULL,
  active boolean NOT NULL DEFAULT true,
  site_id integer,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX asset_attribute_details_idx_site_id ON asset_attribute_details (site_id);

;
CREATE TABLE asset_attribute_values (
  id INTEGER PRIMARY KEY NOT NULL,
  value text,
  field_id integer NOT NULL,
  FOREIGN KEY (field_id) REFERENCES asset_attribute_details(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX asset_attribute_values_idx_field_id ON asset_attribute_values (field_id);

;
CREATE TABLE asset_data (
  id INTEGER PRIMARY KEY NOT NULL,
  asset_id integer NOT NULL,
  data blob NOT NULL,
  created timestamp NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX asset_data_idx_asset_id ON asset_data (asset_id);

;
CREATE TABLE asset_users (
  id INTEGER PRIMARY KEY NOT NULL,
  asset_id integer NOT NULL,
  user_id integer NOT NULL,
  FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX asset_users_idx_asset_id ON asset_users (asset_id);

;
CREATE INDEX asset_users_idx_user_id ON asset_users (user_id);

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
CREATE INDEX assets_idx_site ON assets (site);

;
CREATE TABLE attachment_attribute_data (
  id INTEGER PRIMARY KEY NOT NULL,
  value text,
  date_value date,
  field_id integer NOT NULL,
  attachment_id integer NOT NULL,
  FOREIGN KEY (attachment_id) REFERENCES attachments(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (field_id) REFERENCES attachment_attribute_details(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX attachment_attribute_data_idx_attachment_id ON attachment_attribute_data (attachment_id);

;
CREATE INDEX attachment_attribute_data_idx_field_id ON attachment_attribute_data (field_id);

;
CREATE TABLE attachment_attribute_details (
  id serial NOT NULL,
  code text,
  name text,
  type text,
  active boolean NOT NULL DEFAULT 1,
  site_id integer NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX attachment_attribute_details_idx_site_id ON attachment_attribute_details (site_id);

;
CREATE TABLE attachment_attribute_values (
  id serial NOT NULL,
  value text,
  priority text DEFAULT '50',
  field_id integer NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (field_id) REFERENCES attachment_attribute_details(id) ON UPDATE CASCADE
);

;
CREATE INDEX attachment_attribute_values_idx_field_id ON attachment_attribute_values (field_id);

;
CREATE TABLE attachment_data (
  id INTEGER PRIMARY KEY NOT NULL,
  att_id integer NOT NULL,
  data blob NOT NULL,
  created timestamp NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (att_id) REFERENCES attachments(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX attachment_data_idx_att_id ON attachment_data (att_id);

;
CREATE TABLE attachment_tags (
  id INTEGER PRIMARY KEY NOT NULL,
  attachment_id integer NOT NULL,
  tag_id integer NOT NULL,
  FOREIGN KEY (attachment_id) REFERENCES attachments(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX attachment_tags_idx_attachment_id ON attachment_tags (attachment_id);

;
CREATE INDEX attachment_tags_idx_tag_id ON attachment_tags (tag_id);

;
CREATE TABLE attachments (
  id INTEGER PRIMARY KEY NOT NULL,
  page_id integer NOT NULL,
  status text NOT NULL DEFAULT 'published',
  filename text NOT NULL,
  description text,
  mime_type text NOT NULL,
  priority integer NOT NULL DEFAULT 50,
  created timestamp NOT NULL DEFAULT current_timestamp,
  updated timestamp NOT NULL DEFAULT current_timestamp,
  slug text NOT NULL,
  FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX attachments_idx_page_id ON attachments (page_id);

;
CREATE TABLE element_attributes (
  id INTEGER PRIMARY KEY NOT NULL,
  element_id integer,
  code varchar(60),
  FOREIGN KEY (element_id) REFERENCES elements(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX element_attributes_idx_element_id ON element_attributes (element_id);

;
CREATE TABLE element_contents (
  id INTEGER PRIMARY KEY NOT NULL,
  element_id integer NOT NULL,
  data text NOT NULL,
  created timestamp NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (element_id) REFERENCES elements(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX element_contents_idx_element_id ON element_contents (element_id);

;
CREATE TABLE element_users (
  id INTEGER PRIMARY KEY NOT NULL,
  element_id integer,
  user_id integer,
  FOREIGN KEY (element_id) REFERENCES elements(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX element_users_idx_element_id ON element_users (element_id);

;
CREATE INDEX element_users_idx_user_id ON element_users (user_id);

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
CREATE INDEX elements_idx_site ON elements (site);

;
CREATE TABLE forms (
  id INTEGER PRIMARY KEY NOT NULL,
  site_id integer NOT NULL,
  owner_id integer NOT NULL,
  name text NOT NULL,
  mail_to text,
  mail_from text,
  recaptcha boolean NOT NULL DEFAULT false,
  recaptcha_public_key text,
  recaptcha_private_key text,
  ssl boolean,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX forms_idx_owner_id ON forms (owner_id);

;
CREATE INDEX forms_idx_site_id ON forms (site_id);

;
CREATE TABLE forms_constraints (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL,
  type text NOT NULL DEFAULT 'Required',
  value text
);

;
CREATE TABLE forms_content (
  id INTEGER PRIMARY KEY NOT NULL,
  content text NOT NULL,
  field_id integer NOT NULL,
  FOREIGN KEY (field_id) REFERENCES forms_fields(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX forms_content_idx_field_id ON forms_content (field_id);

;
CREATE TABLE forms_field_type (
  id INTEGER PRIMARY KEY NOT NULL,
  type enum NOT NULL DEFAULT 'Text'
);

;
CREATE TABLE forms_fields (
  id INTEGER PRIMARY KEY NOT NULL,
  form_id integer NOT NULL,
  label text NOT NULL,
  name text NOT NULL,
  priority integer NOT NULL DEFAULT 10,
  type integer NOT NULL,
  fields text,
  FOREIGN KEY (form_id) REFERENCES forms(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (type) REFERENCES forms_field_type(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX forms_fields_idx_form_id ON forms_fields (form_id);

;
CREATE INDEX forms_fields_idx_type ON forms_fields (type);

;
CREATE TABLE forms_fields_constraints (
  id INTEGER PRIMARY KEY NOT NULL,
  field_id integer,
  constraint_id integer,
  FOREIGN KEY (constraint_id) REFERENCES forms_constraints(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (field_id) REFERENCES forms_fields(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX forms_fields_constraints_idx_constraint_id ON forms_fields_constraints (constraint_id);

;
CREATE INDEX forms_fields_constraints_idx_field_id ON forms_fields_constraints (field_id);

;
CREATE TABLE forms_submit_field (
  id INTEGER PRIMARY KEY NOT NULL,
  value text NOT NULL,
  email text NOT NULL,
  redirect integer NOT NULL,
  submitted timestamp NOT NULL DEFAULT current_timestamp,
  form_id integer NOT NULL,
  FOREIGN KEY (form_id) REFERENCES forms(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (redirect) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX forms_submit_field_idx_form_id ON forms_submit_field (form_id);

;
CREATE INDEX forms_submit_field_idx_redirect ON forms_submit_field (redirect);

;
CREATE TABLE master_domains (
  id INTEGER PRIMARY KEY NOT NULL,
  domain varchar(255) NOT NULL,
  site integer NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX master_domains_idx_site ON master_domains (site);

;
CREATE TABLE page_attribute_data (
  id INTEGER PRIMARY KEY NOT NULL,
  value text,
  date_value date,
  field_id integer NOT NULL,
  page_id integer NOT NULL,
  FOREIGN KEY (field_id) REFERENCES page_attribute_details(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_attribute_data_idx_field_id ON page_attribute_data (field_id);

;
CREATE INDEX page_attribute_data_idx_page_id ON page_attribute_data (page_id);

;
CREATE TABLE page_attribute_details (
  id INTEGER PRIMARY KEY NOT NULL,
  code text,
  name text,
  type text,
  active boolean NOT NULL DEFAULT true,
  cascade boolean NOT NULL DEFAULT false,
  site_id integer NOT NULL,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_attribute_details_idx_site_id ON page_attribute_details (site_id);

;
CREATE TABLE page_attribute_values (
  id INTEGER PRIMARY KEY NOT NULL,
  value text,
  field_id integer NOT NULL,
  FOREIGN KEY (field_id) REFERENCES page_attribute_details(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_attribute_values_idx_field_id ON page_attribute_values (field_id);

;
CREATE TABLE page_contents (
  id INTEGER PRIMARY KEY NOT NULL,
  page_id integer NOT NULL,
  status text NOT NULL DEFAULT 'Published',
  body text NOT NULL,
  created timestamp NOT NULL DEFAULT current_timestamp,
  created_by integer,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_contents_idx_created_by ON page_contents (created_by);

;
CREATE INDEX page_contents_idx_page_id ON page_contents (page_id);

;
CREATE TABLE page_drafts (
  id INTEGER PRIMARY KEY NOT NULL,
  page_id integer NOT NULL,
  status text NOT NULL DEFAULT 'draft',
  created_by integer,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_drafts_idx_created_by ON page_drafts (created_by);

;
CREATE INDEX page_drafts_idx_page_id ON page_drafts (page_id);

;
CREATE TABLE page_drafts_content (
  id INTEGER PRIMARY KEY NOT NULL,
  draft_id integer NOT NULL,
  body text,
  created timestamp NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (draft_id) REFERENCES page_drafts(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_drafts_content_idx_draft_id ON page_drafts_content (draft_id);

;
CREATE TABLE page_tags (
  id INTEGER PRIMARY KEY NOT NULL,
  page_id integer NOT NULL,
  tag_id integer NOT NULL,
  FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_tags_idx_page_id ON page_tags (page_id);

;
CREATE INDEX page_tags_idx_tag_id ON page_tags (tag_id);

;
CREATE TABLE page_users (
  id INTEGER PRIMARY KEY NOT NULL,
  page_id integer,
  user_id integer,
  FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX page_users_idx_page_id ON page_users (page_id);

;
CREATE INDEX page_users_idx_user_id ON page_users (user_id);

;
CREATE TABLE pages (
  id INTEGER PRIMARY KEY NOT NULL,
  url text NOT NULL,
  status text NOT NULL DEFAULT 'published',
  parent_id integer,
  template_id integer,
  h1 text,
  breadcrumb text NOT NULL,
  title text NOT NULL,
  description text,
  priority integer NOT NULL DEFAULT 50,
  content_type text NOT NULL DEFAULT 'text/html',
  created timestamp NOT NULL DEFAULT current_timestamp,
  updated timestamp NOT NULL DEFAULT current_timestamp,
  site integer NOT NULL,
  created_by integer,
  blog boolean NOT NULL DEFAULT false,
  note_changes text,
  markup_type text,
  FOREIGN KEY (parent_id) REFERENCES pages(id),
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX pages_idx_parent_id ON pages (parent_id);

;
CREATE INDEX pages_idx_created_by ON pages (created_by);

;
CREATE INDEX pages_idx_site ON pages (site);

;
CREATE INDEX pages_idx_template_id ON pages (template_id);

;
CREATE UNIQUE INDEX pages_url_site ON pages (url, site);

;
CREATE TABLE parameter (
  id INTEGER PRIMARY KEY NOT NULL,
  data_type text NOT NULL,
  parameter text NOT NULL
);

;
CREATE TABLE parameter_defaults (
  id INTEGER PRIMARY KEY NOT NULL,
  parameter_id integer NOT NULL,
  data text,
  FOREIGN KEY (parameter_id) REFERENCES parameter(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX parameter_defaults_idx_parameter_id ON parameter_defaults (parameter_id);

;
CREATE TABLE redirect_domains (
  id INTEGER PRIMARY KEY NOT NULL,
  master_domain integer NOT NULL,
  domain varchar NOT NULL,
  status enum NOT NULL DEFAULT 'active',
  FOREIGN KEY (master_domain) REFERENCES master_domains(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX redirect_domains_idx_master_domain ON redirect_domains (master_domain);

;
CREATE TABLE role (
  id INTEGER PRIMARY KEY NOT NULL,
  role text NOT NULL
);

;
CREATE TABLE role_admin (
  role_id INTEGER PRIMARY KEY NOT NULL,
  FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE TABLE roles_allowed (
  role integer NOT NULL,
  role_allowed integer NOT NULL,
  PRIMARY KEY (role, role_allowed),
  FOREIGN KEY (role) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (role_allowed) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX roles_allowed_idx_role ON roles_allowed (role);

;
CREATE INDEX roles_allowed_idx_role_allowed ON roles_allowed (role_allowed);

;
CREATE TABLE site_attributes (
  id INTEGER PRIMARY KEY NOT NULL,
  site_id integer,
  code text NOT NULL,
  value text NOT NULL,
  super boolean NOT NULL DEFAULT false,
  name text,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX site_attributes_idx_site_id ON site_attributes (site_id);

;
CREATE TABLE sites (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(140) NOT NULL,
  status text NOT NULL DEFAULT 'active',
  template boolean NOT NULL DEFAULT false,
  profile_site integer,
  FOREIGN KEY (profile_site) REFERENCES sites(id)
);

;
CREATE INDEX sites_idx_profile_site ON sites (profile_site);

;
CREATE TABLE sites_users (
  id INTEGER PRIMARY KEY NOT NULL,
  site_id integer NOT NULL,
  user_id integer NOT NULL,
  FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX sites_users_idx_site_id ON sites_users (site_id);

;
CREATE INDEX sites_users_idx_user_id ON sites_users (user_id);

;
CREATE TABLE tag_groups (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL,
  cascade boolean NOT NULL DEFAULT false,
  multiple boolean NOT NULL DEFAULT false
);

;
CREATE TABLE tags (
  id INTEGER PRIMARY KEY NOT NULL,
  group_id integer NOT NULL,
  name text NOT NULL,
  FOREIGN KEY (group_id) REFERENCES tag_groups(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX tags_idx_group_id ON tags (group_id);

;
CREATE TABLE template_contents (
  id INTEGER PRIMARY KEY NOT NULL,
  template_id integer NOT NULL,
  data text NOT NULL,
  created timestamp NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX template_contents_idx_template_id ON template_contents (template_id);

;
CREATE TABLE templates (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL,
  site integer NOT NULL,
  FOREIGN KEY (site) REFERENCES sites(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX templates_idx_site ON templates (site);

;
CREATE UNIQUE INDEX templates_name ON templates (name);

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username text NOT NULL,
  password text NOT NULL,
  email text NOT NULL,
  name text NOT NULL,
  tel text,
  status text NOT NULL DEFAULT 'active',
  last_login timestamp,
  last_failed_login timestamp
);

;
CREATE UNIQUE INDEX user_index ON users (username);

;
CREATE TABLE users_data (
  id INTEGER PRIMARY KEY NOT NULL,
  users_id integer NOT NULL,
  key text NOT NULL,
  value text NOT NULL,
  FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX users_data_idx_users_id ON users_data (users_id);

;
CREATE TABLE users_parameter (
  users_id integer NOT NULL,
  parameter_id integer NOT NULL,
  value text NOT NULL,
  PRIMARY KEY (users_id, parameter_id),
  FOREIGN KEY (parameter_id) REFERENCES parameter(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX users_parameter_idx_parameter_id ON users_parameter (parameter_id);

;
CREATE INDEX users_parameter_idx_users_id ON users_parameter (users_id);

;
CREATE TABLE users_role (
  users_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (users_id, role_id),
  FOREIGN KEY (role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX users_role_idx_role_id ON users_role (role_id);

;
CREATE INDEX users_role_idx_users_id ON users_role (users_id);

;

COMMIT;

