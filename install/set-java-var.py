import sys

jdkDir = sys.argv[1]

profile = '/etc/profile'

f = open(profile, 'r')
lines = f.readlines()
f.close()

f = open(profile, 'w')

javaConfigured = False
for line in lines:
    newLine = line
    if line.startswith('JAVA_HOME'):
        newLine = 'JAVA_HOME=' + jdkDir + '\n'
        javaConfigured = True
    f.write(newLine)

if not javaConfigured:
    f.write('\nJAVA_HOME=' + jdkDir)
    f.write('\nJRE_HOME=$JAVA_HOME/jre')
    f.write('\nPATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin')
    f.write('\nexport JAVA_HOME')
    f.write('\nexport JRE_HOME')
    f.write('\nexport PATH')

f.close()
