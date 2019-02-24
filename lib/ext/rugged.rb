module Rugged
  class Reference
    def local?
      !remote?
    end

    def time
      target.time
    end

    def targets?(reference)
      target == reference.target
    end
  end
end
