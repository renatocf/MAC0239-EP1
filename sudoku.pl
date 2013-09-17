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

scalar @ARGV == 1
or die "USAGE: sudoku.pl sudoku.txt";

my $filename = shift;
open(my $fh, "<", $filename);

my Sudoku $sudoku = new Sudoku(3);
$sudoku->upload($fh);
$sudoku->gen_cnf();
$sudoku->grid_print();

#######################################################################
##                          DOCUMENTATION                            ##
#######################################################################
__END__

SUDOKU:              
--------------------

