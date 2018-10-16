# -*- coding:utf-8 -*-
import urllib3
import json
import base64
import argparse
import sys

def main(args):
    openApiURL = "http://aiopen.etri.re.kr:8000/WiseASR/Recognition"
    accessKey = "Your Own Key"
    audioFilePath = args.input
    languageCode = "korean"

    file = open(audioFilePath, "rb")
    audioContents = base64.b64encode(file.read()).decode("utf8")
    file.close()

    requestJson = {
        "access_key": accessKey,
        "argument": {
            "language_code": languageCode,
            "audio": audioContents
        }
    }

    http = urllib3.PoolManager()
    response = http.request(
        "POST",
        openApiURL,
        headers={"Content-Type": "application/json; charset=UTF-8"},
        body=json.dumps(requestJson)
    )
    data = response.data
    data = data.decode("utf-8")

    print("[responseCode] " + str(response.status))
    print("[responBody]")
    print(data)


# Arguments Setting
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", "-i", dest='input', type=str, help="Input your wav")
    args = parser.parse_args()
    if args.input is None:
        print('Usage : python speech_recognition.py -i "input file"')
        sys.exit(1)
    else:
        main(args)
