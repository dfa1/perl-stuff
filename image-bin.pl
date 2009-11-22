#!/usr/bin/perl

# image-bin.pl -- upload images from command line
# as time of writing (April 2009) this script is useless; use only as LWP example
use LWP::UserAgent;
use HTTP::Request::Common 'POST';

use constant URL => 'http://lab.passiomatic.com/image-bin/index.cgi';

$file = shift or die "$0: please specify a file\n";

$r = LWP::UserAgent->new->request(POST URL,
				  Content_Type => 'form-data',
				  Content      => [
						   the_file =>  [ $file ],
						   title    =>  "" # TODO
						  ],
				 );

die "$0: didn't get a '303'.\n" unless 303 == $r->code;
print $r->headers->header('Location'), "\n";
