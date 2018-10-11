#!/bin/bash

# Copyright 2017.08.09 sanghong.kim@inha.ac.kr
# 	    2014~2017  Department of Engineering of Electronics at the University of Inha
#	    Korean Speech recognition
#
#
#

# Print the command line for logging
echo "prep_data..."
echo "Your command is : $0 $@"



if [ $# -ne 2 ]; then
	echo "Usage: $0 <src-dir> <sdt-dir>"
	echo "Example : $0 /Korean_data data/Korean_data"
	exit 1
fi

# Source directory
src=$1
# Destination directory
dst=$2


if [ ! -d $dst ]; then
	mkdir -p $dst || exit 1;
fi

[ ! -d $src ] && echo "$0: no such directory $src" && exit 1;


for source_dir in $(find -L $src -mindepth 1 -maxdepth 1 -type d | sort); do
	source=$(basename $source_dir)

	mkdir -p $dst/$source || exit 1;

	echo "$(basename $0 | xargs -I% basename % .sh): Previous $dst/$source wav.scp, text, utt2spk, segments were removed"
	wav_scp=$dst/$source/wav.scp; [[ -f "$wav_scp" ]] && rm $wav_scp
	trans=$dst/$source/text; [[ -f "$trans" ]] && rm $trans
	utt2spk=$dst/$source/utt2spk; [[ -f "$utt2spk" ]]  && rm $utt2spk
	spk2utt=$dst/$source/spk2utt; [[ -f "$spk2utt" ]]  && rm $spk2utt
	segments=$dst/$source/segments; [[ -f "$segments" ]] && rm $segments
	textraw=$dst/$source/textraw; [[ -f "$textraw" ]] && rm $textraw


	for trans_dir in $(find -L $source_dir -mindepth 1 -maxdepth 1 -type d | sort); do
		find -L $trans_dir -iname "*.wav" | sort | xargs -I% basename % .wav | \
			awk -v "dir=$trans_dir" '{printf "%s %s/%s.wav\n", $0, dir, $0}' >> $wav_scp|| exit 1

		trd=$(basename $trans_dir)
		## This part was copied
		data_num=`ls $trans_dir | wc -w`
	        data_list=`ls $trans_dir`

        	for txt in `seq 1 $data_num`; do
	                data_name=$(echo $data_list | cut -d' ' -f$txt)
        	        snt_list=$(ls $trans_dir/$data_name | grep .txt)
	                snt_num=$(echo $snt_list | wc -w)

	                for snt in $(seq 1 $snt_num); do
                	        get_snt=`echo $snt_list | cut -d' ' -f$snt`
				tmp1=$(echo $data_name | xargs -I% basename % .txt)
	                        tmp2=$(cat $get_snt)
	                        wav_snt=`echo $get_snt | sed 's/.txt//g'`
	                        wav_name=`echo $get_snt | sed 's/.txt/.wav/g'`
	                        time1=0.0
                	        tmp=`soxi -D $wav_name`
        	                time2=`printf "%.2f\n" "$tmp"`
	                        echo "$tmp1 $tmp1 $time1 $time2" >> $segments
        	                echo "$tmp1 $tmp2" >> $trans
				echo "$tmp1 $trd" >> $utt2spk || exit 1
	                done
	        done
	done

	cat $dst/$source/text | awk '{$1=""; print $0}' $dst/$source/text | sed 's/^ *//' > $dst/$source/textraw || exit 1
	echo "$source done"
	utils/utt2spk_to_spk2utt.pl $utt2spk >$spk2utt || exit 1
done



# textraw

echo "$0 : successfully prepared data in $dst"

exit 0
