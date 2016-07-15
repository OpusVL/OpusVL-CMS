-- Dumped from existing CMS deployment
CREATE TABLE users_favourites (
    id integer NOT NULL,
    user_id integer NOT NULL,
    page character varying(255) NOT NULL,
    name character varying(255)
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

