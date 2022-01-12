#!/usr/bin/env python3
# encoding: utf-8

"""
This script:
  1) Reads up-to-date color definitions from Orbit API
  2) If running in the check-only mode
    a) Checks if the regenerated file would result in a different content
    b) If yes, it calls a script to create relevant Jira task
  3) Else
    a) Regenerates xcassets file with updated color definitions
    b) Regenerates a swift source code that uses that color xcassets file
"""

import sys
import os
import json
import re
import pathlib
import shutil
from urllib.request import urlopen
import update_colors_jira_task

ORBIT_URL = 'https://unpkg.com/@kiwicom/orbit-design-tokens/output/theo-spec.json'
ORBIT_COLOR_PREFIX = 'palette'

contents_filename = 'Contents.json'

xcassets_header = '''{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
'''

xcassets_color_template = '''{{
  "colors" : [
    {{
      "color" : {{
        "color-space" : "srgb",
        "components" : {{
          "alpha" : "1.000",
          "blue" : "0x{B}",
          "green" : "0x{G}",
          "red" : "0x{R}"
        }}
      }},
      "idiom" : "universal"
    }}
  ],
  "info" : {{
    "author" : "xcode",
    "version" : 1
  }}
}}
'''

source_filename_plural = f'Colors'
source_group_template = '\n    // MARK: - {group}'
source_line_template = '    static let {name} = Color("{description}", bundle: .current)'
source_line_template_uicolor = '    static let {name} = fromResource(named: "{description}")'
source_template = '''/// Generated and updated by 'Automation/orbit/update_colors.py'
// swiftlint:disable:previous orphaned_doc_comment

import SwiftUI

public extension Color {{
{colorList}
}}
'''

source_template_uicolor = '''/// Generated and updated by 'Automation/orbit/update_colors.py'
// swiftlint:disable:previous orphaned_doc_comment

import UIKit

public extension UIColor {{
{colorList}
}}
'''

def lowercase_first_letter(s):
  return s[:1].lower() + s[1:] if str else ''

def camel_case_split(str):
  return re.findall(r'[A-Z](?:[a-z]+|[A-Z]*(?=[A-Z]|$))', str)

def str_to_hexa(str):
  return '{0:0{1}x}'.format(int(str),2).upper()

def get_updated_colors():
  r = urlopen(ORBIT_URL).read()
  data = json.loads(r)
  return {k: v for k, v in data.items() if k.startswith(ORBIT_COLOR_PREFIX)}

def isRunningInCheckOnlyMode():
  return "--check-only" in sys.argv

def colorsFolderPath():
  if len(sys.argv) > 1 and not sys.argv[1].startswith('-'):
    colorsFolder = pathlib.Path(sys.argv[1])
    assert colorsFolder.exists(), f'Path {colorsFolder} does not exist'
    return colorsFolder
  else:
    # Find color source files folder
    iosRootPath = pathlib.Path(__file__).absolute().parent.parent.parent
    return next(iosRootPath.rglob(f'{source_filename_plural}.swift')).parent

if __name__ == "__main__":

  colors = get_updated_colors()

  colorsFolder = colorsFolderPath()
  codePath = colorsFolder.joinpath(f'{source_filename_plural}.swift')
  codePathUIColor = colorsFolder.joinpath(f'UI{source_filename_plural}.swift')
  assetPath = colorsFolder.joinpath(f'{source_filename_plural}.xcassets')

  if not isRunningInCheckOnlyMode():
    # Recreate the xcassets folder
    shutil.rmtree(assetPath, ignore_errors = True)
    assetPath.mkdir(exist_ok = True)

  sourceColorLines = []
  sourceUIColorLines = []
  lastColorGroup = ''

  for key, value in sorted(colors.items()):
      
      # Parse key and value into tokens and hex colors
      key_tokens = camel_case_split(key)
      group = key_tokens[0]
      name = lowercase_first_letter("".join(key_tokens[0:]))

      if name == "white":
        # default system white color will be used due to name clash
        continue

      description = " ".join(key_tokens[0:])
      rgb_hex_colors = list(map(lambda c: str_to_hexa(c), re.findall(r'\d+', value)))
      
      assert len(rgb_hex_colors) == 3, "Expected 3 decimal RGB values from JSON"

      if group != lastColorGroup:
        sourceColorLines.append(source_group_template.format(group = group))
        sourceUIColorLines.append(source_group_template.format(group = group))
        lastColorGroup = group

      sourceColorLines.append(source_line_template.format(name = name, description = description))
      sourceUIColorLines.append(source_line_template_uicolor.format(name = name, description = description))

      if isRunningInCheckOnlyMode():
        continue

      groupPath = assetPath.joinpath(group)
      colorSetPath = groupPath.joinpath(f'{description}.colorset')

      groupPath.mkdir(exist_ok = True)
      colorSetPath.mkdir(exist_ok = True)

      # Create generic xcassets header
      with open(groupPath.joinpath(contents_filename), "w") as contentsFile:
          contentsFile.write(xcassets_header)

      # Create color definition file
      with open(colorSetPath.joinpath(contents_filename), "w") as colorSetFile:
          colorSetFile.write(xcassets_color_template.format(R = rgb_hex_colors[0], G = rgb_hex_colors[1], B = rgb_hex_colors[2]))

  updatedSourceContent = source_template.format(colorList = '\n'.join(sourceColorLines))
  updatedSourceContentUIColor = source_template_uicolor.format(colorList = '\n'.join(sourceUIColorLines))

  if isRunningInCheckOnlyMode():
    isUpdateAvailable = updatedSourceContent != open(codePath).read() or updatedSourceContentUIColor != open(codePathUIColor).read()
    exitCode = 0

    if isUpdateAvailable:
      exitCode = update_colors_jira_task.create()

    sys.exit(exitCode)

  # Recreate the color extensions source file
  with open(codePath, "w") as sourceFile:
      sourceFile.write(updatedSourceContent)

  with open(codePathUIColor, "w") as sourceFile:
      sourceFile.write(updatedSourceContentUIColor)