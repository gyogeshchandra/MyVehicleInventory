use strict;
use warnings;

use MyInventory;

my $app = MyInventory->apply_default_middlewares(MyInventory->psgi_app);
$app;

