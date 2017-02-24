class Order < ApplicationRecord
  require "active_merchant/billing/rails"
  
  has_many :order_items, :dependent => :destroy

  attr_accessor :card_security_code
  attr_accessor :credit_card_number
  attr_accessor :expiration_month
  attr_accessor :expiration_year

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :card_security_code, presence: true
  validates :credit_card_number, presence: true
  validates :expiration_month, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :expiration_year, presence: true

  validate :valid_card

  def credit_card
    ActiveMerchant::Billing::CreditCard.new(
      number:              credit_card_number,
      verification_value:  card_security_code,
      month:               expiration_month,
      year:                expiration_year,
      first_name:          first_name,
      last_name:           last_name
    )
  end

  def valid_card
    if !credit_card.valid?
      errors.add(:base, "The credit card information you provided is not valid.  Please double check the information you provided and then try again.")
      false
    else
      true
    end
  end

  def process
    if valid_card
      response = GATEWAY.authorize(amount * 100, credit_card)
      #puts "****** Gateway Response ******* "+response.inspect
      if response.success?
        transaction = GATEWAY.capture(amount * 100, response.authorization)
        #puts "****** Transaction ******* "+transaction.inspect
        if !transaction.success?
          errors.add(:base, "The credit card you provided was declined.  Please double check your information and try again.") and return
          return false
        end
        update_columns({authorization_code: transaction.authorization, success: true})
        return true
      else
        errors.add(:base, "The credit card you provided was declined.  Please double check your information and try again.") and return
        return false
      end
    end
  end
end
