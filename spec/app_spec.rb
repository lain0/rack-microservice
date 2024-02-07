# frozen_string_literal: true

require 'rspec'
require_relative '../app/app'

# rubocop:disable Style/StringLiterals
RSpec.describe Application do
  let(:app) { described_class.new }
  let(:env) { {
    "CONTENT_TYPE" =>
    'application/json',
    "REQUEST_METHOD" => "GET",
    "PATH_INFO" => "/",
    "rack.input" => StringIO.new("") }
  }
  let(:response) { app.call(env) }
  let(:status)   { response[0] }
  let(:body)     { response[2][0] }

  describe "get to /" do
    it do
      expect(status).to eq 200
    end

    it 'body contains status 200' do
      expect(body).to eq "{\"data\":{},\"status\":200}"
    end
  end

  # describe "get to /users" do
  #   let(:env) { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/users", "rack.input"=> StringIO.new("") } }

  #   it "returns the body OK" do
  #     expect(status).to eq 200
  #   end
  # end

  describe "post to /users/create" do
    context 'with no input params 400' do
      let(:env) { { "REQUEST_METHOD" => "POST", "PATH_INFO" => "/users/create", "rack.input" => StringIO.new("") } }

      it do
        expect(status).to eq 400
      end
    end
  end

  describe "put to /users/create" do
    context 'with not allowed method 405' do
      let(:env) { { "REQUEST_METHOD" => "PUT", "PATH_INFO" => "/users/create", "rack.input" => StringIO.new("") } }

      it do
        expect(status).to eq 405
      end
    end
  end
end

# rubocop:enable Style/StringLiterals
