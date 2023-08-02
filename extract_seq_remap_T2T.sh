#!/bin/bash
#PBS -l nodes=1:ppn=2,mem=20gb
#PBS -l walltime=20:00:00
#PBS -q analysis
#PBS -A proj-fs0002

cd ${PBS_O_WORKDIR}
ref="/users/u236519/Sairam/T2T_CHM13/chm13v2.0.fa.gz"
index="/users/u236519/Sairam/Proj_Brain/bowtie_index/"
bowtie="/hgsc_software/bowtie2/bowtie2-2.3.0/"
bedtools="/hgsc_software/bedtools/bedtools-2.29.2/bin/bedtools"

bam=${b}

file=$(basename ${bam} .bam)
echo "${file}"

#reads that mapped properly as pairs
samtools view -u -f 1 -F 12 ${bam} > ${file}_map_map.bam
# R1 unmapped, R2 mapped
samtools view -u -f 4 -F 264 ${bam} > ${file}_unmap_map.bam
# R1 mapped, R2 unmapped
samtools view -u -f 8 -F 260 ${bam} > ${file}_map_unmap.bam
# R1 & R2 unmapped
samtools view -u -f 12 -F 256 ${bam} > ${file}_unmap_unmap.bam

# Merge
samtools merge -u ${file}_unmapped.bam ${file}_unmap_map.bam ${file}_map_unmap.bam ${file}_unmap_unmap.bam

# remove intermediate BAM files
rm ${file}_unmap_map.bam
rm ${file}_map_unmap.bam
rm ${file}_unmap_unmap.bam

#Sort
samtools sort -n ${file}_map_map.bam > ${file}_mapped.sort.bam
samtools sort -n ${file}_unmapped.bam > ${file}_unmapped.sort.bam

# remove intermediate BAM files
rm ${file}_map_map.bam
rm ${file}_unmapped.bam

#Extract reads
${bedtools} bamtofastq -i ${file}_mapped.sort.bam -fq ${file}_mapped.1.fastq -fq2 ${file}_mapped.2.fastq
${bedtools} bamtofastq -i ${file}_unmapped.sort.bam -fq ${file}_unmapped.1.fastq -fq2 ${file}_unmapped.2.fastq

# remove intermediate BAM files
rm ${file}_mapped.sort.bam
rm ${file}_unmapped.sort.bam

#Merge reads
cat ${file}_mapped.1.fastq ${file}_unmapped.1.fastq > ${file}.1.fastq
cat ${file}_mapped.2.fastq ${file}_unmapped.2.fastq > ${file}.2.fastq

# remove intermediate fastq files
rm ${file}_mapped.1.fastq
rm ${file}_mapped.2.fastq
rm ${file}_unmapped.1.fastq
rm ${file}_unmapped.2.fastq

#/hgsc_software/bwa/latest/bin/bwa mem -t 8 ${ref} ${file}.1.fastq ${file}.2.fastq | samtools sort -@ 8 -o ${file}_mapped_T2T.sorted.bam -
${bowtie}bowtie2 -p 8 -x ${index}T2T -1 ${file}.1.fastq -2 ${file}.2.fastq | samtools sort -@ 8 -o ${file}_mapped_T2T.sorted.bam
samtools index ${file}_mapped_T2T.sorted.bam

# remove intermediate fastq files
rm ${file}.1.fastq
rm ${file}.2.fastq
