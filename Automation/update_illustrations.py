#!/usr/bin/env python3
# encoding: utf-8

"""
This script:
  1) Gets all currently defined illustration names from 'Illustrations.swift'
  2) Downloads and rewrites all illustrations
"""

import sys
import os
import re
import pathlib
import shutil
import time
from urllib.request import urlretrieve

content_template = '''{{
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
source_filename = 'Illustrations.swift'

def uppercase_first_letter(s):
  return s[:1].upper() + s[1:] if str else ''

def get_illustration_names(codePath):
  p = re.compile(r'case\s+(\w+)')
  names = []
  with open(codePath, 'r') as illustrationCode:
    for line in illustrationCode:
      for case in p.findall(line):
        if case == 'none':
          continue
        names.append(uppercase_first_letter(case))
  return names

def download_illustration(illustrationName, sizeIndex, assetDownloadedPath):
  url = illustration_url_template.format(illustrationName = illustrationName, size = sizes[sizeIndex-1])
  filename = f'{illustrationName}@{sizeIndex}x.png'
  filepath = assetDownloadedPath.joinpath(filename)
  print(f'Downloading [{url}] -> [{filename}] ...')
  try:
    urlretrieve(url, filepath)
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
    return next(iosRootPath.rglob(source_filename)).parent

if __name__ == "__main__":

  folder = illustrationsFolderPath()
  codePath = folder.joinpath(source_filename)
  assetDownloadedPath = folder.joinpath('../Illustrations/Illustrations.xcassets/')
  assetDownloadedPath.mkdir(exist_ok = True)

  for illustration in get_illustration_names(codePath):

    folderPath = assetDownloadedPath.joinpath("{illustration}.imageset/".format(illustration = illustration))
    folderPath.mkdir(exist_ok = True)

    # Create definition file
    with open(folderPath.joinpath('Contents.json'), "w") as contentFile:
      contentFile.write(content_template.format(name = illustration))

    time.sleep(1)

    for sizeIndex in range(1, 4):
      download_illustration(illustration, sizeIndex, folderPath)
      time.sleep(0.5)
