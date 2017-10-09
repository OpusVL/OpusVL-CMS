use strict;
use warnings;

use OpusVL::FB11WebsiteAdmin;

my $app = OpusVL::FB11WebsiteAdmin->apply_default_middlewares(OpusVL::FB11WebsiteAdmin->psgi_app);
$app;

