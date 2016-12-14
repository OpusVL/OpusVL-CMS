-- Fixes the site_id against attribute values, and then the field_id against
-- those. The attribute values are given the same site as the field they are
-- attached to, and then we normalise all fields by finding the profile site
-- (which we just created, so there's only one), and attaching the values to
-- that.

-- We have to do it here, not in the 2-3 directory, because we overlooked assets
-- until this migration.

UPDATE page_attribute_values AS value 
   SET site_id = field.site_id 
  FROM page_attribute_details AS field 
 WHERE field.id = value.field_id
;

UPDATE attachment_attribute_values AS value 
   SET site_id = field.site_id 
  FROM attachment_attribute_details AS field 
 WHERE field.id = value.field_id
;

UPDATE asset_attribute_values AS value 
   SET site_id = field.site_id 
  FROM asset_attribute_details AS field 
 WHERE field.id = value.field_id
;

UPDATE page_attribute_values values
   SET field_id = profile_field.id
  FROM page_attribute_details site_field
  JOIN page_attribute_details profile_field
    ON site_field.code = profile_field.code
   AND profile_field.site_id = (
        SELECT id FROM sites WHERE profile_site IS NULL LIMIT 1
    )
 WHERE site_field.id = values.field_id
;

UPDATE attachment_attribute_values values
   SET field_id = profile_field.id
  FROM attachment_attribute_details site_field
  JOIN attachment_attribute_details profile_field
    ON site_field.code = profile_field.code
   AND profile_field.site_id = (
        SELECT id FROM sites WHERE profile_site IS NULL LIMIT 1
    )
 WHERE site_field.id = values.field_id
;

UPDATE asset_attribute_values values
   SET field_id = profile_field.id
  FROM asset_attribute_details site_field
  JOIN asset_attribute_details profile_field
    ON site_field.code = profile_field.code
   AND profile_field.site_id = (
        SELECT id FROM sites WHERE profile_site IS NULL LIMIT 1
    )
 WHERE site_field.id = values.field_id
;

UPDATE page_attribute_data data
   SET field_id = profile_field.id
  FROM page_attribute_details site_field
  JOIN page_attribute_details profile_field
    ON site_field.code = profile_field.code
   AND profile_field.site_id = (
        SELECT id FROM sites WHERE profile_site IS NULL LIMIT 1
    )
 WHERE site_field.id = data.field_id
;


UPDATE attachment_attribute_data data
   SET field_id = profile_field.id
  FROM attachment_attribute_details site_field
  JOIN attachment_attribute_details profile_field
    ON site_field.code = profile_field.code
   AND profile_field.site_id = (
        SELECT id FROM sites WHERE profile_site IS NULL LIMIT 1
    )
 WHERE site_field.id = data.field_id
;

UPDATE asset_attribute_data data
   SET field_id = profile_field.id
  FROM asset_attribute_details site_field
  JOIN asset_attribute_details profile_field
    ON site_field.code = profile_field.code
   AND profile_field.site_id = (
        SELECT id FROM sites WHERE profile_site IS NULL LIMIT 1
    )
 WHERE site_field.id = data.field_id
;
