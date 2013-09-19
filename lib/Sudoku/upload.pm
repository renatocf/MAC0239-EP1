#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Subroutine:  upload
# Arguments:   filehandle
# Description: Given a filehandle with the sudoku's input:
#              1 - reads the text and stores the values;
#              2 - sum the number of variables with the number
#                  of non-0 variables;
#              3 - stores the list of values (0 and non-0) in 
#                  the attribute SUDOKU.
sub upload
{
    my ($sudoku, $fh) = (shift, shift);
    my $n_squares = $sudoku->{N_SQUARES};
    
    my $n = 0; my @all;
    while(my $vars = <$fh>)
    {
        chomp $vars;
        next if($vars =~ /^\s*#/);
        
        # If there is a variable defined, we 
        # know the values of one of the squares
        my @vars = split " ", $vars;
        map { ($_ > 0) ? ($sudoku->{N_CLAUSES} += 9) : () } @vars;
        
        # Check if we read more variables than necessary
        # and, in this case, throws an exception...    
        $n += scalar @vars;
        if($n > $n_squares**2) {
            die "Exceeded number of arguments\n", "Stopped at $!\n";
        }
        else { push @all, @vars; }
    }
    
    $sudoku->{SUDOKU} = \@all;
}

1;
