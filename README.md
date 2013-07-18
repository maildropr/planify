Planify [![Build Status](https://secure.travis-ci.org/kdayton-/planify.png?branch=master)](http://travis-ci.org/kdayton-/planify) [![Code Climate](https://codeclimate.com/github/kdayton-/planify.png)](https://codeclimate.com/github/kdayton-/planify) [![Coverage Status](https://coveralls.io/repos/kdayton-/planify/badge.png)](https://coveralls.io/r/kdayton-/planify)
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

Next, create a User class with the `Planify::User` mixin. This will add `Limitable` counting and plan storage.

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


## Usage

After creating your Limitables, Plan, and User models, you are ready to start enforcing limits.

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

## Rails Integration

Planify includes a Rails mixin, which adds some useful features to your controllers. To use it, include `Planify::Integrations::Rails` in your `ApplicationController`:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Planify::Integrations::Rails
  ...
end
```

This will include two methods: `enforce_limit!` and `limit_exceeded!`. `enforce_limit!` will call `limit_exceeded!` if the user is over their limit.

```ruby
# app/controllers/widget_controller.rb
class WidgetController < ApplicationController
  before_filter :enforce_widget_limit, only: [:new, :create]

  ...

  private

  def enforce_widget_limit
    enforce_limit! current_user, Widget
  end
end
```

If the user's Widget limit is exceeded it will raise an exception.

You can change this behavior by creating your own `limit_exceeded!` method in your ApplicationController.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Planify::Integrations::Rails
  
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
