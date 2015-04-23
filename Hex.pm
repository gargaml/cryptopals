package Hex;

use warnings;
use strict;

use Exporter qw/import/;

our @EXPORT_OK = qw/to_base64 print_base64/;

my @t = ('A'..'Z','a'..'z','0'..'9','+','/', '=');

sub int24_to_base64 {
    my $n = shift;
    my $mask = 0b111111;
    my @t = ();
    for (my $i = 0; $i < 4; $i++) {
	$t[$i] = ($n & ($mask << (6 * (3 - $i)))) >> (6 * (3 - $i));
    }
    @t;
}

sub pad {
    my $hex = shift;

    my $length = length($hex) / 2;
    my $padding_length = 3 - $length;
    my $padded = $hex . ("\0" x $padding_length);
    my @base64 = int24_to_base64(hex $padded);
    splice(@base64, -1) if $length == 2;
    splice(@base64, -2) if $length == 1;
    @base64;
}

sub to_base64 {
    my $s = shift;
    
    my @hex = unpack('(A6)*', $s);
    my $last = pop @hex;
    my @end = pad($last);
    my @base64 = map { int24_to_base64 hex } @hex, @end;
    map { $t[$_] } @base64;
}

sub print_base64 {
    my $content = shift;
    my @base64 = to_base64($content);
    my $s = join('', @base64);
    print "$s\n";
}

1;
