require 'treetop'
require 'set'

require File.expand_path(File.join(File.dirname(__FILE__), 'node_extensions.rb'))

class Parser

  Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'spdx_parser.treetop')))
  @@parser = SpdxParser.new

  def self.parse_to_ruby(data)
    parse_tree(data).to_ruby
  end

  def self.parse_licenses(data)
    tree = parse_tree(data)
    tree.get_licenses
  end

  private

  def self.parse_tree(data)
    # Couldn't figure out treetop to make parens optional
    data = "(#{data})" unless data.start_with?("(")

    tree = @@parser.parse(data)

    if(tree.nil?)
      raise Exception, "Parse error at offset: #{@@parser.index}"
    end

    self.clean_tree(tree)
    return tree
  end

  def self.clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each {|node| self.clean_tree(node) }
  end
end