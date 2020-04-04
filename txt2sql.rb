require 'sequel'

DB = Sequel.connect('sqlite://collection.db')

files = Dir['*.txt']
people = %w[navalny soloviev svetov zhirinovsky]
people.each do |x|
  DB.create_table x.to_sym do
    primary_key :id
    String :all_words
    Integer :all_words_count
    String :adj
    Integer :adj_count
    String :nouns
    Integer :nouns_count
    String :verbs
    Integer :verbs_count
  end
    #lists = files.keep_if { |file| file.basename.start_with? x}
  DB[x.to_sym]

end