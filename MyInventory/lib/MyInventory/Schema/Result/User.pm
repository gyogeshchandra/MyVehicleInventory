use utf8;
package MyInventory::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyInventory::Schema::Result::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 email_visible

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 firstname

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 lastname

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 location

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 about_me

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "email_visible",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "firstname",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "lastname",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "location",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "about_me",
  { data_type => "text", is_nullable => 1 },
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
  { "foreign.userid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 blogs

Type: has_many

Related object: L<MyInventory::Schema::Result::Blog>

=cut

__PACKAGE__->has_many(
  "blogs",
  "MyInventory::Schema::Result::Blog",
  { "foreign.userid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<MyInventory::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "MyInventory::Schema::Result::UserRole",
  { "foreign.userid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roleids

Type: many_to_many

Composing rels: L</user_roles> -> roleid

=cut

__PACKAGE__->many_to_many("roleids", "user_roles", "roleid");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-25 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s1r1mjXJqZzRdLk0PGpC9A


# You can replace this text with custom code or comments, and it will be preserved on regeneration

# Have the 'password' column use a SHA-1 hash and 20-byte salt
# with RFC 2307 encoding; Generate the 'check_password" method
__PACKAGE__->add_columns(
    'password' => {
        passphrase       => 'rfc2307',
        passphrase_class => 'SaltedDigest',
        passphrase_args  => {
            algorithm   => 'SHA-1',
            salt_random => 20.
        },
        passphrase_check_method => 'check_password',
    },
); 

sub name {
  my ($self) = @_;
  my $bestname;

  if ($self->firstname) {
    $bestname = $self->firstname;
    if ($self->lastname) {
      $bestname .= ' ' . $self->lastname;
    }
  }
  elsif ($self->lastname) {
    $bestname = $self->lastname;
  }
  else {
    $bestname = $self->username;
  }
  return $bestname;
}

sub has_name {
  my ($self) = @_;

  if ($self->firstname) {
    return 1;
  }
  elsif ($self->lastname) {
    return 1;
  }
  else {
    return 0;
  }
}

__PACKAGE__->meta->make_immutable;
1;
