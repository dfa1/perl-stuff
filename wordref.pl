#!/usr/bin/env perl

# wordref.pl -- query http://wordreference.com for translations

#  Don't call this script directly. Create symlinks first:
#    $ ln -s wordref.pl enit.pl   # english to italian
#    $ ln -s wordref.pl iten.pl   # italian to english
#    ... and so on (check these magic names at http://www.wordreference.com)
#
#  then use the symlinks!

use LWP;
use HTML::TreeBuilder;

$0 =~ s/.pl$//;
$0 =~ s/\.\///;
$0 = (split /\//, $0)[-1];

$word = shift;
$url = "http://www.wordreference.com/$0/";
$response = LWP::UserAgent->new->get($url . $word,
   (
     'User-Agent' => 'Mozilla',
   )
);
die "Can't get $url: ", $response->status_line unless $response->is_success;

$root = HTML::TreeBuilder->new->parse($response->content);
foreach ($root->find_by_attribute('class', 'Rtbl')) {
    print_defs($_) foreach ($_->find_by_tag_name('tr'));
}

sub print_defs {
    ($defs) = @_;

    foreach ($defs->find_by_tag_name('td')) {
	$_ = $_->as_text();
	next if /^(v|nm|nf|nmf|adj|nf|del)$/;
	print "$_ ";
    }

    print "\n";
}
