package MyInventory::Controller::Member;
use Moose;
use namespace::autoclean;
use MyInventory::Form::User; 

BEGIN { extends 'Catalyst::Controller'; }

has 'form' => (
  isa => 'MyInventory::Form::User',
  is => 'rw',
  lazy => 1,
  default => sub { MyInventory::Form::User->new }
);

=head1 NAME

MyInventory::Controller::Member - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  # Detach if user is not logged-in.
  $c->detach('/unauthorized_action') if !$c->user_exists;

  # Sort users by name and put in stash for template sidebar menu.
  $c->stash(users => [sort_users_by_name($self, $c)]);

  $c->detach($c->view("TT"));
}

sub about :Local :Args(0) {
  my ( $self, $c ) = @_;

  $c->detach($c->view("TT"));
}

sub create :Local {
  my ( $self, $c, $user_id ) = @_;
 
  # Sort users by username and put in stash for template sidebar menu.
  #$c->stash(users => [$c->model('DB::User')->all_username]);

  $c->stash(template => 'member/create.tt', form => $self->form );
 
  # Validate and insert data into database.
  return unless $self->form->process(
    item_id => $user_id,
    params => $c->req->parameters,
    schema => $c->model('DB')->schema
  );
  
  $c->res->redirect($c->uri_for_action('/index'));
  # Form validated and data inserted into database,
  # now auto-generate new member's first blog entry.

  ##Get new member info.
  # my $row = $c->model('DB::User')->most_recent->first; 
  # my $userid = $row->id; 
  # my $name = $row->name; 

  ##Create new member's first blog entry.
  # $row = $c->model('DB::Blog')->new_result({}); 
  # $row->userid($userid);
  # $row->title("Welcome ".$name."!");
  # $row->content(
# "<h3>You Are Now A Member Of MyInventory!</h3>
# <p>You may now:</p>
# <ul>
# <li>Post blog entries and comments via the Blog pages.</li>
# <li>Optionally provide your contact and other information to other users via the Members pages.</li>
# <li>View other member's contact information via the Members pages.</li>
# </ul>
# <h3>About This Blog Entry</h3>
# <p>This blog entry was automatically created when you became a member of the YARDBIRD Fan Club, you may edit or delete it as you wish.</p>
# <p>It is suggested that you edit this blog entry to see how HTML Tags may be used to style blog entries and comments.</p>
# <p>Happy blogging!</p>"
# );
  # $row->created(DateTime->now);
  # $row->insert; 

  ##Automatically login new user.
  # $c->authenticate({ username => $self->form->value->{username}, password => $self->form->value->{password} });

  ##Redirect to new user's blog entries page.
  # $c->res->redirect($c->uri_for_action('/blog/entries/index', $row->id));
}

sub edit :Local :Args(1) {
  my ( $self, $c, $uID ) = @_;

  # Detach if user is not logged-in.
  $c->detach('/unauthorized_action') if !$c->user_exists;

  # Detach if user entered a malicious uri and is trying to edit another user's info.
  $c->detach('/unauthorized_action') if $c->user->id != $uID;

  # Sort users by username and put in stash for template sidebar menu.
  $c->stash(users => [$c->model('DB::User')->all_username]);

  # Prepare to use the form.
  $c->stash(template => 'member/edit.tt', form => $self->form );

  # Validate and update user row in user table.
  return unless $self->form->process(
    item_id => $uID, 
    params => $c->req->params,
    schema => $c->model('DB')->schema,
  );

  # Redirect to Members page.
  $c->res->redirect($c->uri_for_action('/member/index'));
}
 
sub delete :Local :Args(1) {
  my ( $self, $c, $uID ) = @_;

  # Detach if user is not logged-in.
  $c->detach('/unauthorized_action') if !$c->user_exists;

  # Detach if user entered a malicious uri and is trying to delete another user's membership.
  $c->detach('/unauthorized_action') if $c->user->id != $uID;

  my $submit = $c->req->params;
  if ($submit->{submit} eq 'Yes') {
    $c->model('DB::User')->specific($uID)->delete; 
    $c->res->redirect($c->uri_for_action('/logout/index'));
  }
  elsif ($submit->{submit} eq 'No') {
    $c->res->redirect($c->uri_for_action('member/index'));
  }

  $c->detach($c->view("TT"));
}
  
sub show :Local :Args(1) {
  my ( $self, $c, $uID ) = @_;

  # Detach if user is not logged-in.
  $c->detach('/unauthorized_action') if !$c->user_exists;

  # Sort users by name and put in stash for template sidebar menu.
  $c->stash(users => [sort_users_by_name($self, $c)]);

  $c->stash(row => $c->model('DB::User')->specific($uID)->first);

  $c->detach($c->view("TT"));
}

sub sort_users_by_name {
  my ( $self, $c ) = @_;

  my @users;
  for my $user ($c->model('DB::User')->all) {
    push @users, { id => $user->id, name => $user->name };
  }

  my @sorted_users = sort { "\L$a->{name}" cmp "\L$b->{name}" } @users;

  my @rows;
  for my $user (@sorted_users) {
    push @rows, $c->model('DB::User')->specific($user->{id})->first;
  }

  return @rows;
}
 
=head1 AUTHOR

Yogesh Chandra

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
