#!/bin/bash

ls ../Data/VCF * | grep .vcf$ > temp.txt

mkdir ../Data/RecalVCF
mkdir ../Data/RecalVCFTable
mkdir ../Data/Tranches

while read vcf; do
        name=${vcf%.vcf}

	java -jar GenomeAnalysisTK.jar \
    		-T VariantRecalibrator \
    		-R ../Data/human_g1k_v37.fasta \
    		-input ../${name}.vcf \
    		-resource:hapmap,known=false,training=true,truth=true,prior=15.0 hapmap_3.3.b37.vcf \
    		-resource:1000G,known=false,training=true,truth=false,prior=10.0 1000G_phase1.snps.high_confidence.b37.vcf \
    		-an DP \
    		-an QD \
    		-an FS \
    		-an SOR \
    		-an MQ \
    		-an ReadPosRankSum \
    		-an InbreedingCoeff \
    		-mode SNP \
    		-tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 \
    		-recalFile ../Data/RecalVCFTable/${name}_SNP.recal \
    		-tranchesFile ../Data/Tranches/${name}_SNP.tranches \
    		-rscriptFile recalibrate_SNP_plots.R 

	java -jar GenomeAnalysisTK.jar \
    		-T ApplyRecalibration \
		-R ../Data/human_g1k_v37.fasta \
                -input ../${name}.vcf \
    		-mode SNP \
   		--ts_filter_level 99.0 \
		-recalFile ../Data/RecalVCFTable/${name}_SNP.recal \
                -tranchesFile ../Data/Tranches/${name}_SNP.tranches \
    		-o ../Data/RecalVCF/{name}_recal_SNP.vcf 
	
	java -jar GenomeAnalysisTK.jar \
                -T VariantRecalibrator \
                -R ../Data/human_g1k_v37.fasta \
                -input ../${name}_recal_SNP.vcf \
		-resource:mills,known=true,training=true,truth=true,prior=12.0 Mills_and_1000G_gold_standard.indels.b37.vcf \  
                -an DP \
                -an QD \
                -an FS \
                -an SOR \
                -an MQ \
                -an ReadPosRankSum \
                -an InbreedingCoeff \
                -mode INDEL \
		--maxGaussians 4 \
                -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 \
                -recalFile ../Data/RecalVCFTable/${name}_INDEL.recal \
                -tranchesFile ../Data/Tranches/${name}_INDEL.tranches \
                -rscriptFile recalibrate_INDEL_plots.R

        java -jar GenomeAnalysisTK.jar \
                -T ApplyRecalibration \
                -R ../Data/human_g1k_v37.fasta \
                -input ../${name}_recal_SNP.vcf \
                -mode INDEL \
                --ts_filter_level 99.0 \
                -recalFile ../Data/RecalVCFTable/${name}_INDEL.recal \
                -tranchesFile ../Data/Tranches/${name}_INDEL.tranches \
                -o ../Data/RecalVCF/{name}_recal_SNP_INDEL.vcf	

done < temp.txt
rm temp.txt


