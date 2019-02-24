require 'English'

require 'rainbow'
require 'rugged'

require 'ext/rugged'

module Git
  module Switcher
    class Error < StandardError; end
  end
end

require 'git/switcher/version'
require 'git/switcher/menu'
