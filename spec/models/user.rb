class User
  include Mongoid::Document
  include Planify::User

  field :name, default: "John"
end