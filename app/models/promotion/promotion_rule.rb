class Promotion::PromotionRule < ActiveRecord::Base
  # table name
  self.table_name = 'promotion_rules'
  # extends ...................................................................
  # includes ..................................................................
  # constants .................................................................
  # related macros ............................................................
  # relationships .............................................................
  belongs_to :promotion
  # validations ...............................................................
  validates :type_name, presence: true
  validates :preferences, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # other macros (like devise's) ..............................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end