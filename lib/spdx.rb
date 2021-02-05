# frozen_string_literal: true

require "spdx/version"
require "spdx_parser"
require "json"
require_relative "exception"
require_relative "license"

module Spdx
  def self.names
    (licenses.keys + licenses.map { |_k, v| v["name"] }).sort
  end

  def self.exceptions
    unless defined?(@exceptions)
      data = JSON.parse(File.read(File.expand_path("../exceptions.json", __dir__)))
      @exceptions = {}

      data["exceptions"].each do |details|
        id = details.delete("licenseExceptionId")
        @exceptions[id] = details
      end
    end
    @exceptions
  end

  def self.license_exists?(id)
    licenses.key?(id.to_s) || licenses_downcase.key?(id.to_s.downcase)
  end

  def self.exception_exists?(id)
    exceptions.key?(id.to_s) || exceptions_downcase.key?(id.to_s.downcase)
  end

  def self.licenses
    unless defined?(@licenses)
      data = JSON.parse(File.read(File.expand_path("../licenses.json", __dir__)))
      @licenses = {}

      data["licenses"].each do |details|
        id = details.delete("licenseId")
        @licenses[id] = details
      end
    end
    @licenses
  end

  def self.licenses_downcase
    unless defined?(@licenses_downcase)
      @licenses_downcase = {}
      licenses.keys.each { |key| @licenses_downcase[key.downcase] = key }
    end
    @licenses_downcase
  end

  def self.exceptions_downcase
    unless defined?(@exceptions_downcase)
      @exceptions_downcase = {}
      exceptions.keys.each { |key| @exceptions_downcase[key.downcase] = key }
    end
    @exceptions_downcase
  end

  def self.normalize(spdx_string, top_level_parens: false)
    normalize_tree(SpdxParser.parse(spdx_string), parens: top_level_parens)
  end

  private_class_method def self.normalize_tree(node, parens: true)
    case node
    when SpdxGrammar::LogicalAnd
      left = normalize_tree(node.left)
      right = normalize_tree(node.right)
      if parens
        "(#{left} AND #{right})"
      else
        "#{left} AND #{right}"
      end
    when SpdxGrammar::LogicalOr
      left = normalize_tree(node.left)
      right = normalize_tree(node.right)
      if parens
        "(#{left} OR #{right})"
      else
        "#{left} OR #{right}"
      end
    when SpdxGrammar::With
      license = normalize_tree(node.license)
      exception = normalize_tree(node.exception)
      if parens
        "(#{license} WITH #{exception})"
      else
        "#{license} WITH #{exception}"
      end
    when SpdxGrammar::None
      "NONE"
    when SpdxGrammar::NoAssertion
      "NOASSERTION"
    when SpdxGrammar::License
      licenses_downcase[node.text_value.downcase]
    when SpdxGrammar::LicensePlus
      "#{normalize_tree(node.child)}+"
    when SpdxGrammar::LicenseRef
      node.text_value
    when SpdxGrammar::DocumentRef
      node.text_value
    when SpdxGrammar::LicenseException
      exceptions_downcase[node.text_value.downcase]
    end
  end

  def self.valid?(spdx_string)
    return false unless spdx_string.is_a?(String)

    SpdxParser.parse(spdx_string)
    true
  rescue SpdxGrammar::SpdxParseError
    false
  end

  def self.parse(spdx_string)
    SpdxParser.parse(spdx_string)
  end
end
