import sys

var = sys.argv[1]

profile = '/etc/profile'

f = open(profile, 'r')
lines = f.readlines()
f.close()

f = open(profile, 'w')

configured = False
for line in lines:
    newLine = line
    if line.startswith('DERBY_INSTALL'):
        newLine = 'DERBY_INSTALL=' + var + '\n'
        configured = True
    f.write(newLine)

if not configured:
    f.write('\nDERBY_INSTALL=' + var)
    f.write('\nexport DERBY_INSTALL')

f.close()
