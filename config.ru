# frozen_string_literal: true

require_relative 'app/app'

use Rack::ContentType, 'application/json'
run Application.new
