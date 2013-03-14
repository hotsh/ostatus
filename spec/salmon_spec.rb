require_relative 'helper'
require_relative '../lib/ostatus/salmon.rb'

describe OStatus::Salmon do
  describe "Salmon.from_xml" do
    it "returns nil if source is empty string" do
      OStatus::Salmon.from_xml("").must_equal(nil)
    end
  end
end
