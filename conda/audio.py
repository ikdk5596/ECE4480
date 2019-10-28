# copied from http://snowdeer.github.io/python/2017/11/15/python-raspberry-pyaudio-example/

import pyaudio
import wave
import sys
import msvcrt
import argparse

chunk = 1024

def record():
    format = pyaudio.paInt16
    channel = 1
    rate = 16000
    filename = input("Output Filename : ")
    pya = pyaudio.PyAudio()

    stream = pya.open(
        format = format,
        channels = channel,
        rate = rate,
        input = True,
        frames_per_buffer = chunk
    )

    print("Recording...")
    frames = []
    print("Press Esc to Quit")

    while True:
        data = stream.read(chunk)
        frames.append(data)
        if msvcrt.kbhit():
            if ord(msvcrt.getch()) == 27:
                break

    file = wave.open(filename, 'wb')
    file.setsampwidth(pya.get_sample_size(format))
    file.setnchannels(channel)
    file.setframerate(rate)
    file.writeframes(b''.join(frames))
    file.close()

    print("Done")

def play():
    filename = input("Input Filename : ")
    file = wave.open(filename, 'rb')
    pya = pyaudio.PyAudio()
    stream = pya.open(
        format = pya.get_format_from_width(file.getsampwidth()),
        channels = file.getnchannels(),
        rate = file.getframerate(),
        output = True
        )
    data = file.readframes(chunk)

    '''
    selection = input("Press q to Quit")
    if selection is "Q" or "q":
        print("Quitting")
        sys.exit()
    '''

    print("Press Esc to Quit")
    while data is not None:
        stream.write(data)
        data = file.readframes(chunk)
        if msvcrt.kbhit():
            if ord(msvcrt.getch()) == 27:
                break

