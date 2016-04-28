package MyInventory::Form::User;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'WordChars', 'NotAllDigits', 'SimpleStr' ); 
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'User' );

has_field 'username' => (
  type => 'Text',
  apply => [ NoSpaces, WordChars, NotAllDigits ], 
  required => 1,
  unique => 1,
  maxlength => 25,
);
has_field 'password' => (
  type => 'Password',
  apply => [ NoSpaces, WordChars, NotAllDigits ], 
  required => 1,
  maxlength => 25,
);
has_field 'password_confirm' => (
  type => 'PasswordConf',
  tags => { label_after => ': ' }, 
);
has_field 'email' => (
  type  => 'Email',
  required => 1,
  unique => 1,
  maxlength => 45,
);
has_field 'email_visible' => (
  type  => 'Checkbox',
);
has_field 'firstname' => (
  type => 'Text',
  apply => [ NoSpaces, WordChars, NotAllDigits ], 
  maxlength => 25,
);
has_field 'lastname' => (
  type => 'Text',
  apply => [ NoSpaces, WordChars, NotAllDigits ], 
  maxlength => 25,
);
has_field 'location' => (
  type => 'Text',
  maxlength => 95,
);
has_field 'about_me' => (
  type => 'TextArea',
  cols => 70,
  rows => 10,
  do_label => 0, 
);
has_field 'submit' => (
  type => 'Submit',
  value => 'Submit',
);

no HTML::FormHandler::Moose;
1;
