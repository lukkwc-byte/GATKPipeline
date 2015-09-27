#!/bin/bash

ls ../Data/Dedup * | grep _dedup.bam$ > temp.txt

mkdir ../Data/RealignmentTargets
mkdir ../Data/RealignedBams

while read dedup; do
	name=${dedup%_dedup.bam}
	java -jar ./GenomeAnalysisTK.jar -nt 24 \
		-T RealignerTargetCreator \
		-R ../Data/human_g1k_v37.fasta \
		-I ../Data/Dedup/${dedup} \
		-known Mills_and_1000G_gold_standard.indels.b37.vcf \
		-o ../Data/RealignmentTargets/${name}_realignment_targets.list
	
	java -jar ./GenomeAnalysisTK.jar \
    		-T IndelRealigner \
    		-R ../Data/human_g1k_v37.fasta \
    		-I ../Data/Dedup/${dedup} \
    		-known Mills_and_1000G_gold_standard.indels.b37.vcf \
		-targetIntervals ../Data/RealignmentTargets/${name}_realignment_targets.list \
    		-o ../Data/RealignedBams/${name}_realigned.bam


done< temp.txt

rm temp.txt
