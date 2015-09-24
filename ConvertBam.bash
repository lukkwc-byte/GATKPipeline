#!/bin/bash

ls ../Data/Sam * | grep _aligned.sam$ > temp.txt

mkdir ../Data/SortedBam
mkdir ../Data/Dedup
mkdir ../Data/Metrics

while read sam; do
	input=$sam
	name=${sam%*_aligned.sam}
	
	#Create a sorted bam
	sortedBam=../Data/SortedBam/${name}_sorted.bam
	java -jar /bin/picard-tools-1.133/picard.jar SortSam \
		INPUT=$input \
		OUTPUT=$sortedBam \
		SORT_ORDER=coordinate
	
	#Mark the duplictes
	dedupBam=../Data/Dedup/${name}_dedup.bam
	metrics=../Data/Metrics/${name}_metrics.txt
	java -jar /bin/picard-tools-1.133/picard.jar MarkDuplicates \
		INPUT=$sortedBam \
		OUTPUT=$dedupBam \
		METRICS_FILE=$metrics
	
	#Index Bam File
	java -jar /bin/picard-tools-1.133/picard.jar BuildBamIndex \
		INPUT=$dedupBam

done < temp.txt	
rm temp.txt 
