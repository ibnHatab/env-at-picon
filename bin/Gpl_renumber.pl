#!/usr/bin/perl -w
#
# add offset to hexdump -C
# and strings -t x

$offset = hex $ARGV[0] or do {
	print "usage: $0 0xff810000 < infile > outfile\n";
	exit;
};


print "off: $offset \n";

while (<STDIN>) {

	($addr, $line) = $_ =~ m/\s*(\w+) (.*)/;
	if (defined $addr) {
		$addr = hex $addr;
		printf "%08x %s\n", $addr + $offset, $line;
	} else {
		print $_;
	}
}
