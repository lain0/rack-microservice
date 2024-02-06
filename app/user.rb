# frozen_string_literal: true

require 'sequel/plugins/serialization'
require 'sequel/plugins/validation_helpers'

class User < Sequel::Model
  plugin :json_serializer
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :email, :age], message: 'was not given'
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    validates_type String, [:name, :email]
    validates_type Integer, :age
    validates_unique(:name, :email)
  end
end
