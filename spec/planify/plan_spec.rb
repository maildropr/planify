require "spec_helper"

describe Planify::Plan do
  subject { StarterPlan.new }

  describe ".limit" do
    it "returns the max limit for a Trackable class" do
      subject.limit(Post).should eq 100
    end
  end
end