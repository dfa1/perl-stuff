#!/usr/bin/perl

# omploader.pl -- upload images to http://omploader.org from command line

use LWP::UserAgent;
use HTTP::Request::Common 'POST';

use constant URL => 'http://omploader.org';

$file = shift or die "$0: please specify a file\n";

$r = LWP::UserAgent->new->request(POST URL . "/upload",
				  Content_Type => 'form-data',
				  Content      => [
						   file1 =>  [ $file ],
						  ],
				 );

die "$0: didn't get a '200'.\n" unless 200 == $r->code;

for (split /\n/, $r->content) {
  print URL . "/$2\n" if /\W+(View file|With name):\W<a\Whref="(.*)".*/;
}
