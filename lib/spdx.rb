require "spdx/version"
require "spdx-licenses"
require "fuzzy_match"

module Spdx
  def self.find(name)
    SpdxLicenses[name] || find_by_special_case(name) || closest(name)
  end

  def self.closest(name)
    name = name.gsub(/#{stop_words.join('|')}/i, '')
    name = name.gsub(/(\d)/, ' \1 ')
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
    %w(version software the right)
  end

  def self.find_by_name(name)
    match = SpdxLicenses.data.find{|k,v| v['name'] == name }
    SpdxLicenses[match[0]] if match
  end

  def self.find_by_special_case(name)
    SpdxLicenses[special_cases[name.downcase]]
  end

  def self.special_cases
    {
      'perl_5' => 'Artistic-1.0-Perl',
      'bsd3' => 'BSD-3-Clause',
      'bsd' => 'BSD-3-Clause',
      'new bsd license' => 'BSD-3-Clause',
      'gplv3' => 'GPL-3.0',
      'gpl-2' => 'GPL-2.0',
      'gpl' => 'GPL-2.0+',
      "gnu lesser general public license" => 'LGPL-2.1+',
      'lgplv2 or later' => 'LGPL-2.1+',
      'gplv2 or later' => 'GPL-2.0+',
      'public domain' => 'Unlicense'
    }
  end

  def self.names
    SpdxLicenses.data.keys + SpdxLicenses.data.map{|k,v| v['name'] }
  end
end
