#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  fml_square
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given a a list, prints the elements $a and $b 
#              in the format "-$a -$b 0".
sub fml_square
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    for(my $k = 0; $k < $n_squares; $k++) 
    {    
        #                           x
        #      .--------------------^-----------------------.
        #        01   02   03   04   05   06   07   08   09     …
        #      .----.----.----.----.----.----.----.----.----.-- …
        # y 01 | A1 | A2 | A3 | A4 | A5 | A6 | A7 | A8 | A9 | A
        #      |----|----|----|----|----|----|----|----|----|--
        #                            ⋮ 
        # Produces:
        # A1 ∨ A2 ∨ A3 ∨ A4 ∨ A5 ∨ A6 ∨ A7 ∨ A8 ∨ A9 
        
        print($position + $k, " "); 
    }
    print "0 \n";
}

1;
