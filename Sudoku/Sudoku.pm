#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Libraries
use cnf;
use fml_columns;
use fml_lines;
use fml_given;
use fml_square;
use fml_subgrid;
use grid_scroll;
use grid_print;
use num_lines;
use solution;
use upload;

#######################################################################
##                            CONSTRUCTOR                            ##
#######################################################################

sub new 
{
    # Class name
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    
    # Constructor args
    my $prop = shift
    or die "Sudoku's proportion required, stopped";
    
    $prop =~ /^(\d+)$/
    or die "The prop must be made only of integers, stopped";

    ($prop = $1) > 0
    or die "The prop must be strictly positive, stopped";
    
    # Number of squares
    my $n_squares = $prop**2;
    my $n_lines   = n_lines($prop, $n_squares);
    
    # Object (reference to a hash)
    my $sudoku = {
        PROP        => $prop,
        N_SQUARES   => $n_squares,
        N_VARS      => $n_squares**3,
        N_CLAUSES   => $n_lines,
        SUDOKU      => [],
        ANSWER      => undef
    };
    
    bless $sudoku, $class;
    return $sudoku;
}

sub DESTROY
{
    my $sudoku = shift;
    $sudoku->{ANSWER}->close() if $sudoku->{ANSWER};
}

1;
