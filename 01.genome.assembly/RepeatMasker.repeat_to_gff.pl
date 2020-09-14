#!/usr/bin/perl
=head1 Name

RepeatMasker.repeat_to_gff.pl  --  convert repeat raw formats to gff formats
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
out_to_gff3($repeat_file,$Prefix) if($repeat_file =~ /\.out$/);
sub out_to_gff3 {
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
                next if($t[0] =~ /\D/ || !$t[0]);
                my $start = $t[5];
                my $end = $t[6];
                my $id = $pre_tag."TE".$mark;
                my $chr = $t[4];
                my $score = $t[0];
                my $strand = ($t[8] eq '+') ? "+" : "-";
                my $target = $t[9];
                my $class = $t[10];
                my @ary;
                push @ary,$t[11] if($t[11] !~ /[\(\)]/);
                push @ary,$t[12] if($t[12] !~ /[\(\)]/);
                push @ary,$t[13] if($t[13] !~ /[\(\)]/);
                @ary = sort {$a<=>$b} @ary;
                my ($target_start,$target_end) = ($ary[0],$ary[1]);

                $output .= "$chr\tRepeatMasker\tTransposon\t$start\t$end\t$score\t$strand\t.\tID=$id;Target=$target $target_start $target_end;Class=$class;PercDiv=$t[1];PercDel=$t[2];PercIns=$t[3];\n";
                $mark++;
        }
        close IN;

        open OUT,">$file.gff" || die "fail creat $file";
        print OUT "##gff-version 3\n$output";
        close OUT;

}