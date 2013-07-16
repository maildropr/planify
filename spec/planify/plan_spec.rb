require "spec_helper"

describe Planify::Plan do
  subject { StarterPlan }

  describe ".limit" do
    it "returns the max limit for a Trackable class" do
      subject.limit(Post).should eq 100
    end
  end

  describe ".max" do
    before { subject.max(String, 5) }

    it "sets the maximum number of Class allowed" do
      subject.limit(String).should eq 5
    end
  end
end