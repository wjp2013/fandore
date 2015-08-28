module OrderStates
  extend ActiveSupport::Concern

  included do

    include AASM

    enum state: {
      checkout: 0,
      # addressed: 2,
      # invoiced: 4,
      # shipmented: 6,
      pending: 10,
      paid: 20,
      filtered: 30,
      inlaided: 40,
      packed: 50,
      delivered: 60,
      completed: 70,
      canceled: 90,
      closed: 90,
      resumed: 100
    }

    aasm column: :state, enum: true do

      state :checkout, initial: true
      state :pending
      state :paid
      state :filtered
      state :inlaided
      state :packed
      state :delivered
      state :completed
      state :canceled
      state :closed
      state :resumed

      event :pay, after: :notify_to_client do
        transitions form: :pending, to: :paid
      end

      event :filter, after: :notify_to_client do
        transitions form: :paid, to: :filtered
      end

      event :inlaid, after: :notify_to_client do
        transitions form: :filtered, to: :inlaided
      end

      event :pack, after: :notify_to_client do
        transitions form: :inlaided, to: :packed
      end

      event :delivery, after: :notify_to_client do
        transitions form: [:paid, :packed], to: :delivered, guard: :has_payment?
      end

      event :complete do
        transitions form: :delivery, to: :completed
      end

      event :cancel do
        transitions form: :pending, to: :canceled
      end

      event :closed do
        transitions form: [:pending, :completed], to: :closed
      end

      event :resume do
        # transitions form: :closed, to: :resumed
        transitions form: :closed, to: :pending
      end

    end

    # TODO: 这里需要验证订单确实已经付款过，拥有 payments
    def has_payment?
      true
    end

    # TODO: 这里需要给客户发送通知
    def notify_to_client
      true
    end

  end

  module ClassMethods
  end

  private
end