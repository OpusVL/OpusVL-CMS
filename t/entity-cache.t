use Test::Most;
use Test::DBIx::Class {
    schema_class => 'OpusVL::CMS::Schema',
    traits => [qw/Testpostgresql/],
}, 'Site';

ok my $site = Site->create({ name => 'test' }), "Created a site";
my $template = '[% foo %]';
is $site->cached_entity($template), undef, 'Should have no cache entry';
my $result = 'a result';
$site->cache_entity($template, $result);
is $site->cached_entity($template), $result, 'Should have a cache entry';
is $site->cached_entity($template), $result, 'Should have a cache entry';
my $updated_result = 'updated'; 
# NOTE: I'm not sure that this
# will ever happen, but I'd rather it did roughly the right thing.
# note that it's not updating the created date if it is updated.
$site->cache_entity($template, $updated_result);
is $site->cached_entity($template), $updated_result, 'Should have an updated cache entry';
$site->clear_cache;
is $site->cached_entity($template), undef, 'Should have no cache entry';

done_testing;
