#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(reduce max);

open FILE, $ARGV[0] or die "Can't open '$ARGV[0]'! $!";

my $details = $ARGV[1] eq '-d' if $ARGV[1];

my %total_for;
my %details_for;
my $total = 0;

while (my $line = <FILE>) {
    next if $line =~ /,"Total"$/;

    my ($textbook, $school, $amount) = (
        $line =~ m/
            ^
            ("[^"]*",|,)
            (?:"[^"]*",|,){2}
            "([^"]*)"
            .*
            "([^"]*)"
            $
        /x
    );
    $total_for{$school} += $amount;
    $details_for{$school}{$textbook} += $amount if $details;

    $total += $amount;
    #DEBUG#print "$line\n$school - $total_for{$school}\n" if $line =~ /camden/i;
} 

sub longest { 
    reduce { 
        length($a) > length($b) ? $a : $b 
    } @_ 
}


my @schools = sort keys %total_for;

for my $school (@schools) {
    printf("%-".(length(longest(@schools)) + 2)."s,  \$%.2f\n", $school, $total_for{$school});

    my @textbooks = sort keys %{$details_for{$school}};
    for my $textbook (@textbooks) {
        printf("`- %-".(length(longest(@textbooks)) + 2)."s,  \$%.2f\n", $textbook, $details_for{$school}{$textbook});
    }
}

printf("TOTAL: \$%.2f\n", $total);
