require 'test_helper'

module Git
  class SwitcherTest < Minitest::Test
    def test_that_it_has_a_name
      refute_nil ::Git::Switcher::NAME
    end

    def test_that_it_has_a_version_number
      refute_nil ::Git::Switcher::VERSION
    end

    def test_it_does_something_useful
      assert true # you better believe it!
    end
  end
end
