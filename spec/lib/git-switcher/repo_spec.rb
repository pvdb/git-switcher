require 'spec_helper'

describe Git::Switcher::Repo do

  it "subclasses Rugged::Repository" do
    described_class.superclass.should be Rugged::Repository
  end

end
