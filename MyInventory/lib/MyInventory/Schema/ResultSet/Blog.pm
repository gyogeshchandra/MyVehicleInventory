package MyInventory::Schema::ResultSet::Blog;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub specific {
  my ($self, $bID) = @_;

  return $self->search({id => $bID});
} 

sub most_recent {
  my ($self) = @_;

  return $self->search({}, {order_by => {-desc => ['id']}, rows => 4});
} 

sub all_user {
  my ($self, $uID) = @_;

  return $self->search({userid => $uID}, {order_by => {-desc => ['id']}});
} 

1;
