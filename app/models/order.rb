class Order < ActiveRecord::Base
  # table name
  # extends ...................................................................
  # includes ..................................................................
  include OrderStates
  # constants .................................................................
  # related macros ............................................................
  attr_accessor :use_shipping
  # relationships .............................................................
  # belongs_to :store
  belongs_to :user
  belongs_to :created_by, class_name: 'User'
  belongs_to :approver, class_name: 'User'
  belongs_to :canceler, class_name: 'User'

  belongs_to :billing_address, class_name: 'User::Address'
  belongs_to :shipping_address, class_name: 'User::Address'

  has_many :line_items, dependent: :destroy, inverse_of: :order
  has_many :variants, through: :line_items
  has_many :products, through: :variants
  # has_many :payments, dependent: :destroy
  # has_many :refunds, through: :payments
  # has_many :return_authorizations, dependent: :destroy, inverse_of: :order
  # has_many :reimbursements, inverse_of: :order
  # has_many :adjustments, -> { order("#{Adjustment.table_name}.created_at ASC") }, as: :adjustable, dependent: :destroy
  # has_many :line_item_adjustments, through: :line_items, source: :adjustments
  # has_many :shipment_adjustments, through: :shipments, source: :adjustments
  # has_many :inventory_units, inverse_of: :order

  # has_and_belongs_to_many :promotions, join_table: 'orders_promotions'
  # has_many :shipments, dependent: :destroy, inverse_of: :order

  # validations ...............................................................
  # callbacks .................................................................
  before_validation :clone_shipping_address, if: :use_shipping?
  before_create :create_token
  before_create :link_by_email
  # scopes ....................................................................
  # other macros (like devise's) ..............................................
  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address
  # accepts_nested_attributes_for :payments
  # accepts_nested_attributes_for :shipments
  # class methods .............................................................
  # public instance methods ...................................................
  def shipping_address
    super || build_shipping_address(user_id: user_id)
  end

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      #NOTE: 这里应该改成 购物车假删除, 并且购物车删除，不删除关联的 line items
      item.cart_id = nil
      line_items << item
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def link_by_email
    self.email = user.email if self.user
  end

  def clone_shipping_address
    if shipping_address && billing_address.nil?
      self.billing_address = shipping_address.clone
    else
      self.billing_address.attributes = shipping_address.attributes.except('id', 'updated_at', 'created_at')
    end
    true
  end

  def create_token
    self.guest_token ||= loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(guest_token: random_token)
    end
  end

  def use_shipping?
    # @use_shipping == true || @use_shipping == 'true' || @use_shipping == '1'
    @use_shipping == true
  end

end
