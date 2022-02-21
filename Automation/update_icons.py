#!/usr/bin/env python3
# encoding: utf-8

"""
This script:
    1) Downloads the current icon font file
    2) Replaces the current icon font file
    3) Regenerates a swift file to access the font using the information from orbit-icons.svg
"""

import sys
import os
import pathlib
import shutil
import xml.etree.ElementTree as elementTree
import urllib.request

source_template = '''/// Generated and updated by 'Automation/orbit/update_icons.py'
// swiftlint:disable:previous orphaned_doc_comment

public extension Icon {{

    enum Symbol: Comparable, CaseIterable {{
{cases}

        public var value: String {{
            switch self {{
{values}
            }}
        }}
    }}
}}
'''

def kebab_case_to_camel_case(string):
    head, *tail = string.split("-")    
    return "".join([head.lower()] + [x.title() for x in tail])
    
def dictionary_from_xml(path):
    
    tree = elementTree.parse(path)
    root = tree.getroot()
    
    pairs = [(x.attrib["glyph-name"], x.attrib["unicode"]) for x in root.findall(".//{*}glyph")]
    
    return { k: v for (k, v) in pairs }

if __name__ == "__main__":
    
    icons_folder = pathlib.Path(sys.argv[1])
    icons_swift_path = icons_folder.joinpath("Icons.swift")
    icon_font_path = icons_folder.joinpath("Icons.ttf")
    
    zip_name = "font.zip"
    unzipped_folder_name = "orbit-icons-font"
    urllib.request.urlretrieve("https://images.kiwi.com/orbit-icons/orbit-icons-font.zip", zip_name)  
    shutil.unpack_archive(zip_name, ".")    
    
    shutil.copyfile(f"{unzipped_folder_name}/orbit-icons.ttf", icon_font_path)    
    icon_values = dictionary_from_xml(f"{unzipped_folder_name}/orbit-icons.svg")
    
    os.remove(zip_name)
    shutil.rmtree(unzipped_folder_name)

    case_lines = []
    value_lines = []
        
    for icon_name, value in sorted(icon_values.items(), key = lambda x: x[0].lower()):
        
        swift_icon_name = kebab_case_to_camel_case(icon_name)
        
        encoded_value = value.encode("unicode_escape")
        
        if "\\u" in str(encoded_value):
            inner_value = str(encoded_value).split("'")[1].split("u")[-1]            
        else:
            inner_value = hex(ord(value))[2:].zfill(4)
        
        swift_value = f"\\u{{{inner_value}}}"
        
        case_lines.append(f"        case {swift_icon_name}")
        value_lines.append(f"                case .{swift_icon_name}: return \"{swift_value}\"")
        
    case_lines.append(f"        case none")
    value_lines.append(f"                case .none: return \"\"")
            
    updated_file_content = source_template.format(cases = '\n'.join(case_lines), values = '\n'.join(value_lines))
    
    with open(icons_swift_path, "w+") as source_file:
        source_file.write(updated_file_content)
        