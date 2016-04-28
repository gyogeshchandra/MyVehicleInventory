package MyInventory::Schema::ResultSet::BlogComment;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub specific_comment {
  my ($self, $id) = @_;

  return $self->search({id => $id});
} 

sub specific_blog {
  my ($self, $bID) = @_;

  return $self->search({blogid => $bID});
} 

sub all_user {
  my ($self, $uID) = @_;

  return $self->search({userid => $uID}, {order_by => {-desc => ['id']}});
} 

1;
