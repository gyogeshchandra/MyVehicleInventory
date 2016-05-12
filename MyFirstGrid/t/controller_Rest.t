use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MyFirstGrid';
use MyFirstGrid::Controller::Rest;

ok( request('/rest')->is_success, 'Request should succeed' );
done_testing();
