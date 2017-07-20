class Order < ApplicationRecord
  require "active_merchant/billing/rails"
  before_create :generate_guid
  before_create :generate_random_id
  
  has_many :order_items, :dependent => :destroy

  attr_accessor :card_security_code
  attr_accessor :credit_card_number
  attr_accessor :expiration_month
  attr_accessor :expiration_year
  attr_accessor :terms_of_service

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :card_security_code, presence: true
  validates :credit_card_number, presence: true
  validates :expiration_month, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :expiration_year, presence: true
  validate  :expire_after_today
  validates :terms_of_service, acceptance: true
#  validate :validate_card

  def to_param
    obscure_uniq_identifier
  end
  
  def generate_guid
    self.obscure_uniq_identifier = SecureRandom.hex
  end
  
  def generate_random_id
    self.id = SecureRandom.random_number(1_000_000)
  end
  
  def purchase(cart)
    # Create list of items purchased
    @items = Array.new      
    cart.cart_items.each do |i|
      item = Hash.new 
      item[:name] = i[:item_type]+" #"+i[:item_id].to_s
      item[:description] = ""
      item[:quantity] = i[:quantity]
      item[:amount] = i[:price_cents]
      @items << item
    end
    Rails.logger.info "Items: " + @items.inspect
    @subtotal = amount
    
    # Process credit card payment
    response = GATEWAY.purchase(amount*100.round, credit_card, purchase_options)
    Rails.logger.info "Gateway response: "+response.inspect
    self.success = response.success? ? true : false
    self.authorization_code = response.authorization
    response.success?
  end
  
  private
  
  def purchase_options
    {
      :items => @items,
      :total => @subtotal, 
      :ip => "216.228.167.10",
      :description => "WescomPhotos.com purchase",
#      :billing_address => {
#        :name     => "The Bulletin",
#        :address1 => "1777 SW Chandler Ave",
#        :city     => "Bend",
#        :state    => "OR",
#        :country  => "US",
#        :zip      => "97701"
#      }
    }
  end
  
  def expire_after_today
    if expiration_year.to_i > Date.today.year
      return true
    else
      if expiration_month.to_i >= Date.today.month
        return true
      else
        errors.add(:expiration_month, "not valid")
        return false
      end
    end
  end
  
  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      # :type               => card_type,
      :number             => credit_card_number,
      :verification_value => card_security_code,
      :month              => expiration_month,
      :year               => expiration_year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end
end
