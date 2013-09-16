#!/usr/bin/perl
package main;
use v5.14;

# Pragmas
use strict;
use warnings;

# Libraries
use FindBin qw($Bin);
use lib "$Bin/Sudoku";
use lib "$Bin/zchaff";

# Packages
use Sudoku;
use Zchaff;

my Sudoku $sudoku = new Sudoku(3);
$sudoku->gen_cnf();

my $sat_solver = Zchaff::init(729);

#######################################################################
##                          DOCUMENTATION                            ##
#######################################################################
__END__

SUDOKU:              
--------------------

