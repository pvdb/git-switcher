module Rugged
  class Reference
    def local?
      !remote?
    end

    def time
      #
      # we can't just use `target.time` here, because that
      # corresponds to the time attribute for the commit's
      # so-called "committer", not for its "author"...
      #
      # for regular commits these two time attributes will be
      # the same, but after rebasing for instance "committer"
      # will be different from "author", as will their "time"
      # attributes
      #
      # see also: https://git.io/fhNEv
      #
      target.author[:time]
    end

    def targets?(reference)
      target == reference.target
    end
  end
end
