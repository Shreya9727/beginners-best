#Date:12/2/19
#Author: Shreya 
#Purpose: To extract last 400 reads from the mock.fastq file and write the program to compute average quality score and %GC content of reads per base position. 
#Note: Use Phred64 ASCII encoding to convert ASCII characters into quality values.

=head
You need to have a file which contains Phred64 ASCII values in the following format:
example: Q	P_error		ASCII	
	  0	1.00000	64	@	
=cut


#Defining hash values(ascii scores) & keys(ascii symbols): 	
 open (ASCII,"ascii64.txt") or die "FNF";
 while ($line=<ASCII>)
 {
     if ($line=~/^(\d{1,2})\s+\S+\s\d+\s+(\S)/)
     {$hash{$2}=$1;}
 }

#The last 400 reads were extracted using linux commands and have been saved in the file "last1600.txt"

#Extracting reads and keys from the fastq file into the code:
open (FASTQ,"last1600.txt") or die "FNF";
@f=<FASTQ>;
$l=@f;

#Making new files that store reads and quality symbols separately
open (SEQUENCE,">seq.txt") or die "FNF";
open (QUALITY,">quality.txt") or die "FNF";

foreach $f(0..$l)
{
if (@f[$f]=~/^[A|T|G|C|N].*[A|T|G|C|N]$/)
{
@seq= split //, @f[$f];
@quality= split //, @f[$f+2];
print SEQUENCE"@seq";
print QUALITY"@quality";
}
}

#Calculating GC content per base position using matrix method:
open (SEQUENCE,"seq.txt") or die "FNF";
@seq=<SEQUENCE>;

foreach $i(0..399)
{
foreach $j(0..35)
{
$seq[$i][$j]=<@seq>;
}
}

print "BASE POSITION\t % GC CONTENT\n";

foreach $i(0..35)
{
foreach $j(0..399)
{
if ($seq[$j][$i] eq 'G')
{$g++;}
if ($seq[$j][$i] eq 'C')
{$c++;}
if ($seq[$j][$i] eq 'A')
{$a++;}
if ($seq[$j][$i] eq 'T')
{$t++;}
}
$gc= (($g+$c)*100)/($g+$c+$a+$t);
$position=$i+1;
print "\t$position\t  $gc\n";
}

print"\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

#Calculating average quality score per base position using matrix method:
open (QUALITY,"quality.txt") or die "FNF";
@quality=<QUALITY>;

foreach $s(0..399)
{
foreach $k(0..35)
{
$quality[$s][$k]=<@quality>;
}
}

print "\n\nBASE POSITION\tAVG QUALITY SCORE\n";

foreach $s(0..35)
{
foreach $k(0..399)
{
$count++;
$total+=$hash{$quality[$k][$s]};
$avg=$total/$count;
$position=$s+1;
}
print "\t$position\t $avg\n";
}
