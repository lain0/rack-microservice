# frozen_string_literal: true

require 'json-schema'
require 'pry'

module JsonValidation
  module_function

  SCHEMA = {
    type: 'object',
    required: %w[age name email],
    properties: {
      age: {
        type: 'integer',
        minimum: 1,
        maximum: 100
      },
      name: {
        type: 'string'
      },
      email: {
        type: 'string'
      }
    }
  }.freeze

  # returns true/false
  def call(params)
    JSON::Validator.validate(SCHEMA, params)
  end

  # returns true/error message
  def errors(params)
    JSON::Validator.validate!(SCHEMA, params)
  rescue JSON::Schema::ValidationError => e
    e.message
  end
end
