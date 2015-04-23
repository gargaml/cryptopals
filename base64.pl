#!/usr/bin/perl

use warnings;
use strict;

use Data::Printer;

use Hex qw/to_base64 print_base64/;

my $encoded = print_base64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d");
p $encoded;
