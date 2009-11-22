#!/usr/bin/env perl

# rssheadings.pl -- get headings from a remote site

use LWP::Simple;
use XML::RSS;

$url = shift;
die "rssheadings.pl: missing URL\n" unless $url;

$content = get($url);
die "rssheadings.pl: couldn't get it!" unless $content;

$rss = new XML::RSS (version => '2.0');
$rss->parse($content);
print "\"$_->{'title'}\" $_->{'link'}\n" foreach @{$rss->{'items'}};
