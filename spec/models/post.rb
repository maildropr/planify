class Post
  include Mongoid::Document
  include Planify::Limitable
end