use utf8;
package MyFirstGrid::Schema::DB::Result::Inventory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyFirstGrid::Schema::DB::Result::Inventory

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<inventory>

=cut

__PACKAGE__->table("inventory");

=head1 ACCESSORS

=head2 inv_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 client_id

  data_type: 'integer'
  is_nullable: 0

=head2 amount

  data_type: 'decimal'
  default_value: 0.00
  is_nullable: 0
  size: [10,2]

=head2 tax

  data_type: 'decimal'
  default_value: 0.00
  is_nullable: 0
  size: [10,2]

=head2 total

  data_type: 'decimal'
  default_value: 0.00
  is_nullable: 0
  size: [10,2]

=head2 note

  data_type: 'char'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "inv_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "client_id",
  { data_type => "integer", is_nullable => 0 },
  "amount",
  {
    data_type => "decimal",
    default_value => "0.00",
    is_nullable => 0,
    size => [10, 2],
  },
  "tax",
  {
    data_type => "decimal",
    default_value => "0.00",
    is_nullable => 0,
    size => [10, 2],
  },
  "total",
  {
    data_type => "decimal",
    default_value => "0.00",
    is_nullable => 0,
    size => [10, 2],
  },
  "note",
  { data_type => "char", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</inv_id>

=back

=cut

__PACKAGE__->set_primary_key("inv_id");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-04-20 00:51:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EcWeTlstkreWe+t7o6JSHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
