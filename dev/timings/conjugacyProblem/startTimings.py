#!/usr/bin/env python3
from parameters import nrRandomElements, groups, TIMEOUT, MEMORY
import sys
import os
import shutil
from subprocess import Popen, PIPE, STDOUT, TimeoutExpired
from tqdm import tqdm
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
path = 'out_timingsWithPackage'
if os.path.exists(path):
    shutil.rmtree(path)
os.mkdir(path)
path = 'out_timingsWithoutPackage'
if os.path.exists(path):
    shutil.rmtree(path)
os.mkdir(path)

#########################
# Timing With Package
#########################
averageWithPackage = []
for i in range(0, len(groups)):
    ID = str(i + 1)
    print ('Start Timing with Package for Group '+ID)
    # Write header for timings
    with open('out_timingsWithPackage/'+ID+'.csv', mode='w') as writer:
        writer.write('time\n')
    # Read random elements
    detectedTimout = False
    with open('out_randomElements/'+ID+'.csv', mode='r') as csvfile:
        reader = csv.DictReader(csvfile)
        # Start new GAP session for each conjugacy problem
        for randomElements in tqdm(reader, total=nrRandomElements):
            proc = Popen([GAP, '-q', '-o', MEMORY], stdin=PIPE, stdout=PIPE, stderr=STDOUT,encoding='utf8')
            # Declare Global Variables
            proc.stdin.write('ID := "'+ID+'";;\n')
            proc.stdin.write('groups := '+groups[i]+';;\n')
            proc.stdin.write('g := ')
            proc.stdin.write(randomElements['g'])
            proc.stdin.write(';;\n')
            proc.stdin.write('h := ')
            proc.stdin.write(randomElements['h'])
            proc.stdin.write(';;\n')
            # Solve Conjugacy Problem
            proc.stdin.write('ReadPackage("WPE","dev/conjugacyProblem/genTimingWithPackage.g");;\n')
            # Wait until GAP session finishes or we exceed maximal duration of this session
            try:
                proc.communicate(timeout=TIMEOUT)
            except TimeoutExpired:
                proc.kill()
                detectedTimout = True
                break
    # Compute average time
    if detectedTimout:
        averageWithPackage.append('>= %d s' % TIMEOUT)
        print (bcolors.FAIL + 'TimeoutExpired: killed process, skip this group' + bcolors.ENDC)
        print ('average time >= %d s' % TIMEOUT)
    else:
        with open('out_timingsWithPackage/'+ID+'.csv', newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            time = sum([int(row['time']) for row in reader]) / nrRandomElements
            averageWithPackage.append(time)
            print ('average time = %.3f s' % (time / 1000))

#########################
# Timing Without Package
#########################
if withoutPackage:
    averageWithoutPackage = []
    for i in range(0, len(groups)):
        ID = str(i + 1)
        print ('Start Timing without Package for Group '+ID)
        # Write header for timings
        with open('out_timingsWithoutPackage/'+ID+'.csv', mode='w') as writer:
            writer.write('time\n')
        # Read in the random elements
        detectedTimout = False
        with open('out_randomElements/'+ID+'.csv', mode='r') as csvfile:
            reader = csv.DictReader(csvfile)
            # Start new GAP session for each conjugacy problem
            for randomElements in tqdm(reader, total=nrRandomElements):
                proc = Popen([GAP, '-q', '-o', MEMORY], stdin=PIPE, stdout=PIPE, stderr=STDOUT, encoding='utf8')
                # Declare Global Variables
                proc.stdin.write('ID := "'+ID+'";;')
                proc.stdin.write('groups := '+groups[i]+';;')
                proc.stdin.write('g := ')
                proc.stdin.write(randomElements['g'])
                proc.stdin.write(';;')
                proc.stdin.write('h := ')
                proc.stdin.write(randomElements['h'])
                proc.stdin.write(';;')
                # Generatate Random Elements
                proc.stdin.write('ReadPackage("WPE","dev/conjugacyProblem/genTimingWithoutPackage.g");;')
                # Wait until GAP session finishes or we exceed maximal duration of this session
                try:
                    proc.communicate(timeout=TIMEOUT)
                except TimeoutExpired:
                    proc.kill()
                    detectedTimout = True
                    break
        # Compute average time
        if detectedTimout:
            averageWithoutPackage.append('>= %d s' % TIMEOUT)
            print (bcolors.FAIL + 'TimeoutExpired: killed process, skip this group' + bcolors.ENDC)
            print ('average time >= %d s' % TIMEOUT)
        else:
            with open('out_timingsWithoutPackage/'+ID+'.csv', newline='') as csvfile:
                reader = csv.DictReader(csvfile)
                time = sum([int(row['time']) for row in reader]) / nrRandomElements
                averageWithoutPackage.append(time)
                print ('average time = %.3f s' % (time / 1000))

#########################
# Print Final Timings
#########################
if withoutPackage:
    with open('out_timings.csv', mode='w') as csv_file:
        fieldnames = ['GAP4', 'WPE']
        writer = csv.writer(csv_file)
        writer.writerow(fieldnames)
        for i in range(0, len(groups)):
            writer.writerow([averageWithoutPackage[i], averageWithPackage[i]])
else:
    with open('out_timings.csv', mode='w') as csv_file:
        fieldnames = ['WPE']
        writer = csv.writer(csv_file)
        writer.writerow(fieldnames)
        for i in range(0, len(groups)):
            writer.writerow([averageWithPackage[i]])
