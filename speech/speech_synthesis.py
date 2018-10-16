#!/usr/bin/envs python3
# -*- coding: utf-8 -*-

#################################
#				#
#       Inha University		#
#     DSP Lab Sanghong Kim	#
#				#
#################################

"""
Speech Synthesis Python Example
"""


# Import Modules
import sys
import argparse
import requests
from pydub import AudioSegment
import os

def main(args):
    text = args.text
    output = args.output
    wav = os.path.splitext(output)[0] + '.wav'
    print("합성될 Text : %s" %text)
    fp = requests.get('http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&textlen=64&client=tw-ob&q=%s&tl=ko-kr' %text)
    if fp.status_code == 200:
        with open(output, 'wb') as f:
            for chunk in fp:
                f.write(chunk)
    else:
        print("Request Error!")
    fp.close()
    sound = AudioSegment.from_mp3(output)
    sound = sound.set_frame_rate(16000)
    sound.export(wav, format="wav")


# Arguments Setting
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--text", "-t", dest='text', type=str, help="Input your Text")
    parser.add_argument("--output", "-o", dest='output', type=str, help="Out put File", default='output.mp3')
    args = parser.parse_args()
    if args.text is None:
        print('Usage : python speech_synthesis.py -t "input text"')
        sys.exit(1)
    else:
        main(args)

