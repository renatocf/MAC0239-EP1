#!/usr/bin/perl
package main v1.0.0;
use v5.14;

# Pragmas
use strict;
use warnings;

# Libraries
use FindBin qw($Bin);
use lib "$Bin/../lib";

# Classes
use Sudoku;

#######################################################################
##                              OPTIONS                              ##
#######################################################################

# Options
use Getopt::Long;
my $help = undef;
my $size = 9;
GetOptions(
    "help"   => \$help, 
    "size=i" => \$size,
);

#######################################################################
##                            USAGE/HELP                             ##
#######################################################################

# Help
if($help) 
{ 
    system("man ./sudoku.6");
    if($?) # Error with man
    { print while <DATA>; }
    die; 
}

my $usage = << "USAGE";
USAGE: sudoku.pl input.txt [-h] [-s]
Type --help for more information
USAGE

# Usage
scalar @ARGV == 1 or die $usage;

#######################################################################
##                                MAIN                               ##
#######################################################################

# Gets the proportion of the sudoku
# (must be a perfect square root)
my $prop = int sqrt $size;

my $filename = shift;
open(my $fh, "<", $filename);

my Sudoku $sudoku = new Sudoku($prop);
$sudoku->upload     ($fh);
$sudoku->gen_cnf    ();
$sudoku->grid_print ();

#######################################################################
##                            DOCUMENTATION                          ##
#######################################################################
__END__
§ NAME  
=================================================
sudoku.pl - a sudoku SAT-based solver

§ SYNOPSIS
=================================================

Outputs the  answer of the sudoku given as input.
The default size is the 9x9 version  of the game.

Optionally, other sizes can be solved (4x4, 16x16, 
2x2, NxN).

See OPTIONS for more details.

§ OPTIONS
=================================================
-h, --help
    Display the help message.

-s, --size=i
    Set a  perfect square integer as the size  of 
    the sudoku.

§ EXAMPLES
=================================================
The following example can be run if *minisat*  or 
*zChaff* are avaiable in your system.

§ INPUT
-------------------------------------------------
Gets  as  input a file  with the  initial Sudoku.
This file must have the following format:

5 3 0 0 7 0 0 0 0 6 0 0 1 9 5 0 0 0 0 9 8 0 0 0 0 
6 0 8 0 0 0 6 0 0 0 3 4 0 0 8 0 3 0 0 1 7 0 0 0 2 
0 0 0 6 0 6 0 0 0 0 2 8 0 0 0 0 4 1 9 0 0 5 0 0 0 
0 8 0 0 7 9

Each number represents  its position on the grid, 
starting  from 1 till 81. The numbers must be  in
the range 1-9. If it is 0, no number was provided 
in the inital game.

§ OUTPUT:
-------------------------------------------------
If a SAT solver is avaiable and installed in your 
system (zChaff or minisat). The program calls one 
of them internally and prints the answer with the 
grid (input numbers in red):

   .---.---.---.---.---.---.---.---.---.
   | 5 | 3 | 4 | 6 | 7 | 8 | 9 | 1 | 2 |
   |---|---|---|---|---|---|---|---|---|
   | 6 | 7 | 2 | 1 | 9 | 5 | 3 | 4 | 8 |
   |---|---|---|---|---|---|---|---|---|
   | 1 | 9 | 8 | 3 | 4 | 2 | 5 | 6 | 7 |
   |---|---|---|---|---|---|---|---|---|
   | 8 | 5 | 9 | 7 | 6 | 1 | 4 | 2 | 3 |
   |---|---|---|---|---|---|---|---|---|
   | 4 | 2 | 6 | 8 | 5 | 3 | 7 | 9 | 1 |
   |---|---|---|---|---|---|---|---|---|
   | 7 | 1 | 3 | 9 | 2 | 4 | 8 | 5 | 6 |
   |---|---|---|---|---|---|---|---|---|
   | 9 | 6 | 1 | 5 | 3 | 7 | 2 | 8 | 4 |
   |---|---|---|---|---|---|---|---|---|
   | 2 | 8 | 7 | 4 | 1 | 9 | 6 | 3 | 5 |
   |---|---|---|---|---|---|---|---|---|
   | 3 | 4 | 5 | 2 | 8 | 6 | 1 | 7 | 9 |
   '---'---'---'---'---'---'---'---'---'

§ FILES
-------------------------------------------------

* sudoku.pl
    Main program with the user interface.

* Sudoku/Sudoku.pl
    
    Main interface with the module, providing and 
    the  defition  of the  object related to  the 
    sudoku.

* Sudoku/cnf.pm
    
    Uses  the modules  with formules to print the 
    file that may be provided as input to the SAT 
    solver.

* Sudoku/fml/
    Directory  with subroutines  that print  each 
    type of formule that solves the problem.

* Sudoku/grid_scroll.pm

    Suboutine that scrolls the grid in  order  to
    run  the  previous  functions  and print  the 
    clauses.

* Sudoku/grid_print
    
    If  the  term  supports  colors, outputs in a 
    colored  and more visible way  the SAT solver 
    answer.

* Sudoku/solutions.pm
    
    Deterministically  calculates the  number  of 
    clauses  that  will  be  used to describe the 
    sudoku (without the input).
