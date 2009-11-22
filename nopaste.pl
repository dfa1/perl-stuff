#!/usr/bin/perl

# nopaste.pl -- nopaste files from command line

# usage:
#   nopaste file [description]
#   nopaste <STDIN>

use LWP::UserAgent;
use HTTP::Request::Common 'POST';

use constant HOST => 'http://rafb.net';
use constant PASTE => '/paste/paste.php';

%ext = (
#       REGEXP            language
	'pl|pm'           => 'Perl',
	'cpp|cc|hh'       => 'C++',
	'c|h|y|l'         => 'C',
	'java'            => 'Java',
	'py'              => 'Python',
	'rb'              => 'Ruby',
	'sql'             => 'SQL',
	'php'             => 'PHP',
       );

if (scalar @ARGV >= 1) {
  $file = shift;
  open F, "<$file" or die "$0: $file: $!\n";
  @lines = <F>;			# slurp mode
  close F;

  $file =~ /\.(.+)$/; 		# place extension in $1
  foreach (keys %ext) {
    $lang = $ext{$_} if $1 =~ /^($_)$/;
  }

  $desc = shift;
} else {
  @lines = <STDIN>;
}

unless ($desc) {
  # using the first non-empty line as description
  foreach (@lines) {
    $desc = $_ and last unless /^$/;
  }
}

$lang = 'Plain Text' unless $lang;

# the user agent...
$r = LWP::UserAgent->new;

# make it proxy friendly (thanks to Alessandro Sebastiani)
push @{ $r->requests_redirectable }, 'GET';
$r->env_proxy();

# do the request
$r = $r->request(POST HOST . PASTE, [
				nick => $ENV{'USER'},
				text => join("", @lines),
				desc => $desc,
				lang => $lang
			       ]);

die "$0: didn't get a '302 Found'.\n" unless 302 == $r->code;
$p = $r->headers->header('Location');
die "$0: location looks strange '$p'\n" unless $p =~ /\.html$/;
die "$0: too fast\n" if $p =~ /toofast/;
print $p . "\n";
