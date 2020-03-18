# frozen_string_literal: true

require "spec_helper"

describe Spdx do
  describe "find" do
    it "should return know license from short code" do
      expect(Spdx.find("Apache-2.0").name).to eq("Apache License 2.0")
    end

    it "should work with case-insentive short codes" do
      expect(Spdx.find("apache-2.0").name).to eq("Apache License 2.0")
      expect(Spdx.find("agpl-3.0").name).to eq("GNU Affero General Public License v3.0")
    end

    it "should return know license from full name" do
      expect(Spdx.find("Apache License 2.0").name).to eq("Apache License 2.0")
    end

    it "should return nil for commercial" do
      expect(Spdx.find("Commercial")).to be_nil
    end

    it "should return nil for garbage" do
      expect(Spdx.find("foo bar baz")).to be_nil
      expect(Spdx.find("https://github.com/AuthorizeNet/sdk-ruby/blob/master/license.txt")).to be_nil
    end

    it "should return know license from an alias" do
      expect(Spdx.find("The Apache Software License, Version 2.0").name).to eq("Apache License 2.0")
      expect(Spdx.find("Apache 2.0").name).to eq("Apache License 2.0")
      expect(Spdx.find("Apache2").name).to eq("Apache License 2.0")
      expect(Spdx.find("Apache License, Version 2.0").name).to eq("Apache License 2.0")
      expect(Spdx.find("Educational Community License, Version 2.0").name).to eq("Educational Community License v2.0")
      expect(Spdx.find("CDDL + GPLv2 with classpath exception").name).to \
        eq("GNU General Public License v2.0 w/Classpath exception")
      expect(Spdx.find("The MIT License").name).to eq("MIT License")
      expect(Spdx.find("UNLICENSE").name).to eq("The Unlicense")
    end

    it "should strip whitespace from strings before lookups" do
      expect(Spdx.find(" BSD-3-Clause").id).to eq("BSD-3-Clause")
    end

    it "should handle pypi classifiers properly" do
      pypi_mappings = [
        ["Aladdin Free Public License (AFPL)", "Aladdin"],
        ["CC0 1.0 Universal (CC0 1.0) Public Domain Dedication", "CC0-1.0"],
        ["CeCILL-B Free Software License Agreement (CECILL-B)", "CECILL-B"],
        ["CeCILL-C Free Software License Agreement (CECILL-C)", "CECILL-C"],
        ["Eiffel Forum License (EFL)", "EFL-2.0"],
        ["Netscape Public License (NPL)", "NPL-1.1"],
        ["Nokia Open Source License (NOKOS)", "Nokia"],
        ["Academic Free License (AFL)", "AFL-3.0"],
        ["Apache Software License", "Apache-2.0"],
        ["Apple Public Source License", "APSL-2.0"],
        ["Artistic License", "Artistic-2.0"],
        ["Attribution Assurance License", "AAL"],
        ["Boost Software License 1.0 (BSL-1.0)", "BSL-1.0"],
        ["BSD License", "BSD-3-Clause"],
        ["Common Development and Distribution License 1.0 (CDDL-1.0)", "CDDL-1.0"],
        ["Common Public License", "CPL-1.0"],
        ["Eclipse Public License 1.0 (EPL-1.0)", "EPL-1.0"],
        ["Eclipse Public License 2.0 (EPL-2.0)", "EPL-2.0"],
        ["Eiffel Forum License", "EFL-2.0"],
        ["European Union Public Licence 1.0 (EUPL 1.0)", "EUPL-1.0"],
        ["European Union Public Licence 1.1 (EUPL 1.1)", "EUPL-1.1"],
        ["European Union Public Licence 1.2 (EUPL 1.2)", "EUPL-1.2"],
        ["GNU Affero General Public License v3", "AGPL-3.0"],
        ["GNU Affero General Public License v3 or later (AGPLv3+)", "AGPL-3.0-or-later"],
        ["GNU Free Documentation License (FDL)", "GFDL-1.3"],
        ["GNU General Public License (GPL)", "GPL-2.0+"],
        ["GNU General Public License v2 (GPLv2)", "GPL-2.0"],
        ["GNU General Public License v2 or later (GPLv2+)", "GPL-2.0+"],
        ["GNU General Public License v3 (GPLv3)", "GPL-3.0"],
        ["GNU General Public License v3 or later (GPLv3+)", "GPL-3.0+"],
        ["GNU Lesser General Public License v2 (LGPLv2)", "LGPL-2.0"],
        ["GNU Lesser General Public License v2 or later (LGPLv2+)", "LGPL-2.0+"],
        ["GNU Lesser General Public License v3 (LGPLv3)", "LGPL-3.0"],
        ["GNU Lesser General Public License v3 or later (LGPLv3+)", "LGPL-3.0+"],
        ["GNU Library or Lesser General Public License (LGPL)", "LGPL-2.0+"],
        ["IBM Public License", "IPL-1.0"],
        ["Intel Open Source License", "Intel"],
        ["ISC License (ISCL)", "ISC"],
        # ['MirOS License (MirOS)', 'MirOS'],
        ["MIT License", "MIT"],
        ["Motosoto License", "Motosoto"],
        ["Mozilla Public License 1.0 (MPL)", "MPL-1.0"],
        ["Mozilla Public License 1.1 (MPL 1.1)", "MPL-1.1"],
        ["Mozilla Public License 2.0 (MPL 2.0)", "MPL-2.0"],
        ["Nethack General Public License", "NGPL"],
        ["Nokia Open Source License", "Nokia"],
        ["Open Group Test Suite License", "OGTSL"],
        ["PostgreSQL License", "PostgreSQL"],
        ["Python License (CNRI Python License)", "CNRI-Python"],
        # ['Python Software Foundation License', 'Python-2.0'],
        ["Qt Public License (QPL)", "QPL-1.0"],
        ["Ricoh Source Code Public License", "RSCPL"],
        ["SIL Open Font License 1.1 (OFL-1.1)", "OFL-1.1"],
        ["Sleepycat License", "Sleepycat"],
        ["Sun Industry Standards Source License (SISSL)", "SISSL-1.2"],
        ["Sun Public License", "SPL-1.0"],
        ["Universal Permissive License (UPL)", "UPL-1.0"],
        ["University of Illinois/NCSA Open Source License", "NCSA"],
        ["Vovida Software License 1.0", "VSL-1.0"],
        ["W3C License", "W3C"],
        ["X.Net License", "Xnet"],
        ["zlib/libpng License", "zlib-acknowledgement"],
        ["Zope Public License", "ZPL-2.1"],
      ]
      pypi_mappings.each do |license, mapped|
        expect(Spdx.find(license).id).to eq(mapped)
      end
    end

    it "should return know licenses for special cases" do
      expect(Spdx.find("MPL1").name).to eq("Mozilla Public License 1.0")
      expect(Spdx.find("MPL1.0").name).to eq("Mozilla Public License 1.0")
      expect(Spdx.find("MPL1.1").name).to eq("Mozilla Public License 1.1")
      expect(Spdx.find("MPL2").name).to eq("Mozilla Public License 2.0")
      expect(Spdx.find("MPL2.0").name).to eq("Mozilla Public License 2.0")
      expect(Spdx.find("GPL3").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("GPL v3").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("GPL3").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("GPL 3.0").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("GPL-3").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("GPL-2 | GPL-3 [expanded from: GPL (≥ 2)]").name).to \
        eq("GNU General Public License v2.0 or later")
      expect(Spdx.find("GPL-2 | GPL-3 [expanded from: GPL]").name).to \
        eq("GNU General Public License v2.0 or later")
      expect(Spdx.find("GPL (≥ 3)").name).to eq("GNU General Public License v3.0 or later")
      expect(Spdx.find("gpl30").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("GPL v2+").name).to eq("GNU General Public License v2.0 or later")
      expect(Spdx.find("GPL 2").name).to eq("GNU General Public License v2.0 only")
      expect(Spdx.find("GPL v2").name).to eq("GNU General Public License v2.0 only")
      expect(Spdx.find("GPL2").name).to eq("GNU General Public License v2.0 only")
      expect(Spdx.find("GPL-2 | GPL-3").name).to eq("GNU General Public License v2.0 or later")
      expect(Spdx.find("GPL-2 | GPL-3 [expanded from: GPL (≥ 2.0)]").name).to \
        eq("GNU General Public License v2.0 or later")
      expect(Spdx.find("GPL2 w/ CPE").name).to eq("GNU General Public License v2.0 w/Classpath exception")
      expect(Spdx.find("GPL 2.0").name).to eq("GNU General Public License v2.0 only")
      expect(Spdx.find("New BSD License (GPL-compatible)").name).to eq('BSD 3-Clause "New" or "Revised" License')
      expect(Spdx.find("The GPL V3").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("perl_5").name).to eq("Artistic License 1.0 (Perl)")
      expect(Spdx.find("BSD3").name).to eq('BSD 3-Clause "New" or "Revised" License')
      expect(Spdx.find("BSD").name).to eq('BSD 3-Clause "New" or "Revised" License')
      expect(Spdx.find("GPLv3").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("LGPLv2 or later").name).to eq("GNU Library General Public License v2.1 or later")
      expect(Spdx.find("GPLv2 or later").name).to eq("GNU General Public License v2.0 or later")
      expect(Spdx.find("Public Domain").name).to eq("The Unlicense")
      expect(Spdx.find("GPL-2").name).to eq("GNU General Public License v2.0 only")
      expect(Spdx.find("GPL").name).to eq("GNU General Public License v2.0 or later")
      expect(Spdx.find("GNU LESSER GENERAL PUBLIC LICENSE").name).to \
        eq("GNU Library General Public License v2.1 or later")
      expect(Spdx.find("New BSD License").name).to eq('BSD 3-Clause "New" or "Revised" License')
      expect(Spdx.find("(MIT OR X11) ").name).to eq("MIT License")
      expect(Spdx.find("mit-license").name).to eq("MIT License")
      expect(Spdx.find("lgpl-3").name).to eq("GNU Lesser General Public License v3.0 only")
      expect(Spdx.find("agpl-3").name).to eq("GNU Affero General Public License v3.0")
      expect(Spdx.find("cc by-sa 4.0").name).to eq("Creative Commons Attribution Share Alike 4.0 International")
      expect(Spdx.find("cc by-nc-sa 3.0").name).to \
        eq("Creative Commons Attribution Non Commercial Share Alike 3.0 Unported")
      expect(Spdx.find("cc by-sa 3.0").name).to eq("Creative Commons Attribution Share Alike 3.0 Unported")
      expect(Spdx.find("gpl_1").name).to eq("GNU General Public License v1.0 only")
      expect(Spdx.find("gpl_2").name).to eq("GNU General Public License v2.0 only")
      expect(Spdx.find("gpl_3").name).to eq("GNU General Public License v3.0 only")
      expect(Spdx.find("artistic_2").name).to eq("Artistic License 2.0")
      expect(Spdx.find("artistic_1").name).to eq("Artistic License 1.0")
      expect(Spdx.find("apache_2_0").name).to eq("Apache License 2.0")
      expect(Spdx.find("apache_v2").name).to eq("Apache License 2.0")
      expect(Spdx.find("lgpl_2_1").name).to eq("GNU Lesser General Public License v2.1 only")
      expect(Spdx.find("lgpl_v2_1").name).to eq("GNU Lesser General Public License v2.1 only")

      expect(Spdx.find("BSD 3-Clause").name).to eq('BSD 3-Clause "New" or "Revised" License')
      expect(Spdx.find("BSD 3-Clause").name).to eq('BSD 3-Clause "New" or "Revised" License')
      expect(Spdx.find("BSD 2-Clause").name).to eq('BSD 2-Clause "Simplified" License')
      expect(Spdx.find("BSD 2-clause").name).to eq('BSD 2-Clause "Simplified" License')
      expect(Spdx.find("BSD Style").name).to eq('BSD 3-Clause "New" or "Revised" License')

      expect(Spdx.find("GNU LGPL v3+").name).to eq("GNU Lesser General Public License v3.0 only")
      expect(Spdx.find("ZPL 2.1").name).to eq("Zope Public License 2.1")
    end
  end
  context "spdx parsing" do
    context "valid_spdx?" do
      it "returns false for invalid spdx" do
        expect(Spdx.valid_spdx?("AND AND")).to be false
        expect(Spdx.valid_spdx?("MIT OR MIT AND OR")).to be false
        expect(Spdx.valid_spdx?("MIT OR FAKEYLICENSE")).to be false
      end
      it "returns true for valid spdx" do
        expect(Spdx.valid_spdx?("(MIT OR MPL-2.0)")).to be true
        expect(Spdx.valid_spdx?("MIT")).to be true
        expect(Spdx.valid_spdx?("((MIT OR AGPL-1.0) AND (MIT OR MPL-2.0))")).to be true
      end
    end
  end
end
