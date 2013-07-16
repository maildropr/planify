Planify [![Build Status](https://secure.travis-ci.org/kdayton-/planify.png?branch=master)](http://travis-ci.org/kdayton-/planify) [![Code Climate](https://codeclimate.com/github/kdayton-/planify.png)](https://codeclimate.com/github/kdayton-/planify)
========

Make subscription plans and enforce their limits with Planify.

## Requirements
* Ruby 1.9+
* Mongoid 3 (Support for other ORMs will be a future improvement)

## Installation

Add this line to your application's Gemfile:

    gem 'planify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install planify

## Setup 

First, create some Trackables. These are classes which will be limited by the user's plan. For instance, if we were making a blog SaaS:

```ruby
class Post
  include Mongoid::Document
  include Planify::Trackable
end
```

Next, create a Plan. Plans hold information about how many Trackables can be created, as well as features which are available to the user:

```ruby
class StarterPlan
  include Planify::Plan

  max Post, 100 # Can only create up to 100 posts before needing to upgrade

  feature :ajax_search # Plan includes support for AJAX search
end
```

Finally, create a User. Users have a Plan, and also store information about how many Trackables they have created.

```ruby
class User
  include Mongoid::Document
  include Planify::User

  has_plan StarterPlan
end
```

## Usage

After creating your Trackables, Plan, and User models, you are ready to start tracking.

```ruby
# posts_controller.rb

def create
  @user = current_user
  @post = Post.create(params[:post])

  if @user.can_create? @post # User has not hit their Post cap
    @post.save
    @user.created :post
  end
end

def destroy
  @user = current_user
  @post = Post.find(params[:id])

  @post.destroy
  @user.destroyed Post
end
```

You can also test for features:

```ruby
# _nav.haml

-if current_user.has_feature? :ajax_search
  =ajax_search_form
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add some specs (so I don't accidentally break your feature in the future)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
