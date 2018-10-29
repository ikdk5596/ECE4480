def create_envs():
	import os
	import subprocess
	os.system('conda create -y -n py36 python=3.6')
	os.system('Anaconda3\envs\py36\python -m pip install pyaudio')
