#-----BLAST and Exonerate Statistics Thresholds
#set to 'ncbi+', 'ncbi' or 'wublast'
blast_type=ncbi+
#Blastn Percent Coverage Threhold EST-Genome Alignments
pcov_blastn=0.8 
#Blastn Percent Identity Threshold EST-Genome Aligments
pid_blastn=0.85 
#Blastn eval cutoff
eval_blastn=1e-10
#Blastn bit cutoff 
bit_blastn=40 
#Blastn depth cutoff (0 to disable cutoff)
depth_blastn=0 
#Blastx Percent Coverage Threhold Protein-Genome Alignments
pcov_blastx=0.5
#Blastx Percent Identity Threshold Protein-Genome Aligments 
pid_blastx=0.4 
#Blastx eval cutoff
eval_blastx=1e-06
#Blastx bit cutoff 
bit_blastx=30 
#Blastx depth cutoff (0 to disable cutoff)
depth_blastx=0 
#tBlastx Percent Coverage Threhold alt-EST-Genome Alignments
pcov_tblastx=0.8 
#tBlastx Percent Identity Threshold alt-EST-Genome Aligments
pid_tblastx=0.85 
#tBlastx eval cutoff
eval_tblastx=1e-10
#tBlastx bit cutoff 
bit_tblastx=40 
#tBlastx depth cutoff (0 to disable cutoff)
depth_tblastx=0 
#Blastx Percent Coverage Threhold For Transposable Element Masking
pcov_rm_blastx=0.5
#Blastx Percent Identity Threshold For Transposbale Element Masking 
pid_rm_blastx=0.4 
 #Blastx eval cutoff for transposable element masking
eval_rm_blastx=1e-06
#Blastx bit cutoff for transposable element masking
bit_rm_blastx=30 
#Exonerate protein percent of maximal score threshold
ep_score_limit=20 
#Exonerate nucleotide percent of maximal score threshold
en_score_limit=20 