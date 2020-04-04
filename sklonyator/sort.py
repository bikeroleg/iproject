# Gets a file of words in "words: counter" format and discriminates them into categories (noun, verb etc)
import sys
import pymorphy2


morph = pymorphy2.MorphAnalyzer()

VERBS = []
NOUNS = []
ADJ = []

file = open(sys.argv[1], 'r+')
for line in file.readlines():
    if line == '===': break
    p = morph.parse(line.split(':')[0])[0]
    #for p in n:
    if 'INFN' in p.tag:
        VERBS.append(line)
    elif 'NOUN' in p.tag:
        NOUNS.append(line)
    elif 'NPRO' in p.tag:
        continue
    elif 'ADJF' or 'ADJS' in p.tag:
        ADJ.append(line)
file.close()

def write(array, tag):
    file = open(sys.argv[2]+'_'+tag+'.txt', 'w')
    file.write(tag+'\n')
    file.writelines(array)
    file.close()

write(VERBS, 'verbs')
write(NOUNS, 'nouns')
write(ADJ, 'adj')

# verbs = open(sys.argv[2]+'_verbs', 'w')
# verbs.write("ГЛАГОЛЫ:\n")
# verbs.writelines(VERBS)
# verbs.close()
# nouns = open(sys.argv[2]+'_nouns', 'w')
# nouns.write("СУЩЕСТВИТЕЛЬНЫЕ:\n")
# nouns.writelines(NOUNS)
# file.write("ПРИЛАГАТЕЛЬНЫЕ:\n")
# file.writelines(ADJ)
# file.close()
