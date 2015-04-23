#!/usr/bin/perl

use warnings;
use strict;

use Data::Printer;

use Hex qw/to_base64 print_base64 xor/;

xor('ababab', 'ababab');
