# rubocop-automata

[![CircleCI](https://circleci.com/gh/rvillage/rubocop-automata/tree/master.svg?style=svg)](https://circleci.com/gh/rvillage/rubocop-automata/tree/master)
[![Gem Version](https://badge.fury.io/rb/rubocop-automata.svg)](https://badge.fury.io/rb/rubocop-automata)

`rubocop-automata` is automation script for `rubocop --auto-correct` and create pull request.

By requesting a nightly build to CircleCI to execute this script, `rubocop --auto-correct` is invoked, then commit changes and create pull request to GitHub repository if there some changes exist.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-automata'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install rubocop-automata
```

## Usage

### Setting GitHub personal access token to CircleCI

GitHub personal access token is required for sending pull requests to your repository.

1. Go to [your account's settings page](https://github.com/settings/tokens) and generate a personal access token with "repo" scope
2. On CircleCI dashboard, go to your application's "Project Settings" -> "Environment Variables"
3. Add an environment variable `GITHUB_ACCESS_TOKEN` with your GitHub personal access token

### Configure circle.yml

Configure your `.circleci/config.yml` to run `rubocop-automata`, for example:

```yaml
version: 2

default: &default
  working_directory: /usr/src/app
  docker:
    - image: ruby:2.4.2-alpine3.6

jobs:
  checkout_code:
    <<: *default
    steps:
      - checkout
      - persist_to_workspace:
          root: /usr/src/app
          paths:
            - ./*

  bundle_dependencies:
    <<: *default
    steps:
      - attach_workspace:
          at: /usr/src/app
      - restore_cache:
          keys:
            - v1-bundler-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
            - v1-bundler-
      - run: apk --update --upgrade add --no-cache git openssh
      - run: bundle install -j4 --retry=3
      - save_cache:
          key: v1-bundler-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
          paths:
            - /usr/local/bundle

  auto_correction:
    <<: *default
    steps:
      - attach_workspace:
          at: /usr/src/app
      - restore_cache:
          key: v1-bundler-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
      - run: apk --update --upgrade add --no-cache git openssh curl
      - run: rubocop-automata [email] [username]

workflows:
  version: 2

  workflow:
    jobs:
      - checkout_code
      - bundle_dependencies:
          requires:
            - checkout_code
      - auto_correction:
          requires:
            - bundle_dependencies
          filters:
            branches:
              ignore:
                - /ci\/.*/
```

NOTE: Please make sure you replace `[email]`and `[username]` with yours.

### CLI command references

General usage:

```ruby
$ rubocop-automata [github email] [github username]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rvillage/rubocop-automata. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the rubocop-automata project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rvillage/rubocop-automata/blob/master/CODE_OF_CONDUCT.md).
