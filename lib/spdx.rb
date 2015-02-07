require "spdx/version"
require "spdx-licenses"
require "fuzzy_match"

module Spdx
  def self.find(name)
    SpdxLicenses[name] || closest(name)
  end

  def self.closest(name)
    name.gsub!(/#{stop_words.join('|')}/i, '')
    name.gsub!(/(\d)/, ' \1 ')
    best_match = fuzzy_match(name)
    return nil unless best_match
    SpdxLicenses[best_match] || find_by_name(best_match)
  end

  def self.matches(name, max_distance = 40)
    names.map { |key| [key, Text::Levenshtein.distance(name, key)] }
      .select { |arr| arr[1] <= max_distance }
      .sort_by { |arr| arr[1] }
  end

  def self.fuzzy_match(name)
    FuzzyMatch.new(names).find(name, must_match_at_least_one_word: true)
  end

  def self.stop_words
    %w(version software license the right)
  end

  def self.find_by_name(name)
    match = SpdxLicenses.data.find{|k,v| v['name'] == name }
    SpdxLicenses[match[0]] if match
  end

  def self.names
    SpdxLicenses.data.keys + SpdxLicenses.data.map{|k,v| v['name'] }
  end
end
