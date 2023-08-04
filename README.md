# Brain_scWGA_comparision

This repo contains the custom scripts written for alignment analysis of single-cell sequencing WGS data of the brain samples from three different amplification methods. Following are the descriptions of the scripts used for the analysis. The environment variables of some of the PBS scripts are customized for running on the HGSC@Baylor cluster. These need to be changed if it is run on any other system.
  1. `extract_seq_remap_T2T.sh`: This script extracts the sequences from the original BAM (sequences mapped to hg38 reference) and then remaps them to T2T-CHM13 v2.0 reference. 
  2. `T2T_to_hg38_liftover.sh`: This script uses LevioSAM2 v0.2.2 to lift the mappings from T2T to hg38 reference.
  3. `samtools_stat.sh`: This script contains some basic samtools commands for alignment quality analysis.
