#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  fml_given
# Arguments:   none
# Description: Given a sudoku input, create restriction clauses
#              for the previously given positions
sub fml_given
{
    my $sudoku = shift;                   # Object
    my $input     = $sudoku->{SUDOKU};    # Input from stdin
    my $n_vars    = $sudoku->{N_VARS};    # Number of vars
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    for(my $i = 0; $i < $n_squares**2; $i++)
    {
        my $number = $input->[$i];
        
        next if $number == 0;
        for(my $j = 1; $j <= $n_squares; $j++) 
        {
            ($j == $number) 
                ? (say   $j + $i*$n_squares , " 0")
                : (say -($j + $i*$n_squares), " 0");
        }
    }
}

1;
