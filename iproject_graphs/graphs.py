#!/bin/python
import pandas
import numpy as np
from matplotlib import rcParams
import matplotlib.pyplot as plt
import glob
files = glob.glob("*.csv")

politics = {
    'soloviev': 'В. Соловьёв',
    'navalny': 'А. Навальный',
    'svetov': 'М. Светов',
    'zhirinovsky': 'В. Жириновский'
}

for file in files:
    data = pandas.read_csv(file)
    sum = data['count'].sum()
    tenperc = data[:int(data.size/100*10)]['count'].sum()
    percentage = tenperc / (sum / 100)
    print(file+': доля первых 10% слов: '+str(percentage))
    print(int(data.size/100*10))
    #
    # plt.style.use('dark_background')
    rcParams['font.family'] = 'sans-serif'
    rcParams['font.sans-serif'] = ['Liberation Serif', 'Tahoma', 'DejaVu Sans',
                               'Lucida Grande', 'Verdana']
    plt.plot(range(data['words'].size), data['count'])
    
    plt.suptitle(politics[str(file.split('.')[0])]+': общая частотность употребления')
    plt.title('Доля 10% самых употребимых слов: '+ str(int(round(percentage)))+'%')
    plt.ylabel('частота')
    plt.xlabel('слова (сорт. по встречаемости)')
    plt.show()
