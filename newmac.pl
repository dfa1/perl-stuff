#!/usr/bin/perl

die "you must be root\n" if $<;

$IF = 'wlan0';
$IF = $ARGV[0] if @ARGV;

my $newmac = sprintf 
    "00:%02x:%02x:%02x:%02x:%02x", rand(256), 
    rand(256), rand(256), rand(256), rand(256);

print `ifconfig $IF down` or die "ifconfig down\n";
print `ifconfig $IF hw ether $newmac` or die "ifconfig hw\n";
print `ifconfig $IF up` or die "ifconfig up\n";
print "new mac is: $newmac\n";
