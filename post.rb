class Post
  include Mongoid::Document
  
  field :p_id, type: Integer
  field :a_id, type: Integer
  field :t, type: String
  field :action_id, type: Integer
  store_in collection: "randomevent", database: "amura"
end

#class Second < Post
#	field :u_id, type: Integer
 #  store_in collection: "events", database: "amura"
#end
