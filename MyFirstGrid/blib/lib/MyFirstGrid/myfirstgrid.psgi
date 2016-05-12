use strict;
use warnings;

use MyFirstGrid;

my $app = MyFirstGrid->apply_default_middlewares(MyFirstGrid->psgi_app);
$app;

