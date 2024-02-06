# frozen_string_literal: true

require 'pg'
require 'sequel'

pg_server_port = ENV['DOCKER_ENV'] == 'true' ? 'db:5432' : '127.0.0.1:15432'
DB = Sequel.connect("postgres://green_atom:green_atom@#{pg_server_port}/users")

unless DB.table_exists?(:users)
  DB.create_table :users do
    primary_key :id
    String :name, null: false, unique: true
    String :email, null: false, unique: true
    Integer :age, null: false

    Timestamp :created_at, null: false, default: Sequel.lit('now()')
  end
end
