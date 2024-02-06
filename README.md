
# Rack microservice

## ToDo
- [x] README
- [x] how to run
- [ ] how to test
- [X] get/post endpoints
- [X] db validations
- [X] json schema validate
- [ ] auth
- [X] docker-compose


## how to run locally:
```ruby
rake rack:up

# run with webrick server:
RACKUP_HANDLER=webrick rake rack:up
```
## how to run in docker:
```ruby
rake docker:up
```

## run tests locally:
```ruby
rake test:rspec
rake test:post:fail test:post:json_fail
```

## run tests in docker:
```ruby
rake docker:rspec
```
