alter table assets add column slug text;
update assets set slug=id::varchar where slug is null;
alter table assets alter column slug set NOT NULL;
alter table attachments add column slug text;
update attachments set slug=id::varchar where slug is null;
alter table attachments alter column slug set NOT NULL;
alter table elements add column slug text;
update elements set slug=id::varchar where slug is null;
alter table elements alter column slug set NOT NULL;

alter table forms add column   mail_to text,
  add column mail_from text,
  add column recaptcha boolean DEFAULT false NOT NULL,
  add column recaptcha_public_key text,
  add column recaptcha_private_key text,
  add column ssl boolean;
alter table page_contents add column created_by integer;
CREATE INDEX page_contents_idx_created_by on page_contents (created_by);
alter table pages add column content_type text DEFAULT 'text/html' NOT NULL,
    add column markup_type text;
--  CONSTRAINT pages_url_site UNIQUE (url, site)
alter table attachment_attribute_values add column priority text DEFAULT '50';
ALTER TABLE page_contents ADD CONSTRAINT page_contents_fk_created_by FOREIGN KEY (created_by)
  REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;
ALTER TABLE pages drop CONSTRAINT pages_fk_parent_id;
ALTER TABLE pages ADD CONSTRAINT pages_fk_parent_id FOREIGN KEY (parent_id)
  REFERENCES pages (id) DEFERRABLE;
alter table attachment_attribute_values drop constraint attachment_attribute_values_fk_field_id;
ALTER TABLE attachment_attribute_values ADD CONSTRAINT attachment_attribute_values_fk_field_id FOREIGN KEY (field_id)
  REFERENCES attachment_attribute_details (id) ON UPDATE CASCADE DEFERRABLE;

alter table users add column last_login timestamp;
alter table users add column last_failed_login timestamp;
alter table aclfeature add column feature_description text;
-- Dumped from existing CMS deployment
CREATE TABLE users_favourites (
    id integer NOT NULL,
    user_id integer NOT NULL,
    page varchar NOT NULL,
    name varchar
);

CREATE SEQUENCE users_favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_favourites_id_seq OWNED BY users_favourites.id;
ALTER TABLE ONLY users_favourites ALTER COLUMN id SET DEFAULT nextval('users_favourites_id_seq'::regclass);
ALTER TABLE ONLY users_favourites
    ADD CONSTRAINT users_favourites_pkey PRIMARY KEY (id);
CREATE INDEX users_favourites_idx_user_id ON users_favourites USING btree (user_id);
ALTER TABLE ONLY users_favourites
    ADD CONSTRAINT users_favourites_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);

------------

CREATE TABLE user_avatar (
    id integer NOT NULL,
    user_id integer NOT NULL,
    mime_type text NOT NULL,
    data bytea NOT NULL
);

CREATE SEQUENCE user_avatar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_avatar_id_seq OWNED BY user_avatar.id;

ALTER TABLE ONLY user_avatar ALTER COLUMN id SET DEFAULT nextval('user_avatar_id_seq'::regclass);
ALTER TABLE ONLY user_avatar
    ADD CONSTRAINT user_avatar_pkey PRIMARY KEY (id);

CREATE INDEX user_avatar_idx_user_id ON user_avatar USING btree (user_id);
ALTER TABLE ONLY user_avatar
    ADD CONSTRAINT user_avatar_fk_user_id FOREIGN KEY (user_id) REFERENCES users(id) DEFERRABLE;

