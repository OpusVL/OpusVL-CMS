-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Fri Sep  9 17:48:36 2016
-- 
;
SET foreign_key_checks=0;
--
-- Table: `aclfeature`
--
CREATE TABLE `aclfeature` (
  `id` integer NOT NULL auto_increment,
  `feature` text NOT NULL,
  `feature_description` text NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
--
-- Table: `aclfeature_role`
--
CREATE TABLE `aclfeature_role` (
  `aclfeature_id` integer NOT NULL,
  `role_id` integer NOT NULL,
  INDEX `aclfeature_role_idx_aclfeature_id` (`aclfeature_id`),
  INDEX `aclfeature_role_idx_role_id` (`role_id`),
  PRIMARY KEY (`aclfeature_id`, `role_id`),
  CONSTRAINT `aclfeature_role_fk_aclfeature_id` FOREIGN KEY (`aclfeature_id`) REFERENCES `aclfeature` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `aclfeature_role_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `aclrule`
--
CREATE TABLE `aclrule` (
  `id` integer NOT NULL auto_increment,
  `actionpath` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
--
-- Table: `aliases`
--
CREATE TABLE `aliases` (
  `id` integer NOT NULL auto_increment,
  `page_id` integer NOT NULL,
  `url` text NOT NULL,
  INDEX `aliases_idx_page_id` (`page_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `aliases_fk_page_id` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `alternate_domains`
--
CREATE TABLE `alternate_domains` (
  `id` integer NOT NULL auto_increment,
  `port` integer NOT NULL DEFAULT 80,
  `secure` enum('0','1') NOT NULL DEFAULT false,
  `master_domain` integer NOT NULL,
  `domain` varchar(255) NOT NULL,
  INDEX `alternate_domains_idx_master_domain` (`master_domain`),
  PRIMARY KEY (`id`),
  CONSTRAINT `alternate_domains_fk_master_domain` FOREIGN KEY (`master_domain`) REFERENCES `master_domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `asset_attribute_data`
--
CREATE TABLE `asset_attribute_data` (
  `id` integer NOT NULL auto_increment,
  `value` text NULL,
  `date_value` date NULL,
  `field_id` integer NOT NULL,
  `asset_id` integer NOT NULL,
  INDEX `asset_attribute_data_idx_asset_id` (`asset_id`),
  INDEX `asset_attribute_data_idx_field_id` (`field_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `asset_attribute_data_fk_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `asset_attribute_data_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `asset_attribute_details` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `asset_attribute_details`
--
CREATE TABLE `asset_attribute_details` (
  `id` integer NOT NULL auto_increment,
  `code` text NOT NULL,
  `name` text NOT NULL,
  `type` text NOT NULL,
  `active` enum('0','1') NOT NULL DEFAULT true,
  `site_id` integer NULL,
  INDEX `asset_attribute_details_idx_site_id` (`site_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `asset_attribute_details_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `asset_attribute_values`
--
CREATE TABLE `asset_attribute_values` (
  `id` integer NOT NULL auto_increment,
  `value` text NULL,
  `field_id` integer NOT NULL,
  INDEX `asset_attribute_values_idx_field_id` (`field_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `asset_attribute_values_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `asset_attribute_details` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `asset_data`
--
CREATE TABLE `asset_data` (
  `id` integer NOT NULL auto_increment,
  `asset_id` integer NOT NULL,
  `data` BLOB NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  INDEX `asset_data_idx_asset_id` (`asset_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `asset_data_fk_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `asset_users`
--
CREATE TABLE `asset_users` (
  `id` integer NOT NULL auto_increment,
  `asset_id` integer NOT NULL,
  `user_id` integer NOT NULL,
  INDEX `asset_users_idx_asset_id` (`asset_id`),
  INDEX `asset_users_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `asset_users_fk_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `asset_users_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `assets`
--
CREATE TABLE `assets` (
  `id` integer NOT NULL auto_increment,
  `status` text NOT NULL DEFAULT 'published',
  `filename` text NOT NULL,
  `description` text NULL,
  `mime_type` text NOT NULL,
  `site` integer NOT NULL,
  `priority` integer NULL DEFAULT 10,
  `slug` text NOT NULL,
  INDEX `assets_idx_site` (`site`),
  PRIMARY KEY (`id`),
  CONSTRAINT `assets_fk_site` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `attachment_attribute_data`
--
CREATE TABLE `attachment_attribute_data` (
  `id` integer NOT NULL auto_increment,
  `value` text NULL,
  `date_value` date NULL,
  `field_id` integer NOT NULL,
  `attachment_id` integer NOT NULL,
  INDEX `attachment_attribute_data_idx_attachment_id` (`attachment_id`),
  INDEX `attachment_attribute_data_idx_field_id` (`field_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `attachment_attribute_data_fk_attachment_id` FOREIGN KEY (`attachment_id`) REFERENCES `attachments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attachment_attribute_data_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `attachment_attribute_details` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `attachment_attribute_details`
--
CREATE TABLE `attachment_attribute_details` (
  `id` integer NOT NULL auto_increment,
  `code` text NULL,
  `name` text NULL,
  `type` text NULL,
  `active` enum('0','1') NOT NULL DEFAULT '1',
  `site_id` integer NOT NULL,
  INDEX `attachment_attribute_details_idx_site_id` (`site_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `attachment_attribute_details_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `attachment_data`
--
CREATE TABLE `attachment_data` (
  `id` integer NOT NULL auto_increment,
  `att_id` integer NOT NULL,
  `data` BLOB NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  INDEX `attachment_data_idx_att_id` (`att_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `attachment_data_fk_att_id` FOREIGN KEY (`att_id`) REFERENCES `attachments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `attachment_tags`
--
CREATE TABLE `attachment_tags` (
  `id` integer NOT NULL auto_increment,
  `attachment_id` integer NOT NULL,
  `tag_id` integer NOT NULL,
  INDEX `attachment_tags_idx_attachment_id` (`attachment_id`),
  INDEX `attachment_tags_idx_tag_id` (`tag_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `attachment_tags_fk_attachment_id` FOREIGN KEY (`attachment_id`) REFERENCES `attachments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `attachment_tags_fk_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `attachments`
--
CREATE TABLE `attachments` (
  `id` integer NOT NULL auto_increment,
  `page_id` integer NOT NULL,
  `status` text NOT NULL DEFAULT 'published',
  `filename` text NOT NULL,
  `description` text NULL,
  `mime_type` text NOT NULL,
  `priority` integer NOT NULL DEFAULT 50,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  `updated` timestamp NOT NULL DEFAULT current_timestamp,
  `slug` text NOT NULL,
  INDEX `attachments_idx_page_id` (`page_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `attachments_fk_page_id` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `element_attributes`
--
CREATE TABLE `element_attributes` (
  `id` integer NOT NULL auto_increment,
  `element_id` integer NULL,
  `code` varchar(60) NULL,
  INDEX `element_attributes_idx_element_id` (`element_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `element_attributes_fk_element_id` FOREIGN KEY (`element_id`) REFERENCES `elements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `element_contents`
--
CREATE TABLE `element_contents` (
  `id` integer NOT NULL auto_increment,
  `element_id` integer NOT NULL,
  `data` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  INDEX `element_contents_idx_element_id` (`element_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `element_contents_fk_element_id` FOREIGN KEY (`element_id`) REFERENCES `elements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `element_users`
--
CREATE TABLE `element_users` (
  `id` integer NOT NULL auto_increment,
  `element_id` integer NULL,
  `user_id` integer NULL,
  INDEX `element_users_idx_element_id` (`element_id`),
  INDEX `element_users_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `element_users_fk_element_id` FOREIGN KEY (`element_id`) REFERENCES `elements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `element_users_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `elements`
--
CREATE TABLE `elements` (
  `id` integer NOT NULL auto_increment,
  `status` text NOT NULL DEFAULT 'published',
  `name` text NOT NULL,
  `site` integer NOT NULL,
  `slug` text NOT NULL,
  INDEX `elements_idx_site` (`site`),
  PRIMARY KEY (`id`),
  CONSTRAINT `elements_fk_site` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `forms`
--
CREATE TABLE `forms` (
  `id` integer NOT NULL auto_increment,
  `site_id` integer NOT NULL,
  `owner_id` integer NOT NULL,
  `name` text NOT NULL,
  `mail_to` text NULL,
  `mail_from` text NULL,
  `recaptcha` enum('0','1') NOT NULL DEFAULT false,
  `recaptcha_public_key` text NULL,
  `recaptcha_private_key` text NULL,
  `ssl` enum('0','1') NULL,
  INDEX `forms_idx_owner_id` (`owner_id`),
  INDEX `forms_idx_site_id` (`site_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `forms_fk_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `forms_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `forms_constraints`
--
CREATE TABLE `forms_constraints` (
  `id` integer NOT NULL auto_increment,
  `name` text NOT NULL,
  `type` text NOT NULL DEFAULT 'Required',
  `value` text NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
--
-- Table: `forms_content`
--
CREATE TABLE `forms_content` (
  `id` integer NOT NULL auto_increment,
  `content` text NOT NULL,
  `field_id` integer NOT NULL,
  INDEX `forms_content_idx_field_id` (`field_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `forms_content_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `forms_fields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `forms_field_type`
--
CREATE TABLE `forms_field_type` (
  `id` integer NOT NULL auto_increment,
  `type` enum('Text', 'Textarea', 'Select', 'Checkbox', 'Submit') NOT NULL DEFAULT 'Text',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
--
-- Table: `forms_fields`
--
CREATE TABLE `forms_fields` (
  `id` integer NOT NULL auto_increment,
  `form_id` integer NOT NULL,
  `label` text NOT NULL,
  `name` text NOT NULL,
  `priority` integer NOT NULL DEFAULT 10,
  `type` integer NOT NULL,
  `fields` text NULL,
  INDEX `forms_fields_idx_form_id` (`form_id`),
  INDEX `forms_fields_idx_type` (`type`),
  PRIMARY KEY (`id`),
  CONSTRAINT `forms_fields_fk_form_id` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `forms_fields_fk_type` FOREIGN KEY (`type`) REFERENCES `forms_field_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `forms_fields_constraints`
--
CREATE TABLE `forms_fields_constraints` (
  `id` integer NOT NULL auto_increment,
  `field_id` integer NULL,
  `constraint_id` integer NULL,
  INDEX `forms_fields_constraints_idx_constraint_id` (`constraint_id`),
  INDEX `forms_fields_constraints_idx_field_id` (`field_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `forms_fields_constraints_fk_constraint_id` FOREIGN KEY (`constraint_id`) REFERENCES `forms_constraints` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `forms_fields_constraints_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `forms_fields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `forms_submit_field`
--
CREATE TABLE `forms_submit_field` (
  `id` integer NOT NULL auto_increment,
  `value` text NOT NULL,
  `email` text NOT NULL,
  `redirect` integer NOT NULL,
  `submitted` timestamp NOT NULL DEFAULT current_timestamp,
  `form_id` integer NOT NULL,
  INDEX `forms_submit_field_idx_form_id` (`form_id`),
  INDEX `forms_submit_field_idx_redirect` (`redirect`),
  PRIMARY KEY (`id`),
  CONSTRAINT `forms_submit_field_fk_form_id` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `forms_submit_field_fk_redirect` FOREIGN KEY (`redirect`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `master_domains`
--
CREATE TABLE `master_domains` (
  `id` integer NOT NULL auto_increment,
  `domain` varchar(255) NOT NULL,
  `site` integer NOT NULL,
  INDEX `master_domains_idx_site` (`site`),
  PRIMARY KEY (`id`),
  CONSTRAINT `master_domains_fk_site` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_attribute_data`
--
CREATE TABLE `page_attribute_data` (
  `id` integer NOT NULL auto_increment,
  `value` text NULL,
  `date_value` date NULL,
  `field_id` integer NOT NULL,
  `page_id` integer NOT NULL,
  INDEX `page_attribute_data_idx_field_id` (`field_id`),
  INDEX `page_attribute_data_idx_page_id` (`page_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_attribute_data_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `page_attribute_details` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `page_attribute_data_fk_page_id` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_attribute_details`
--
CREATE TABLE `page_attribute_details` (
  `id` integer NOT NULL auto_increment,
  `code` text NULL,
  `name` text NULL,
  `type` text NULL,
  `active` enum('0','1') NOT NULL DEFAULT true,
  `cascade` enum('0','1') NOT NULL DEFAULT false,
  `site_id` integer NOT NULL,
  INDEX `page_attribute_details_idx_site_id` (`site_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_attribute_details_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_attribute_values`
--
CREATE TABLE `page_attribute_values` (
  `id` integer NOT NULL auto_increment,
  `value` text NULL,
  `field_id` integer NOT NULL,
  `site_id` integer NULL,
  INDEX `page_attribute_values_idx_field_id` (`field_id`),
  INDEX `page_attribute_values_idx_site_id` (`site_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_attribute_values_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `page_attribute_details` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `page_attribute_values_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_contents`
--
CREATE TABLE `page_contents` (
  `id` integer NOT NULL auto_increment,
  `page_id` integer NOT NULL,
  `status` text NOT NULL DEFAULT 'Published',
  `body` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  `created_by` integer NULL,
  INDEX `page_contents_idx_created_by` (`created_by`),
  INDEX `page_contents_idx_page_id` (`page_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_contents_fk_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `page_contents_fk_page_id` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_drafts`
--
CREATE TABLE `page_drafts` (
  `id` integer NOT NULL auto_increment,
  `page_id` integer NOT NULL,
  `status` text NOT NULL DEFAULT 'draft',
  `created_by` integer NULL,
  INDEX `page_drafts_idx_created_by` (`created_by`),
  INDEX `page_drafts_idx_page_id` (`page_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_drafts_fk_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `page_drafts_fk_page_id` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_drafts_content`
--
CREATE TABLE `page_drafts_content` (
  `id` integer NOT NULL auto_increment,
  `draft_id` integer NOT NULL,
  `body` text NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  INDEX `page_drafts_content_idx_draft_id` (`draft_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_drafts_content_fk_draft_id` FOREIGN KEY (`draft_id`) REFERENCES `page_drafts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_tags`
--
CREATE TABLE `page_tags` (
  `id` integer NOT NULL auto_increment,
  `page_id` integer NOT NULL,
  `tag_id` integer NOT NULL,
  INDEX `page_tags_idx_page_id` (`page_id`),
  INDEX `page_tags_idx_tag_id` (`tag_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_tags_fk_page_id` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `page_tags_fk_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `page_users`
--
CREATE TABLE `page_users` (
  `id` integer NOT NULL auto_increment,
  `page_id` integer NULL,
  `user_id` integer NULL,
  INDEX `page_users_idx_page_id` (`page_id`),
  INDEX `page_users_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `page_users_fk_page_id` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `page_users_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `pages`
--
CREATE TABLE `pages` (
  `id` integer NOT NULL auto_increment,
  `url` text NOT NULL,
  `status` text NOT NULL DEFAULT 'published',
  `parent_id` integer NULL,
  `template_id` integer NULL,
  `h1` text NULL,
  `breadcrumb` text NOT NULL,
  `title` text NOT NULL,
  `description` text NULL,
  `priority` integer NOT NULL DEFAULT 50,
  `content_type` text NOT NULL DEFAULT 'text/html',
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  `updated` timestamp NOT NULL DEFAULT current_timestamp,
  `site` integer NOT NULL,
  `created_by` integer NULL,
  `blog` enum('0','1') NOT NULL DEFAULT false,
  `note_changes` text NULL,
  `markup_type` text NULL,
  INDEX `pages_idx_parent_id` (`parent_id`),
  INDEX `pages_idx_created_by` (`created_by`),
  INDEX `pages_idx_site` (`site`),
  INDEX `pages_idx_template_id` (`template_id`),
  PRIMARY KEY (`id`),
  UNIQUE `pages_url_site` (`url`, `site`),
  CONSTRAINT `pages_fk_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `pages` (`id`),
  CONSTRAINT `pages_fk_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pages_fk_site` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pages_fk_template_id` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `parameter`
--
CREATE TABLE `parameter` (
  `id` integer NOT NULL auto_increment,
  `data_type` text NOT NULL,
  `parameter` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
--
-- Table: `redirect_domains`
--
CREATE TABLE `redirect_domains` (
  `id` integer NOT NULL auto_increment,
  `master_domain` integer NOT NULL,
  `domain` varchar(255) NOT NULL,
  `status` enum('active', 'disabled') NOT NULL DEFAULT 'active',
  INDEX `redirect_domains_idx_master_domain` (`master_domain`),
  PRIMARY KEY (`id`),
  CONSTRAINT `redirect_domains_fk_master_domain` FOREIGN KEY (`master_domain`) REFERENCES `master_domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `role`
--
CREATE TABLE `role` (
  `id` integer NOT NULL auto_increment,
  `role` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
--
-- Table: `role_admin`
--
CREATE TABLE `role_admin` (
  `role_id` integer NOT NULL auto_increment,
  INDEX (`role_id`),
  PRIMARY KEY (`role_id`),
  CONSTRAINT `role_admin_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `roles_allowed`
--
CREATE TABLE `roles_allowed` (
  `role` integer NOT NULL,
  `role_allowed` integer NOT NULL,
  INDEX `roles_allowed_idx_role` (`role`),
  INDEX `roles_allowed_idx_role_allowed` (`role_allowed`),
  PRIMARY KEY (`role`, `role_allowed`),
  CONSTRAINT `roles_allowed_fk_role` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `roles_allowed_fk_role_allowed` FOREIGN KEY (`role_allowed`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `site_attributes`
--
CREATE TABLE `site_attributes` (
  `id` integer NOT NULL auto_increment,
  `site_id` integer NULL,
  `code` text NOT NULL,
  `value` text NOT NULL,
  `super` enum('0','1') NOT NULL DEFAULT false,
  `name` text NULL,
  INDEX `site_attributes_idx_site_id` (`site_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `site_attributes_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `sites`
--
CREATE TABLE `sites` (
  `id` integer NOT NULL auto_increment,
  `name` varchar(140) NOT NULL,
  `status` text NOT NULL DEFAULT 'active',
  `template` enum('0','1') NOT NULL DEFAULT false,
  `profile_site` integer NULL,
  INDEX `sites_idx_profile_site` (`profile_site`),
  PRIMARY KEY (`id`),
  CONSTRAINT `sites_fk_profile_site` FOREIGN KEY (`profile_site`) REFERENCES `sites` (`id`)
) ENGINE=InnoDB;
--
-- Table: `sites_users`
--
CREATE TABLE `sites_users` (
  `id` integer NOT NULL auto_increment,
  `site_id` integer NOT NULL,
  `user_id` integer NOT NULL,
  INDEX `sites_users_idx_site_id` (`site_id`),
  INDEX `sites_users_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `sites_users_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sites_users_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `tag_groups`
--
CREATE TABLE `tag_groups` (
  `id` integer NOT NULL auto_increment,
  `name` text NOT NULL,
  `cascade` enum('0','1') NOT NULL DEFAULT false,
  `multiple` enum('0','1') NOT NULL DEFAULT false,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
--
-- Table: `tags`
--
CREATE TABLE `tags` (
  `id` integer NOT NULL auto_increment,
  `group_id` integer NOT NULL,
  `name` text NOT NULL,
  INDEX `tags_idx_group_id` (`group_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `tags_fk_group_id` FOREIGN KEY (`group_id`) REFERENCES `tag_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `template_contents`
--
CREATE TABLE `template_contents` (
  `id` integer NOT NULL auto_increment,
  `template_id` integer NOT NULL,
  `data` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp,
  INDEX `template_contents_idx_template_id` (`template_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `template_contents_fk_template_id` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `templates`
--
CREATE TABLE `templates` (
  `id` integer NOT NULL auto_increment,
  `name` text NOT NULL,
  `site` integer NOT NULL,
  INDEX `templates_idx_site` (`site`),
  PRIMARY KEY (`id`),
  UNIQUE `templates_name_site` (`name`, `site`),
  CONSTRAINT `templates_fk_site` FOREIGN KEY (`site`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `users`
--
CREATE TABLE `users` (
  `id` integer NOT NULL auto_increment,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `email` text NOT NULL,
  `name` text NOT NULL,
  `tel` text NULL,
  `status` text NOT NULL DEFAULT 'active',
  `last_login` timestamp NULL,
  `last_failed_login` timestamp NULL,
  PRIMARY KEY (`id`),
  UNIQUE `user_index` (`username`)
) ENGINE=InnoDB;
--
-- Table: `attachment_attribute_values`
--
CREATE TABLE `attachment_attribute_values` (
  `id` serial NOT NULL auto_increment,
  `value` text NULL,
  `priority` text NULL DEFAULT '50',
  `field_id` integer NOT NULL,
  `site_id` integer NULL,
  INDEX `attachment_attribute_values_idx_field_id` (`field_id`),
  INDEX `attachment_attribute_values_idx_site_id` (`site_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `attachment_attribute_values_fk_field_id` FOREIGN KEY (`field_id`) REFERENCES `attachment_attribute_details` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `attachment_attribute_values_fk_site_id` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `parameter_defaults`
--
CREATE TABLE `parameter_defaults` (
  `id` integer NOT NULL auto_increment,
  `parameter_id` integer NOT NULL,
  `data` text NULL,
  INDEX `parameter_defaults_idx_parameter_id` (`parameter_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `parameter_defaults_fk_parameter_id` FOREIGN KEY (`parameter_id`) REFERENCES `parameter` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `users_data`
--
CREATE TABLE `users_data` (
  `id` integer NOT NULL auto_increment,
  `users_id` integer NOT NULL,
  `key` text NOT NULL,
  `value` text NOT NULL,
  INDEX `users_data_idx_users_id` (`users_id`),
  PRIMARY KEY (`id`),
  CONSTRAINT `users_data_fk_users_id` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `aclrule_role`
--
CREATE TABLE `aclrule_role` (
  `aclrule_id` integer NOT NULL auto_increment,
  `role_id` integer NOT NULL auto_increment,
  INDEX `aclrule_role_idx_aclrule_id` (`aclrule_id`),
  INDEX `aclrule_role_idx_role_id` (`role_id`),
  PRIMARY KEY (`aclrule_id`, `role_id`),
  CONSTRAINT `aclrule_role_fk_aclrule_id` FOREIGN KEY (`aclrule_id`) REFERENCES `aclrule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `aclrule_role_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `users_parameter`
--
CREATE TABLE `users_parameter` (
  `users_id` integer NOT NULL auto_increment,
  `parameter_id` integer NOT NULL auto_increment,
  `value` text NOT NULL,
  INDEX `users_parameter_idx_parameter_id` (`parameter_id`),
  INDEX `users_parameter_idx_users_id` (`users_id`),
  PRIMARY KEY (`users_id`, `parameter_id`),
  CONSTRAINT `users_parameter_fk_parameter_id` FOREIGN KEY (`parameter_id`) REFERENCES `parameter` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `users_parameter_fk_users_id` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `users_role`
--
CREATE TABLE `users_role` (
  `users_id` integer NOT NULL auto_increment,
  `role_id` integer NOT NULL auto_increment,
  INDEX `users_role_idx_role_id` (`role_id`),
  INDEX `users_role_idx_users_id` (`users_id`),
  PRIMARY KEY (`users_id`, `role_id`),
  CONSTRAINT `users_role_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `users_role_fk_users_id` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1;
