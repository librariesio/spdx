# frozen_string_literal: true

module SpdxGrammar
  class LogicalBinary < Treetop::Runtime::SyntaxNode
    # Used internally

    def licenses
      (left.licenses + right.licenses).uniq
    end

    def left
      elements[0]
    end

    def right
      elements[1]
    end
  end

  class LogicalAnd < LogicalBinary
  end

  class LogicalOr < LogicalBinary
  end

  class With < Treetop::Runtime::SyntaxNode
    def licenses
      license.licenses
    end

    def license
      elements[0]
    end

    def exception
      elements[1]
    end
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
      [text_value]
    end
  end

  class LicensePlus < Treetop::Runtime::SyntaxNode
    def licenses
      child.licenses
    end

    def child
      elements[0]
    end
  end

  class LicenseRef < Treetop::Runtime::SyntaxNode
    def licenses
      [text_value]
    end
  end

  class DocumentRef < Treetop::Runtime::SyntaxNode
    def licenses
      [text_value]
    end
  end

  class LicenseException < Treetop::Runtime::SyntaxNode
    # TODO: actually do license exceptions
  end

  class GroupedExpression < Treetop::Runtime::SyntaxNode
    # Used internally
  end

  class Operand < Treetop::Runtime::SyntaxNode
    # Used internally
  end

  class SpdxParseError < StandardError
  end
end
