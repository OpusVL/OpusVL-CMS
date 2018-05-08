-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Tue Jul 12 13:08:16 2016
-- 
;
--
-- Table: aliases
--
CREATE TABLE "aliases" (
  "id" serial NOT NULL,
  "page_id" integer NOT NULL,
  "url" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "aliases_idx_page_id" on "aliases" ("page_id");

;
--
-- Table: alternate_domains
--
CREATE TABLE "alternate_domains" (
  "id" serial NOT NULL,
  "port" integer DEFAULT 80 NOT NULL,
  "secure" boolean DEFAULT false NOT NULL,
  "master_domain" integer NOT NULL,
  "domain" character varying NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "alternate_domains_idx_master_domain" on "alternate_domains" ("master_domain");

;
--
-- Table: asset_attribute_data
--
CREATE TABLE "asset_attribute_data" (
  "id" serial NOT NULL,
  "value" text,
  "date_value" date,
  "field_id" integer NOT NULL,
  "asset_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "asset_attribute_data_idx_asset_id" on "asset_attribute_data" ("asset_id");
CREATE INDEX "asset_attribute_data_idx_field_id" on "asset_attribute_data" ("field_id");

;
--
-- Table: asset_attribute_details
--
CREATE TABLE "asset_attribute_details" (
  "id" serial NOT NULL,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "type" text NOT NULL,
  "active" boolean DEFAULT true NOT NULL,
  "site_id" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "asset_attribute_details_idx_site_id" on "asset_attribute_details" ("site_id");

;
--
-- Table: asset_attribute_values
--
CREATE TABLE "asset_attribute_values" (
  "id" serial NOT NULL,
  "value" text,
  "field_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "asset_attribute_values_idx_field_id" on "asset_attribute_values" ("field_id");

;
--
-- Table: asset_data
--
CREATE TABLE "asset_data" (
  "id" serial NOT NULL,
  "asset_id" integer NOT NULL,
  "data" bytea NOT NULL,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "asset_data_idx_asset_id" on "asset_data" ("asset_id");

;
--
-- Table: asset_users
--
CREATE TABLE "asset_users" (
  "id" serial NOT NULL,
  "asset_id" integer NOT NULL,
  "user_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "asset_users_idx_asset_id" on "asset_users" ("asset_id");
CREATE INDEX "asset_users_idx_user_id" on "asset_users" ("user_id");

;
--
-- Table: assets
--
CREATE TABLE "assets" (
  "id" serial NOT NULL,
  "status" text DEFAULT 'published' NOT NULL,
  "filename" text NOT NULL,
  "description" text,
  "mime_type" text NOT NULL,
  "site" integer NOT NULL,
  "global" boolean DEFAULT false NOT NULL,
  "priority" integer DEFAULT 10,
  "slug" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "assets_idx_site" on "assets" ("site");

;
--
-- Table: attachment_attribute_data
--
CREATE TABLE "attachment_attribute_data" (
  "id" serial NOT NULL,
  "value" text,
  "date_value" date,
  "field_id" integer NOT NULL,
  "attachment_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "attachment_attribute_data_idx_attachment_id" on "attachment_attribute_data" ("attachment_id");
CREATE INDEX "attachment_attribute_data_idx_field_id" on "attachment_attribute_data" ("field_id");

;
--
-- Table: attachment_attribute_details
--
CREATE TABLE "attachment_attribute_details" (
  "id" serial NOT NULL,
  "code" text,
  "name" text,
  "type" text,
  "active" boolean DEFAULT '1' NOT NULL,
  "site_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "attachment_attribute_details_idx_site_id" on "attachment_attribute_details" ("site_id");

;
--
-- Table: attachment_data
--
CREATE TABLE "attachment_data" (
  "id" serial NOT NULL,
  "att_id" integer NOT NULL,
  "data" bytea NOT NULL,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "attachment_data_idx_att_id" on "attachment_data" ("att_id");

;
--
-- Table: attachment_tags
--
CREATE TABLE "attachment_tags" (
  "id" serial NOT NULL,
  "attachment_id" integer NOT NULL,
  "tag_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "attachment_tags_idx_attachment_id" on "attachment_tags" ("attachment_id");
CREATE INDEX "attachment_tags_idx_tag_id" on "attachment_tags" ("tag_id");

;
--
-- Table: attachments
--
CREATE TABLE "attachments" (
  "id" serial NOT NULL,
  "page_id" integer NOT NULL,
  "status" text DEFAULT 'published' NOT NULL,
  "filename" text NOT NULL,
  "description" text,
  "mime_type" text NOT NULL,
  "priority" integer DEFAULT 50 NOT NULL,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  "updated" timestamp DEFAULT current_timestamp NOT NULL,
  "slug" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "attachments_idx_page_id" on "attachments" ("page_id");

;
--
-- Table: default_attribute_values
--
CREATE TABLE "default_attribute_values" (
  "id" serial NOT NULL,
  "field_id" integer NOT NULL,
  "value" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "default_attribute_values_idx_field_id" on "default_attribute_values" ("field_id");

;
--
-- Table: default_attributes
--
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
--
-- Table: element_attributes
--
CREATE TABLE "element_attributes" (
  "id" serial NOT NULL,
  "element_id" integer,
  "code" character varying(60),
  PRIMARY KEY ("id")
);
CREATE INDEX "element_attributes_idx_element_id" on "element_attributes" ("element_id");

;
--
-- Table: element_contents
--
CREATE TABLE "element_contents" (
  "id" serial NOT NULL,
  "element_id" integer NOT NULL,
  "data" text NOT NULL,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "element_contents_idx_element_id" on "element_contents" ("element_id");

;
--
-- Table: element_users
--
CREATE TABLE "element_users" (
  "id" serial NOT NULL,
  "element_id" integer,
  "user_id" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "element_users_idx_element_id" on "element_users" ("element_id");
CREATE INDEX "element_users_idx_user_id" on "element_users" ("user_id");

;
--
-- Table: elements
--
CREATE TABLE "elements" (
  "id" serial NOT NULL,
  "status" text DEFAULT 'published' NOT NULL,
  "name" text NOT NULL,
  "site" integer NOT NULL,
  "global" boolean DEFAULT false NOT NULL,
  "slug" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "elements_idx_site" on "elements" ("site");

;
--
-- Table: forms
--
CREATE TABLE "forms" (
  "id" serial NOT NULL,
  "site_id" integer NOT NULL,
  "owner_id" integer NOT NULL,
  "name" text NOT NULL,
  "mail_to" text,
  "mail_from" text,
  "recaptcha" boolean DEFAULT false NOT NULL,
  "recaptcha_public_key" text,
  "recaptcha_private_key" text,
  "ssl" boolean,
  PRIMARY KEY ("id")
);
CREATE INDEX "forms_idx_owner_id" on "forms" ("owner_id");
CREATE INDEX "forms_idx_site_id" on "forms" ("site_id");

;
--
-- Table: forms_constraints
--
CREATE TABLE "forms_constraints" (
  "id" serial NOT NULL,
  "name" text NOT NULL,
  "type" text DEFAULT 'Required' NOT NULL,
  "value" text,
  PRIMARY KEY ("id")
);

;
--
-- Table: forms_content
--
CREATE TABLE "forms_content" (
  "id" serial NOT NULL,
  "content" text NOT NULL,
  "field_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "forms_content_idx_field_id" on "forms_content" ("field_id");

;
--
-- Table: forms_field_type
--
CREATE TABLE "forms_field_type" (
  "id" serial NOT NULL,
  "type" character varying DEFAULT 'Text' NOT NULL,
  PRIMARY KEY ("id")
);

;
--
-- Table: forms_fields
--
CREATE TABLE "forms_fields" (
  "id" serial NOT NULL,
  "form_id" integer NOT NULL,
  "label" text NOT NULL,
  "name" text NOT NULL,
  "priority" integer DEFAULT 10 NOT NULL,
  "type" integer NOT NULL,
  "fields" text,
  PRIMARY KEY ("id")
);
CREATE INDEX "forms_fields_idx_form_id" on "forms_fields" ("form_id");
CREATE INDEX "forms_fields_idx_type" on "forms_fields" ("type");

;
--
-- Table: forms_fields_constraints
--
CREATE TABLE "forms_fields_constraints" (
  "id" serial NOT NULL,
  "field_id" integer,
  "constraint_id" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "forms_fields_constraints_idx_constraint_id" on "forms_fields_constraints" ("constraint_id");
CREATE INDEX "forms_fields_constraints_idx_field_id" on "forms_fields_constraints" ("field_id");

;
--
-- Table: forms_submit_field
--
CREATE TABLE "forms_submit_field" (
  "id" serial NOT NULL,
  "value" text NOT NULL,
  "email" text NOT NULL,
  "redirect" integer NOT NULL,
  "submitted" timestamp DEFAULT current_timestamp NOT NULL,
  "form_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "forms_submit_field_idx_form_id" on "forms_submit_field" ("form_id");
CREATE INDEX "forms_submit_field_idx_redirect" on "forms_submit_field" ("redirect");

;
--
-- Table: master_domains
--
CREATE TABLE "master_domains" (
  "id" serial NOT NULL,
  "domain" character varying(255) NOT NULL,
  "site" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "master_domains_idx_site" on "master_domains" ("site");

;
--
-- Table: page_attribute_data
--
CREATE TABLE "page_attribute_data" (
  "id" serial NOT NULL,
  "value" text,
  "date_value" date,
  "field_id" integer NOT NULL,
  "page_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_attribute_data_idx_field_id" on "page_attribute_data" ("field_id");
CREATE INDEX "page_attribute_data_idx_page_id" on "page_attribute_data" ("page_id");

;
--
-- Table: page_attribute_details
--
CREATE TABLE "page_attribute_details" (
  "id" serial NOT NULL,
  "code" text,
  "name" text,
  "type" text,
  "active" boolean DEFAULT true NOT NULL,
  "cascade" boolean DEFAULT false NOT NULL,
  "site_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_attribute_details_idx_site_id" on "page_attribute_details" ("site_id");

;
--
-- Table: page_attribute_values
--
CREATE TABLE "page_attribute_values" (
  "id" serial NOT NULL,
  "value" text,
  "field_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_attribute_values_idx_field_id" on "page_attribute_values" ("field_id");

;
--
-- Table: page_contents
--
CREATE TABLE "page_contents" (
  "id" serial NOT NULL,
  "page_id" integer NOT NULL,
  "status" text DEFAULT 'Published' NOT NULL,
  "body" text NOT NULL,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  "created_by" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_contents_idx_created_by" on "page_contents" ("created_by");
CREATE INDEX "page_contents_idx_page_id" on "page_contents" ("page_id");

;
--
-- Table: page_drafts
--
CREATE TABLE "page_drafts" (
  "id" serial NOT NULL,
  "page_id" integer NOT NULL,
  "status" text DEFAULT 'draft' NOT NULL,
  "created_by" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_drafts_idx_created_by" on "page_drafts" ("created_by");
CREATE INDEX "page_drafts_idx_page_id" on "page_drafts" ("page_id");

;
--
-- Table: page_drafts_content
--
CREATE TABLE "page_drafts_content" (
  "id" serial NOT NULL,
  "draft_id" integer NOT NULL,
  "body" text,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_drafts_content_idx_draft_id" on "page_drafts_content" ("draft_id");

;
--
-- Table: page_tags
--
CREATE TABLE "page_tags" (
  "id" serial NOT NULL,
  "page_id" integer NOT NULL,
  "tag_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_tags_idx_page_id" on "page_tags" ("page_id");
CREATE INDEX "page_tags_idx_tag_id" on "page_tags" ("tag_id");

;
--
-- Table: page_users
--
CREATE TABLE "page_users" (
  "id" serial NOT NULL,
  "page_id" integer,
  "user_id" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "page_users_idx_page_id" on "page_users" ("page_id");
CREATE INDEX "page_users_idx_user_id" on "page_users" ("user_id");

;
--
-- Table: pages
--
CREATE TABLE "pages" (
  "id" serial NOT NULL,
  "url" text NOT NULL,
  "status" text DEFAULT 'published' NOT NULL,
  "parent_id" integer,
  "template_id" integer,
  "h1" text,
  "breadcrumb" text NOT NULL,
  "title" text NOT NULL,
  "description" text,
  "priority" integer DEFAULT 50 NOT NULL,
  "content_type" text DEFAULT 'text/html' NOT NULL,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  "updated" timestamp DEFAULT current_timestamp NOT NULL,
  "site" integer NOT NULL,
  "created_by" integer,
  "blog" boolean DEFAULT false NOT NULL,
  "note_changes" text,
  "markup_type" text,
  PRIMARY KEY ("id"),
  CONSTRAINT "pages_url_site" UNIQUE ("url", "site")
);
CREATE INDEX "pages_idx_parent_id" on "pages" ("parent_id");
CREATE INDEX "pages_idx_created_by" on "pages" ("created_by");
CREATE INDEX "pages_idx_site" on "pages" ("site");
CREATE INDEX "pages_idx_template_id" on "pages" ("template_id");

;
--
-- Table: parameter
--
CREATE TABLE "parameter" (
  "id" serial NOT NULL,
  "data_type" text NOT NULL,
  "parameter" text NOT NULL,
  PRIMARY KEY ("id")
);

;
--
-- Table: plugins
--
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
--
-- Table: redirect_domains
--
CREATE TABLE "redirect_domains" (
  "id" serial NOT NULL,
  "master_domain" integer NOT NULL,
  "domain" character varying NOT NULL,
  "status" character varying DEFAULT 'active' NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "redirect_domains_idx_master_domain" on "redirect_domains" ("master_domain");

;
--
-- Table: site_attributes
--
CREATE TABLE "site_attributes" (
  "id" serial NOT NULL,
  "site_id" integer,
  "code" text NOT NULL,
  "value" text NOT NULL,
  "super" boolean DEFAULT false NOT NULL,
  "name" text,
  PRIMARY KEY ("id")
);
CREATE INDEX "site_attributes_idx_site_id" on "site_attributes" ("site_id");

;
--
-- Table: sites
--
CREATE TABLE "sites" (
  "id" serial NOT NULL,
  "name" character varying(140) NOT NULL,
  "status" text DEFAULT 'active' NOT NULL,
  PRIMARY KEY ("id")
);

;
--
-- Table: sites_users
--
CREATE TABLE "sites_users" (
  "id" serial NOT NULL,
  "site_id" integer NOT NULL,
  "user_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "sites_users_idx_site_id" on "sites_users" ("site_id");
CREATE INDEX "sites_users_idx_user_id" on "sites_users" ("user_id");

;
--
-- Table: tag_groups
--
CREATE TABLE "tag_groups" (
  "id" serial NOT NULL,
  "name" text NOT NULL,
  "cascade" boolean DEFAULT false NOT NULL,
  "multiple" boolean DEFAULT false NOT NULL,
  PRIMARY KEY ("id")
);

;
--
-- Table: tags
--
CREATE TABLE "tags" (
  "id" serial NOT NULL,
  "group_id" integer NOT NULL,
  "name" text NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "tags_idx_group_id" on "tags" ("group_id");

;
--
-- Table: template_contents
--
CREATE TABLE "template_contents" (
  "id" serial NOT NULL,
  "template_id" integer NOT NULL,
  "data" text NOT NULL,
  "created" timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "template_contents_idx_template_id" on "template_contents" ("template_id");

;
--
-- Table: templates
--
CREATE TABLE "templates" (
  "id" serial NOT NULL,
  "name" text NOT NULL,
  "site" integer NOT NULL,
  "global" boolean DEFAULT false NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "templates_name" UNIQUE ("name")
);
CREATE INDEX "templates_idx_site" on "templates" ("site");

;
--
-- Table: attachment_attribute_values
--
CREATE TABLE "attachment_attribute_values" (
  "id" serial NOT NULL,
  "value" text,
  "priority" text DEFAULT '50',
  "field_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "attachment_attribute_values_idx_field_id" on "attachment_attribute_values" ("field_id");

;
ALTER TABLE "aliases" ADD CONSTRAINT "aliases_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "alternate_domains" ADD CONSTRAINT "alternate_domains_fk_master_domain" FOREIGN KEY ("master_domain")
  REFERENCES "master_domains" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "asset_attribute_data" ADD CONSTRAINT "asset_attribute_data_fk_asset_id" FOREIGN KEY ("asset_id")
  REFERENCES "assets" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "asset_attribute_data" ADD CONSTRAINT "asset_attribute_data_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "asset_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "asset_attribute_details" ADD CONSTRAINT "asset_attribute_details_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "asset_attribute_values" ADD CONSTRAINT "asset_attribute_values_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "asset_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "asset_data" ADD CONSTRAINT "asset_data_fk_asset_id" FOREIGN KEY ("asset_id")
  REFERENCES "assets" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "asset_users" ADD CONSTRAINT "asset_users_fk_asset_id" FOREIGN KEY ("asset_id")
  REFERENCES "assets" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "asset_users" ADD CONSTRAINT "asset_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "assets" ADD CONSTRAINT "assets_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachment_attribute_data" ADD CONSTRAINT "attachment_attribute_data_fk_attachment_id" FOREIGN KEY ("attachment_id")
  REFERENCES "attachments" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachment_attribute_data" ADD CONSTRAINT "attachment_attribute_data_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "attachment_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachment_attribute_details" ADD CONSTRAINT "attachment_attribute_details_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachment_data" ADD CONSTRAINT "attachment_data_fk_att_id" FOREIGN KEY ("att_id")
  REFERENCES "attachments" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachment_tags" ADD CONSTRAINT "attachment_tags_fk_attachment_id" FOREIGN KEY ("attachment_id")
  REFERENCES "attachments" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachment_tags" ADD CONSTRAINT "attachment_tags_fk_tag_id" FOREIGN KEY ("tag_id")
  REFERENCES "tags" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "default_attribute_values" ADD CONSTRAINT "default_attribute_values_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "default_attributes" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "element_attributes" ADD CONSTRAINT "element_attributes_fk_element_id" FOREIGN KEY ("element_id")
  REFERENCES "elements" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "element_contents" ADD CONSTRAINT "element_contents_fk_element_id" FOREIGN KEY ("element_id")
  REFERENCES "elements" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "element_users" ADD CONSTRAINT "element_users_fk_element_id" FOREIGN KEY ("element_id")
  REFERENCES "elements" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "element_users" ADD CONSTRAINT "element_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "elements" ADD CONSTRAINT "elements_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms" ADD CONSTRAINT "forms_fk_owner_id" FOREIGN KEY ("owner_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms" ADD CONSTRAINT "forms_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms_content" ADD CONSTRAINT "forms_content_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "forms_fields" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms_fields" ADD CONSTRAINT "forms_fields_fk_form_id" FOREIGN KEY ("form_id")
  REFERENCES "forms" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms_fields" ADD CONSTRAINT "forms_fields_fk_type" FOREIGN KEY ("type")
  REFERENCES "forms_field_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms_fields_constraints" ADD CONSTRAINT "forms_fields_constraints_fk_constraint_id" FOREIGN KEY ("constraint_id")
  REFERENCES "forms_constraints" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms_fields_constraints" ADD CONSTRAINT "forms_fields_constraints_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "forms_fields" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms_submit_field" ADD CONSTRAINT "forms_submit_field_fk_form_id" FOREIGN KEY ("form_id")
  REFERENCES "forms" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "forms_submit_field" ADD CONSTRAINT "forms_submit_field_fk_redirect" FOREIGN KEY ("redirect")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "master_domains" ADD CONSTRAINT "master_domains_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_attribute_data" ADD CONSTRAINT "page_attribute_data_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "page_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_attribute_data" ADD CONSTRAINT "page_attribute_data_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_attribute_details" ADD CONSTRAINT "page_attribute_details_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_attribute_values" ADD CONSTRAINT "page_attribute_values_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "page_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_contents" ADD CONSTRAINT "page_contents_fk_created_by" FOREIGN KEY ("created_by")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_contents" ADD CONSTRAINT "page_contents_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_drafts" ADD CONSTRAINT "page_drafts_fk_created_by" FOREIGN KEY ("created_by")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_drafts" ADD CONSTRAINT "page_drafts_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_drafts_content" ADD CONSTRAINT "page_drafts_content_fk_draft_id" FOREIGN KEY ("draft_id")
  REFERENCES "page_drafts" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_tags" ADD CONSTRAINT "page_tags_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_tags" ADD CONSTRAINT "page_tags_fk_tag_id" FOREIGN KEY ("tag_id")
  REFERENCES "tags" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_users" ADD CONSTRAINT "page_users_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "page_users" ADD CONSTRAINT "page_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "pages" ADD CONSTRAINT "pages_fk_parent_id" FOREIGN KEY ("parent_id")
  REFERENCES "pages" ("id") DEFERRABLE;

;
ALTER TABLE "pages" ADD CONSTRAINT "pages_fk_created_by" FOREIGN KEY ("created_by")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "pages" ADD CONSTRAINT "pages_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "pages" ADD CONSTRAINT "pages_fk_template_id" FOREIGN KEY ("template_id")
  REFERENCES "templates" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "redirect_domains" ADD CONSTRAINT "redirect_domains_fk_master_domain" FOREIGN KEY ("master_domain")
  REFERENCES "master_domains" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "site_attributes" ADD CONSTRAINT "site_attributes_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "sites_users" ADD CONSTRAINT "sites_users_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "sites_users" ADD CONSTRAINT "sites_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "tags" ADD CONSTRAINT "tags_fk_group_id" FOREIGN KEY ("group_id")
  REFERENCES "tag_groups" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "template_contents" ADD CONSTRAINT "template_contents_fk_template_id" FOREIGN KEY ("template_id")
  REFERENCES "templates" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "templates" ADD CONSTRAINT "templates_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "attachment_attribute_values" ADD CONSTRAINT "attachment_attribute_values_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "attachment_attribute_details" ("id") ON UPDATE CASCADE DEFERRABLE;

;
