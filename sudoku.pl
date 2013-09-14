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
scalar @ARGV == 1 and my $prop = shift @ARGV 
or die "USAGE: perl sudoku.pl prop\n";

$prop =~ /^(\d+)$/
or die "The prop must be made only of integers";

($prop = $1) > 0
or die "The prop must be strictly positive";

# Number of squares
my $n_squares = $prop**2;

# Number of variables and clausules
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
for(my $y = 1; $y <= $n_squares; $y += $prop) {
    for(my $x = 1; $x <= $n_squares; $x++) 
        { &two_by_two_grid($x, $y); }
}

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
        
    # Just 1 number per column
    $n_lines += $n_squares**2 * ($n_squares*($n_squares-1))/2;
    
    # Just 1 number per subgrid
    $n_lines += $prop * $n_squares**2 * ($n_squares*($n_squares-1))/2;
                                           
    return $n_lines;
}

# Subroutine:  two_by_two
# Arguments:   list of numbers
# Description: Given a a list, prints the elements $a and $b 
#              in the format "-$a -$b 0".
sub two_by_two_grid
{
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    # Goes from $position to $position + 9, for all numbers
    for my $pos ($position .. $position+($n_squares-1) )
    {
        # I: → , J: ↓
        for(my $i = 0; $i < $prop; $i++) {
            for(my $j = 0; $j < $prop; $j++)
            {
                #                       Goes untill √9-1
                #            .-----------------------------------.
                #          x + 0*9                             x + 1*9
                #            ^                                   ^
                #            1   2   3   4   5   6   7   8   9   1   ...
                #          .---.---.---.---.---.---.---.---.---.---. ...
                # y + 0*9² | A |   |   |   |   |   |   |   |   | D | 
                #          |---|---|---|---|---|---|---|---|---|---| 
                # y + 1*9² | B |   |   |   |   |   |   |   |   | E | 
                #          |---|---|---|---|---|---|---|---|---|---| 
                # y + 2*9² | C |   |   |   |   |   |   |   |   | F | 
                #          |---|---|---|---|---|---|---|---|---|---| 
                #     ^                         ⋮                    
                #     '-- Goes untill √9-1                          
                # 
                # Produces (in this order): 
                # 
                # ¬A ∨ ¬B, ¬A ∨ ¬C, ¬A ∨ ¬D, ¬A ∨ ¬E, ¬A ∨ ¬F, ...
                # ¬B ∨ ¬C, ¬B ∨ ¬D, ¬B ∨ ¬E, ¬B ∨ ¬F, ...
                # ¬C ∨ ¬D, ¬C ∨ ¬E, ¬C ∨ ¬F, ...
                # ¬D ∨ ¬E, ¬D ∨ ¬F, ...
                # ¬E ∨ ¬F, ...
                # ...
                
                # K: → , L: ↓
                for(my $k = $i; $k < $prop; $k++) {
                    for(my $l = ($k==$i)? ($j+1):(0); $l < $prop; $l++)
                    {
                        # Produces the numbers for the 1st and 2nd arg
                        my $first  = $pos + ($i * $n_squares)     # → 
                                          + ($j * $n_squares**2); # ↓ 
                        my $second = $pos + ($k * $n_squares)     # → 
                                          + ($l * $n_squares**2); # ↓ 
                        
                        print "-$first -$second 0\n";
                    }
                } #k
            } #j
        } #i
    } #position
}

#######################################################################
##                          DOCUMENTATION                            ##
#######################################################################
__END__

SUDOKU:              
--------------------

