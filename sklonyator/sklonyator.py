import sys
import pymorphy2
import sqlite3
import io
import string
import re

stopwords = []
output = []
morph = pymorphy2.MorphAnalyzer()
db = sqlite3.connect('../tweets.db')
cursor = db.cursor()
f = open('stop.txt', mode='r')


def db_fill(array):
    out = open('output.txt', mode='w')
    out.writelines(array)
    out.close()


def remove_punctuation(st):
    #return str(st).strip(string.punctuation).replace('–', '').replace("…", '').replace(';', '').strip('⠀').strip('•').strip('\n').strip('«').strip('»').strip('\n•').strip('\n')
    return re.sub(r'[^\w\s]', '', str(st))


for x in f.readlines():
    stopwords.append(x.rstrip())

if __name__ == "__main__":
    for row in cursor.execute('SELECT * from tweets'):
        for i in row[3].strip('\n').split(' '):
            x = i.strip().strip('\n')
            author = row[2]
            if not x.startswith('@') and not x.startswith('http') and not x.startswith('#') and stopwords.count(x) == 0 and x != '':
                x = remove_punctuation(x).replace('\n', '')
                if x!= '' and x!= '_':
                    output.append(author+':'+morph.parse(x)[0].normal_form+'\n')

f.close()
db_fill(output)
