


#DEPRECATED
=begin slova = %w(мы давно предлагали решение слушали)
file = File.open('rules.txt')
hashrule = []

class String
  def suffix?(suffix)
    self[-suffix.length, suffix.length] == suffix
  end
end

def expected_letters(rule_infinitive)
  letters = []
  # x = if rule_infinitive[1] == '^' then '[^' # is in negative?
  #   #else '[' # not negative
  #end

  rule_infinitive.delete('[').each_char do |s|
    break if s == ']' # stop

    letters.append s # collect expected letters
  end
  # puts letters.join
  rule_infinitive.delete_prefix!('['+letters.join+']')
  # puts rule_infinitive if rand(10) > 5
  [letters, rule_infinitive]
end

file.readlines.each do |line| # collect rules
  next if line.start_with?('#', 'flag') # ignore comments

  # remove the comment
  line = line.downcase.split('#')[0]
  rule = line.split('>') # rule[0] is an infinitive, rule[1] is a form

  hashrule.append rule # hash format: {'ить' => '-ить,и'}
end
file.close

slova.each do |slovo|
  puts slovo
  words = []
  answer = []
  hashrule.each do |rule|\
    next if rule[1].nil? # if rule exists

    # check whether it must or must not start with some letter
    letters = []
    if rule[0].start_with?('[') # is rule included?
      letters = expected_letters(rule[0])
      rule[0] = letters[1]
      letters = letters[0]
      # p rule[1] if letters == %w(е ж н р ш щ ч) && rule[1] == '-й,х'
    end
    rule[0].delete!(' ') # 'и т ь' => 'ить'
    # p rule[0]

    if rule[1].start_with? '-' # if it has something to delete
      ss = rule[1].split(',') # ss[0] is a removable part, ss[1] is a form's end

      if slovo.suffix? ss[1] # if the end matches
        # puts (slovo.delete_suffix(ss[1])+ss[0].delete('-')).delete_suffix(rule[0])[-1] if letters == %w(е ж н р ш щ ч) && rule[1] == '-й,х'
        if letters[0] != '^' && letters.any?((slovo.delete_suffix(ss[1])+ss[0].delete('-')).delete_suffix(rule[0])[-1]) # if it has and should have
          words.append(slovo.delete_suffix(ss[1]) + ss[0].delete('-'))
        elsif letters[0] == '^' && letters.any?((slovo.delete_suffix(ss[1])+ss[0].delete('-')).delete_suffix(rule[0])[-1]) == false # if it haven't but shouldn't have
          words.append(slovo.delete_suffix(ss[1]) + ss[0].delete('-'))
        else
          next # go to the next rule since this is not appropriate
        end
      end
    elsif slovo.end_with?(rule[1]) # if it doesn't have anything to delete
      words.append(slovo + rule[0]) # then just add it to the end
    end
  end
  dict = File.readlines 'dict.txt'
  words.each do |x|
    dict.each { |y| answer.append x if x == y.chomp }
  end
  if answer.length.zero?
    puts words[0]
  else
    puts answer[0]
  end
end
=end