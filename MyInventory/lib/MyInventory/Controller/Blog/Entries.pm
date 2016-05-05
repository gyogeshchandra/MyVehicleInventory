package MyInventory::Controller::Inventory::Entries;
use Moose;
use namespace::autoclean;
use MyInventory::Form::BlogComment;

BEGIN { extends 'Catalyst::Controller'; }

has 'comment_form' => (
  isa => 'MyInventory::Form::BlogComment',
  is => 'rw',
  lazy => 1,
  default => sub { MyInventory::Form::BlogComment->new }
); 

=head1 NAME

MyInventory::Controller::Inventory::Entries - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(1) {
  my ($self, $c, $bID) = @_;

  my $row = $c->model('DB::Inventory')->specific($bID)->first;
  $c->stash(blog_entry => $row);
  $c->stash(blog_entries => [$c->model('DB::Inventory')->all_user($row->userid->id)]);
  $c->stash(blog_comments => $c->model('DB::BlogComment'));

  # Determine if logged-in user has created any inventory entries and put
  # flag in stash. The template uses this to allow user to create
  # first inventory entry if they have none.
  if ($c->user_exists) {
    if ($c->user->id != $row->userid->id) {
      $row = $c->model('DB::Inventory')->all_user($c->user->id)->first;
      if ($row) {
        $c->stash(user_has_no_blog_entries => 0);
      }
      else {
        $c->stash(user_has_no_blog_entries => 1);
      }
    }
  }

  # Don't allow comments to be added if user is not logged in.
  if ($c->user_exists) {
    $c->stash(template => 'inventory/entries/index.tt', form => $self->comment_form);

    $row = $c->model('DB::BlogComment')->new_result({});
    $row->blogid($bID);
    $row->userid($c->user->id);
    $row->created(DateTime->now);

    # Validate and add database row
    return unless $self->comment_form->process(
      item => $row,
      params => $c->req->params,
    );

    # Form validated, refresh the page.
    $c->res->redirect($c->uri_for_action('/inventory/entries/index', $bID));
  }
  else {
    return;
  }
}

sub create :Local :Args(0) {
  my ($self, $c) = @_;

  # Detach if user is not logged-in.
  $c->detach('/unauthorized_action') if !$c->user_exists;

  my $row;

  my $submit = $c->req->params->{submit};
  if ($submit eq "Yes") {
    $row = $c->model('DB::Inventory')->new_result({}); 
    $row->title($c->req->params->{title});
    $row->content($c->req->params->{content});
    $row->userid($c->user->id);
    $row->created(DateTime->now);
    return if !$row->title || !$row->content;
    $row->insert;
  }

  if ($submit eq "Yes" || $submit eq "No") {
    # Get the most recent inventory entry if one exists and display it, else go to the /inventory/index page.
    $row = $c->model('DB::Inventory')->all_user($c->user->id)->first; 
    if ($row) {
      $c->res->redirect($c->uri_for_action('/inventory/entries/index', $row->id));
    }
    else {
      $c->res->redirect($c->uri_for_action('/inventory/index'));
    }
  }
}

sub edit :Local :Args(1) {
  my ($self, $c, $bID) = @_;

  # Detach if user is not logged-in.
  $c->detach('/unauthorized_action') if !$c->user_exists;

  # Prepare to edit inventory entry.
  # Detach if user is attempting to edit an entry that doesn't belong to user.
  my $row = $c->model('DB::Inventory')->specific($bID)->first; 
  $c->detach('/unauthorized_action') if ($c->user->id != $row->userid->id);

  $c->stash(blog_entry => $row);

  my $submit = $c->req->params->{submit};
  if ($submit eq "Yes") {
    $row->title($c->req->params->{title});
    $row->content($c->req->params->{content});
    return if !$row->title || !$row->content;
    $row->update;
  }

  if ($submit eq "Yes" || $submit eq "No") {
    # Get the most recent inventory entry if one exists and display it, else go to the /inventory/index page.
    $row = $c->model('DB::Inventory')->all_user($c->user->id)->first; 
    if ($row) {
      $c->res->redirect($c->uri_for_action('/inventory/entries/index', $row->id));
    }
    else {
      $c->res->redirect($c->uri_for_action('/inventory/index'));
    }
  }
}

sub delete :Local :Args(1) {
  my ($self, $c, $bID) = @_;

  # Detach if user is not logged-in.
  $c->detach('/unauthorized_action') if !$c->user_exists;

  # Detach if user attempts to delete an entry that doesn't belong to them.
  my $row = $c->model('DB::Inventory')->specific($bID)->first; 
  $c->detach('/unauthorized_action') if ($c->user->id != $row->userid->id);

  $c->stash(blog_entry => $row);
  $c->stash(blog_entries => [$c->model('DB::Inventory')->all_user($c->user->id)]);
  $c->stash(blog_comments => $c->model('DB::BlogComment'));

  my $submit = $c->req->params->{submit};
  if ($submit eq 'Yes') {
    $row->delete; 

    # Get the most recent inventory entry if one exists and display it, else go to the /inventory/index page.
    $row = $c->model('DB::Inventory')->all_user($c->user->id)->first; 
    if ($row) {
      $c->res->redirect($c->uri_for_action('/inventory/entries/index', $row->id));
    }
    else {
      $c->res->redirect($c->uri_for_action('/inventory/index'));
    }
  }
  elsif ($submit eq 'No') {
    $c->res->redirect($c->uri_for_action('/inventory/entries/index', $bID));
  }
}
 
sub edit_comments :Path('/inventory/comments/edit') :Args(1) {
  my ($self, $c, $uID) = @_;

  # Detach if user is not logged-in, or is trying to delete somebody else's comments.
  $c->detach('/unauthorized_action') if !$c->user_exists;
  $c->detach('/unauthorized_action') if ($c->user->id != $uID);

  # inventory/entries/index.tt only makes the "Edit/Delete Comments" link available if user
  # has comments. The only way a user would get this far into this subroutine if they
  # had no comments would be if they entered a malicious uri, so detach if that occurs.
  my @rows = $c->model('DB::BlogComment')->all_user($uID);
  $c->detach('/unauthorized_action') if !@rows;

  $c->stash(blog_comments => [@rows]);

  my $submit = $c->req->params->{submit};
  if ($submit eq "Yes") {
    my $rs = $c->model('DB::BlogComment')->all_user($uID);
    my $cnt = 0;
    for my $row (@rows) {
      if ($c->req->params->{'checkbox'.$cnt} eq "Yes") {
        $rs->specific_comment($row->id)->delete_all;
      }
      else {
        $row->content($c->req->params->{'content'.$cnt});
        $row->update;
      }
      $cnt++;
    }
  }

  if ($submit eq "Yes" || $submit eq "No") {
    # Get the most recent inventory entry if one exists and display it, else go to the /inventory/index page.
    my $row = $c->model('DB::Inventory')->all_user($uID)->first; 
    if ($row) {
      $c->res->redirect($c->uri_for_action('/inventory/entries/index', $row->id));
    }
    else {
      $c->res->redirect($c->uri_for_action('/inventory/index'));
    }
  }
}

=head1 AUTHOR

Yogesh Chandra

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
