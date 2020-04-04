# frozen_string_literal: true

require 'csv'
Dir['*.txt'].each do |file|
  CSV.open("#{file}.csv", 'wb') do |csv|
    File.open file do |x|
      x.readlines.each do |line|
        csv << line.delete(' ').delete('\n').split(':')
      end
    end
  end
end
