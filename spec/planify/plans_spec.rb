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
        max Post, 10
      end

      Planify::Plans.get(:starter).limit(Post).should == 10
    end
  end

  describe ".get" do
    context "with a string" do
      it "will match the plan" do
        Planify::Plans.define :starter
        Planify::Plans.get("starter").should be_an_instance_of Planify::Plan
      end
    end

    context "when plan is defined" do
      before do
        Planify::Plans.define :starter do
          max Post, 10
        end
      end

      it "returns the plan" do
        Planify::Plans.get(:starter).limit(Post).should == 10
      end
    end

    context "when plan is undefined" do
      it "raises an ArgumentError" do
        expect { Planify::Plans.get(:non_existant) }.to raise_exception(ArgumentError)
      end
    end
  end

  describe ".all" do
    before { Planify::Plans.clear }

    it "returns all defined plans" do
      Planify::Plans.all.should be_empty
      
      Planify::Plans.define :plan1
      Planify::Plans.define :plan2

      Planify::Plans.all.size.should == 2
    end

    it "returns an array of plans" do
      Planify::Plans.define :plan1

      Planify::Plans.all.should be_an Array
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