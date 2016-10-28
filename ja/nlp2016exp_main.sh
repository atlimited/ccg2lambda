#!/bin/bash

# This is a script to do evaluation for NLP2016.
#
# ./nlp2016exp.sh <cores> <result_dir>
#

cores=${1:-3}
results_dir=$2

cp ja/coqlib_ja.v coqlib.v
coqc coqlib.v

mkdir -p ja_{plain,parsed,results}
### Extract JSeM problems from XML fail into separate plain files.
# A list of jsem problems with tags ("jsem_problem_list") is created.
rm -f jsem_problems_list
cp ja/jsem.xml .
python extract_jsem_problems_ribe.py jsem.xml ja_plain

### Plain results ###
./ja/nlp2016exp_set.sh $cores $results_dir plain
./ja/nlp2016exp_eval.sh $results_dir plain

### Gold-tree results ###
# Remove semantically-parsed files from previous plain run.
rm -rf ja_parsed_plain
cp -r ja_parsed ja_parsed_plain
rm ja_parsed/*.sem.*
# Copying gold parse trees onto the ja_parse directory
cp ja_parsed_gold/*.xml ja_parsed/
./ja/nlp2016exp_set.sh $cores $results_dir gold
./ja/nlp2016exp_eval.sh $results_dir gold
# Restore the plain parsed files
cp ja_parsed_plain/* ja_parsed/