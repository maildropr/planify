Planify [![Build Status](https://secure.travis-ci.org/maildropr/planify.png?branch=master)](http://travis-ci.org/maildropr/planify) [![Code Climate](https://codeclimate.com/github/maildropr/planify.png)](https://codeclimate.com/github/maildropr/planify) [![Coverage Status](https://coveralls.io/repos/maildropr/planify/badge.png)](https://coveralls.io/r/maildropr/planify) [![Gem Version](https://badge.fury.io/rb/planify.png)](http://badge.fury.io/rb/planify)
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

### Limitables
Limitables are classes which can be limited based on plan settings. To create a limitable, include the `Planify::Limitable` mixin in your class.

```ruby
# app/models/widget.rb
class Widget
  include Mongoid::Document
  include Planify::Limitable
  ...
end
```

### Plans
Plans hold information about how many instances of a `Limitable` can be created, as well as which features are available to users subscribed to this plan:

```ruby
# config/initializers/plans.rb
Planify::Plans.define :starter do
  max Widget, 100 # Can only create up to 100 widgets before needing to upgrade

  feature :ajax_search
end
```

### Users
Add the `Planify::User` mixin to your user class. This will keep track of how many limitables the user has created, as well as their plan and plan overrides:

```ruby
class User
  include Mongoid::Document
  include Planify::User
  ...
end
```

Then assign the user a plan:

```ruby
@user = User.create
@user.has_plan :starter
```

You can also assign user-specific overrides to plan limits and features:

```ruby
# This user has half the widgets and no ajax-search
@user.has_plan :starter do
  max Widget, 50
  feature :ajax_search, false
end
```

## Usage

After creating your Limitables, Plans, and User, you are ready to start enforcing limits.

```ruby
# widgets_controller.rb

def create
  @user = current_user

  if @user.can_create? Widget # User has not hit their Widget cap
    @widget = Widget.create(params[:widget])
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

## Rails Integration

When used inside a Rails project, Planify automatically adds two methods to your controllers: `enforce_limit!` and `limit_exceeded!`. `enforce_limit!` will call `limit_exceeded!` if the user is over their limit.

```ruby
# app/controllers/widget_controller.rb
class WidgetController < ApplicationController
  before_filter :enforce_widget_limit, only: [:new, :create]

  ...

  private

  def enforce_widget_limit
    # If the user's Widget limit is exceeded, limit_exceeded! will be called
    enforce_limit! current_user, Widget
  end
end
```

The default behavior of `limit_exceeded!` is to raise an Exception. You can change this behavior by creating your own `limit_exceeded!` method in your `ApplicationController`.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  def limit_exceeded!
    redirect_to upgrade_plan_url, notice: "You must upgrade your account!"
  end
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add some specs (so I don't accidentally break your feature in the future)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
