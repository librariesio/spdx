# frozen_string_literal: true

require "spdx/version"
require "fuzzy_match"
require "spdx_parser"
require "json"
require_relative "exception"
require_relative "license"

# Fuzzy matcher for licenses to SPDX standard licenses
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
    licenses.key?(id.to_s) || licenses.keys.one? { |key| key.downcase == id.downcase }
  end

  def self.exception_exists?(id)
    exceptions.key?(id.to_s) || exceptions.keys.one? { |key| key.downcase == id.downcase }
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

  def self.valid_spdx?(spdx_string)
    return false unless spdx_string.is_a?(String)

    SpdxParser.parse(spdx_string)
    true
  rescue SpdxGrammar::SpdxParseError
    false
  end

  def self.parse_spdx(spdx_string)
    SpdxParser.parse(spdx_string)
  end
end
