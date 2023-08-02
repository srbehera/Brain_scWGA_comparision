#!/bin/bash
#PBS -l nodes=1:ppn=2,mem=20gb
#PBS -l walltime=10:00:00
#PBS -q analysis
#PBS -A proj-fs0002

source /hgsc_software/miniconda/miniconda3/etc/profile.d/conda.sh
conda activate leviosam2-0.2.2
cd ${PBS_O_WORKDIR}
ref="/users/u236519/Sairam/Proj_Brain/"
bam="A37_dMDA_Exp1-8-3_sn5_P67-10_FC_S36_R.bowtie.hg38.sorted_dup_marked_mapped_T2T.sorted.bam"
file=$(basename ${bam} .bam)

sh leviosam2.sh -a bowtie2 -A -10 -q 10 -H 5 -i ${bam} -o ${file}_ilmn-pe-lifted -f ${ref}hg38.fa -b ${ref}bowtie_index/hg38 -C chm13v2-hg38.clft -t 16
~                                                                                                                                                         
~                                                                                                                                                         
~                             
