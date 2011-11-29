module App
  module Model
    class User < Sequel::Model

      plugin :schema

      unless table_exists?
        set_schema do
          primary_key :id
          String :name, null: false
          String :password, null: false
        end

        create_table
      end

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
  end
end
