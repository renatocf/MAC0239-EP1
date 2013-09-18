#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  fml_subgrid
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given the positions of a grid, prints the clauses
#              in a combination of 2 by 2 for the positions in 
#              its subgrid (in the format "-$a -$b 0").
sub fml_subgrid
{
    my $sudoku = shift;                   # Object
    my $prop      = $sudoku->{PROP};      # Proportion
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    # Goes from $position to $position + 9, for all numbers
    for my $pos ($position .. $position+($n_squares-1) )
    {
        # I: → , J: ↓
        for(my $i = 0; $i < $prop; $i++) {
            for(my $j = 0; $j < $prop; $j++)
            {
                #                       Goes untill √9-1
                #            .-----------------------------------.
                #          x + 0*9                             x + 1*9
                #            ^                                   ^
                #            1   2   3   4   5   6   7   8   9   1   …
                #          .---.---.---.---.---.---.---.---.---.---. …
                # y + 0*9² | A |   |   |   |   |   |   |   |   | D | 
                #          |---|---|---|---|---|---|---|---|---|---| 
                # y + 1*9² | B |   |   |   |   |   |   |   |   | E | 
                #          |---|---|---|---|---|---|---|---|---|---| 
                # y + 2*9² | C |   |   |   |   |   |   |   |   | F | 
                #          |---|---|---|---|---|---|---|---|---|---| 
                #     ^                         ⋮                    
                #     '-- Goes untill √9-1                          
                # 
                # Produces (in this order): 
                # 
                # ¬A ∨ ¬B, ¬A ∨ ¬C, ¬A ∨ ¬D, ¬A ∨ ¬E, ¬A ∨ ¬F, ...
                # ¬B ∨ ¬C, ¬B ∨ ¬D, ¬B ∨ ¬E, ¬B ∨ ¬F, ...
                # ¬C ∨ ¬D, ¬C ∨ ¬E, ¬C ∨ ¬F, ...
                # ¬D ∨ ¬E, ¬D ∨ ¬F, ...
                # ¬E ∨ ¬F, ...
                # ...
                
                # K: → , L: ↓
                for(my $k = $i; $k < $prop; $k++) {
                    for(my $l = ($k==$i)? ($j+1):(0); $l < $prop; $l++)
                    {
                        # Produces the numbers for the 1st and 2nd arg
                        my $first  = $pos + ($i * $n_squares)     # → 
                                          + ($j * $n_squares**2); # ↓ 
                        my $second = $pos + ($k * $n_squares)     # → 
                                          + ($l * $n_squares**2); # ↓ 
                        
                        print "-$first -$second 0\n";
                    }
                } #k
            } #j
        } #i
    } #position
}

1;
