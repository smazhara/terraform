require 'awesome_print'
require 'pry-byebug'
require 'rspec/its'
require 'rspec/collection_matchers'
require 'hashdiff'

require_relative '../lib/ge'

def fixture(name)
  File.read("#{__dir__}/plans/#{name}")
end
