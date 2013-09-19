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
    my $Bin    = shift; # SAT solver (minisat) path
    my $nsq    = $sudoku->{N_SQUARES};
    
    # No binary provided, act as a getter
    return $sudoku->{ANSWER} if not defined $Bin;
    
    # Otherwise, set the variable if undefined
    unless(defined $sudoku->{ANSWER})
    {
        qx|$Bin/minisat ${nsq}x${nsq}_sudoku.cnf ${nsq}x${nsq}_sudoku.ans|;
        
        open  ($sudoku->{ANSWER}, "<", "${nsq}x${nsq}_sudoku.ans")
        or die "Cannot open ${nsq}x${nsq}_sudoku.ans for reading\n";
        
        # Lock file for not overwriting wjile reading
        flock $sudoku->{ANSWER}, LOCK_SH
        or die "Cound not get a shared lock for ${nsq}x${nsq}_sudoku.ans\n",
               "Stopped at $!\n";
    }
    
    # And then return the FILEHANDLE
    return $sudoku->{ANSWER};
}

1;
