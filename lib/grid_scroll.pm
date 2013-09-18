#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  grid_scroll
# Arguments:   size of the scroll, function to be executed
#              for each one of the selected points
# Description: Given a function, applies it in size to size
#              squares in the grid (sizemust be a divisor 
#              of the number of squares).
sub grid_scroll 
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Size and function
    my ($size, $func) = (shift, shift);
    
    $n_squares % $size == 0
    or die "grid_scroll: $size does not divide $n_squares\n",
           "             It must do it to scroll the grid\n";
    
    for(my $y = 1; $y <= $n_squares; $y += $size) {
        for(my $x = 1; $x <= $n_squares; $x += $size) { 
            $sudoku->$func($x,$y); 
        }
    }
}

1;
