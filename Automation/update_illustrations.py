#!/usr/bin/env python3
# encoding: utf-8

"""
This script:
  1) Downloads original hi-res illustration resources
  2) Resizes them into 1x, 2x and 3x sizes
"""

import sys
import os
import pathlib
import re
import requests
import shutil
import subprocess
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

illustration_source_template = '''import Foundation
import Orbit

public extension Illustration {{

    enum Asset: String, CaseIterable, AssetNameProviding {{
{cases}
    }}
}}
'''

illustration_heights = [200, 400, 600]
illustration_url_template = 'https://images.kiwi.com/illustrations/originals/{illustrationName}.png'
source_filename = 'Illustrations.swift'

def get_illustration_names():
  url = 'https://raw.githubusercontent.com/kiwicom/orbit/master/packages/orbit-components/src/Illustration/consts.mts'
  response = requests.get(url, stream=True)

  names = []

  for line in response.iter_lines():
    match = re.search('\"(\w+)\"', line.decode('utf-8'))

    if match:
      names.append(match.group(1))

  return names

def download_and_resize_illustration(illustrationName, assetDownloadedPath):
  url = illustration_url_template.format(illustrationName = illustrationName)
  originalFilename = f'{illustrationName}@full.png'
  originalFilepath = assetDownloadedPath.joinpath(originalFilename)
  print(f'Downloading [{url}] ...')
  try:
    urlretrieve(url, originalFilepath)

    print(f'Resizing [{illustrationName}] -> ', end='')

    for idx, height in enumerate(illustration_heights):
      print(f'[{height}@{(idx+1)}x] ... ', end='')

      resizedFilename = f'{illustrationName}@{(idx+1)}x.png'
      resizedFilePath = assetDownloadedPath.joinpath(resizedFilename)

      # Resize
      command = f'convert {originalFilepath} -resize x{height} -filter Lanczos -quality 100 {resizedFilePath}'
      subprocess.run(command, shell=True)

      # Optimize
      command = f'pngquant --speed 1 --quality=65-85 --strip -f -o {resizedFilePath} -- {resizedFilePath}'
      subprocess.run(command, shell=True)

    print()
    os.remove(originalFilepath)
    
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
  assetDownloadedPath = folder.joinpath('./Illustrations.xcassets/')
  assetDownloadedPath.mkdir(exist_ok = True)
  illustration_names = []

  for illustration in get_illustration_names():

    folderPath = assetDownloadedPath.joinpath("{illustration}.imageset/".format(illustration = illustration))
    folderPath.mkdir(exist_ok = True)

    # Create definition file
    with open(folderPath.joinpath('Contents.json'), "w") as contentFile:
      contentFile.write(content_template.format(name = illustration))

    download_and_resize_illustration(illustration, folderPath)

    illustration_names.append('        case ' + illustration[0].lower() + illustration[1:])

  codePath = folder.joinpath(source_filename)
  illustration_names.sort()

  # Recreate illustrations source file
  with open(codePath, "w") as sourceFile:
    sourceFile.write(illustration_source_template.format(cases = '\n'.join(illustration_names)))
