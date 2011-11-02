class User < Sequel::Model
  
  plugin :validation_helpers
  
  def validate
    super
    validates_presence [:name, :password]
    validates_unique :name
  end
  
  def self.authenticate(name, password)
    user = self.first(name: name)
    user if user && user.password == password
  end
  
  include BCrypt
  
  def password
    Password.new(super)
  end
  
  def password=(new_password)
    super(Password.create(new_password))
  end
end