#!/bin/bash

ls ../Data/Dedup * | grep _dedup.bam$ > temp.txt

mkdir ../Data/TrimmedBam

while read bam; do
	name=${bam%_dedup.bam}
	
	#Get only TTN
	samtools view -h1 ../Data/Dedup/${name}_dedup.bam 2:179389001-179674000 > ../Data/TrimmedBam/${name}_trimmed.bam

	#IndexNewBam
        java -jar /bin/picard-tools-1.133/picard.jar BuildBamIndex \
                INPUT=../Data/TrimmedBam/${name}_trimmed.bam

done < temp.txt
rm temp.txt
