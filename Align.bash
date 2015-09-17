#!/bin/bash

ls ../Data | grep .fastq.gz$ > temp.txt
while read FASTQ; do
	patientNum=${FASTQ%_*_*}
	temp=${FASTQ#*_}
	readNum=${temp:0:2}
	dirNum=${temp:3:2}
	out=${patientNum}_${readNum}_${dirNum}_aligned.sam
	tag="@RG\tID:${patientNum}_${readNum}_${dirNum}\tSM:${patientNum}\tPL:illumina\tLB:Lib-${patientNum}_${readNum}"
	bwa mem -M -R $tag -p human_g1k_v37.fasta.gz $FASTQ > $out 
	
done<temp.txt
rm temp.txt
