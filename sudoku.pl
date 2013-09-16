#!/usr/bin/perl
package main;
use v5.14;

# Pragmas
use strict;
use warnings;

# Libraries
use FindBin qw($Bin);
use lib "$Bin/Sudoku";

# Packages
use Sudoku;

my Sudoku $sudoku = new Sudoku(3);
$sudoku->gen_cnf();
$sudoku->grid_print();

#######################################################################
##                          DOCUMENTATION                            ##
#######################################################################
__END__

SUDOKU:              
--------------------

