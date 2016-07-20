delete
from page_attribute_data
where id in (
    select d.id
    from page_attribute_details f
    inner join page_attribute_data d on d.field_id = f.id
    inner join pages p on d.page_id = p.id
    inner join sites s on s.id = p.site
    where f.site_id <> p.site and f.site_id <> s.profile_site
);
