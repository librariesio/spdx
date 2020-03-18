module Spdx
  class License
    attr_reader :id, :name, :osi_approved
    alias_method :osi_approved?, :osi_approved

    def initialize(id, name, osi_approved)
      @id = id
      @name = name
      @osi_approved = osi_approved
    end
  end
end