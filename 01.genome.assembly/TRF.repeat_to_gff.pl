#!/usr/bin/perl
=head1 Name

TRF.repeat_to_gff.pl  --  convert repeat raw formats to gff formats
=cut
use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
use File::Path;  
## function " mkpath" and "rmtree" deal with directory
##get options from command line into variables and set default values
my ($Verbose,$Help,$Prefix);
GetOptions(
        "prefix:s"=>\$Prefix,
        "verbose"=>\$Verbose,
        "help"=>\$Help
);
die `pod2text $0` if (@ARGV == 0 || $Help);

my $repeat_file = shift;
dat_to_gff3($repeat_file,$Prefix) if($repeat_file =~ /\.dat$/);
sub dat_to_gff3 {
        my $file = shift;
        my $pre_tag = shift;
        my $output;

        $pre_tag .= "_" if($pre_tag);
        my $line_num = `wc -l $file`;
        $line_num = $1 if($line_num =~ /^(\d+)/);
        my $mark = create_marker($line_num);
        my $chr;

        open IN,$file || die "fail open $file";
        while (<IN>) {
                $chr = $1 if(/^Sequence:\s+(\S+)/);
                my @t = split /\s+/;
                next if(@t != 15);
                my $start = $t[0];
                my $end = $t[1];
                my $id = $pre_tag."TR".$mark;

                my $score = $t[7];
                my $strand = "+";
                $output .= "$chr\tTRF\tTandemRepeat\t$start\t$end\t$score\t$strand\t.\tID=$id;PeriodSize=$t[2];CopyNumber=$t[3];PercentMatches=$t[5];PercentIndels=$t[6];Consensus=$t[13];\n";
                $mark++;
        }
        close IN;

        open OUT,">$file.gff" || die "fail creat $file";
        print OUT "##gff-version 3\n$output";
        close OUT;

}