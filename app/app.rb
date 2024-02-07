# frozen_string_literal: true

require 'json/ext'
require 'puma'
require 'rack/content_type'
require 'rackup/server'

require_relative 'db'
require_relative 'user'
require_relative 'json_validation'

class Application
  def call(env)
    req_method = env['REQUEST_METHOD']
    path = env['PATH_INFO']
    case req_method
    when 'GET'
      get(path)
    when 'POST'
      rack_input = env['rack.input'].read
      params = rack_input.empty? ? {} : JSON.parse(rack_input)
      if JsonValidation.call(params)
        post(path, params)
      else
        wrong_params(params)
      end
    else
      method_not_allowed(req_method)
    end
  end

  private

  def get(path)
    case path
    when '/'
      data = {}
      status = { status: 200 }
      render(data, status)
    when *["/users", "/users/"]
      data = User.all
      render data
    when /\/users\/\d/
      data = User[id(path)]
      if data.nil?
        not_found(path)
      else
        render data
      end
    else
      not_found(path)
    end
  end

  def post(path, params)
    case path
    when '/users/create'
      user_create(params)
    else
      not_found(path)
    end
  end

  def method_not_allowed(req_method)
    [405, {}, [{ errors: [status: 405, message: "Method not allowed: #{req_method}"] }.to_json]]
  end

  def not_found(path)
    [404, {}, [{ errors: [status: 404, source: path.to_s] }.to_json]]
  end

  def id(path)
    path.split('/').reject(&:empty?)[1]
  end

  def render(data, hash = {})
    result = { data: }.merge(hash).to_json
    [200, {}, [result]]
  end

  def wrong_params(params)
    [400, {}, [{ errors: [status: 400, message: JsonValidation.errors(params)] }.to_json]]
  end

  def user_create(params)
    user = User.new(params)
    if user.valid? && user.errors.empty?
      data = user.save
      [201, {}, [{ data:, source: "/users/#{data.id}" }.to_json]]
    else
      [422, {}, [{ errors: [status: 422, message: user.errors] }.to_json]]
    end
  end
end
