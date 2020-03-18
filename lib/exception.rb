# frozen_string_literal: true

module Spdx
  class Exception
    attr_reader :id, :name, :deprecated
    alias deprecated? deprecated

    def initialize(id, name, deprecated)
      @id = id
      @name = name
      @deprecated = deprecated
    end
  end
end
