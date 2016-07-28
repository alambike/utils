#!/usr/bin/perl
use strict;
use Data::Dumper;

my $pid = $ARGV[0];

open my $f, "/proc/$pid/environ" || die($!);

my $linea = <$f>;
print Dumper(split '\0', $linea);
