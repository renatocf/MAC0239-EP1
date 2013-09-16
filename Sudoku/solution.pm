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
sub solution
{
    my $sudoku = shift;
    my $nsq = $sudoku->{N_SQUARES};
    qx/minisat ${nsq}x${nsq}_sudoku.cnf ${nsq}x${nsq}_sudoku.ans/;
    
    close($sudoku->{ANSWER}) if ref $sudoku->{ANSWER};
    open($sudoku->{ANSWER}, "<", "${nsq}x${nsq}_sudoku.ans");
    
    # Lock file for not overwriting wjile reading
    flock $sudoku->{ANSWER}, LOCK_SH
    or die "Cound not get a shared lock for ${nsq}x${nsq}_sudoku.ans\n",
           "Stopped at $!\n";

    return $sudoku->{ANSWER};
}

1;
