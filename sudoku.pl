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

# Classes
use Sudoku;
use Zchaff;

#######################################################################
##                              OPTIONS                              ##
#######################################################################

# Options
use Getopt::Long;
my $help = undef;
my $prop = 3;
GetOptions(
    "help"         => \$help, 
    "proportion=i" => \$prop,
);

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
