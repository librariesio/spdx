require "spdx/version"
require "spdx-licenses"
require "text"

module Spdx
  def self.find(name)
    SpdxLicenses[name] || closest(name)
  end

  def self.closest(name)
    name.gsub!(/software|license/i, '')
    best_match = matches(name).first
    return nil unless best_match
    id = best_match[0]
    SpdxLicenses[id] || find_by_name(id)
  end

  def self.matches(name, max_distance = 40)
    names.map { |key| [key, Text::Levenshtein.distance(name, key)] }
      .select { |arr| arr[1] <= max_distance }
      .sort_by { |arr| arr[1] }
  end

  def self.find_by_name(name)
    match = SpdxLicenses.data.find{|k,v| v['name'] == name }
    SpdxLicenses[match[0]] if match
  end

  def self.names
    SpdxLicenses.data.keys + SpdxLicenses.data.map{|k,v| v['name'] }
  end
end
