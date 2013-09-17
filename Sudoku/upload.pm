#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

sub upload
{
    my ($sudoku, $fh) = (shift, shift);
    chomp(my $vars = <$fh>);
    
    # If there is a variable defined, we 
    # know the values of one of the squares
    my @vars = split(" ", $vars);
    map { ($_ > 0) ? ($sudoku->{N_CLAUSES} += 9) : () } @vars;
    $sudoku->{SUDOKU} = \@vars;
}

1;
