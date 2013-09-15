#!/usr/bin/perl
package Sudoku;
use v5.14;

# Pragmas
use strict; 
use warnings;

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
    
    # Object (reference to a hash)
    my $sudoku = {
        PROP        => $prop,
        N_SQUARES   => $n_squares,
        N_VARS      => $n_squares**3,
        N_CLAUSULES => &n_lines($prop, $n_squares)
    };
    
    bless $sudoku, $class;
    return $sudoku;
}

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
    print "p cnf $sudoku->{N_VARS} $sudoku->{N_CLAUSULES}\n";
    
    # First clausules: just 1 number per square
    # ⋀ (i=1,n²) [ ⋁ (j=n*(i-1)+1,n*i S_i,j ]
    $sudoku->grid_scroll(1, \&one_per_square);

    # Second clausules: just 1 number per line
    # ¬S_i,j ∨ ¬S_k,j, ∀ i ∈ [1,n²], ∀ j ∈ [1,n], ∀ k ∈ [i,n²]
    $sudoku->grid_scroll(1, \&two_by_two_lines);

    # Third clausules: just 1 number per column
    # ¬S_i,j ∨ ¬S_i,k, ∀ i ∈ [1,n²], ∀ j ∈ [1,n], ∀ k ∈ [j,n]
    $sudoku->grid_scroll(1, \&two_by_two_columns);

    # Fourth clausules: just 1 number per subgrid
    # ¬S_i+k,j+k ∨ ¬S_i+l,j+l, ∀ i,j ∈ [1,n], ∀ k ∈ [1,√n], l ∈ [j,√n]
    $sudoku->grid_scroll($prop, \&two_by_two_grid);
    
    close($cnf);
}

#######################################################################
##                          SUBROUTINES                              ##
#######################################################################

# Subroutine:  n_lines
# Arguments:   number of squares
# Description: Given the number of squares, deterministically 
#              calculates how may clausules will be used to
#              create an entry in the cnf format.
sub n_lines 
{
    # Proportion and number of squares
    my ($prop, $n_squares) = (shift, shift); 
    
    # 1 Number per position in the grid.
    my $n_lines = $n_squares**2; 
    
    # Just 1 number of each type per line
    $n_lines += $n_squares**2 * ($n_squares*($n_squares-1))/2;
    
    # Just 1 number of each type per column
    $n_lines += $n_squares**2 * ($n_squares*($n_squares-1))/2;
    
    # Just 1 number of each type per subgrid
    $n_lines += $prop**2 * $n_squares * ($n_squares*($n_squares-1))/2;
    
    return $n_lines;
}

# Subroutine:  grid_scroll
# Arguments:   size of the scroll, function to be executed
#              for each one of the selected points
# Description: Given a function, applies it in size to size
#              squares in the grid (sizemust be a divisor 
#              of the number of squares).
sub grid_scroll 
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Size and function
    my ($size, $func) = (shift, shift);
    
    $n_squares % $size == 0
    or die "grid_scroll: $size does not divide $n_squares\n",
           "             It must do it to scroll the grid\n";
    
    for(my $y = 1; $y <= $n_squares; $y += $size) {
        for(my $x = 1; $x <= $n_squares; $x += $size) { 
            $sudoku->$func($x,$y); 
        }
    }
}

# Subroutine:  one_per_square
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given a a list, prints the elements $a and $b 
#              in the format "-$a -$b 0".
sub one_per_square
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    for(my $k = 0; $k < $n_squares; $k++) 
    {    
        #                           x
        #      .--------------------^-----------------------.
        #        01   02   03   04   05   06   07   08   09     …
        #      .----.----.----.----.----.----.----.----.----.-- …
        # y 01 | A1 | A2 | A3 | A4 | A5 | A6 | A7 | A8 | A9 | A
        #      |----|----|----|----|----|----|----|----|----|--
        #                            ⋮ 
        # Produces:
        # A1 ∨ A2 ∨ A3 ∨ A4 ∨ A5 ∨ A6 ∨ A7 ∨ A8 ∨ A9 
        
        print($position + $k, " "); 
    }
    print "0 \n";
}
    
# Subroutine:  two_by_two_lines
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given the positions of a grid, prints the clauses
#              in a combination of 2 by 2 for the positions in the
#              right of it (in the format "-$a -$b 0").
sub two_by_two_lines
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    for my $pos ($position .. $position+($n_squares-1) )
    {
        my ($first, $second) = ($pos, $pos);
        for(my $k = $x+1; $k <= $n_squares; $k++) 
        { 
            #              x                  x+1               x+2    …
            #    .---------- … -----. .---------- … -----. .---------- …
            #     01   02         09   01   02         09   01   02     
            #   .----.----.- … -.----.----.----.- … -.----.----.----.- …
            # y | A1 | A2 |  …  | A9 | B1 | B2 |  …  | B9 | C1 | C2 |  …
            #   |----|----|- … -|----|----|----|- … -|----|----|----|- …
            #                          ⋮                    
            # 
            # Produces (in this order): 
            # 
            # ¬A1 ∨ ¬B1, ¬A1 ∨ ¬C1, ... , ¬B1 ∨ ¬C1, ...
            # ¬A2 ∨ ¬B2, ¬A2 ∨ ¬C2, ... , ¬B2 ∨ ¬C2, ...
            # ...
            # ¬A9 ∨ ¬B9, ...
            
            $second += $n_squares;
            print "-$first -$second 0\n";
        }
    }
}

# Subroutine:  two_by_two_columns
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given the positions of a grid, prints the clauses
#              in a combination of 2 by 2 for the positions above
#              it (in the format "-$a -$b 0").
sub two_by_two_columns 
{
    my $sudoku = shift;                   # Object
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
    my  ($x, $y) = (shift, shift);
    my $position = 1 + ($x-1)*$n_squares + ($y-1)*$n_squares**2;
    
    for my $pos ($position .. $position+($n_squares-1) )
    {
        my ($first, $second) = ($pos, $pos);
        for(my $k = $y+1; $k <= $n_squares; $k++) 
        { 
            #                           x
            #      .--------------------^-----------------------.
            #        01   02   03   04   05   06   07   08   09     …
            #      .----.----.----.----.----.----.----.----.----.-- …
            # y 01 | A1 | A2 | A3 | A4 | A5 | A6 | A7 | A8 | A9 | A
            #      |----|----|----|----|----|----|----|----|----|--
            #   02 | B1 | B2 | B3 | B4 | B5 | B6 | B7 | B8 | B9 | B
            #      |----|----|----|----|----|----|----|----|----|--
            #   03 | C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 | C
            #      |----|----|----|----|----|----|----|----|----|--
            #                            ⋮
            # 
            # Produces (in this order): 
            # 
            # ¬A1 ∨ ¬B1, ¬A1 ∨ ¬C1, ...
            # ¬A2 ∨ ¬B2, ¬A2 ∨ ¬C2, ...
            # ¬A3 ∨ ¬B3, ¬A3 ∨ ¬C3, ...
            # ¬A4 ∨ ¬B4, ¬A4 ∨ ¬C4, ...
            # ¬A5 ∨ ¬B5, ¬A5 ∨ ¬C5, ...
            # ¬A6 ∨ ¬B6, ¬A6 ∨ ¬C6, ...
            # ¬A7 ∨ ¬B7, ¬A7 ∨ ¬C7, ...
            # ¬A8 ∨ ¬B8, ¬A8 ∨ ¬C8, ...
            # ¬A9 ∨ ¬B9, ¬A9 ∨ ¬C9, ...

            $second += $n_squares**2;
            print "-$first -$second 0\n";
        }
    }
}

# Subroutine:  two_by_two_grid
# Arguments:   virtual positions in the grid 
#              (ignoring that each column has 9 elements)
# Description: Given the positions of a grid, prints the clauses
#              in a combination of 2 by 2 for the positions in 
#              its subgrid (in the format "-$a -$b 0").
sub two_by_two_grid
{
    my $sudoku = shift;                   # Object
    my $prop      = $sudoku->{PROP};      # Proportion
    my $n_squares = $sudoku->{N_SQUARES}; # Number of squares
    
    # Localization and position
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
                #            1   2   3   4   5   6   7   8   9   1   …
                #          .---.---.---.---.---.---.---.---.---.---. …
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

