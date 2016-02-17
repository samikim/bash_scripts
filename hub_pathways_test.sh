#!/bin/bash

# Takes 2 parameters: file containing hub list, containing directory name

# This script goes through the following steps to test that hub pathways are functioning correctly:
# 0. Grab the hub compounds from a hub input file (different lines for different sets of hub compounds)

# Loop for every pair of hub compounds:
# 1. Creates an input file for running the hub compounds search (input compound, target compound, hubs, max, 1.0)
# 2. Runs the pathway search jar with the input file, generates an output file of all the pathway results
# 3. Checks if no hub compounds are in the output file; if not store all hub compounds contained and jump to writing final output file
# 4. Also extracts min num of carbons tracked / num of carbons in input compound
# 5. Create a new input file for running normal compounds search (input compound, target compound, max, carbon %)
# 6. Runs the pathway search jar with the new input file, generates a control output file
# 7. Runs the python script to convert both output pathway results to a list of compounds/RPAIRs only
# 8. Check that the hub results are fully contained in the original search; if not store all pathways not contained and jump to writing final output file
# 9. Write a line in the final output file that includes: Input compound, target compound, hub set num, % carbons conserved, num of pathways found, 
# 	hubs contained (if any), pathways not contained (if any), shortest hub pathway length, shortest orig path length, longest hub pathway length, longest orig path length



# Function that takes a pair of compounds and does all tests
# Input: input compound, target compound, hub compounds
eval_pair ()
{
	# Testing that functions work
	#echo "> $hub1 $hub2"

	# Create input file for hub compound search
	echo "DBHOST	localhost
DBPORT	3306
DBNAME	MetaDB_2015
DBUSER	MetaDBUser
DBPASS	meta
MOLDIR	map_02132015/rpair_mol
RPAIRDIR	map_02132015/rpair_only_maps
REACTIONDIR	map_02132015/rpair_maps
K	1000000
USEREVERSE	1
HUBS	$1
STARTCID	$hub1
TARGETCID	$hub2
CARBONTRACK	max
PERCENTCARBON	1.0
WEIGHTTYPE	WEIGHT_OF_ONE
OUTPUTDIR	"$2"/hub_output" > "$2"/hub_input/"$hub1"_"$hub2".txt

 	# Run pathway search jar
 	cd ~/metapath/allison_resources/lpat_bpat_test_cases
	java -jar -Xms2g -Xmx6g -jar lpat_hubs.jar "$2"/hub_input/"$hub1"_"$hub2".txt

	# Check if no hub compounds are in the output file
#for hub in $hub_set
#do

	# If there are hub compounds, jump to final output


	# Extract min num of carbons tracked


	# Create new input file for normal search


	# Run pathway search jar again


	# Run python script converting path files to lists of compounds/RPAIRs only


	# Check that hub pathways are included in original pathway search results


	# If there are missing pathways, store them in list


	# Open and write line in final output file
	# Input compound, target compound, hub set num, % carbons conserved, num of pathways found, 
	# hubs contained (if any), pathways not contained (if any), shortest hub pathway length, 
	# shortest orig path length, longest hub pathway length, longest orig path length

}

# Make all the directories needed
mkdir -p "$2"/hub_input;
mkdir -p "$2"/hub_output;
mkdir -p "$2"/orig_input;
mkdir -p "$2"/orig_output;


# Open hub list file and grab hub set
while IFS='' read -r line
do
	hub_set=$(echo $line | tr "," "\n")

# Loop over all pairs of hubs, can probably parallelize this
	for hub1 in $hub_set
	do
		for hub2 in $hub_set
		do
			if [ "$hub1" != "$hub2" ]
				then
				eval_pair "$line" "$2"
				break
			fi
		done
		break
	done

done < "$1"