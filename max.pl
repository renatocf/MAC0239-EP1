#!/usr/bin/perl
use v5.14;

my $max = -1;

while(my $line = <>)
{
    chomp $line;
    my @nums = split " ", $line;
    for my $num (@nums) {
        $max = abs $num if abs $num > $max;
    }
}

say $max;
