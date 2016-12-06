#!/usr/bin/perl

use Getopt::Long;
use Data::Dumper;

my %opts = ( 'verbose' => 1 , 'column' => 1);

GetOptions(\%opts, "verbose=s", "translation=s", "column=s", "removeercc");

my %trTable;

if(open(TR, "<$opts{translation}")) { #or die "Couldn't open translation table $opts{translation}\n";
    while(<TR>) {
	chomp();
	my @fields = split(/\t/);
	if($trTable{$fields[0]} and ($trTable{$fields[0]} ne $fields[1])) { if($opts{verbose} >= 1) { warn "$fields[0] was $trTable{$fields[0]} now $fields[1]\n";} }
	$trTable{$fields[0]} = $fields[1];
    }
} else { if($opts{verbose > 1}) { warn "Couldn't open translation table $opts{translation}, proceeding\n"; }
}
if($opts{verbose} > 2) {
    print Dumper(\%trTable)."\n";
}

while(<>) {
    chomp();
    my @fields = split(/\t/);
    if($fields[0] =~ /^N_/) {
	$fields[0] =~ s/^N_/__/;
    } elsif($trTable{$fields[0]}) {
	$fields[0] = $trTable{$fields[0]};
    }
    if($opts{removeercc} && ($fields[0] =~ "^ERCC-")) {
    } else {
	print "$fields[0]\t$fields[$opts{column}]\n";
    }
}
