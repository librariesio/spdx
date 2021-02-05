# frozen_string_literal: true

require "spec_helper"

describe Spdx do
  context "spdx parsing" do
    context "valid?" do
      it "returns false for invalid spdx" do
        expect(Spdx.valid?("AND AND")).to be false
        expect(Spdx.valid?(" AND ")).to be false
        expect(Spdx.valid?(" WITH ")).to be false
        expect(Spdx.valid?("MIT AND ")).to be false
        expect(Spdx.valid?("MIT OR MIT AND OR")).to be false
        expect(Spdx.valid?("MIT OR FAKEYLICENSE")).to be false
        expect(Spdx.valid?(nil)).to be false
        expect(Spdx.valid?("")).to be false
        expect(Spdx.valid?("MIT (MIT)")).to be false
      end
      it "returns true for valid spdx" do
        expect(Spdx.valid?("(MIT OR MPL-2.0)")).to be true
        expect(Spdx.valid?("MIT")).to be true
        expect(Spdx.valid?("MIT OR MPL-2.0 AND AGPL-1.0")).to be true
        expect(Spdx.valid?("MIT OR (GPL-1.0 OR MPL-2.0) AND AGPL-1.0")).to be true
        expect(Spdx.valid?("MIT AND MPL-2.0 OR AGPL-1.0")).to be true
        expect(Spdx.valid?("MIT AND (GPL-1.0 OR MPL-2.0) OR AGPL-1.0")).to be true
        expect(Spdx.valid?("MIT OR (DocumentRef-something-1:LicenseRef-MIT-style-1 OR MPL-2.0) AND AGPL-1.0")).to be true
        expect(Spdx.valid?("((MIT OR AGPL-1.0) AND (MIT OR MPL-2.0))")).to be true
        expect(Spdx.valid?("MIT OR (MIT)")).to be true
      end
      it "returns true for NONE and NOASSERTION" do
        expect(Spdx.valid?("NONE")).to be true
        expect(Spdx.valid?("(NONE)")).to be false
        expect(Spdx.valid?("NOASSERTION")).to be true
        expect(Spdx.valid?("MIT OR NONE")).to be false
      end
      it "returns true for + expression" do
        expect(Spdx.valid?("AGPL-3.0+")).to be true
      end
      it "is case insentive for license ids" do
        expect(Spdx.valid?("mit OR agpl-3.0+")).to be true
      end
      it "handles LicenseRef" do
        expect(Spdx.valid?("MIT OR LicenseRef-MIT-style-1")).to be true
      end
      it "handles DocumentRef" do
        expect(Spdx.valid?("MIT OR DocumentRef-something-1:LicenseRef-MIT-style-1")).to be true
        expect(Spdx.valid?("MIT OR DocumentRef-something-1")).to be false
      end
    end
  end
  context "normalize" do
    it "normalizes simple licenses" do
      expect(Spdx.normalize("MIT")).to eq "MIT"
      expect(Spdx.normalize("mit")).to eq "MIT"
      expect(Spdx.normalize("MiT")).to eq "MIT"
      expect(Spdx.normalize("(MiT)")).to eq "MIT"
      expect(Spdx.normalize("(((MiT)))")).to eq "MIT"
      expect(Spdx.normalize("LicenseRef-MIT-style-1")).to eq "LicenseRef-MIT-style-1"
      expect(Spdx.normalize("DocumentRef-something-1:LicenseRef-MIT-style-1")).to eq "DocumentRef-something-1:LicenseRef-MIT-style-1"
      expect(Spdx.normalize("Apache-2.0+")).to eq "Apache-2.0+"
      expect(Spdx.normalize("apache-2.0+")).to eq "Apache-2.0+"
    end
    it "normalizes NONE/NOASSERTION" do
      expect(Spdx.normalize("NONE")).to eq "NONE"
      expect(Spdx.normalize("NOASSERTION")).to eq "NOASSERTION"
    end
    it "normalizes boolean expressions" do
      expect(Spdx.normalize("mit AND gPL-2.0")).to eq "(MIT AND GPL-2.0)"
      expect(Spdx.normalize("mit OR gPL-2.0")).to eq "(MIT OR GPL-2.0)"
      expect(Spdx.normalize("mit OR gPL-2.0")).to eq "(MIT OR GPL-2.0)"

      # Does semantic grouping
      expect(Spdx.normalize("mit OR gPL-2.0 AND apAcHe-2.0+")).to eq "(MIT OR (GPL-2.0 AND Apache-2.0+))"

      # But also preserves original groups
      expect(Spdx.normalize("(mit OR gPL-2.0) AND apAcHe-2.0+")).to eq "((MIT OR GPL-2.0) AND Apache-2.0+)"
    end
    it "normalizes WITH expressions" do
      expect(Spdx.normalize("GPL-2.0-only WITH Classpath-exception-2.0")).to eq "(GPL-2.0-only WITH Classpath-exception-2.0)"
      expect(Spdx.normalize("Gpl-2.0-ONLY WITH ClassPath-exception-2.0")).to eq "(GPL-2.0-only WITH Classpath-exception-2.0)"
      expect(Spdx.normalize("EPL-2.0 OR (GPL-2.0-only WITH Classpath-exception-2.0)")).to eq "(EPL-2.0 OR (GPL-2.0-only WITH Classpath-exception-2.0))"
      expect(Spdx.normalize("epl-2.0 OR (gpl-2.0-only WITH classpath-exception-2.0)")).to eq "(EPL-2.0 OR (GPL-2.0-only WITH Classpath-exception-2.0))"
      expect(Spdx.normalize("epl-2.0 OR gpl-2.0-only WITH classpath-exception-2.0")).to eq "(EPL-2.0 OR (GPL-2.0-only WITH Classpath-exception-2.0))"
      expect(Spdx.normalize("epl-2.0 OR gpl-2.0-only WITH classpath-exception-2.0 AND mpl-2.0+")).to eq "(EPL-2.0 OR ((GPL-2.0-only WITH Classpath-exception-2.0) AND MPL-2.0+))"
    end
  end
  context "licenses" do
    it "returns a list of possible licenses" do
      expect(Spdx.parse("MIT OR MPL-2.0").licenses).to eq ["MIT", "MPL-2.0"]
    end
    it "returns empty array for NONE or NOASSERTION" do
      expect(Spdx.parse("NONE").licenses).to eq []
      expect(Spdx.parse("NOASSERTION").licenses).to eq []
    end
    it "returns LicenseRefs" do
      expect(Spdx.parse("MIT OR LicenseRef-MIT-style-1").licenses).to eq %w[MIT LicenseRef-MIT-style-1]
    end
    it "returns DocumentRefs" do
      expect(Spdx.parse("MIT OR DocumentRef-something-1:LicenseRef-MIT-style-1").licenses).to eq %w[MIT DocumentRef-something-1:LicenseRef-MIT-style-1]
    end
  end

  context "exceptions" do
    it "parses a valid spdx WITH expression" do
      expect(Spdx.valid?("EPL-2.0 OR (GPL-2.0-only WITH Classpath-exception-2.0)")).to be true
    end
    it "returns false for a license in the exception spot" do
      expect(Spdx.valid?("EPL-2.0 OR (GPL-2.0-only WITH AGPL-3.0)")).to be false
    end
    it "provides full details for a parse error" do
      expect { Spdx.parse("MIT OR ((WHAT)") }.to raise_error(SpdxGrammar::SpdxParseError, "Unable to parse expression 'MIT OR ((WHAT)'. Parse error at offset: 3")
    end
  end
end
