# frozen_string_literal: true

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

  class None < Treetop::Runtime::SyntaxNode
    def licenses
      []
    end
  end

  class NoAssertion < Treetop::Runtime::SyntaxNode
    def licenses
      []
    end
  end

  class License < Treetop::Runtime::SyntaxNode
    def licenses
      text_value
    end
  end

  class UserDefinedLicense < Treetop::Runtime::SyntaxNode
  end

  class LicenseRef < Treetop::Runtime::SyntaxNode
    def licenses
      text_value
    end
  end

  class DocumentRef < Treetop::Runtime::SyntaxNode
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
