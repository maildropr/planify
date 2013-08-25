require "spec_helper"

describe Planify::Plan do
  subject { Planify::Plans.get(:starter) }

  describe ".limit" do
    before { subject.max(Post, 100) }

    it "returns the max limit for a Limitable class" do
      subject.limit(Post).should eq 100
    end
  end

  describe ".max" do
    before { subject.max(Post, 5) }

    it "sets the maximum number of Class allowed" do
      subject.limit(Post).should eq 5
    end
  end

  describe ".feature" do
    before do
      subject.feature :ajax_search
      subject.feature :live_reload, false
    end

    it "sets availability of the feature" do
      subject.features.keys.should include :ajax_search, :live_reload
    end

    it "defaults features to enabled" do
      subject.features[:ajax_search].should be_true
    end
  end

  describe ".enable_feature" do
    it "enables the named feature" do
      subject.enable_feature(:live_reload)
      subject.feature_enabled?(:live_reload).should be_true
    end
  end

  describe ".disable_feature" do
    it "disables the named feature" do
      subject.disable_feature(:live_reload)
      subject.feature_enabled?(:live_reload).should be_false
    end
  end

  describe ".feature_enabled?" do
    before { subject.feature(:ajax_search) }

    it "returns true if the feature is enabled for this plan" do
      subject.feature_enabled?(:ajax_search).should be_true
    end

    it "returns false if the feature if explicitly disabled" do
      subject.feature(:ajax_search, false)
      subject.feature_enabled?(:ajax_search).should be_false
    end

    it "returns false if the feature does not exist" do
      subject.feature_enabled?(:dne_feature).should be_false
    end
  end

  describe ".feature_disabled?" do
    before { subject.feature(:ajax_search) }

    it "returns true if the feature is not enabled for this plan" do
      subject.feature_disabled?(:ajax_search).should be_false
    end

    it "returns true if the feature if explicitly disabled" do
      subject.feature(:ajax_search, false)
      subject.feature_disabled?(:ajax_search).should be_true
    end

    it "returns true if the feature does not exist" do
      subject.feature_disabled?(:dne_feature).should be_true
    end

    it "returns false if the feature is enabled" do
      subject.feature_disabled?(:ajax_search).should be_false
    end
  end

  describe ".dup" do
    it "returns a duplicate plan with the same features and limits" do
      duplicate = subject.dup

      duplicate.should_not be subject
      duplicate.limits.all.should == subject.limits.all
      duplicate.features.should == subject.features
    end
  end


  describe ".price" do
    context "with arguments" do
      it "sets the current price" do
        subject.price(10.00)

        subject.price.should == 10.00
      end
    end

    context "without arguments" do
      before { subject.price(15.00) }

      it "returns the current price" do
        subject.price.should == 15.00
      end
    end

    context "when no price is set" do
      it "returns zero" do
        Planify::Plan.new.price.should == 0.00
      end
    end
  end

  describe ".description" do
    context "with arguments" do
      it "sets the plan description" do
        subject.description "The best plan ever!"

        subject.description.should == "The best plan ever!"
      end
    end

    context "without arguments" do
      before { subject.description("Plan Description") }

      it "returns the plan description" do
        subject.description.should == "Plan Description"
      end
    end

    context "when no description is set" do
      it "returns nil" do
        Planify::Plan.new.description.should be_nil
      end
    end
  end

  describe ".name" do
    context "with arguments" do
      it "sets the plan name" do
        subject.name "Starter Plan"

        subject.name.should == "Starter Plan"
      end
    end

    context "without arguments" do
      before { subject.name("Premium Plan") }

      it "returns the plan name" do
        subject.name.should == "Premium Plan"
      end
    end

    context "when no name is set" do
      it "returns nil" do
        Planify::Plan.new.name.should be_nil
      end
    end
  end

  describe ".merge!" do

    let(:pro_plan) do
      Planify::Plans.define :pro do
        max Post, 1000
        feature :ajax_search
      end
    end

    it "merges settings in other plan into this plan" do
      subject.merge! pro_plan

      subject.features.keys.should include :ajax_search
      subject.limit(Post).should == 1000
    end
  end

end