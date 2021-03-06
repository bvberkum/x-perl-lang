#! /usr/bin/perl

use strict;
use warnings;

use IO::Socket::INET;
use Getopt::Long;


my $serve = 0;
my $host = '0.0.0.0';
my $port = '7777';
my $getopt = 0;
my $verbose = 0;

$getopt = GetOptions(
    "serve"  => \$serve,
    "host"  => \$host,
    "port"  => \$port,
    "verbose"  => \$verbose );


if( $serve ) {
 
    # auto-flush on socket
    $| = 1;
     
    # creating a listening socket
    my $socket = new IO::Socket::INET (
        LocalHost => $host,
        LocalPort => $port,
        Proto => 'tcp',
        Listen => 5,
        Reuse => 1
    );
    die "cannot create socket $!\n" unless $socket;
    print "server waiting for client connection on port $port\n";
     
    while(1)
    {
        # waiting for a new client connection
        my $client_socket = $socket->accept();
     
        # get information about a newly connected client
        my $client_address = $client_socket->peerhost();
        my $client_port = $client_socket->peerport();
        print "connection from $client_address:$client_port\n";

        my $data = readline($client_socket);
        print "received line: $data\n";

        # read up to 1024 characters from the connected client
        #my $data = "";
        #$client_socket->recv($data, 1024);
        #print "received data: $data\n";
     
        # write response data to the connected client
        $data = "ok";
        $client_socket->send($data);
     
        # notify client that response has been sent
        shutdown($client_socket, 1);
    }
     
    $socket->close();
}
 else {

    print "Nothing todo";
}
