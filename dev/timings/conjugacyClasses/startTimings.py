#!/usr/bin/env python3
from parameters import groups, TIMEOUT, MEMORY
import sys
from subprocess import Popen, PIPE, STDOUT, TimeoutExpired
import csv

csv.field_size_limit(sys.maxsize)

# https://stackoverflow.com/questions/287871/how-to-print-colored-text-to-the-terminal
class bcolors:
    FAIL = '\033[91m'
    ENDC = '\033[0m'

# optional argument GAP path
GAP = '/bin/gap.sh'
if sys.argv[1:]:
    GAP = sys.argv[1]
    if len(sys.argv) > 2:
        withoutPackage = sys.argv[2]
    else:
        withoutPackage = False

#########################
# Clear Directories
#########################
with open('out_timingsWithPackage.csv', mode='w') as writer:
    writer.write('#conjugacy classes,time\n')
with open('out_timingsWithoutPackage.csv', mode='w') as writer:
    writer.write('#conjugacy classes,time in s\n')

#########################
# Timing With Package
#########################
for i in range(0, len(groups)):
    ID = str(i + 1)
    print ('Start Timing with Package for Group '+ID)
    # Start new GAP session
    proc = Popen([GAP, '-q', '-o', MEMORY], stdin=PIPE, stdout=PIPE, stderr=STDOUT, encoding='utf8')
    # Declare Global Variables
    proc.stdin.write('ID := "'+ID+'";;')
    proc.stdin.write('groups := '+groups[i]+';;')
    # Compute Conjugacy Classes
    proc.stdin.write('ReadPackage("WPE","dev/conjugacyClasses/genTimingWithPackage.g");;')
    # Wait until GAP session finishes or we exceed maximal duration of this session
    try:
        outs, errs = proc.communicate(timeout=TIMEOUT)
    except TimeoutExpired:
        proc.kill()
        print (bcolors.FAIL + 'TimeoutExpired: killed process, skip this group' + bcolors.ENDC)
        with open('out_timingsWithPackage.csv', mode='a') as writer:
            writer.write('NA,>=%d\n' % TIMEOUT)

#########################
# Timing Without Package
#########################
if withoutPackage:
    timeWithoutPackage = []
    for i in range(0, len(groups)):
        ID = str(i + 1)
        print ('Start Timing without Package for Group '+ID)
        # Start new GAP session
        proc = Popen([GAP, '-q', '-o', MEMORY], stdin=PIPE, stdout=PIPE, stderr=STDOUT, encoding='utf8')
        # Declare Global Variables
        proc.stdin.write('ID := "'+ID+'";;')
        proc.stdin.write('groups := '+groups[i]+';;')
        # Compute Conjugacy Classes
        proc.stdin.write('ReadPackage("WPE","dev/conjugacyClasses/genTimingWithoutPackage.g");;')
        # Wait until GAP session finishes or we exceed maximal duration of this session
        try:
            outs, errs = proc.communicate(timeout=TIMEOUT)
        except TimeoutExpired:
            proc.kill()
            print (bcolors.FAIL + 'TimeoutExpired: killed process, skip this group' + bcolors.ENDC)
            with open('out_timingsWithoutPackage.csv', mode='a') as writer:
                writer.write('NA,>=%d\n' % TIMEOUT)
