#!/bin/bash

ls ../Data/Fastq | grep R1.fastq.gz$ > temp.txt
mkdir ../Data/Sam
while read FASTQ; do
	patientNum=${FASTQ%_*_*}
	temp=${FASTQ#*_}
	readNum=${temp:0:2}
	dirNum=${temp:3:2}
	out=../Data/Sam/${patientNum}_${readNum}_aligned.sam
	tag="@RG\tID:${patientNum}_${readNum}\tSM:${patientNum}\tPL:illumina\tLB:Lib-${patientNum}_${readNum}"
	pair=${patientNum}_${readNum}_R2.fastq.gz 
	bwa mem -M -R $tag ../Data/human_g1k_v37.fasta.gz ../Data/Fastq/${FASTQ} ../Data/Fastq/${pair} > $out 
	
done<temp.txt
rm temp.txt
