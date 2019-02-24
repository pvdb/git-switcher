# this loads all of 'git-multi'
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/switcher'

def repository
  pry Rugged::Repository.new(Dir.pwd)
end
