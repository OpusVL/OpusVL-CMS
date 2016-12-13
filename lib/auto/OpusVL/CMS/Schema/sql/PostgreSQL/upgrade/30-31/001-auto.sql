-- Convert schema '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/30/001-auto.yml' to '/home/colin/git/OpusVL/FB11-CMS/OpusVL-CMS/lib/auto/OpusVL/CMS/Schema/sql/_source/deploy/31/001-auto.yml':;

--
-- View: "page_attributes"
--
CREATE VIEW "page_attributes" ( "field_id", "code", "value", "page_id", "site_id", "cascade", "type" ) AS
    
    select field.id as field_id, field.code as code, 
        case when type = 'date' then vals.date_value::varchar else vals.value end as value, 
            page_id as page_id, field.site_id as site_id, cascade, type
    from page_attribute_details field
    left outer join page_attribute_data vals
    on field.id = vals.field_id
    where field.active = true

;


