#!/usr/bin/perl
use strict;
use warnings;
use MyInventory::Schema;

# $ perl -Ilib set_hashed_passwords.pl 

my $schema = MyInventory::Schema->connect('dbi:mysql:myinventory', 'root', 'password');
my @users = $schema->resultset('User')->all;
foreach my $user (@users) {
    $user->password('password');
    $user->update;
}