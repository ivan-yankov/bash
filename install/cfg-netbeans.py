import os
import fileinput
import sys

destDir = sys.argv[1]
userDir = sys.argv[2]
cacheDir = sys.argv[3]
jdkPath = sys.argv[4]

cfgFile = destDir + '/etc/netbeans.conf'
for line in fileinput.input(cfgFile, inplace = True):
    if line.find('netbeans_default_userdir') >= 0:
        print 'netbeans_default_userdir="' + userDir + '"'
        continue
    if line.find('netbeans_default_cachedir') >= 0:
        print 'netbeans_default_cachedir="' + cacheDir + '"'
        continue
    if line.find('netbeans_jdkhome') >= 0:
        print 'netbeans_jdkhome="' + jdkPath + '"'
        continue
    print line
