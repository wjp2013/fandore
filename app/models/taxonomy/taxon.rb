class Taxonomy::Taxon < ActiveRecord::Base
  # table name
  self.table_name = 'taxons'
  # extends ...................................................................
  has_ancestry
  # includes ..................................................................
  # constants .................................................................
  # related macros ............................................................
  # relationships .............................................................
  belongs_to :taxonomy, inverse_of: :taxons
  has_many :classifications, -> { order(:position) }, dependent: :delete_all, inverse_of: :taxon
  has_many :products, through: :classifications
  # validations ...............................................................
  validates :name, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :goods, -> { where.not(name: '钻石')}
  scope :diamond, -> { find_by(name: '钻石')}
  # other macros (like devise's) ..............................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
