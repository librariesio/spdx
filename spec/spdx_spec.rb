# frozen_string_literal: true

require "spec_helper"

describe Spdx do
  context "spdx parsing" do
    context "valid_spdx?" do
      it "returns false for invalid spdx" do
        expect(Spdx.valid_spdx?("AND AND")).to be false
        expect(Spdx.valid_spdx?("MIT OR MIT AND OR")).to be false
        expect(Spdx.valid_spdx?("MIT OR FAKEYLICENSE")).to be false
        expect(Spdx.valid_spdx?(nil)).to be false
        expect(Spdx.valid_spdx?("")).to be false
        expect(Spdx.valid_spdx?("MIT (MIT)")).to be false
      end
      it "returns true for valid spdx" do
        expect(Spdx.valid_spdx?("(MIT OR MPL-2.0)")).to be true
        expect(Spdx.valid_spdx?("MIT")).to be true
        expect(Spdx.valid_spdx?("((MIT OR AGPL-1.0) AND (MIT OR MPL-2.0))")).to be true
        expect(Spdx.valid_spdx?("MIT OR (MIT)")).to be true
      end
      it "returns true for NONE and NOASSERTION" do
        expect(Spdx.valid_spdx?("NONE")).to be true
        expect(Spdx.valid_spdx?("(NONE)")).to be false
        expect(Spdx.valid_spdx?("NOASSERTION")).to be true
        expect(Spdx.valid_spdx?("MIT OR NONE")).to be false
      end
      it "returns true for + expression" do
        expect(Spdx.valid_spdx?("AGPL-3.0+")).to be true
      end
      it "is case insentive for license ids" do
        expect(Spdx.valid_spdx?("mit OR agpl-3.0+")).to be true
      end
      it "handles LicenseRef" do
        expect(Spdx.valid_spdx?("MIT OR LicenseRef-MIT-style-1")).to be true
      end
      it "handles DocumentRef" do
        expect(Spdx.valid_spdx?("MIT OR DocumentRef-something-1:LicenseRef-MIT-style-1")).to be true
        expect(Spdx.valid_spdx?("MIT OR DocumentRef-something-1")).to be false
      end
    end
  end
  context "licenses" do
    it "returns a list of possible licenses" do
      expect(Spdx.parse_spdx("MIT OR MPL-2.0").licenses).to eq ["MIT", "MPL-2.0"]
    end
    it "returns empty array for NONE or NOASSERTION" do
      expect(Spdx.parse_spdx("NONE").licenses).to eq []
      expect(Spdx.parse_spdx("NOASSERTION").licenses).to eq []
    end
    it "returns LicenseRefs" do
      expect(Spdx.parse_spdx("MIT OR LicenseRef-MIT-style-1").licenses).to eq %w[MIT LicenseRef-MIT-style-1]
    end
    it "returns DocumentRefs" do
      expect(Spdx.parse_spdx("MIT OR DocumentRef-something-1:LicenseRef-MIT-style-1").licenses).to eq %w[MIT DocumentRef-something-1:LicenseRef-MIT-style-1]
    end
  end

  context "exceptions" do
    it "parses a valid spdx with expression" do
      expect(Spdx.valid_spdx?("EPL-2.0 OR (GPL-2.0-only WITH Classpath-exception-2.0)")).to be true
    end
    it "returns false for a license in the exception spot" do
      expect(Spdx.valid_spdx?("EPL-2.0 OR (GPL-2.0-only WITH AGPL-3.0)")).to be false
    end
    it "provides full details for a parse error" do
      expect { Spdx.parse_spdx("MIT OR ((WHAT)") }.to raise_error(SpdxGrammar::SpdxParseError, "Unable to parse expression '(MIT OR ((WHAT))'. Parse error at offset: 0")
    end
  end
end
