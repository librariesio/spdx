require "spdx/version"
require "spdx-licenses"
require "text"

module Spdx
  def self.find(name)
    SpdxLicenses[name] || closest(name)
  end

  def self.closest(name)
    name.gsub!(/software|license/i, '')
    match = names.sort_by do |key|
      Text::Levenshtein.distance(name, key)
    end.first
    SpdxLicenses[match] || find_by_name(match)
  end

  def self.find_by_name(name)
    match = SpdxLicenses.data.find{|k,v| v['name'] == name }
    SpdxLicenses[match[0]] if match
  end

  def self.names
    SpdxLicenses.data.keys + SpdxLicenses.data.map{|k,v| v['name'] }
  end
end
