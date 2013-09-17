#!/usr/bin/perl 
package Sudoku;
use v5.14;

# Pragmas
use strict;
use warnings;

use Term::ANSIColor qw(:constants);

# Subroutine:  grid_print
# Arguments:   none
# Description: Given the answer stored inside the object, print it
#              based on this reference. If the answer was not called
#              yet, the function calls the method responsible for that.
sub grid_print 
{
    my $sudoku = shift;
    my $prop      = $sudoku->{PROP};
    my $input     = $sudoku->{SUDOKU};
    my $n_squares = $sudoku->{N_SQUARES};
    my $ANS = $sudoku->solution();
    
    chomp(my $title = <$ANS>);
    say "The problem is $title.";
    $title =~ /^(UN|)SAT$/i or die "Not a minisat answer!";
    exit if($1);
    
    # Prints the top of the table
    print ".---" x $n_squares, ".\n";
    
    # The middle
    $/ = " ";
    my ($i, $count, $blocks) = (0, -1, 0);
    while(my $var = <$ANS>)
    {
        if($var > 0)
        {
            my $res; $i++; $count++;
            unless($res = $var % $n_squares) { $res += $n_squares }
            
            print "| ";
            
            # Print with colors (if avaiable)
            ($input->[$count]) 
                ? (print BOLD, RED, "$res ", RESET)
                : (print "$res ");
           
            if($i % $n_squares == 0)
            {
                print "|\n";
                ($i != $n_squares**2)
                    ? (print "|---" x $n_squares, "|\n") : ();
            }
        }
    }

    # And finally the bottom
    print "'---" x $n_squares, "'\n";
}

1;
