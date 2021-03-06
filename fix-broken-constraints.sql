-- This file is intended to fix PREM's CMS database to remove autogenerated
-- constraints that are now wrong, and replace them with the ones that would
-- have been deployed if we'd deployed it from scratch in the first place.

-- This drops and recreates all of the constraints because we want them to be
-- named the same thing as the deploymenthandler script makes, irrespective of
-- whether they were functionally wrong.

-- This does not drop any FK that has gone away because I daren't.

-- It might work for other people too.

-- (note: why don't they have default_attribute_values or default_attributes?)

BEGIN;

ALTER TABLE "aliases" DROP CONSTRAINT "aliases_page_id_fkey";
ALTER TABLE "aliases" ADD CONSTRAINT "aliases_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "alternate_domains" DROP CONSTRAINT "alternate_domains_master_domain_fkey";
ALTER TABLE "alternate_domains" ADD CONSTRAINT "alternate_domains_fk_master_domain" FOREIGN KEY ("master_domain")
  REFERENCES "master_domains" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "asset_attribute_data" DROP CONSTRAINT "asset_attribute_data_asset_id_fkey";
ALTER TABLE "asset_attribute_data" ADD CONSTRAINT "asset_attribute_data_fk_asset_id" FOREIGN KEY ("asset_id")
  REFERENCES "assets" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "asset_attribute_data" DROP CONSTRAINT "asset_attribute_data_field_id_fkey";
ALTER TABLE "asset_attribute_data" ADD CONSTRAINT "asset_attribute_data_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "asset_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "asset_attribute_details" DROP CONSTRAINT "asset_attribute_details_site_id_fkey";
ALTER TABLE "asset_attribute_details" ADD CONSTRAINT "asset_attribute_details_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "asset_attribute_values" DROP CONSTRAINT "asset_attribute_values_field_id_fkey";
ALTER TABLE "asset_attribute_values" ADD CONSTRAINT "asset_attribute_values_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "asset_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "asset_data" DROP CONSTRAINT "asset_data_asset_id_fkey";
ALTER TABLE "asset_data" ADD CONSTRAINT "asset_data_fk_asset_id" FOREIGN KEY ("asset_id")
  REFERENCES "assets" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "asset_users" DROP CONSTRAINT "asset_users_asset_id_fkey";
ALTER TABLE "asset_users" ADD CONSTRAINT "asset_users_fk_asset_id" FOREIGN KEY ("asset_id")
  REFERENCES "assets" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "asset_users" DROP CONSTRAINT "asset_users_user_id_fkey";
ALTER TABLE "asset_users" ADD CONSTRAINT "asset_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "assets" DROP CONSTRAINT "assets_site_fkey";
ALTER TABLE "assets" ADD CONSTRAINT "assets_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachment_attribute_data" DROP CONSTRAINT "attachment_attribute_data_attachment_id_fkey";
ALTER TABLE "attachment_attribute_data" ADD CONSTRAINT "attachment_attribute_data_fk_attachment_id" FOREIGN KEY ("attachment_id")
  REFERENCES "attachments" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachment_attribute_data" DROP CONSTRAINT "attachment_attribute_data_field_id_fkey";
ALTER TABLE "attachment_attribute_data" ADD CONSTRAINT "attachment_attribute_data_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "attachment_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachment_attribute_details" DROP CONSTRAINT "attachment_attribute_details_site_id_fkey";
ALTER TABLE "attachment_attribute_details" ADD CONSTRAINT "attachment_attribute_details_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachment_data" DROP CONSTRAINT "attachment_data_att_id_fkey";
ALTER TABLE "attachment_data" ADD CONSTRAINT "attachment_data_fk_att_id" FOREIGN KEY ("att_id")
  REFERENCES "attachments" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachment_tags" DROP CONSTRAINT "attachment_tags_attachment_id_fkey";
ALTER TABLE "attachment_tags" ADD CONSTRAINT "attachment_tags_fk_attachment_id" FOREIGN KEY ("attachment_id")
  REFERENCES "attachments" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachment_tags" DROP CONSTRAINT "attachment_tags_tag_id_fkey";
ALTER TABLE "attachment_tags" ADD CONSTRAINT "attachment_tags_fk_tag_id" FOREIGN KEY ("tag_id")
  REFERENCES "tags" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachments" DROP CONSTRAINT "attachments_page_id_fkey";
ALTER TABLE "attachments" ADD CONSTRAINT "attachments_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "element_attributes" DROP CONSTRAINT "element_attributes_element_id_fkey";
ALTER TABLE "element_attributes" ADD CONSTRAINT "element_attributes_fk_element_id" FOREIGN KEY ("element_id")
  REFERENCES "elements" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "element_contents" DROP CONSTRAINT "element_contents_element_id_fkey";
ALTER TABLE "element_contents" ADD CONSTRAINT "element_contents_fk_element_id" FOREIGN KEY ("element_id")
  REFERENCES "elements" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "element_users" DROP CONSTRAINT "element_users_element_idid_fkey";
ALTER TABLE "element_users" ADD CONSTRAINT "element_users_fk_element_id" FOREIGN KEY ("element_id")
  REFERENCES "elements" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "element_users" DROP CONSTRAINT "element_users_user_idid_fkey";
ALTER TABLE "element_users" ADD CONSTRAINT "element_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "elements" DROP CONSTRAINT "elements_site_fkey";
ALTER TABLE "elements" ADD CONSTRAINT "elements_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "forms" DROP CONSTRAINT "forms_owner_id_fkey";
ALTER TABLE "forms" ADD CONSTRAINT "forms_fk_owner_id" FOREIGN KEY ("owner_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "forms" DROP CONSTRAINT "forms_site_id_fkey";
ALTER TABLE "forms" ADD CONSTRAINT "forms_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "forms_content" DROP CONSTRAINT "forms_content_field_id_fkey";
ALTER TABLE "forms_content" ADD CONSTRAINT "forms_content_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "forms_fields" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "forms_fields" DROP CONSTRAINT "forms_fields_form_id_fkey";
ALTER TABLE "forms_fields" ADD CONSTRAINT "forms_fields_fk_form_id" FOREIGN KEY ("form_id")
  REFERENCES "forms" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "forms_submit_field" DROP CONSTRAINT "forms_submit_field_form_id_fkey";
ALTER TABLE "forms_submit_field" ADD CONSTRAINT "forms_submit_field_fk_form_id" FOREIGN KEY ("form_id")
  REFERENCES "forms" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "forms_submit_field" DROP CONSTRAINT "forms_submit_field_redirect_fkey";
ALTER TABLE "forms_submit_field" ADD CONSTRAINT "forms_submit_field_fk_redirect" FOREIGN KEY ("redirect")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "master_domains" DROP CONSTRAINT "master_domains_site_fkey";
ALTER TABLE "master_domains" ADD CONSTRAINT "master_domains_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_attribute_data" DROP CONSTRAINT "page_attribute_data_field_id_fkey";
ALTER TABLE "page_attribute_data" ADD CONSTRAINT "page_attribute_data_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "page_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_attribute_data" DROP CONSTRAINT "page_attribute_data_page_id_fkey";
ALTER TABLE "page_attribute_data" ADD CONSTRAINT "page_attribute_data_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_attribute_details" DROP CONSTRAINT "page_attribute_details_site_id_fkey";
ALTER TABLE "page_attribute_details" ADD CONSTRAINT "page_attribute_details_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_attribute_values" DROP CONSTRAINT "page_attribute_values_field_id_fkey";
ALTER TABLE "page_attribute_values" ADD CONSTRAINT "page_attribute_values_fk_field_id" FOREIGN KEY ("field_id")
  REFERENCES "page_attribute_details" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_contents" DROP CONSTRAINT "page_contents_created_by_fkey";
-- the new one already exists ?!?!?1

ALTER TABLE "page_contents" DROP CONSTRAINT "page_contents_page_id_fkey";
ALTER TABLE "page_contents" ADD CONSTRAINT "page_contents_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_drafts" DROP CONSTRAINT "page_drafts_created_by_fkey";
ALTER TABLE "page_drafts" ADD CONSTRAINT "page_drafts_fk_created_by" FOREIGN KEY ("created_by")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_drafts" DROP CONSTRAINT "page_drafts_page_id_fkey";
ALTER TABLE "page_drafts" ADD CONSTRAINT "page_drafts_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_drafts_content" DROP CONSTRAINT "page_drafts_content_draft_id_fkey";
ALTER TABLE "page_drafts_content" ADD CONSTRAINT "page_drafts_content_fk_draft_id" FOREIGN KEY ("draft_id")
  REFERENCES "page_drafts" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_tags" DROP CONSTRAINT "page_tags_page_id_fkey";
ALTER TABLE "page_tags" ADD CONSTRAINT "page_tags_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_tags" DROP CONSTRAINT "page_tags_tag_id_fkey";
ALTER TABLE "page_tags" ADD CONSTRAINT "page_tags_fk_tag_id" FOREIGN KEY ("tag_id")
  REFERENCES "tags" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

-- this doesn't exist yet ?!?!
ALTER TABLE page_users ALTER COLUMN page_id TYPE integer USING (page_id::integer);
DELETE FROM page_users p WHERE p.page_id NOT IN (SELECT id FROM pages);
ALTER TABLE "page_users" ADD CONSTRAINT "page_users_fk_page_id" FOREIGN KEY ("page_id")
  REFERENCES "pages" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "page_users" DROP CONSTRAINT "page_users_user_id_fkey";
ALTER TABLE "page_users" ADD CONSTRAINT "page_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "pages" DROP CONSTRAINT "pages_parent_id_fkey";
-- the new one already exists ?!?!?1

ALTER TABLE "pages" DROP CONSTRAINT "pages_created_by_fkey";
ALTER TABLE "pages" ADD CONSTRAINT "pages_fk_created_by" FOREIGN KEY ("created_by")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "pages" DROP CONSTRAINT "pages_site_fkey";
ALTER TABLE "pages" ADD CONSTRAINT "pages_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "pages" DROP CONSTRAINT "pages_template_id_fkey";
ALTER TABLE "pages" ADD CONSTRAINT "pages_fk_template_id" FOREIGN KEY ("template_id")
  REFERENCES "templates" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "redirect_domains" DROP CONSTRAINT "redirect_domains_master_domain_fkey";
ALTER TABLE "redirect_domains" ADD CONSTRAINT "redirect_domains_fk_master_domain" FOREIGN KEY ("master_domain")
  REFERENCES "master_domains" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "site_attributes" DROP CONSTRAINT "site_attributes_site_id_fkey";
ALTER TABLE "site_attributes" ADD CONSTRAINT "site_attributes_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "sites_users" DROP CONSTRAINT "sites_users_site_id_fkey";
ALTER TABLE "sites_users" ADD CONSTRAINT "sites_users_fk_site_id" FOREIGN KEY ("site_id")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "sites_users" DROP CONSTRAINT "sites_users_user_id_fkey";
ALTER TABLE "sites_users" ADD CONSTRAINT "sites_users_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "tags" DROP CONSTRAINT "tags_group_id_fkey";
ALTER TABLE "tags" ADD CONSTRAINT "tags_fk_group_id" FOREIGN KEY ("group_id")
  REFERENCES "tag_groups" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "template_contents" DROP CONSTRAINT "template_contents_template_id_fkey";
ALTER TABLE "template_contents" ADD CONSTRAINT "template_contents_fk_template_id" FOREIGN KEY ("template_id")
  REFERENCES "templates" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "templates" DROP CONSTRAINT "templates_site_fkey";
ALTER TABLE "templates" ADD CONSTRAINT "templates_fk_site" FOREIGN KEY ("site")
  REFERENCES "sites" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "attachment_attribute_values" DROP CONSTRAINT "attachment_attribute_values_field_id_fkey";

COMMIT;
