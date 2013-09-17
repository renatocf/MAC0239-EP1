#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  n_lines
# Arguments:   number of squares
# Description: Given the number of squares, deterministically 
#              calculates how may clausules will be used to
#              create an entry in the cnf format.
sub n_lines 
{
    # Proportion and number of squares
    my ($prop, $n_squares) = (shift, shift);
    
    # 1 Number per position in the grid.
    my $n_lines = $n_squares**2; 
    
    # Just 1 number of each type per line
    $n_lines += $n_squares**2 * ($n_squares*($n_squares-1))/2;
    
    # Just 1 number of each type per column
    $n_lines += $n_squares**2 * ($n_squares*($n_squares-1))/2;
    
    # Just 1 number of each type per subgrid
    $n_lines += $prop**2 * $n_squares * ($n_squares*($n_squares-1))/2;
    
    return $n_lines;
}

1;
