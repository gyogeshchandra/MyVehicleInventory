package MyFirstGrid::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }
with 'Catalyst::TraitFor::Controller::jQuery::jqGrid'; 

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
  my ($self, $c) = @_;

  $c->detach($c->view("TT"));
}

sub getdata :Local {
  my ($self, $c) = @_;

  my $inv_rs = $c->model('DB::Inventory')->search({});
  $inv_rs = $self->jqgrid_page($c, $inv_rs);
  my @row_data;
  while (my $inv = $inv_rs->next) {
    my $single_row = {
      cell => [
        $inv->inv_id,
        $inv->client_id,
        $inv->amount,
        $inv->tax,
        $inv->total,
        $inv->note,
      ],
    };
    push @row_data, $single_row;
  }
  $c->stash->{json_data}{rows} = \@row_data;
  $c->stash->{current_view} = 'JSON'; 
}

sub postrow :Local {
  my ($self, $c) = @_;

  my $data = $c->request->parameters;
  if ($data->{oper} eq 'edit') { # save row 
    my $inv_rs = $c->model('DB::Inventory')->search({inv_id => $data->{id}});
    $inv_rs->update({
      client_id => $data->{client_id},
      amount => $data->{amount},
      tax => $data->{tax}, 
      total => $data->{total}, 
      note => $data->{note}, 
    });
    $c->response->status(204); 
  }
  elsif ($data->{oper} eq 'add') { # add new row
    my $inv_rs = $c->model('DB::Inventory');
    $inv_rs->create({
      client_id => $data->{client_id},
      amount => $data->{amount},
      tax => $data->{tax}, 
      total => $data->{total}, 
      note => $data->{note}, 
    });
    $c->response->status(204); 
  }  
  elsif ($data->{oper} eq 'del') { # delete row
    my $inv_rs = $c->model('DB::Inventory')->search({inv_id => $data->{id}});
    $inv_rs->delete();
    $c->response->status(204); 
  }
  else {
    $c->response->body('400 BAD REQUEST: Root/postrow');
    $c->response->status(400); # 400 BAD REQUEST 
  } 
} 

sub foo :Local{
	my ($self,$c)=@_;
	$c->response->body("Welcome To Yogesh's Vehicle Inventory App");
}
sub default :Path {
  my ($self, $c) = @_;

  $c->response->body('Page not found');
  $c->response->status(404);
}

# Attempt to render a view, if needed.

sub end :ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
