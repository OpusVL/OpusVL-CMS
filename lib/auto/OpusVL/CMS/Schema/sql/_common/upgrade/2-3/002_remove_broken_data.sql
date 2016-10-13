-- Removes values for attributes that are not set against the right site.
-- Either the site or the profile should own the field (_details) against which
-- the value (_data) is set, or else it is removed
delete
from page_attribute_data
where id in (
    select d.id
    from page_attribute_details f
    inner join page_attribute_data d on d.field_id = f.id
    inner join pages p on d.page_id = p.id
    inner join sites s on s.id = p.site
    where f.site_id <> s.id and f.site_id <> s.profile_site
);

delete
from asset_attribute_data
where id in (
    select d.id
    from asset_attribute_details f
    inner join asset_attribute_data d on d.field_id = f.id
    inner join assets a on d.asset_id = a.id
    inner join sites s on s.id = a.site
    where f.site_id <> s.id and f.site_id <> s.profile_site
);

delete
from attachment_attribute_data
where id in (
    select d.id
    from attachment_attribute_details f
    inner join attachment_attribute_data d on d.field_id = f.id
    inner join attachments a on d.attachment_id = a.id
    inner join pages p on a.page_id = p.id
    inner join sites s on s.id = p.site
    where f.site_id <> p.site and f.site_id <> s.profile_site
);
