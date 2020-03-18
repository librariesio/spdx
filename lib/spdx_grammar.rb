# frozen_string_literal: true

require "treetop"

module SpdxGrammar
  class CompoundExpression < Treetop::Runtime::SyntaxNode
    def licenses
      elements[0].licenses
    end
  end

  class LogicalOr < Treetop::Runtime::SyntaxNode
  end

  class LogicalAnd < Treetop::Runtime::SyntaxNode
  end

  class With < Treetop::Runtime::SyntaxNode
  end

  class License < Treetop::Runtime::SyntaxNode
    def licenses
      text_value
    end
  end

  class LicenseException < Treetop::Runtime::SyntaxNode
    # TODO: actually do license exceptions
  end

  class Body < Treetop::Runtime::SyntaxNode
    def licenses
      elements.map { |node| node.licenses if node.respond_to?(:licenses) }.flatten.uniq.compact
    end
  end

  class SpdxParseError < StandardError
  end
end
