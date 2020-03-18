module Spdx
  class Exception
    attr_reader :id, :name, :deprecated
    alias_method :deprecated?, :deprecated

    def initialize(id, name, deprecated)
      @id = id
      @name = name
      @deprecated = deprecated
    end
  end
end