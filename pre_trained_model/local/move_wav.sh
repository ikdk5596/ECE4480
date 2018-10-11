#!/bin/bash


# src=$1

src=/home/sanghong/Korean_data/source/decode

tmp=`find -L $src -maxdepth 1 -iname "*.wav"`

mv $tmp $src/tmp

