Planify [![Build Status](https://secure.travis-ci.org/kdayton-/planify.png?branch=master)](http://travis-ci.org/kdayton-/planify) [![Code Climate](https://codeclimate.com/github/kdayton-/planify.png)](https://codeclimate.com/github/kdayton-/planify)
========

Make subscription plans and enforce their limits with Planify.

## Requirements

Ruby:
* 1.9.3
* 2.0.0
* JRuby (1.9 mode)
* Rubinius (1.9 mode)

Mongoid 3 (Support for other ORMs will be a future improvement)

## Installation

Add this line to your application's Gemfile:

    gem 'planify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install planify

## Setup 

First, we'll define a `Limitable`. Limitables are classes which can be limited based on plan settings.

```ruby
# app/models/widget.rb
class Widget
  include Mongoid::Document
  include Planify::Limitable
  ...
end
```

Next we define a Plan. Plans hold information about how many instances of a Limitable can be created, as well as features which are available to users subscribed to this plan:

```ruby
# config/initializers/plans.rb
Planify::Plans.define :starter do
  max Widget, 100 # Can only create up to 100 widgets before needing to upgrade

  feature :ajax_search # Plan includes support for AJAX search
end
```

Next, create a User. Users have a Plan, and also store information about how many Limitables they have created.

```ruby
class User
  include Mongoid::Document
  include Planify::User

  has_plan :starter
end
```

## Usage

After creating your Limitables, Plan, and User models, you are ready to start tracking.

```ruby
# widgets_controller.rb

def create
  @user = current_user
  @widget = Widget.create(params[:widget])

  if @user.can_create? @widget # User has not hit their Widget cap
    @widget.save
    @user.created :widget
  end
end

def destroy
  @user = current_user
  @widget = Widget.find(params[:id])

  @widget.destroy
  @user.destroyed @widget
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
