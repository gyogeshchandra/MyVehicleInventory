package MyFirstGrid;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'MyFirstGrid',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Specify which stash keys are exposed as a JSON response. 
__PACKAGE__->config({
  'View::JSON' => {
    expose_stash => qw(json_data)
  }
});

# Start the application
__PACKAGE__->setup();

1;
