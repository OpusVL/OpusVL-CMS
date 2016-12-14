-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/31/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/32/001-auto.yml':;

--
-- View: "attachment_attributes"
--
CREATE VIEW "attachment_attributes" ( "field_id", "code", "value", "attachment_id", "site_id", "type" ) AS
    
    select field.id as field_id, field.code as code, 
        case when type = 'date' then vals.date_value::varchar else vals.value end as value, 
            attachment_id as attachment_id, field.site_id as site_id, type
    from attachment_attribute_details field
    left outer join attachment_attribute_data vals
    on field.id = vals.field_id
    where field.active = true

;
--
-- View: "asset_attributes"
--
CREATE VIEW "asset_attributes" ( "field_id", "code", "value", "asset_id", "site_id", "type" ) AS
    
    select field.id as field_id, field.code as code, 
        case when type = 'date' then vals.date_value::varchar else vals.value end as value, 
            asset_id as asset_id, field.site_id as site_id, type
    from asset_attribute_details field
    left outer join asset_attribute_data vals
    on field.id = vals.field_id
    where field.active = true

;

