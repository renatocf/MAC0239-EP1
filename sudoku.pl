#!/usr/bin/perl
package main;
use v5.14;

# Pragmas
use strict;
use warnings;

# Packages
use Sudoku;

my Sudoku $sudoku = new Sudoku(3);
$sudoku->gen_cnf();
