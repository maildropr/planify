require "spec_helper"

describe Planify::User, focus: false do
  subject { User.new }
  before(:each) do
    Planify::Plans.define :starter do
      max Post, 100
      feature :ajax_search
    end

    subject.has_plan :starter
  end

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

  describe ".can_create?" do
    before { subject.plan.max(Post, 1) }
    
    it "should return true if limit for class is not reached" do
      subject.can_create?(Post).should be_true
    end

    it "should return false if limit for class is exceeded" do
      subject.created Post
      subject.can_create?(Post).should be_false
    end
  end

  describe ".has_feature?" do
    it "returns true if the users plan has the given feature enabled" do
      subject.has_feature?(:ajax_search).should be_true
    end

    it "returns false if the users plan does not have the feature" do
      subject.has_feature?(:dne_feature).should be_false
    end

    it "returns false if the feature is disabled for the users plan" do
      subject.plan.feature(:ajax_search, false)
      subject.has_feature?(:ajax_search).should be_false
    end
  end

  describe ".created" do
    it "should increase the creation count for the given limitable" do
      expect { subject.created Post }.to change{ subject.creation_count(Post) }.by(1)
    end

    it "should persist the change" do
      subject.save!
      subject.created Post

      user = User.find(subject.id)
      user.creation_count(Post).should == 1
    end
  end

  describe ".destroyed" do
    before { subject.created Post }
    it "should decrease the creation count for the given limitable" do
      expect { subject.destroyed Post }.to change{ subject.creation_count(Post) }.by(-1)
    end

    it "should persist the change" do
      subject.save!
      subject.destroyed Post

      user = User.find(subject.id)
      user.creation_count(Post).should == 0
    end
  end

  describe ".creation_count" do
    before { subject.created(Post) }

    it "returns the number of limitable created" do
      subject.creation_count(Post).should == 1
    end
  end
end