require 'rubygems'
require 'rake'
require 'rake/clean'

DATA_DIR="data"

CLEAN.include ["#{DATA_DIR}/*.csv","#{DATA_DIR}/*.json"]

task :ratings_to_csv do
  sh %{ruby bin/ratings-to-csv.rb}
end

task :ratings_to_json do
  sh %{ruby bin/ratings-to-json.rb}
end

task :download => [:ratings_to_csv, :ratings_to_json]