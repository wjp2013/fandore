class User < ActiveRecord::Base
  # extends ...................................................................
  has_secure_password
  has_one_time_password length: 6
  # includes ..................................................................
  # constants .................................................................
  # related macros ............................................................
  # relationships .............................................................
  has_one :profile
  has_many :verification_codes
  # validations ...............................................................
  validates :mobile, presence: true,
            uniqueness: true,
            format: { with: /\A(13[0-9]|15[0-9]|18[7-8])[0-9]{8}\z/ }
  validates :email,
            presence: true,
            uniqueness: true,
            length: { in: 6..20 },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  # callbacks .................................................................
  after_create :send_sms
  # scopes ....................................................................
  # other macros (like devise's) ..............................................
  accepts_nested_attributes_for :profile, update_only: true
  # class methods .............................................................
  # public instance methods ...................................................
  def profile
    super || build_profile
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def send_sms
    User::VerificationCode.send_verification_code(self.mobile)
  end

end
