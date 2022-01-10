#!/usr/bin/env python3
# encoding: utf-8

"""
This script:
  1) Gets all currently used illustration names from our source code 'Illustrations.swift'
  2) Downloads all illustrations with proper file names
"""

import sys
import os
import re
import pathlib
import shutil
import time
from urllib.request import urlretrieve

content_template = '''
{{
  "images" : [
    {{
      "filename" : "{name}@1x.png",
      "idiom" : "universal",
      "scale" : "1x"
    }},
    {{
      "filename" : "{name}@2x.png",
      "idiom" : "universal",
      "scale" : "2x"
    }},
    {{
      "filename" : "{name}@3x.png",
      "idiom" : "universal",
      "scale" : "3x"
    }}
  ],
  "info" : {{
    "author" : "xcode",
    "version" : 1
  }}
}}
'''

sizes = [200, 400, 600]
illustration_url_template = 'https://images.kiwi.com/illustrations/0x{size}/{illustrationName}.png'
source_filename = 'Illustrations'

def uppercase_first_letter(s):
  return s[:1].upper() + s[1:] if str else ''

def get_illustration_names(codePath):
  p = re.compile(r'case\s+(\w+)')
  names = []
  with open(codePath, 'r') as illustrationCode:
    for line in illustrationCode:
      for case in p.findall(line):
        names.append(uppercase_first_letter(case))
  return names

def download_illustration(illustrationName, sizeIndex, assetDownloadedPath):
  url = illustration_url_template.format(illustrationName = illustrationName, size = sizes[sizeIndex-1])
  path = assetDownloadedPath.joinpath("{illustrationName}@{sizeIndex}x.png".format(illustrationName = illustrationName, sizeIndex = sizeIndex))
  print("Downloading [{url}] -> [{path}] ...".format(url = url, path = path))
  try:
    urlretrieve(url, path)
  except Exception as e:
    print(f'❗️{e}')

def illustrationsFolderPath():
  if len(sys.argv) > 1 and not sys.argv[1].startswith('-'):
    folder = pathlib.Path(sys.argv[1])
    assert folder.exists(), f'Path {folder} does not exist'
    return folder
  else:
    # Find source files folder
    iosRootPath = pathlib.Path(__file__).absolute().parent.parent.parent
    return next(iosRootPath.rglob(f'{source_filename}.swift')).parent

if __name__ == "__main__":

  folder = illustrationsFolderPath()
  codePath = folder.joinpath(f'{source_filename}.swift')
  assetDownloadedPath = folder.joinpath('../Illustrations/Illustrations.xcassets/⚠️ Downloaded/')
  assetDownloadedPath.mkdir(exist_ok = True)

  for illustration in get_illustration_names(codePath):

    folderPath = assetDownloadedPath.joinpath("{illustration}.imageset/".format(illustration = illustration))
    folderPath.mkdir(exist_ok = True)

    # Create definition file
    with open(folderPath.joinpath('Contents.json'), "w") as contentFile:
      contentFile.write(content_template.format(name = illustration))

    for sizeIndex in range(1, 4):
      download_illustration(illustration, sizeIndex, folderPath)
      time.sleep(0.3)
