from create import create_envs
from audio import play, record
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('-o','--option', dest='option',
                        help="To Play Audio, python audio.py --option play \nTo Record Audio, python audio.py --option record")
    arg = parser.parse_args()
    if arg.option is None:
        create_envs()
        print(parser.print_help())
        print("To activate env : conda activate py36")
    elif arg.option == "play":
        play()
    elif arg.option == "record":
        record()
    else:
        print(parser.print_help())