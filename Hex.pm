package Hex;

use warnings;
use strict;

use Exporter qw/import/;
use List::MoreUtils qw/pairwise/;

our @EXPORT_OK = qw/to_base64 print_base64 xor/;

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

    print "pad : $hex\n";
    my $length = length($hex) / 2;
    if ($length == 3) {
	int24_to_base64(hex($hex));
    } else {
	my $padding_length = 3 - $length;
	my $padded = hex($hex . ("00" x $padding_length));
	my @base64 = int24_to_base64($padded);
	my $base64_padding = $padding_length == 1 ? 1 : 2;
	splice(@base64, - $base64_padding);
	@base64, ((64) x $base64_padding);
    }
}

sub to_base64 {
    my $s = shift;
    
    my @hex = unpack('(A6)*', $s);
    my $last = pop @hex;
    my @end = pad($last);
    my @base64 = map { int24_to_base64 hex } @hex;
    map { $t[$_] } @base64, @end;
}

sub print_base64 {
    my $content = shift;
    my @base64 = to_base64($content);
    my $s = join('', @base64);
    print "$s\n";
}

sub xor {
    my ($a, $b) = @_;

    my @a_bytes = unpack('(A2)*', $a);
    my @b_bytes = unpack('(A2)*', $b);
    my @result = pairwise { hex($a) ^ hex($b) } @a_bytes, @b_bytes;
    my @r = map { sprintf "%02x", $_ } @result;
    join '', @r;
}

1;
