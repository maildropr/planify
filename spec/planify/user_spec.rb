require "spec_helper"

describe Planify::User, focus: false do
  subject { User.new }
  before { subject.plan = StarterPlan }

  it "should have a plan" do
    subject.plan.should == StarterPlan
  end

  context "with a configuration block" do
    before do
      subject.plan = StarterPlan do
        max Post, 5
      end
    end

    it "the configuration should override the plan defaults" do
      subject.plan
    end
  end

end