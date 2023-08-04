bam="file.bam"
file=$(basename ${bam} .bam) 

# samtools commands for calculating basic stats, mean depth and coverage
samtools stats ${bam} | grep ^SN | cut -f 2- > ${file}_stat.txt
samtools depth -a ${bam} | awk 'BEGIN{sum=0;count=0;c=0} {count++} {if($3>0) c++;sum+=$3} END {print sum/c}' > ${file}_mean_depth.txt
samtools depth -a ${bam} | awk 'BEGIN{sum=0;count=0} {count++} {if($3>0) sum++} END {print sum/count}' > ${file}_coverage.txt
