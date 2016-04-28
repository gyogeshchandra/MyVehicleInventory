package MyInventory::Schema::ResultSet::User;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub most_recent {
  my ($self) = @_;

  return $self->search({}, { order_by => {-desc => ['id']} });
} 

sub specific {
  my ($self, $uID) = @_;

  return $self->search({id => $uID});
} 

sub all_username {
  my ($self, $uID) = @_;

  return $self->search({}, {order_by => ['username']});
} 

1;
