#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

# Libraries
use fml::columns;
use fml::given;
use fml::lines;
use fml::square;
use fml::subgrid;
use grid::scroll;

#######################################################################
##                             HEADER                                ##
#######################################################################

# Comments section
my $comments = << "COMMENTS";
c Nome      Renato Cordeiro Ferreira
c MAC0239   Metodos Formais de Programacao
c Professor Marcelo Finger
c Problema  Sudoku 9x9
COMMENTS

#######################################################################
##                            CLAUSULES                              ##
#######################################################################

sub gen_cnf 
{
    my $sudoku    = shift;                # Object
    my $prop      = $sudoku->{PROP};      # Proportion
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    open(my $cnf, ">", "${n_squares}x${n_squares}_sudoku.cnf");
    select $cnf; $| = 1;
    
    # Comments and header
    print "$comments";
    print "p cnf $sudoku->{N_VARS} $sudoku->{N_CLAUSES}\n";
    
    # Restrictions: all the sudoku's input
    $sudoku->fml_given;
    
    # First clausules: just 1 number per square
    # ⋀ (i=1,n²) [ ⋁ (j=n*(i-1)+1,n*i) S_i,j ]
    $sudoku->grid_scroll(1, \&fml_square);

    # Second clausules: just 1 number per line
    # ¬S_i,j ∨ ¬S_k,j, ∀ i ∈ [1,n²], ∀ j ∈ [1,n], ∀ k ∈ [i,n²]
    $sudoku->grid_scroll(1, \&fml_lines);

    # Third clausules: just 1 number per column
    # ¬S_i,j ∨ ¬S_i,k, ∀ i ∈ [1,n²], ∀ j ∈ [1,n], ∀ k ∈ [j,n]
    $sudoku->grid_scroll(1, \&fml_columns);

    # Fourth clausules: just 1 number per subgrid
    # ¬S_i+k,j+k ∨ ¬S_i+l,j+l, ∀ i,j ∈ [1,n], ∀ k ∈ [1,√n], l ∈ [j,√n]
    $sudoku->grid_scroll($prop, \&fml_subgrid);
    
    close($cnf); select STDOUT;
}
