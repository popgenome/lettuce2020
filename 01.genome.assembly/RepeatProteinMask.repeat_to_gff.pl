#!/usr/bin/perl
=head1 Name

RepeatPrepeat.repeat_to_gff.pl  --  convert repeat raw formats to gff formats
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
annot_to_gff3($repeat_file,$Prefix) if($repeat_file =~ /\.annot$/);
sub annot_to_gff3 {
        my $file = shift;
        my $pre_tag = shift;
        my $output;

        $pre_tag .= "_" if($pre_tag);
        my $line_num = `wc -l $file`;
        $line_num = $1 if($line_num =~ /^(\d+)/);
        my $mark = create_marker($line_num);

        open IN,$file || die "fail open $file";
        while (<IN>) {
                s/^\s+//;
                my @t = split /\s+/;
                next if($t[0] =~ /^pValue/);
                my $start = $t[4];
                my $end = $t[5];
                my $id = $pre_tag."TP".$mark;
                my $chr = $t[3];
                my $score = $t[1]; ##use pvalue here
                my $strand = $t[6];
                my $target = $t[7];
                my $class = $t[8];
                my @ary = ($t[9],$t[10]);
                @ary = sort {$a<=>$b} @ary;
                my ($target_start,$target_end) = ($ary[0],$ary[1]);

                $output .= "$chr\tRepeatProteinMask\tTEprotein\t$start\t$end\t$score\t$strand\t.\tID=$id;Target=$target $target_start $target_end;Class=$class;pValue=$t[0];\n";
                $mark++;
        }
        close IN;

        open OUT,">$file.gff" || die "fail creat $file";
        print OUT "##gff-version 3\n$output";
        close OUT;

}