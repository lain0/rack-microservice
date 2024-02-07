# frozen_string_literal: true

namespace :docker do
  desc 'docker build'
  task :build do
    sh 'docker compose build'
  end

  desc 'docker up pg'
  task :up_pg do
    sh 'docker compose up -d db'
  end

  desc 'docker up'
  task :up do
    sh 'docker compose up -d && docker compose logs -f '
  end

  desc 'docker stop'
  task :stop do
    sh 'docker compose stop'
  end

  namespace :stop do
    desc 'docker stop rack'
    task :rack do
      sh 'docker compose stop rack'
    end
  end

  desc 'docker recreate'
  task :recreate do
    sh 'docker compose stop rack && docker compose build --no-cache rack'
  end

  desc 'docker rspec'
  task :rspec do
    sh 'docker exec -it gr-my-rack rake test:rspec'
  end
end

namespace :test do
  desc 'rspec app'
  task :rspec do
    sh 'rspec spec --format documentation '
  end

  namespace :post do
    require 'json/ext'
    # curl -X POST -H "content-type: application/json" -d '{"name": "New User", "age": 30, "email": "new@user.ru"}' http://localhost:9292/users/create
    desc 'curl post new OK'
    task :new do
      age = rand(100)
      data = { name: "user#{age}", age: age, email: "user#{age}@example.ru" }
      sh "curl -X POST -H 'content-type: application/json' -d \'#{data.to_json}\' http://localhost:9292/users/create"
    end

    desc 'curl post empty'
    task :empty do
      data = {}
      sh "curl -X POST -H 'content-type: application/json' http://localhost:9292/users/create"
    end

    desc 'curl post fail'
    task :fail do
      data = { name: 'New User', age: 30, email: 'new@user.ru' }
      sh "curl -X POST -H 'content-type: application/json' -d \'#{data.to_json}\' http://localhost:9292/users/create"
    end

    desc 'curl post json schema fail'
    task :json_fail do
      data = { name: 'New User', age: 30, emal: 'new@user.ru' }
      sh "curl -X POST -H 'content-type: application/json' -d \'#{data.to_json}\' http://localhost:9292/users/create"
    end
  end
end

namespace :rack do
  desc 'rack up'
  task :up do
    sh 'bundle exec rackup config.ru'
  end
end
