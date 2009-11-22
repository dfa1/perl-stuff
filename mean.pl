#!/usr/bin/perl

# mean.pl -- calculate mean for your CV (new Italian rules)

# input file is a CSV:
# name, vote, CFU, discard from mean? (0 = false, 1 = true)

die "usage $0 file \n" unless @ARGV; 

open DATA, "<$ARGV[0]" or die "$0: cannot open '$ARGV[0]'\n";

foreach (<DATA>) {		# slurp mode
    next if /^\n$/;		# skip empty lines
    next if /^#/;		# skip comments
    # fields are: name, vote, cfu, discard?
    @fields = split ',', $_;
    $name = shift @fields;
    my %exam;
    $exam{'cfu'} = shift @fields;
    $exam{'vote'} = shift @fields;
    $exam{'discard'} = shift @fields;
    $exams{$name} = \%exam;
}

close DATA;

foreach (keys %exams) {
    $scfu += $exams{$_}{'cfu'};
    next if $exams{$_}{'discard'} == 1;
    next if $exams{$_}{'vote'} == 0;
    $mcfu += $exams{$_}{'cfu'};
    $sum += $exams{$_}{'cfu'} * $exams{$_}{'vote'};
}

$mean = $sum / $mcfu;
$vote = $mean * 11 / 3;

print 
"CFU  = $scfu
Mean = $mean
Vote = $vote
";


