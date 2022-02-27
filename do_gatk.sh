#!/bin/bash
#$ -l rmem=16G
#$ -P littorina

BAM_DIR=$1
WORK_DIR=$2
FASTA=$3
BED_FILE=$4

echo ${BAM_DIR}
echo ${WORK_DIR}
echo ${FASTA}
echo ${BED_FILE}

#echo "Task id is $SGE_TASK_ID"

FILES=($(ls -1 ${BAM_DIR}/*.bam))

#echo $FILES

FILENAME=${FILES[$SGE_TASK_ID-1]}
sample_name=$(echo $(basename $FILENAME) | sed 's/.RG.bam//')
SUBSET_BAM=${WORK_DIR}/${sample_name}.subset.bam

echo The input file is ${FILENAME}
echo The sample name is ${sample_name}

module load apps/java
PATH=$PATH:/data/bo1srs/gatk-4.0.7.0
export PATH
# May need to edit to be path to the picard.jar that you have access to
PICARD=/data/bo1srs/picard/build/libs/picard.jar


# check if analysis has already been run

if [ ! -f ${WORK_DIR}/${sample_name}.done ]
then
# create a subset bam to contain just the contigs being analysed

java -jar ${PICARD} ReorderSam I=${FILENAME} O=${SUBSET_BAM} R=${FASTA} S=true CREATE_INDEX=true

gatk --java-options '-Xmx8g' HaplotypeCaller -R ${FASTA} -ERC GVCF -I ${SUBSET_BAM} -L ${BED_FILE} --output-mode EMIT_ALL_CONFIDENT_SITES -O ${WORK_DIR}/${sample_name}.g.vcf.gz
else echo "Analysis has already been run"
fi

status=$?
if [ $status == 0 ];
then
touch ${WORK_DIR}/${sample_name}.done
rm ${SUBSET_BAM}
else
touch ${WORK_DIR}/${sample_name}.fail
fi


#https://www.rc.fas.harvard.edu/resources/documentation/submitting-large-numbers-of-jobs-to-odyssey
