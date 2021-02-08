# frozen_string_literal: true

require "treetop"
require "set"

require_relative "spdx_grammar"

class SpdxParser
  Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), "spdx_parser.treetop")))

  SKIP_PARENS = ["NONE", "NOASSERTION", ""].freeze

  def self.parse(data)
    data ||= ""
    parse_tree(data)
  end

  def self.parse_licenses(data)
    tree = parse_tree(data)
    tree.get_licenses
  end

  private_class_method def self.parse_tree(data)
    parser = SpdxGrammarParser.new # The generated grammar parser is not thread safe

    tree = parser.parse(data)
    raise SpdxGrammar::SpdxParseError, "Unable to parse expression '#{data}'. Parse error at offset: #{parser.index}" if tree.nil?

    prune(tree)
  end

  private_class_method def self.clean(root_node)
    root_node.elements&.delete_if { |node| node.instance_of?(Treetop::Runtime::SyntaxNode) }
  end

  private_class_method def self.prune(root_node)
    clean(root_node)

    root_node.elements&.each_with_index do |node, i|
      case node
      when SpdxGrammar::GroupedExpression, SpdxGrammar::Operand
        clean(node)
        child = node.elements[0]
        child.parent = root_node
        root_node.elements[i] = child

        case child
        when SpdxGrammar::GroupedExpression, SpdxGrammar::Operand
          # re-prune if child's child is a GroupedExpression or Operand
          prune(root_node)
        else
          prune(child)
        end
      else
        prune(node)
      end
    end

    case root_node
    when SpdxGrammar::GroupedExpression
      child = root_node.elements[0]
      child.parent = root_node.parent

      return child
    end

    root_node
  end
end
