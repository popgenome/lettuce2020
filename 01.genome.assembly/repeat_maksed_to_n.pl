#!/usr/bin/perl

##Mask transposon/repeat in genome sequence
##Using the lastest techniq in Collect.pm

die "Usage: $0 <seq.fa> <TE.out|gff>\n" if(@ARGV != 2);
use strict;


my %seq;
my %rep;

Read_fasta($ARGV[0],\%seq);

print STDERR "read sequence done\n";

Read_gff($ARGV[1],\%rep) if ($ARGV[1] =~ /\.gff$/);
Read_RepeatMasker($ARGV[1],\%rep) if ($ARGV[1] =~ /\.out$/);

print STDERR "read tranposon done\n";

foreach my $seq_name (sort keys %seq) {
        my $seq_head = $seq{$seq_name}{head};
        my $seq_str = $seq{$seq_name}{seq};

        my @pos;
        foreach my $p (@{$rep{$seq_name}}) {
                push @pos,[$p->[2],$p->[3]];
        }
        Remask_seq(\$seq_str,\@pos);
        Display_seq(\$seq_str);
        print ">$seq_head\n$seq_str";
}

print STDERR "Mask task done\n";
#read fasta file
#usage: Read_fasta($file,\%hash);
#############################################
sub Read_fasta{
        my $file=shift;
        my $hash_p=shift;

        my $total_num;
        open(IN, $file) || die ("can not open $file\n");
        $/=">"; <IN>; $/="\n";
        while (<IN>) {
                chomp;
                my $head = $_;
                my $name = $1 if($head =~ /^(\S+)/);

                $/=">";
                my $seq = <IN>;
                chomp $seq;
                $seq=~s/\s//g;
                $/="\n";

                if (exists $hash_p->{$name}) {
                        warn "name $name is not uniq";
                }

                $hash_p->{$name}{head} =  $head;
                $hash_p->{$name}{len} = length($seq);
                $hash_p->{$name}{seq} = $seq;

                $total_num++;
        }
        close(IN);

        return $total_num;
}
##read RepeatMasker .out file
#usage: Read_RepeatMasker($file,\%hash);
############################################
sub Read_RepeatMasker{
        my $file=shift;
        my $hash_p=shift;

        open (IN,$file) || die ("fail open $file\n");
        while (<IN>) {
                s/^\s+//;
                my @temp=split(/\s+/);
                next if($temp[8] != 'C' && $temp[8] != '+');
                my $tname = $temp[4];
                my $strand = ($temp[8] eq '+') ? '+' : '-';
                my $start = $temp[5];
                my $end = $temp[6];
                my $TE_name = $temp[9];
                my $TE_class = $temp[10];

                push @{$hash_p->{$tname}}, [$TE_name,$strand,$start,$end,$TE_class];
        }
        close(IN);

}

##read repeat gff file
#usage: Read_gff($file,\%hash);
############################################
sub Read_gff{
        my $file=shift;
        my $hash_p=shift;

        open (IN,$file) || die ("fail open $file\n");
        while (<IN>) {
                chomp;
                my @t=split(/\t/);
                my $tname = $t[0];
                my $strand = $t[6];
                my $start = $t[3];
                my $end = $t[4];
                my $TE_name = $1 if($t[8] =~ /Target=(\S+)/);
                my $TE_class = $1 if($t[8] =~ /Class=([^;]+)/);

                push @{$hash_p->{$tname}}, [$TE_name,$strand,$start,$end,$TE_class];
        }
        close(IN);

}
#############################################
sub Display_seq{
        my $seq_p=shift;
        my $num_line=(@_) ? shift : 80; ##set the number of charcters in each line
        my $disp;

        $$seq_p =~ s/\s//g;
        for (my $i=0; $i<length($$seq_p); $i+=$num_line) {
                $disp .= substr($$seq_p,$i,$num_line)."\n";
        }
        $$seq_p = $disp;
}
#############################################
##remask a sequence with repeat positon
##usage: Remask_seq(\$seq,\@pos);
###########################################
sub Remask_seq{
        my $seq_p = shift; ##sequence pointer
        my $rep_ap = shift; ##array pointer for repeat position
        my $maskC = (@_) ? shift : "n"; ##set the base for masking result
        $$seq_p =~ s/\s//g;
        foreach my $p (@$rep_ap) {
                my ($start,$end) = ($p->[0] <= $p->[1]) ? ($p->[0] , $p->[1]) : ($p->[1], $p->[0]);
                substr($$seq_p,$start-1,$end-$start+1) = $maskC x ($end-$start+1) if($start-1<=length $$seq_p);
        }
}