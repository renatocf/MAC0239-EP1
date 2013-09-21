#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;
use Fcntl qw(LOCK_SH);

# Subroutine:  solution.pm
# Arguments:   none
# Description: Solves the problem, calling an external SAT Solver (as
#              'minisat' or 'zChaff'. Locks the '.ans' file for
#              avoiding external overwrite while running the program.
sub solve
{
    my $sudoku = shift; # Object
    my $solver = shift; # SAT solver type
    my $path   = shift; # SAT solver path
    my $stat   = shift; # Creates a statistics file if required
    my $nsq    = $sudoku->{N_SQUARES};
    my $proof;
    
    # No binary provided, act as a getter
    return $sudoku->{ANSWER} if not defined $path;
    
    # Otherwise, set the variable if undefined
    unless(defined $sudoku->{ANSWER})
    {
        # File names to be used in the program
        my $cnf = "${nsq}x${nsq}_sudoku.cnf";
        my $ans = "${nsq}x${nsq}_sudoku.ans";
        
        # Execute the solver and gets the answer
        -x "$path/$solver" 
        or die "$path/$solver not found\n";
        $proof = qx|$path/$solver $cnf $ans|;
        
        if(defined $stat)
        {
            # Files with statistics, if required to print
            open(STAT, ">", "${nsq}x${nsq}_sudoku.stat");
            
            # Eliminates results if they are 
            # printed with the statistics/proof data
            print STAT ($proof =~ s/1.*0//gr);
            
            # Close the file
            close(STAT);
        }
        
        # Open the file to read the answer
        open  ($sudoku->{ANSWER}, "<", "${nsq}x${nsq}_sudoku.ans")
        or die "Cannot open ${nsq}x${nsq}_sudoku.ans for reading\n";
        
        # Lock file for not overwriting while reading
        flock $sudoku->{ANSWER}, LOCK_SH
        or die "Cound not get a shared lock for ${nsq}x${nsq}_sudoku.ans\n",
               "Stopped at $!\n";
    }
    
    # And then return the FILEHANDLE
    return $sudoku->{ANSWER};
}

1;
