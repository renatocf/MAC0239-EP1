#!/usr/bin/perl 
package Sudoku;
use v5.14;

# Pragmas
use strict;
use warnings;

# Libraries
use Term::ANSIColor qw(:constants);

# Subroutine:  grid_print
# Arguments:   none
# Description: Given the answer stored inside the object, print it
#              based on this reference. If the answer was not called
#              yet, the function calls the method responsible for that.
sub grid_print 
{
    my $sudoku = shift; # Object
    my $ANS       = $sudoku->solve;
    my $prop      = $sudoku->{PROP};
    my $input     = $sudoku->{SUDOKU};
    my $n_squares = $sudoku->{N_SQUARES};
    
    defined $ANS or die "No answer defined!\n";
        
    chomp(my $title = <$ANS>);
    say "The problem is ", uc $title, ".";
    $title =~ /^(UN|)SAT$/i or die "Not a SAT solver answer!";
    exit if($1);
    
    # Prints the top of the table
    print ".---" x $n_squares, ".\n";
    
    # The middle
    $/ = " ";
    my ($vars_read, $count, $lines) = (0, -1, 0);
    while(my $var = <$ANS>)
    {
        # Ignores variables <= 0. Otherwise, sum 
        # the number of vars read and the counter
        next if($var <= 0);
        $vars_read++; $count++;
        
        # Normalizes the variable number to the $n_squares 
        # interval. If it is 0, changes it to $n_squares
        my $ans = $var % $n_squares; 
        ($ans == 0) ? ($ans += $n_squares) : ();
        
        # Prints a grid separator from $prop to $prop lines
        ($count % $prop == 0 and $count % $n_squares != 0) 
            ? (print BOLD, YELLOW, "‖ ", RESET)
            : (print "| ")
        ;
        
        # Print with colors (if available)
        # ($res == 2)
        ($input->[$count])
            ? (print BOLD, RED,   "$ans ", RESET)
            : (print BOLD, WHITE, "$ans ", RESET)
        ;
       
        # $n_squares vars already read: end of line
        if($vars_read % $n_squares == 0)
        {
            # Line finishes and is counted
            print "|\n"; $lines++;
            
            # Unless it is the last
            if($vars_read != $n_squares**2)
            {
                # Prints $n_squares vertical bars 
                # to make a separator between lines.
                for(my $k = 0; $k < $n_squares; $k++) 
                {
                    # Prints a vertival grid separator 
                    # ('|') from $prop to $prop times
                    ($k != 0 and $k % $prop == 0) 
                        ? (print BOLD, YELLOW, "‖", RESET) 
                        : (print BOLD, WHITE,  "|", RESET)
                    ;
                    
                    # Print a horizontal grid separator 
                    # ('-') from $prop to $prop times
                    ($lines != 1 and $lines % $prop == 0)
                        ? (print BOLD, YELLOW, "===", RESET)
                        : (print BOLD, WHITE,  "---", RESET)
                    ;
                }
                # End of the auxiliar line
                print "|\n";
                
            } # $vars_read
        } # n_squares read
    } # <$var>

    # And finally the bottom
    print "'---" x $n_squares, "'\n";
}

1;
