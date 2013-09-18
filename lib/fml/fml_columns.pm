#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  fml_columns
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given the positions of a grid, prints the clauses
#              in a combination of 2 by 2 for the positions above
#              it (in the format "-$a -$b 0").
sub fml_columns
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    for my $pos ($position .. $position+($n_squares-1) )
    {
        my ($first, $second) = ($pos, $pos);
        for(my $k = $y+1; $k <= $n_squares; $k++) 
        { 
            #                           x
            #      .--------------------^-----------------------.
            #        01   02   03   04   05   06   07   08   09     …
            #      .----.----.----.----.----.----.----.----.----.-- …
            # y 01 | A1 | A2 | A3 | A4 | A5 | A6 | A7 | A8 | A9 | A
            #      |----|----|----|----|----|----|----|----|----|--
            #   02 | B1 | B2 | B3 | B4 | B5 | B6 | B7 | B8 | B9 | B
            #      |----|----|----|----|----|----|----|----|----|--
            #   03 | C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 | C
            #      |----|----|----|----|----|----|----|----|----|--
            #                            ⋮
            # 
            # Produces (in this order): 
            # 
            # ¬A1 ∨ ¬B1, ¬A1 ∨ ¬C1, ...
            # ¬A2 ∨ ¬B2, ¬A2 ∨ ¬C2, ...
            # ¬A3 ∨ ¬B3, ¬A3 ∨ ¬C3, ...
            # ¬A4 ∨ ¬B4, ¬A4 ∨ ¬C4, ...
            # ¬A5 ∨ ¬B5, ¬A5 ∨ ¬C5, ...
            # ¬A6 ∨ ¬B6, ¬A6 ∨ ¬C6, ...
            # ¬A7 ∨ ¬B7, ¬A7 ∨ ¬C7, ...
            # ¬A8 ∨ ¬B8, ¬A8 ∨ ¬C8, ...
            # ¬A9 ∨ ¬B9, ¬A9 ∨ ¬C9, ...

            $second += $n_squares**2;
            print "-$first -$second 0\n";
        }
    }
}

1;
