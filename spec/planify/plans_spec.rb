require "spec_helper"

describe Planify::Plans do

  before(:each) { Planify::Plans.clear }

  describe ".define" do
    it "creates a plan with the given name" do
      plan = Planify::Plans.define :starter
      Planify::Plans.get(:starter).should == plan
    end

    it "given block should be evaluated on plan" do
      plan = Planify::Plans.define :starter do
        max String, 10
      end

      Planify::Plans.get(:starter).limit(String).should == 10
    end
  end

  describe ".get" do
    context "when plan is defined" do
      before do
        Planify::Plans.define :starter do
          max String, 10
        end
      end

      it "returns the plan" do
        Planify::Plans.get(:starter).limit(String).should == 10
      end
    end

    context "when plan is undefined" do
      it "raises an ArgumentError" do
        expect { Planify::Plans.get(:non_existant) }.to raise_exception(ArgumentError)
      end
    end
  end

  describe ".clear" do
    before { Planify::Plans.define :starter }

    it "destroys all plans" do
      Planify::Plans.all.should_not be_empty
      Planify::Plans.clear
      Planify::Plans.all.should be_empty
    end
  end
end