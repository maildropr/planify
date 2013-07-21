require "spec_helper"
require "planify/integrations/rails"

METHODS = [
  :enforce_limit!,
  :limit_exceeded!
]

module ActionController
  class Base
    def self.helper(*args); end
  end
end

describe Planify::Integrations::Rails do
  subject { ActionController::Base.send(:include, Planify::Integrations::Rails) }

  describe ".included" do
    it "it adds controller methods to ActionController::Base" do
      METHODS.each do |method|
        subject.should respond_to method
      end
    end
  end

  describe ".enforce_limit!" do
    let(:user) { User.new }
    before do
      Planify::Plans.define :starter do
        max Post, 1
      end

      user.has_plan :starter
    end

    context "user is over their quota" do
      before { user.created Post }

      it "calls limit_exceeded!" do
        subject.should_receive(:limit_exceeded!)
        subject.enforce_limit! user, Post
      end
    end

    context "user is under their quota" do
      it "returns nil" do
        subject.should_not_receive(:limit_exceeded!)
        subject.enforce_limit!(user, Post).should be_nil
      end
    end
  end

  describe ".limit_exceeded!" do
    it "raises exception" do
      expect { subject.limit_exceeded! }.to raise_error
    end
  end

end