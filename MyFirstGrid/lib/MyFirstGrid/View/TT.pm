package MyFirstGrid::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

sub test {
	my ($self,$c);
	$c->response('Hi');
}
=head1 NAME

MyFirstGrid::View::TT - TT View for MyFirstGrid

=head1 DESCRIPTION

TT View for MyFirstGrid.

=head1 SEE ALSO

L<MyFirstGrid>

=head1 AUTHOR

Yogesh Chandra,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
