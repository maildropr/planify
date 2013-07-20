require "spec_helper"

describe Planify::ClassHelper do
  subject { Object.new.extend(Planify::ClassHelper) }

  describe ".normalize_class" do
    context "with a class constant" do
      it "returns a string representation" do
        subject.normalize_class(Post).should == "Post"
      end
    end

    context "with a class instance" do
      it "returns a string representation of the instance's class" do
        subject.normalize_class(Post.new).should == "Post"
      end
    end

    context "with a module" do
      it "returns a string representation of the module's name" do
        module Foo; end
        subject.normalize_class(Foo).should == "Foo"
      end
    end

    context "with a string" do
      context "string represents a constant name" do
        it "returns itself" do
          subject.normalize_class("Post").should == "Post"
        end
      end

      context "string does not represent a constant name" do
        it "raises NameError" do
          expect { subject.normalize_class("Not::ARealClass") }.to raise_exception(NameError)
        end
      end
    end

    context "with a symbol" do
      context "symbol represents a constant name" do
        it "returns a string representation of the symbol" do
          subject.normalize_class(:post).should == "Post"
        end
      end

      context "symbol does not represent a constant name" do
        it "raises NameError" do
          expect { subject.normalize_class(:not_a_class) }.to raise_exception(NameError)
        end
      end
    end


  end
end
