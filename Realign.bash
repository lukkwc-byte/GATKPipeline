#!/bin/bash

ls ../Data/Dedup * | grep _dedup.bam$ > temp.txt
mkdir ../Data/RealignmentTargets

while read dedup; do
	name=${dedup#
done< temp.txt


rm temp.txt
