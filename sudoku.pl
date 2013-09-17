#!/usr/bin/perl
package main;
use v5.14;

# Pragmas
use strict;
use warnings;

# Libraries
use FindBin qw($Bin);
use lib "$Bin/Sudoku";

# Classes
use Sudoku;

#######################################################################
##                              OPTIONS                              ##
#######################################################################

# Options
use Getopt::Long;
my $help = undef;
my $size = 3;
GetOptions(
    "help"   => \$help, 
    "size=i" => \$size,
);
my $prop = sqrt $size;

# Usage
scalar @ARGV == 1
or die "USAGE: sudoku.pl input.txt";

#######################################################################
##                                MAIN                               ##
#######################################################################

my $filename = shift;
open(my $fh, "<", $filename);

my Sudoku $sudoku = new Sudoku($prop);
$sudoku->upload     ($fh);
$sudoku->gen_cnf    ();
$sudoku->grid_print ();

#######################################################################
##                          DOCUMENTATION                            ##
#######################################################################
__END__

SUDOKU:              
--------------------
