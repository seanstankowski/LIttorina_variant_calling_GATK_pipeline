#!/bin/bash -ve

#$ -pe smp 4
# request memory for job (default 6G, max 72G)
#$ -l mem=8G
#$ -l rmem=8G
# run time for job in hours:mins:sec (max 168:0:0, jobs with h_rt < 8:0:0 have priority)
#$ -l h_rt=7:59:00


cp /fastdata/bo1srs/RNAseq_arc_sax_20210504 /shared/snooklin1/GroupA/bo1srs


