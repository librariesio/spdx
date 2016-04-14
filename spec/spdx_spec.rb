require 'spec_helper'

describe Spdx do
  describe 'find' do
    it "should return know license from short code" do
      expect(Spdx.find('Apache-2.0').name).to eq("Apache License 2.0")
    end

    it "should work with case-insentive short codes" do
      expect(Spdx.find('apache-2.0').name).to eq("Apache License 2.0")
      expect(Spdx.find('agpl-3.0').name).to eq("GNU Affero General Public License v3.0")
    end

    it "should return know license from full name" do
      expect(Spdx.find('Apache License 2.0').name).to eq("Apache License 2.0")
    end

    it "should return nil for garbage" do
      expect(Spdx.find('foo bar baz')).to be_nil
      expect(Spdx.find('Copyright Zendesk. All Rights Reserved.')).to be_nil
      expect(Spdx.find('https://github.com/AuthorizeNet/sdk-ruby/blob/master/license.txt')).to be_nil
    end

    it "should return know license from an alias" do
      expect(Spdx.find('The Apache Software License, Version 2.0').name).to eq("Apache License 2.0")
      expect(Spdx.find('Apache 2.0').name).to eq("Apache License 2.0")
      expect(Spdx.find('Apache2').name).to eq("Apache License 2.0")
      expect(Spdx.find('Apache License, Version 2.0').name).to eq("Apache License 2.0")
      expect(Spdx.find('Educational Community License, Version 2.0').name).to eq("Educational Community License v2.0")
      expect(Spdx.find('CDDL + GPLv2 with classpath exception').name).to eq("GNU General Public License v2.0 w/Classpath exception")
      expect(Spdx.find('The MIT License').name).to eq("MIT License")
      expect(Spdx.find('UNLICENSE').name).to eq("The Unlicense")
    end

    it "should return know licenses for special cases" do
      expect(Spdx.find('MPL1').name).to eq('Mozilla Public License 1.0')
      expect(Spdx.find('MPL1.0').name).to eq('Mozilla Public License 1.0')
      expect(Spdx.find('MPL1.1').name).to eq('Mozilla Public License 1.1')
      expect(Spdx.find('MPL2').name).to eq('Mozilla Public License 2.0')
      expect(Spdx.find('MPL2.0').name).to eq('Mozilla Public License 2.0')
      expect(Spdx.find('GPL3').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('GPL v3').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('GPL3').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('GPL 3.0').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('GPL-3').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('GPL-2 | GPL-3 [expanded from: GPL (≥ 2)]').name).to eq('GNU General Public License v2.0 or later')
      expect(Spdx.find('GPL-2 | GPL-3 [expanded from: GPL]').name).to eq('GNU General Public License v2.0 or later')
      expect(Spdx.find('GPL (≥ 3)').name).to eq('GNU General Public License v3.0 or later')
      expect(Spdx.find('gpl30').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find("GPL v2+").name).to eq('GNU General Public License v2.0 or later')
      expect(Spdx.find("GPL 2").name).to eq('GNU General Public License v2.0 only')
      expect(Spdx.find("GPL v2").name).to eq('GNU General Public License v2.0 only')
      expect(Spdx.find("GPL2").name).to eq('GNU General Public License v2.0 only')
      expect(Spdx.find("GPL-2 | GPL-3").name).to eq('GNU General Public License v2.0 or later')
      expect(Spdx.find("GPL-2 | GPL-3 [expanded from: GPL (≥ 2.0)]").name).to eq('GNU General Public License v2.0 or later')
      expect(Spdx.find("GPL2 w/ CPE").name).to eq('GNU General Public License v2.0 w/Classpath exception')
      expect(Spdx.find("GPL 2.0").name).to eq('GNU General Public License v2.0 only')
      expect(Spdx.find("New BSD License (GPL-compatible)").name).to eq('BSD 3-clause "New" or "Revised" License')
      expect(Spdx.find("The GPL V3").name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('perl_5').name).to eq("Artistic License 1.0 (Perl)")
      expect(Spdx.find('BSD3').name).to eq('BSD 3-clause "New" or "Revised" License')
      expect(Spdx.find('BSD').name).to eq('BSD 3-clause "New" or "Revised" License')
      expect(Spdx.find('GPLv3').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('LGPLv2 or later').name).to eq('GNU Lesser General Public License v2.1 or later')
      expect(Spdx.find('GPLv2 or later').name).to eq('GNU General Public License v2.0 or later')
      expect(Spdx.find('Public Domain').name).to eq('The Unlicense')
      expect(Spdx.find('GPL-2').name).to eq('GNU General Public License v2.0 only')
      expect(Spdx.find('GPL').name).to eq('GNU General Public License v2.0 or later')
      expect(Spdx.find('GNU LESSER GENERAL PUBLIC LICENSE').name).to eq('GNU Lesser General Public License v2.1 or later')
      expect(Spdx.find('New BSD License').name).to eq('BSD 3-clause "New" or "Revised" License')
      expect(Spdx.find('(MIT OR X11) ').name).to eq('MIT License')
      expect(Spdx.find('mit-license').name).to eq('MIT License')
      expect(Spdx.find('lgpl-3').name).to eq('GNU Lesser General Public License v3.0 only')
      expect(Spdx.find('agpl-3').name).to eq('GNU Affero General Public License v3.0')
      expect(Spdx.find('cc by-sa 4.0').name).to eq('Creative Commons Attribution Share Alike 4.0')
      expect(Spdx.find('cc by-nc-sa 3.0').name).to eq('Creative Commons Attribution Non Commercial Share Alike 3.0')
      expect(Spdx.find('cc by-sa 3.0').name).to eq('Creative Commons Attribution Share Alike 3.0')
      expect(Spdx.find('gpl_1').name).to eq('GNU General Public License v1.0 only')
      expect(Spdx.find('gpl_2').name).to eq('GNU General Public License v2.0 only')
      expect(Spdx.find('gpl_3').name).to eq('GNU General Public License v3.0 only')
      expect(Spdx.find('artistic_2').name).to eq('Artistic License 2.0')
      expect(Spdx.find('artistic_1').name).to eq('Artistic License 1.0')
      expect(Spdx.find('apache_2_0').name).to eq('Apache License 2.0')
      expect(Spdx.find('apache_v2').name).to eq('Apache License 2.0')
      expect(Spdx.find('lgpl_2_1').name).to eq('GNU Lesser General Public License v2.1 only')
      expect(Spdx.find('lgpl_v2_1').name).to eq('GNU Lesser General Public License v2.1 only')
    end
  end
end
