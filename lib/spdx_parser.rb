# frozen_string_literal: true

require "treetop"
require "set"

require_relative "spdx_grammar"

class SpdxParser
  Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), "spdx_parser.treetop")))

  SKIP_PARENS = ["NONE", "NOASSERTION", ""]
  @parser = SpdxGrammarParser.new

  def self.parse(data)
    parse_tree(data)
  end

  def self.parse_licenses(data)
    tree = parse_tree(data)
    tree.get_licenses
  end

  private_class_method def self.parse_tree(data)
    # Couldn't figure out treetop to make parens optional
    data = "(#{data})" unless data.start_with?("(") || SKIP_PARENS.include?(data)
    tree = @parser.parse(data)

    raise SpdxGrammar::SpdxParseError, "Parse error at offset: #{@parser.index}" if tree.nil?

    clean_tree(tree)
    tree
  end

  private_class_method def self.clean_tree(root_node)
    return if root_node.elements.nil?

    root_node.elements.delete_if { |node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each { |node| clean_tree(node) }
  end
end
