require "spec_helper"

describe Planify::User, focus: false do
  subject { User.new }
  before { subject.has_plan :starter }

  describe ".has_plan" do
    it "should assign the plan" do
      subject.plan.limit(Post).should == 100
    end

    it "should persist the plan name" do
      subject.save!
      user = User.find(subject.id)

      user.plan.limit(Post).should == 100
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

      it "should store the configuration change" do
        subject.save!
        user = User.find(subject.id)

        user.plan.limit(Post).should == 5
      end

      it "should not change the base plan" do
        Planify::Plans.get(:starter).limit(Post).should == 100
      end
    end
  end
end