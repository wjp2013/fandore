class Product::ProductOptionType < ActiveRecord::Base
  # table name
  self.table_name = 'product_option_types'
  # extends ...................................................................
  acts_as_list scope: :product
  # includes ..................................................................
  # constants .................................................................
  # related macros ............................................................
  # relationships .............................................................
  belongs_to :product, inverse_of: :product_option_types
  belongs_to :option_type, inverse_of: :product_option_types
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # other macros (like devise's) ..............................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
