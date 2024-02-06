
# ToDo
[x] README
[x] how to run
[ ] tests
[X] get/post endpoints
[X] db vs validations
[X] validate json schema
[ ] auth
[X] docker-compose


## how to run locally:
```sh
rake rack:up

# run with webrick server:
RACKUP_HANDLER=webrick rake rack:up
```
## how to run in docker:
```sh
rake docker:up
```

## run tests locally:
```sh
rake test:rspec
rake test:post:fail test:post:json_fail
```

## run tests in docker:
```sh
rake docker:rspec
```
