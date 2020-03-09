require 'spdx/version'
require 'spdx-licenses'
require 'fuzzy_match'
require 'parser'

# Fuzzy matcher for licenses to SPDX standard licenses
module Spdx # rubocop:disable Metrics/ModuleLength
  def self.find(name)
    name = name.strip
    return nil if commercial?(name)
    return nil if non_spdx?(name)

    search(name)
  end

  def self.search(name)
    lookup(name) ||
      find_by_special_case(name) ||
      closest(name)
  end

  def self.commercial?(name)
    name.casecmp('commercial').zero?
  end

  def self.non_spdx?(name)
    ['standard pil license'].include? name.downcase
  end

  def self.lookup(name)
    return false if name.nil?
    return SpdxLicenses[name] if SpdxLicenses.exist?(name)

    lowercase = SpdxLicenses.data.keys.sort.find { |k| k.casecmp(name).zero? }
    SpdxLicenses[lowercase] if lowercase
  end

  def self.closest(name)
    name.gsub!(/#{stop_words.join('|')}/i, '')
    name.gsub!(/(\d)/, ' \1 ')
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
    %w[version software the or right all]
  end

  def self.find_by_name(name)
    match = SpdxLicenses.data.find { |_k, v| v['name'] == name }
    lookup(match[0]) if match
  end

  def self.find_by_special_case(name)
    gpl = gpl_match(name)
    return gpl if gpl

    lookup(special_cases[name.downcase.strip])
  end

  def self.gpl_match(name)
    match = name.match(/^(l|a)?gpl-?\s?_?v?(1|2|3)\.?(\d)?(\+)?$/i)
    return unless match

    lookup "#{match[1]}GPL-#{match[2]}.#{match[3] || 0}#{match[4]}"
  end

  def self.special_cases # rubocop:disable Metrics/MethodLength
    {
      'perl_5' => 'Artistic-1.0-Perl',
      'bsd3' => 'BSD-3-Clause',
      'bsd' => 'BSD-3-Clause',
      'bsd license' => 'BSD-3-Clause',
      'new bsd license' => 'BSD-3-Clause',
      'gnu gpl v2' => 'GPL-2.0-only',
      'gpl' => 'GPL-2.0+',
      'gpl-2 | gpl-3 [expanded from: gpl (≥ 2.0)]' => 'GPL-2.0+',
      'gpl-2 | gpl-3 [expanded from: gpl]' => 'GPL-2.0+',
      'gpl-2 | gpl-3 [expanded from: gpl (≥ 2)]' => 'GPL-2.0+',
      'gpl-2 | gpl-3' => 'GPL-2.0+',
      'gplv2 or later' => 'GPL-2.0+',
      'the gpl v3' => 'GPL-3.0',
      'gpl (≥ 3)' => 'GPL-3.0+',
      'mpl2.0' => 'mpl-2.0',
      'mpl1' => 'mpl-1.0',
      'mpl1.0' => 'mpl-1.0',
      'mpl1.1' => 'mpl-1.1',
      'mpl2' => 'mpl-2.0',
      'gnu lesser general public license' => 'LGPL-2.1+',
      'lgplv2 or later' => 'LGPL-2.1+',
      'gpl2 w/ cpe' => 'GPL-2.0-with-classpath-exception',
      'new bsd license (gpl-compatible)' => 'BSD-3-Clause',
      'public domain' => 'Unlicense',
      'cc0' => 'CC0-1.0',
      'artistic_2' => 'Artistic-2.0',
      'artistic_1' => 'Artistic-1.0',
      'alv2' => 'Apache-2.0',
      'asl' => 'Apache-2.0',
      'asl 2.0' => 'Apache-2.0',
      'mpl 2.0' => 'MPL-2.0',
      'publicdomain' => 'Unlicense',
      'unlicensed' => 'Unlicense',
      'psfl' => 'Python-2.0',
      'psf' => 'Python-2.0',
      'asl2' => 'Apache-2.0',
      'al2' => 'Apache-2.0',
      'aslv2' => 'Apache-2.0',
      'apache_2_0' => 'Apache-2.0',
      'apache_v2' => 'Apache-2.0',
      'zpl 1.1' => 'ZPL-1.1',
      'zpl 2.0' => 'ZPL-2.0',
      'zpl 2.1' => 'ZPL-2.1',
      'lgpl_2_1' => 'LGPL-2.1',
      'lgpl_v2_1' => 'LGPL-2.1',
      'lgpl version 3' => 'LGPL-3.0',
      'gnu lgpl v3+' => 'LGPL-3.0',
      'gnu lgpl' => 'LGPL-2.1+',
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
      '(mit or x11)' => 'MIT',
      'iscl' => 'ISC',
      'wtf' => 'WTFPL',
      '2-clause bsdl' => 'BSD-2-clause',
      '3-clause bsdl' => 'BSD-3-clause',
      '2-clause bsd' => 'BSD-2-clause',
      '3-clause bsd' => 'BSD-3-clause',
      'bsd 3-clause' => 'BSD-3-clause',
      'bsd 2-clause' => 'BSD-2-clause',
      'two-clause bsd-style license' => 'BSD-2-clause',
      'bsd style' => 'BSD-3-clause',
      'cc0 1.0 universal (cc0 1.0) public domain dedication' => 'CC0-1.0',
      'common development and distribution license 1.0 (cddl-1.0)' => 'CDDL-1.0',
      'european union public licence 1.0 (eupl 1.0)' => 'EUPL-1.0',
      'european union public licence 1.1 (eupl 1.1)' => 'EUPL-1.1',
      'european union public licence 1.2 (eupl 1.2)' => 'EUPL-1.2',
      'vovida software license 1.0' => 'VSL-1.0',
      'w3c license' => 'W3C',
      'zlib/libpng license' => 'zlib-acknowledgement',
      'gnu general public license (gpl)' => 'GPL-2.0+',
      'gnu general public license v2 (gplv2)' => 'GPL-2.0',
      'gnu general public license v2 or later (gplv2+)' => 'GPL-2.0+',
      'gnu general public license v3 (gplv3)' => 'GPL-3.0',
      'gnu general public license v3 or later (gplv3+)' => 'GPL-3.0+',
      'gnu lesser general public license v2 (lgplv2)' => 'LGPL-2.0',
      'gnu lesser general public license v2 or later (lgplv2+)' => 'LGPL-2.0+',
      'gnu lesser general public license v3 (lgplv3)' => 'LGPL-3.0',
      'gnu lesser general public license v3 or later (lgplv3+)' => 'LGPL-3.0+',
      'gnu library or lesser general public license (lgpl)' => 'LGPL-2.0+',
      'netscape public License (npl)' => 'NPL-1.1',
      'apache software license' => 'Apache-2.0',
      'academic free license (afl)' => 'AFL-3.0',
      'gnu free documentation license (fdl)' => 'GFDL-1.3',
      'sun industry standards source license (sissl)' => 'SISSL-1.2',
      'zope public license' => 'ZPL-2.1'
    }
  end

  def self.names
    (SpdxLicenses.data.keys + SpdxLicenses.data.map { |_k, v| v['name'] }).sort
  end

  def self.valid_spdx?(spdx_string)
    eval(Parser.parse_to_ruby(spdx_string))
    return true
  rescue SyntaxError, Exception
    return false
  end

  def self.can_use_with_allow?(spdx_string, allowed_licenses)
    licenses = allowed_licenses
    eval(Parser.parse_to_ruby(spdx_string))
  end

  def self.can_use_with_disallow?(spdx_string, disallowed_licenses)
    possible_licenses = Parser.parse_licenses(spdx_string).to_set
    possible_licenses.subtract(disallowed_licenses)
    licenses = possible_licenses.to_a
    eval(Parser.parse_to_ruby(spdx_string))
  end
end
