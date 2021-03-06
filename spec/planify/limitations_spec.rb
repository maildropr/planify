require "spec_helper"

describe Planify::Limitations do
  describe ".set" do

    context "when specfied class does not include the Limitable module" do
      it "raises ArgumentError" do
        expect { subject.set(Object, 100) }.to raise_exception(ArgumentError)
      end
    end

    context "with a class constant" do
      it "sets the limitation for the given class" do
        subject.set(Post, 100)
        subject.get(Post).should eq 100
      end
    end

    context "with a class instance" do
      it "sets the limitation for the instance class" do
        @post = Post.new

        subject.set(@post, 100)
        subject.get(Post).should eq 100
      end
    end

    context "with a module" do
      it "sets the limitation for the module" do
        module Foo; end
        Foo.send(:include, Planify::Limitable)

        subject.set(Foo, 200)
        subject.get(Foo).should eq 200
      end
    end

    context "with a string" do
      context "string represents a constant name" do
        it "sets the limitation for the constant" do
          subject.set("Post", 100)
          subject.get(Post).should eq 100
        end
      end

      context "string does not represent a constant name" do
        it "raises NameError" do
          expect { subject.set("Not a class", 100) }.to raise_exception(NameError)
        end
      end
    end

    context "with a symbol" do
      context "symbol represents a constant name" do
        it "sets the limitation for the constant" do
          subject.set(:post, 100)
          subject.get(Post).should eq 100
        end
      end

      context "symbol does not represent a constant name" do
        it "raises NameError" do
          expect { subject.set(:non_class, 100) }.to raise_exception(NameError)
        end
      end
    end 
  end # .set

  describe ".get" do

    context "when class limit is defined" do
      before { subject.set(:post, 100) }
      it "returns the limit" do
        subject.get(Post).should == 100
      end
    end

    context "when class limit is undefined" do
      it "returns the default value" do
        subject.get(User, 1).should == 1
      end
    end

  end # .get
end