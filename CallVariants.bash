#!/bin/bash
joint=$1

ls ../Data/RecalBams/ | grep _recal.bam$ > temp.txt
find ../Data/gVCF -name *.g.vcf > temp.list

mkdir ../Data/gVCF
mkdir ../Data/VCF

#while read bam; do
#	name=${bam%_recal.bam}
#	java -jar ./GenomeAnalysisTK.jar -nct 20 \
#		-T HaplotypeCaller \
#    		-R ../Data/human_g1k_v37.fasta \
#		--dbsnp ../Data/dbsnp_138.b37.vcf \
#    		-I ../Data/RecalBams/${bam} \
#   		--genotyping_mode DISCOVERY \
#		-stand_emit_conf 10 \
#		-stand_call_conf 30 \
#		--emitRefConfidence GVCF \
#		-o ../Data/gVCF/${name}.g.vcf
#done < temp.txt
#rm temp.txt

#java -jar ./GenomeAnalysisTK.jar \
#	-T CombineGVCFs \
#	-R ../Data/human_g1k_v37.fasta \
#	-V ./temp.list \
#	-o ../Data/gVCF/${joint}.g.vcf

java -jar ./GenomeAnalysisTK.jar -nt 20 \
        -T GenotypeGVCFs \
        -R ../Data/human_g1k_v37.fasta \
        --variant ../Data/gVCF/${joint}.g.vcf \
        -o ../Data/VCF/${joint}.vcf

