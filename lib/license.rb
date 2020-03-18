# frozen_string_literal: true

module Spdx
  class License
    attr_reader :id, :name, :osi_approved
    alias osi_approved? osi_approved

    def initialize(id, name, osi_approved)
      @id = id
      @name = name
      @osi_approved = osi_approved
    end
  end
end
