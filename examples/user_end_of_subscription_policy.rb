# frozen_string_literal: true

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

User = Struct.new(:end_of_subscription_at, :check_subscription)
