#!/usr/bin/perl
package main;
use v5.14;

# Sudoku proportions
scalar @ARGV == 1 and my $prop = shift @ARGV 
or die "USAGE: perl sudoku.pl prop\n";

$prop =~ /^(\d+)$/
or die "The prop must be made only of integers";

($prop = $1) > 0
or die "The prop must be strictly positive";

# Number of squares
my $n_squares = $prop**2;

# Discards first line, checking if it is a minisat ans
chomp(my $title = <>);
say "The sudoku is $title.";
$title =~ /^(UN|)SAT$/i or die "Not a minisat answer!";
exit if($1);

# Prints the top of the table
print ".---" x $n_squares, ".\n";

# The middle
$/ = " ";
my ($i, $j) = (1,1); 
for(my $num = 1; (my $var = <>) != 0; $num = 1 + ($num+1) % $n_squares)
{
    print "| " unless $var < 0;
    ($var < 0) ? (next) : (print "$num ");  # which is the number?
    ($i == $n_squares) ? ($i = 1) : ($i++); # Line completed?
    
    if($i == 1)
    {
        print "|\n";
        ($j++ != $n_squares) ? # Last variable?
            (print "|---" x $n_squares, "|\n") : ();
    }
}

# And finally the bottom
print "'---" x $n_squares, "'\n";
