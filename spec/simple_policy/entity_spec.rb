# frozen_string_literal: true

RSpec.describe SimplePolicy::Entity do
  subject(:user_end_of_subscription_policy_class) do
    Class.new(described_class) do
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
  end

  let(:user_class) do
    Struct.new(:end_of_subscription_at, :check_subscription)
  end

  let(:user) do
    user_class.new(Time.now - (60 * 60 * 24), false)
  end

  let(:users) do
    Array.new(5) { |i| user_class.new(Time.now - (60 * 60 * 24 * (i - 2)), false) }
  end

  describe '.applies_to?' do
    context 'without block' do
      it do
        expect(user_end_of_subscription_policy_class.applies_to?(user, action: 'games/play')).to be(true)
      end
    end

    context 'with block' do
      it do
        expect(user_end_of_subscription_policy_class.applies_to?(user, action: 'games/play') { user.check_subscription }).to be(false)
      end
    end
  end

  describe '.applies_to_all?' do
    context 'without block' do
      it do
        expect(user_end_of_subscription_policy_class.applies_to_all?(users, action: 'games/play')).to be(false)
      end
    end

    context 'with block' do
      it do
        expect(user_end_of_subscription_policy_class.applies_to_all?(users, action: 'games/play') { user.check_subscription }).to be(false)
      end
    end
  end

  describe '.applies_to_any?' do
    context 'without block' do
      it do
        expect(user_end_of_subscription_policy_class.applies_to_any?(users, action: 'games/play')).to be(true)
      end
    end

    context 'with block' do
      it do
        expect(user_end_of_subscription_policy_class.applies_to_any?(users, action: 'games/play') { user.check_subscription }).to be(false)
      end
    end
  end
end
