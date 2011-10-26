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
    @password ||= Password.new(password_hash)
  end
  
  def password=(new_password)
    self.password_hash = Password.create(new_password)
  end
end