
module Spdx
  class CompoundExpression < Treetop::Runtime::SyntaxNode
    def to_ruby
      self.elements[0].to_ruby.join(" ")
    end

    def get_licenses
      self.elements[0].get_licenses
    end
  end

  class LogicalOr < Treetop::Runtime::SyntaxNode
    def to_ruby
      "||"
    end
  end

  class LogicalAnd < Treetop::Runtime::SyntaxNode
    def to_ruby
      "&&"
    end
  end

  class With < Treetop::Runtime::SyntaxNode
    def to_ruby
      self.text_value.to_sym
    end
  end

  class License < Treetop::Runtime::SyntaxNode
    # TODO: Need to validate licenses
    # TODO: Need to include with clauses
    # TODO: Need to include + values somehow
    def to_ruby
      "licenses.include?(\"#{self.text_value}\")"
    end

    def get_licenses
      self.text_value
    end
  end

  class Body < Treetop::Runtime::SyntaxNode
    def to_ruby
      arr = self.elements.map { |x| x.to_ruby }
      arr.unshift("(")
      arr.push(")")
    end

    def get_licenses
      self.elements.map { |node| node.get_licenses if node.respond_to?(:get_licenses)}.flatten.uniq.compact
    end
  end
end