require "spec_helper"

describe Planify::User::PlanInfo do
  describe ".overrides_as_plan" do
    it "returns an instance of Planify::Plan" do
      subject.overrides_as_plan.should be_an_instance_of Planify::Plan
    end
  end

  describe ".has_overrides?" do
    it "returns true if limit overrides exist" do
      subject.limit_overrides = {post: 100}
      subject.should have_overrides
    end

    it "returns true if feature overrides exist" do
      subject.feature_overrides = {ajax_search: false}
      subject.should have_overrides
    end

    it "returns true if both limit and feature overrides exist" do
      subject.limit_overrides = {post: 100}
      subject.feature_overrides = {ajax_search: false}
      subject.should have_overrides
    end

    it "returns false if neither limit nor feature overrides exist" do
      subject.should_not have_overrides
    end
  end
end