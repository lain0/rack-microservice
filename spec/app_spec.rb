# frozen_string_literal: true

require 'rspec'
require_relative '../app/app'

# rubocop:disable Style/StringLiterals

RSpec.describe Application do
  let(:app)      { Application.new }
  let(:env)      { {
    "CONTENT_TYPE" =>
    'application/json',
    "REQUEST_METHOD" => "GET",
    "PATH_INFO" => "/",
    "rack.input" => StringIO.new("") }
  }
  let(:response) { app.call(env) }
  let(:status)   { response[0] }
  let(:body)     { response[2][0] }

  context "get to /" do
    it "returns the status 200" do
      expect(status).to eq 200
    end

    it "returns the body OK" do
      expect(body).to eq "{\"data\":{},\"status\":200}"
    end
  end

  # describe "get to /users" do
  #   let(:env)      { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/users", "rack.input"=> StringIO.new("") } }

  #   it "returns the body OK" do
  #     expect(status).to eq 200
  #     expect(body).to eq "{:items=>[]}"
  #   end
  # end

  describe "post to /users" do
    context 'with no input params 405' do
      let(:env)      { { "REQUEST_METHOD" => "POST", "PATH_INFO" => "/users/create", "rack.input" => StringIO.new("") } }

      it "returns the body OK" do
        expect(status).to eq 405
        expect(body).to eq "{\"errors\":[{\"status\":405,\"message\":\"Method not allowed: POST\"}]}"
      end
    end
  end
end

# rubocop:enable Style/StringLiterals
