require 'spec_helper'

describe Git::Switcher do
  it "is a module" do
    Git::Switcher.should be_instance_of(Module)
  end
end
