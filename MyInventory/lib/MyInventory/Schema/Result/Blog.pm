use utf8;
package MyInventory::Schema::Result::Blog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyInventory::Schema::Result::Blog

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

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<blog>

=cut

__PACKAGE__->table("blog");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 userid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "userid",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "title",
  { data_type => "text", is_nullable => 0 },
  "content",
  { data_type => "text", is_nullable => 0 },
  "created",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 blog_comments

Type: has_many

Related object: L<MyInventory::Schema::Result::BlogComment>

=cut

__PACKAGE__->has_many(
  "blog_comments",
  "MyInventory::Schema::Result::BlogComment",
  { "foreign.blogid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 userid

Type: belongs_to

Related object: L<MyInventory::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "userid",
  "MyInventory::Schema::Result::User",
  { id => "userid" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-25 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7t/FNexjO9eECFVHNkcKMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
