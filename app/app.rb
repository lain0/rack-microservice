# frozen_string_literal: true

require 'pry'
require 'json/ext'
require 'puma'
require 'rack/content_type'
require 'rackup/server'

require_relative 'db'
require_relative 'user'
require_relative 'json_validation'

class Application # rubocop:disable Style/Documentation
  def call(env)
    rack_input = env['rack.input'].read
    params = rack_input.empty? ? false : JSON.parse(rack_input)
    handle(env['REQUEST_METHOD'], env['PATH_INFO'], params)
  end

  private

  def handle(method, path, params)
    if method == 'GET'
      get(path)
    elsif method == 'POST' && params
      post(path, params)
    else
      method_not_allowed(method)
    end
  end

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

  def method_not_allowed(method)
    [405, {}, [{ errors: [status: 405, message: "Method not allowed: #{method}"]}.to_json]]
  end

  def not_found(path)
    [404, {}, [{ errors: [status: 404, source: path.to_s ]}.to_json]]
  end

  def id(path)
    path.split('/').reject(&:empty?)[1]
  end

  def render(data, hash = {})
    result = { data: data }.merge(hash).to_json
    [200, {}, [result]]
  end

  # def headers
  #   { 'content-type' => 'application/json',
  #     'charset' => 'UTF-8'
  #   }
  # end

  def user_create(params)
    # binding.pry

    return [400, {}, [{ errors: [status: 400, message: JsonValidation.errors(params)] }.to_json]] unless JsonValidation.call(params)

    user = User.new(params)
    if user.valid? && user.errors.empty?
      data = user.save
      [201, {}, [{ data: data, source: "/users/#{data.id}" }.to_json]]
    else
      [422, {}, [{ errors: [status: 422, message: user.errors] }.to_json]]
    end
  end
end
