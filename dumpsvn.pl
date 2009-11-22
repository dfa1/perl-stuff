#!/usr/bin/env perl

# dumpsvn.pl -- dump a svn repository with progress status

$|++;				# autoflush

$SIG{INT} = \&tsktsk;

sub tsktsk {
  close STATUS;
  print "Interrupted!\n";
  exit;
}

$path = shift or die "$0: requires the repository path\n";
$dump_file = shift or die "$0: requires a target file\n";
$youngest_rev = `svnlook youngest $path` or die "$0: unable to get latest revision\n";
$svn_dump_cmd = "svnadmin dump " . $path . " 2>&1 > $dump_file";

open STATUS, "$svn_dump_cmd |" || die "$0: badness: $! ($?)\n";

while (<STATUS>) {
  $i = (grep { /revision/ } split /\n/, $_)[0];
  $i =~ s/^\* Dumped revision |\.$//g;
  printf "\rDumping... %d%%", ($i / $youngest_rev) * 100;
}

close STATUS || die "$0: badness: $! ($?)\n";
print "\rDumping... done!\n";
