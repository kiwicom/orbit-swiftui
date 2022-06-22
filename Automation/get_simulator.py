#!/usr/bin/env python3

import os
import sys
import subprocess
import json

def find_existing_simulator(json, name, runtime_id):
    devices = json["devices"][runtime_id]
    return next((simulator["udid"] for simulator in devices if simulator["name"] == name and simulator["isAvailable"]), None)

def ios_runtime_id(ios_version):
    # expects iOS version number, e.g. "15.2"
    return "com.apple.CoreSimulator.SimRuntime.iOS-" + "-".join(ios_version.split("."))

# Returns an ID of a booted simulator matching the specified criteria - either by finding an available one or creating a new one
def main():
    
    simulator_name = sys.argv[1]
    ios_version = sys.argv[2]
    
    simulators = subprocess.run(["xcrun", "simctl", "list", "-j", "devices", "available"], stdout=subprocess.PIPE, text=True).stdout
    simulators_string = str(simulators).strip()
    simulators_json = json.loads(simulators_string)
    
    runtime_id = ios_runtime_id(ios_version)
    simulator_id = find_existing_simulator(simulators_json, simulator_name, runtime_id)
    
    if not simulator_id:        
        simulator_id = subprocess.run(["xcrun", "simctl", "create", simulator_name, simulator_name, f"iOS{ios_version}"], stdout=subprocess.PIPE, text=True).stdout
    
    # boot if needed
    subprocess.run(["xcrun", "simctl", "bootstatus", simulator_id, "-b"], stdout=subprocess.PIPE, text=True)
    
    return simulator_id

if __name__ == '__main__':
    print(main())
