use strict;
use warnings;

use OpusVL::FB11Website;

my $app = OpusVL::FB11Website->apply_default_middlewares(OpusVL::FB11Website->psgi_app);
$app;

