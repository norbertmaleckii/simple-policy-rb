# SimplePolicy

Policy system for Ruby with awesome features!

Helps you to define policy in a simple way. Define your policies in classses, it means you can separate them from models and reuse them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_policy'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install simple_policy

## Usage

Policies are defined as plain Ruby classes. For rails usage you can put definitions inside `app/policies` folder.

When we want define basic policy class, simply do that:

```ruby
class UserEndOfSubscriptionPolicy < SimplePolicy::Entity
  object_alias :user

  def call
    block_passed? && correct_action? && end_of_subscription?
  end

  def block_passed?
    return true unless block

    instance_eval(&block)
  end

  def correct_action?
    options[:action] == 'games/play'
  end

  def end_of_subscription?
    user.end_of_subscription_at < Time.now
  end
end
```

After that we can use our policy for one object:

```ruby
User = Struct.new(:end_of_subscription_at, :check_subscription)

user = User.new(Time.now - (60 * 60 * 24), false)

UserEndOfSubscriptionPolicy.applies_to?(user, action: 'games/play')
#=> true

UserEndOfSubscriptionPolicy.applies_to?(user, action: 'games/play') { user.check_subscription }
#=> false
```

Or for collection:

```ruby
User = Struct.new(:end_of_subscription_at, :check_subscription)

users = Array.new(5) { |i| User.new(Time.now - (60 * 60 * 24 * (i - 2)), false) }

UserEndOfSubscriptionPolicy.applies_to_all?(users, action: 'games/play')
#=> false

UserEndOfSubscriptionPolicy.applies_to_all?(users, action: 'games/play') { user.check_subscription }
#=> false

UserEndOfSubscriptionPolicy.applies_to_any?(users, action: 'games/play')
#=> true

UserEndOfSubscriptionPolicy.applies_to_any?(users, action: 'games/play') { user.check_subscription }
#=> false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/norbertmaleckii/simple-policy-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/norbertmaleckii/simple-policy-rb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimplePolicy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/norbertmaleckii/simple-policy-rb/blob/main/CODE_OF_CONDUCT.md).
