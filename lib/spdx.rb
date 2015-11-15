require "spdx/version"
require "spdx-licenses"
require "fuzzy_match"

module Spdx
  def self.find(name)
    name = name.downcase
    lookup(name) || find_by_special_case(name) || closest(name)
  end

  def self.lookup(name)
    return false if name.nil?
    return SpdxLicenses[name] if SpdxLicenses[name]
    lowercase = SpdxLicenses.data.keys.find{|k| k.downcase == name.downcase }
    SpdxLicenses[lowercase] if lowercase
  end

  def self.closest(name)
    name = name.gsub(/#{stop_words.join('|')}/i, '')
    name = name.gsub(/(\d)/, ' \1 ')
    best_match = fuzzy_match(name)
    return nil unless best_match
    lookup(best_match) || find_by_name(best_match)
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
    lookup(match[0]) if match
  end

  def self.find_by_special_case(name)
    lookup(special_cases[name.downcase])
  end

  def self.special_cases
    {
      'perl_5' => 'Artistic-1.0-Perl',
      'bsd3' => 'BSD-3-Clause',
      'bsd' => 'BSD-3-Clause',
      'new bsd license' => 'BSD-3-Clause',
      'gplv3' => 'GPL-3.0',
      'gplv2' => 'GPL-2.0',
      'gpl3' => 'GPL-3.0',
      'gpl2' => 'GPL-2.0',
      'gpl 3' => 'GPL-3.0',
      'gpl_1' => 'GPL-1.0',
      'gpl_2' => 'GPL-2.0',
      'gpl_3' => 'GPL-3.0',
      'gpl 2' => 'GPL-2.0',
      'gpl v3' => 'GPL-3.0',
      'gpl v2' => 'GPL-2.0',
      'gpl 3.0' => 'GPL-3.0',
      'gplv3' => 'GPL-3.0',
      'gpl 2.0' => 'GPL-2.0',
      'gpl-3' => 'GPL-3.0',
      'gpl-2' => 'GPL-2.0',
      'gpl30' => 'GPL-3.0',
      'gpl20' => 'GPL-2.0',
      'gpl v3+' => 'GPL-3.0+',
      'gpl v2+' => 'GPL-2.0+',
      'gplv2+' => 'GPL-2.0+',
      'gpl' => 'GPL-2.0+',
      'gpl (≥ 3)' => 'GPL-3.0+',
      'mpl2.0' => 'mpl-2.0',
      'mpl1' => 'mpl-1.0',
      'mpl1.0' => 'mpl-1.0',
      'mpl1.1' => 'mpl-1.1',
      'mpl2' => 'mpl-2.0',
      'gpl-2 | gpl-3 [expanded from: gpl (≥ 2)]' => 'GPL-2.0+',
      'gpl-2 | gpl-3 [expanded from: gpl (≥ 2.0)]' => 'GPL-2.0+',
      'gpl-2 | gpl-3 [expanded from: gpl]' => 'GPL-2.0+',
      'gpl-2 | gpl-3' => 'GPL-2.0+',
      "gnu lesser general public license" => 'LGPL-2.1+',
      'lgplv2 or later' => 'LGPL-2.1+',
      'gplv2 or later' => 'GPL-2.0+',
      'gpl2 w/ cpe' => 'GPL-2.0-with-classpath-exception',
      'new bsd license (gpl-compatible)' => 'BSD-3-Clause',
      'the gpl v3' => 'GPL-3.0',
      'public domain' => 'Unlicense',
      'cc0' => 'CC0-1.0',
      'lgpl v3' => 'LGPL-3.0',
      'artistic_2' => 'Artistic-2.0',
      'artistic_1' => 'Artistic-1.0',
      'lgpl 2.1' => 'LGPL-2.1',
      'lgplv3' => 'LGPL-3.0',
      'gplv3+' => 'GPL-3.0+',
      'alv2' => 'Apache-2.0',
      'asl 2.0' => 'Apache-2.0',
      'mpl 2.0' => 'MPL-2.0',
      'agplv3' => 'AGPL-3.0',
      'publicdomain' => 'Unlicense',
      'unlicensed' => 'Unlicense',
      'lgpl-3' => 'LGPL-3.0',
      'psfl' => 'Python-2.0',
      'psf' => 'Python-2.0',
      'asl2' => 'Apache-2.0',
      'al2' => 'Apache-2.0',
      'aslv2' => 'Apache-2.0',
      'apache_2_0' => 'Apache-2.0',
      'apache_v2' => 'Apache-2.0',
      'ZPL 1.1' => 'ZPL-1.1',
      'ZPL 2.0' => 'ZPL-2.0',
      'ZPL 2.1' => 'ZPL-2.1',
      'lgplv2' => 'LGPL-2.0',
      'lgplv2+' => 'LGPL-2.0+',
      'lgplv2.1' => 'LGPL-2.1',
      'lgpl_2_1' => 'LGPL-2.1',
      'lgpl_v2_1' => 'LGPL-2.1',
      'lgpl v2.1+' => 'LGPL-2.1+',
      'lgplv3+' => 'LGPL-3.0+',
      'lgpl 3.0' => 'LGPL-3.0',
      'lgpl 3' => 'LGPL-3.0',
      'lgpl3' => 'LGPL-3.0',
      'lgpl version 3' => 'LGPL-3.0',
      'agpl3' => 'AGPL-3.0',
      'agpl-3' => 'AGPL-3.0',
      'agpl3+' => 'AGPL-3.0+',
      'cc by-sa 4.0' => 'CC-BY-SA-4.0',
      'cc by-nc-sa 3.0' => 'CC-BY-NC-SA-3.0',
      'cc by-sa 3.0' => 'CC-BY-SA-3.0',
      'mpl v2.0' => 'MPL-2.0',
      'mplv2.0' => 'MPL-2.0',
      'mplv2' => 'MPL-2.0',
      'cpal v1.0' => 'CPAL-1.0',
      'cddl 1.0' => 'CDDL-1.0',
      'cddl 1.1' => 'CDDL-1.1',
      'epl' => 'EPL-1.0',
      'mit-license' => 'MIT',
      'iscl' => 'ISC',
      'wtf' => 'WTFPL'
    }
  end

  def self.names
    SpdxLicenses.data.keys + SpdxLicenses.data.map{|k,v| v['name'] }
  end
end
