#!/usr/bin/perl 
##-wT
package main;
use v5.14;

# Receives as input the number of queens
scalar @ARGV == 1 and my $n_squares = shift @ARGV 
or die "USAGE: draw sudoku.pl n_squares\n";

$n_squares =~ /^(\d+)$/
or die "The proportion must be made only by integers";

($n_squares = $1) > 0
or die "The proporion be strictly positive";

# Discards first line, checking if it is a minisat ans
chomp(my $title = <>);
say "The problem is $title.";
$title =~ /^(UN|)SAT$/i or die "Not a minisat answer!";
exit if($1);

# Prints the top of the table
print ".---" x $n_squares, ".\n";

# The middle
$/ = " ";
my $i = 0;
while(my $var = <>)
{
    if($var > 0)
    {
        my $res; $i++;
        unless($res = $var % $n_squares) { $res += $n_squares }
        print "| $res ";
        
        if($i % $n_squares == 0)
        {
            print "|\n";
            ($i != $n_squares**2) ?
                (print "|---" x $n_squares, "|\n") : ();
        }
    }
}

# And finally the bottom
print "'---" x $n_squares, "'\n";
