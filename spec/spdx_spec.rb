require 'spec_helper'

describe Spdx do
  describe 'find' do
    it "should return know license from short code" do
      expect(Spdx.find('Apache-2.0').name).to eq("Apache License 2.0")
    end

    it "should return know license from full name" do
      expect(Spdx.find('Apache License 2.0').name).to eq("Apache License 2.0")
    end

    it "should return know license from an alias" do
      expect(Spdx.find('The Apache Software License, Version 2.0').name).to eq("Apache License 2.0")
      expect(Spdx.find('Apache 2.0').name).to eq("Apache License 2.0")
      expect(Spdx.find('Apache2').name).to eq("Apache License 2.0")
      expect(Spdx.find('Apache License, Version 2.0').name).to eq("Apache License 2.0")
      expect(Spdx.find('Educational Community License, Version 2.0').name).to eq("Educational Community License v2.0")
      expect(Spdx.find('CDDL + GPLv2 with classpath exception').name).to eq("GNU General Public License v2.0 w/Classpath exception")
      expect(Spdx.find('The MIT License').name).to eq("MIT License")
      # expect(Spdx.find('BSD3').name).to eq('BSD 3-clause "New" or "Revised" License')
      # expect(Spdx.find('GNU LESSER GENERAL PUBLIC LICENSE').name).to eq("GNU General Public License v1.0 only")
    end
  end
end
