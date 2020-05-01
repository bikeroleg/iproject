# IProject: analysing twitter data
# author: bikeroleg (Oleg Yakunin)

require 'twitter'
require 'matplotlib'
require_relative 'database.rb'

#db = Database.new
#puts db.count
#a = db.pull_all

def count_words(array_of_words)
  array_of_words.each_with_object(Hash.new(0)) do |word, counter|
    counter[word] += 1
  end
end

msvetov= []
navalny= []
soloviev = []
zhirik = []
subjects = []
stop = File.open('sklonyator/stop.txt').readlines.each { |x| x.chomp!}

file = File.open('sklonyator/output.txt', 'r')

file.each_line do |x|
  x = x.delete('—').chomp
  x = x.split(':')
  next if x[1] =~ /[a-zA-Z]|\d/

  case x[0]
  when 'msvetov'
    msvetov.append x[1]
  when 'navalny'
    navalny.append x[1]
  when 'VRSoloviev'
    soloviev.append x[1]
  when 'Zhirinovskiy'
    zhirik.append x[1]
  end
end
file.close
subjects.append(msvetov, navalny, soloviev, zhirik)
subjects.each { |s| s.delete_if { |x| stop.any? x}}

subjects.each do |subject|
  counter = count_words(subject)
  counter = counter.sort_by { |_key, value| value }.to_h
  names = %w(svetov navalny soloviev zhirinovsky)
  File.open("#{names[subjects.index subject]}.txt", 'w') do |file|
    counter.reverse_each do |key, value|
      file.write("#{key}: #{value}\n")
    end
    # file.write('===\n')
    file.close
    system("venv/bin/python3.6 sklonyator/sort.py #{file.path} #{names[subjects.index subject]}")
    system('ruby text2csv.rb')
  end
end

