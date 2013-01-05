require 'rugged'

class Git::Switcher::Repo < Rugged::Repository

  def repo
    # a bug/feature in Rugged prevents us from using instances of a subclass of Rugged::Repository
    # in certain methods/places; instead it insists on an instance of Rugged::Repository itself...
    # (meaning we can't use `self` on those occasions!) where is Barbara Liskov when you need her?
    @repo ||= Rugged::Repository.new(self.path)
  end

  def current_branch
    Rugged::Reference.lookup(self, 'HEAD').target.scan(/\Arefs\/heads\/(.*)\Z/).flatten.first
  end

  def current_head? ref
    target('HEAD') == target(ref)
  end

  def reachable? ref
    self.class.reachable? target('HEAD'), target(ref)
  end

  def abbreviated_name ref
    ref.gsub(/\Arefs\/(remotes|heads|tags)\//, '')
  end

  # remote branches

  def remote_branches
    self.refs.find_all { |ref| ref =~ /\Arefs\/remotes\// && ref !~ /\/HEAD\Z/ }
  end

  def remote_branch_name ref
    ref.gsub(/\Arefs\/remotes\//, '')
  end

  def remote_branch_names
    remote_branches.map { |ref| remote_branch_name(ref) }
  end

  # local branches

  def local_branches
    self.refs.find_all { |ref| ref =~ /\Arefs\/heads\// }
  end

  def local_branch_name ref
    ref.gsub(/\Arefs\/heads\//, '')
  end

  def local_branch_names
    local_branches.map { |ref| local_branch_name(ref) }
  end

  # tags

  def tags
    self.refs.find_all { |ref| ref =~ /\Arefs\/tags\// }
  end

  def reachable_tags # time-ordered, as well
    tags.find_all { |tag| reachable? tag }.sort { |first_tag, second_tag|
      # use 'author' timestamp, not 'committer' timestamp, e.g. in case
      # the tag's target commit was the result of a rebase operation!!!
      target(first_tag).author[:time] <=> target(second_tag).author[:time]
    }
  end

  def tag_name ref
    ref.gsub(/\Arefs\/tags\//, '')
  end

  def tag_names
    tags.map { |ref| tag_name(ref) }
  end

  private

  def target ref
    # TODO read up on git tagging, ie. tag another tag, ad infinitum (?)
    target = self.repo.lookup(Rugged::Reference.lookup(self, ref).resolve.target)
    target = target.target if target.is_a? Rugged::Tag
    target
  end

  def self.reachable? current_commit, past_commit
    (current_commit == past_commit) || begin
      current_commit.parents.any? { |parent| self.reachable? parent, past_commit }
    end
  end

end