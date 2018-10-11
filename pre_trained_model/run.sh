#!/bin/bash

# Copyright 2017.08.09 sanghong.kim@inha.ac.kr
#           2014~2017  Department of Engineering of Electronics at the University of Inha
#           Korean Speech recognition
#
#
#

# open path.sh then, set your kaldi path


# Set your dir.
decode_src=./wave

rm ./utils
rm ./stepts

# Set cmd what you want to use Ex) utils/run.pl, utils/queue.pl
train_cmd=utils/run.pl
decode_cmd=utils/run.pl

# Set directory
#train_dir=data/train
#val_dir=data/val
#test_dir=data/test
#dict_dir=data/local/dict
#lang_dir=data/local/lang
#dict_dir_new=data/local/dict_new
decode_dir=data/decode

#. ./path.sh $kaldi_root || exit 1
source ./path.sh || exit 1

# Set variables
decode_nj=1

# Activation part
decode=1

decode_option="--max_active 6500 --min_active 200 --beam 15 --lattice_beam 16"

if [ $decode -eq 1 ]; then
	rm -rf $decode_dir
	python3 local/asr_prep_data.py $decode_src $decode_dir >/dev/null
	utils/utt2spk_to_spk2utt.pl $decode_dir/utt2spk > $decode_dir/spk2utt

	utils/validate_data_dir.sh \
		--no-feats \
		--no-text \
		$decode_dir || exit 1
	spk_id=`find -L $decode_src -maxdepth 1 -iname "*.wav" | xargs -I% basename % .wav`
	echo "spk_id is $spk_id"

fi


if [ $decode -eq 1 ]; then
	steps/make_mfcc.sh \
		--cmd "$train_cmd" \
		--nj $decode_nj \
		$decode_dir \
		exp/make_mfcc/decode \
		$mfccdir
	steps/compute_cmvn_stats.sh \
		$decode_dir \
		exp/make_mfcc/decode \
		$mfccdir
fi

if [ $decode -eq 1 ]; then
	steps/nnet2/decode.sh \
		$decode_option \
		--nj $decode_nj \
		exp/tri3/graph \
		$decode_dir \
		exp/nnet/decode_one

	result=`cat exp/nnet/decode_one/log/decode.1.log | grep $spk_id | grep -Ev 'LOG|WARING' | head -2 | awk '{$1=""; print $0}'`
	echo -e "\nResult : $result\n"
fi
