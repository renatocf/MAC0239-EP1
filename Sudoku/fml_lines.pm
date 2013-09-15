#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  fml_lines
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given the positions of a grid, prints the clauses
#              in a combination of 2 by 2 for the positions in the
#              right of it (in the format "-$a -$b 0").
sub fml_lines
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    for my $pos ($position .. $position+($n_squares-1) )
    {
        my ($first, $second) = ($pos, $pos);
        for(my $k = $x+1; $k <= $n_squares; $k++) 
        { 
            #              x                  x+1               x+2    …
            #    .---------- … -----. .---------- … -----. .---------- …
            #     01   02         09   01   02         09   01   02     
            #   .----.----.- … -.----.----.----.- … -.----.----.----.- …
            # y | A1 | A2 |  …  | A9 | B1 | B2 |  …  | B9 | C1 | C2 |  …
            #   |----|----|- … -|----|----|----|- … -|----|----|----|- …
            #                          ⋮                    
            # 
            # Produces (in this order): 
            # 
            # ¬A1 ∨ ¬B1, ¬A1 ∨ ¬C1, ... , ¬B1 ∨ ¬C1, ...
            # ¬A2 ∨ ¬B2, ¬A2 ∨ ¬C2, ... , ¬B2 ∨ ¬C2, ...
            # ...
            # ¬A9 ∨ ¬B9, ...
            
            $second += $n_squares;
            print "-$first -$second 0\n";
        }
    }
}

1;
