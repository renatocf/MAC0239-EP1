#!/usr/bin/perl
package main;
use v5.14;

# Pragmas
use strict;
use warnings;

#######################################################################
##                    PACKAGE/GLOBAL VARIABLES                       ##
#######################################################################

# Pragmas
use strict; 
use warnings;

# Options
use Getopt::Long;
my $help = undef;
GetOptions("help" => \$help);

# Help message
if($help) { print while <DATA>; exit; }

# Number of queens
scalar @ARGV == 1 and my $n_squares = shift @ARGV 
or die "USAGE: perl sudoku.pl n_squares\n";

$n_squares =~ /^(\d+)$/
or die "The number of squares must be made only of integers";

($n_squares = $1) > 0
or die "The number of squares must be strictly positive";

# Number of squares and clausules
my $n_vars = $n_squares**3;
my $n_clausules = n_lines($n_squares);

#######################################################################
##                             HEADER                                ##
#######################################################################

# Comments section
print << "COMMENTS";
c Nome      Renato Cordeiro Ferreira
c MAC0239   Metodos Formais de Programacao
c Professor Marcelo Finger
c Problema  Sudoku 9x9
COMMENTS

# Header/Preamble section
print << "HEADER";
p cnf $n_vars $n_clausules
HEADER

#######################################################################
##                            CLAUSULES                              ##
#######################################################################

# First clausules: just 1 number per square
# ⋀ (i=1,n²) [ ⋁ (j=n*(i-1)+1,n*i S_i,j ]
for my $i (0..$n_squares*$n_squares-1) 
{
    for my $j (1..$n_squares) { 
        print($i*$n_squares+$j, " "); 
    }
    print "0 \n";
}

# Second clausules: just 1 number per column
# ¬S_i,j ∨ ¬S_i,k, ∀ i ∈ [1,n²], ∀ j ∈ [1,n], ∀ k ∈ [j,n]
for(my $i = 1; $i <= $n_squares*$n_squares; $i++) # (1..$n_squares)
{
    for(my $j = 1; $j <= $n_squares; $j++) # (1..$n_squares)
    {
        # First element goes from 
        my $first = ($j-1)*$n_squares*$n_squares + $i;
        for(my $k = $j+1; $k <= $n_squares; $k++) { #($j+1..$n_squares)
            my $second = ($k-1) * $n_squares*$n_squares + $i;
            print "-$first -$second 0\n" if($first != $second);
        }
    }
}

# Third clausules: just 1 number per subgrid
# ¬S_i+k,j+k ∨ ¬S_i+l,j+l, ∀ i,j ∈ [1,n], ∀ k ∈ [1,√n], l ∈ [j,√n]

#######################################################################
##                          SUBROUTINES                              ##
#######################################################################

# Subroutine:  n_lines
# Arguments:   number of squares
# Description: Given the number of squares, deterministically 
#              calculates how may clausules will be used to
#              create an entry in the cnf format.
sub n_lines {
    my $n_squares = shift;       # Number of squares
    my $n_lines = $n_squares**2; # 1 Number per position in the grid.
        
    # Just 1 queen per column
    $n_lines += $n_squares**2 *($n_squares*($n_squares-1))/2;
                                           
    return $n_lines;
}

# Subroutine:  two_by_two
# Arguments:   list of numbers
# Description: Given a a list, prints the elements $a and $b 
#              in the format "-$a -$b 0".
sub two_by_two 
{
    my $pos = shift; my $size = scalar @{$pos};
    for(my $i = 0; $i < $size; $i++) {
        for(my $j = $i+1; $j < $size; $j++) {
            print "-$pos->[$i] -$pos->[$j] 0\n";
        }
    }
}

#######################################################################
##                          DOCUMENTATION                            ##
#######################################################################
__END__

SUDOKU:              
--------------------

