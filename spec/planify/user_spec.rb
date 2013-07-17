require "spec_helper"

describe Planify::User, focus: false do
  subject { User.new }
  before { subject.has_plan :starter }

  it "should have a plan" do
    subject.plan.limit(Post).should == 100
  end

  context "with a configuration block" do
    before do
      subject.has_plan :starter do
        max Post, 5
      end
    end

    it "the configuration should override the plan defaults" do
      subject.plan.limit(Post).should == 5
    end

    it "should not change the base plan" do
      Planify::Plans.get(:starter).limit(Post).should == 100
    end
  end

end