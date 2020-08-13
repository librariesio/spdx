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
