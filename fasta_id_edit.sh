# Script by Amalia Mailli 20/10/2020

#!/usr/bin/perl -w

#Import fasta file
($fasta_file) = @ARGV;

#Read in the file 
open($fh, "<", $fasta_file) || die "Could not open file $fasta_file/n $!";

while (<$fh>) {
#Remove the new line using chomp
    chomp;
    if($_ =~ /^>(.+)/ ){
	@tmp = split /\|/, $1;
	$species=uc $tmp[1];
	@abbr=split /\s+/, $species; 
	$genus= $abbr[1] =~ s/(\w)\w+/$1./r; 
	$id =$genus.$abbr[2];
        $seqs{$id} = ""; 
        next;
    }
#Read in the next line and assign the sequence string to a hash with the id as key. 
    $seqs{$id} .= $_;
 #Print id ans sequence
}

foreach $id (keys %seqs){

    print ">$id\n$seqs{$id}\n";
    
}
