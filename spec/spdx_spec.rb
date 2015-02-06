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
    end
  end
end
