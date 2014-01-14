#! /bin/bash

# Program: ngsplot_json.sh
# Purpose: Plot sequencing coverages of same dataset at different genomic 
#          regions, with different gene lists. Output with suffix "_json".
#
# -- by Ning-Yi SHAO, MSSM
# Created:      Jan 2014.


if [ $# -lt 1 ]; then
	echo "Usage: $0 config.json"
	exit 0
fi

# jq is needed for parsing json file
# $ wget http://stedolan.github.io/jq/download/linux32/jq (32-bit system)
# $ wget http://stedolan.github.io/jq/download/linux64/jq (64-bit system)

## if jq not in the path, just download it
hash jq 2>/dev/null || \
	{ wget http://stedolan.github.io/jq/download/linux64/jq; chmod u+x jq; }

JSONCONFIG=$1
GENOME=`cat "${JSONCONFIG}" | jq -r '.genome'`
CORES=`cat "${JSONCONFIG}" | jq -r '.cores'`
FL=`cat "${JSONCONFIG}" | jq -r '.fragmentlength'`

# REGIONS=`cat "${JSONCONFIG}" | jq '.regions[] | .["region"]'`
REGIONS=(`jq -r '.regions[] | .["region"]' "${JSONCONFIG}"`)
GENELISTS=(`cat "${JSONCONFIG}" | jq -r '.genelists[] | .["genelist"]'`)
TAGS=(`cat "${JSONCONFIG}" | jq -r '.tags[] | .["tag"]'`)
BAMS=(`cat "${JSONCONFIG}" | jq -r '.bams[] | .["bam"]'`)

# length of genelists
gLen=${#GENELISTS[@]}

if [[ -f config_temp.txt ]]; then
	rm config_temp.txt
fi

for BAM in ${BAMS[@]}; do
	echo ${BAM}
	for (( i=0; i<${gLen}; i++)); do
		echo -e "${BAM}\t${GENELISTS[${i}]}\t${TAGS[${i}]}" >> config_temp.txt
	done
	for REGION in ${REGIONS[@]}; do
		ngs.plot.r -C config_temp.txt -R ${REGION} -G ${GENOME} \
		-O ${BAM/.bam/_json}_${REGION} -FL ${FL} -P ${CORES}
	done
	rm config_temp.txt
done


## example of the config.json
## to plot pair bams of 4 bam at tss and genebody

# {
# 	"genome": "hg19",
# 	"cores": 20,
# 	"fragmentlength": 150,
# 	"regions":[
# 	{
# 		"region": "tss"
# 	},
# 	{
# 		"region": "genebody"
# 	}
# 	],
# 	"genelists":[
# 	{
# 		"genelist": "~/data/misc/hg19_PFC_exp/hg19.PFC.low.txt"
# 	},
# 	{
# 		"genelist": "~/data/misc/hg19_PFC_exp/hg19.PFC.mid.txt"
# 	},
# 	{
# 		"genelist": "~/data/misc/hg19_PFC_exp/hg19.PFC.high.txt"
# 	}
# 	],
# 	"tags":[
# 	{
# 		"tag": "Low"
# 	},
# 	{
# 		"tag": "Mid"
# 	},
# 	{
# 		"tag": "High"
# 	}
# 	],
# 	"bams":[
# 	{
# 		"bam": "175_p2_H3K9me2.bam:175_input.bam"
# 	},
# 	{
# 		"bam": "175_p3_H3K9me2.bam:175_input.bam"
# 	},
# 	{
# 		"bam": "197_p2_H3K9me2.bam:197_input.bam"
# 	},
# 	{
# 		"bam": "197_p3_H3K9me2.bam:197_input.bam"
# 	}
# 	]
# }