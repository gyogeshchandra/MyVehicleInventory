package MyInventory::Controller::Blog;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MyInventory::Controller::Blog - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash(blog_entries => [$c->model('db::blog')->most_recent]);
  $c->stash(blog_comments => $c->model('DB::BlogComment')); 

  my @members;
  for my $user ($c->model('DB::User')->all) {
    my $blog_entry = $c->model('DB::Blog')->all_user($user->id)->first;
    push @members, { name => $user->name, bid => $blog_entry->id } if $blog_entry; 
  }
  my @sorted_members = sort { "\L$a->{name}" cmp "\L$b->{name}" } @members; 
  $c->stash(sorted_members => [@sorted_members]);

  $c->detach($c->view("TT")); 
}

=head1 AUTHOR

Yogesh Chandra

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
