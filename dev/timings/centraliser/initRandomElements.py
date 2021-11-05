#!/usr/bin/env python3
from parameters import nrRandomElements, groups, TIMEOUT, MEMORY
import sys
import os
import shutil
from subprocess import Popen, PIPE, STDOUT, TimeoutExpired

# https://stackoverflow.com/questions/287871/how-to-print-colored-text-to-the-terminal
class bcolors:
    FAIL = '\033[91m'
    ENDC = '\033[0m'

# optional argument GAP path
GAP = '/bin/gap.sh'
if sys.argv[1:]:
    GAP = sys.argv[1]

#########################
# Clear Directories
#########################
path = 'out_randomElements'
if os.path.exists(path):
    shutil.rmtree(path)
os.mkdir(path)

#########################
# Generate Random Elements
#########################
for i in range(0, len(groups)):
    ID = str(i + 1)
    print ('Generating Random Elements for Group '+ID)
    # Start new GAP session
    proc = Popen([GAP, '-q'], stdin=PIPE, stdout=PIPE, stderr=STDOUT, encoding='utf8')
    # Declare Global Variables
    proc.stdin.write('ID := "'+ID+'";')
    proc.stdin.write('nrRandomElements := '+str(nrRandomElements)+';')
    proc.stdin.write('groups := '+groups[i]+';')
    # Generatate Random Elements
    proc.stdin.write('ReadPackage("WPE","dev/centraliser/genRandomElements.g");')
    # Wait until GAP session finishes or we exceed maximal duration of this session
    try:
        outs, errs = proc.communicate(timeout=TIMEOUT)
    except TimeoutExpired:
        proc.kill()
        print (bcolors.FAIL + 'TimeoutExpired: killed process' + bcolors.ENDC)