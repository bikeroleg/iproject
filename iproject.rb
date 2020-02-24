# IProject: analysing twitter data
# author: bikeroleg (Oleg Yakunin)

require 'twitter'
require 'matplotlib'
require_relative 'database.rb'

db = Database.new
puts db.count
a = db.pull_all


# 2350006952-BUVoDTSjE0J4ED4VmkF2P62AdC6RMT1x1ENRkOE
# TerTvHTtCLHXraQlJkpFmx5oRhNdnnCgNwB5aQyZDv1cN