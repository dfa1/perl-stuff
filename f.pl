#!/usr/bin/env perl

# f.pl -- replacing awk '{ print $N; }'
#
# usage:
# create symlinks to this script:
#
#   $ perl -e '`ln -s f.pl f$_` foreach (1..10);'
#
# Now to get the N-th column just do:
#
#   $ command | fN

print +(split ' ', $_, -1)[$0 =~ /f(\d)\z/ ? $1 : 1] . "\n" while (<>);
