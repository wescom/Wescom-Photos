if Rails.env == "development"
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device = File.open(Rails.root.join("log","active_merchant.log"), "a+")
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device.sync = true
  ActiveMerchant::Billing::Base.mode = :test

  login = "JF4279-06"
  password="6I3dPIjyqGoD3WAUDGONJgq8sEbKp7TI"
elsif Rails.env == "production"
  login = 'JF4279-06'
  password='Go2yskAM!'
end
GATEWAY = ActiveMerchant::Billing::FirstdataE4Gateway.new({
      login: login,
      password: password
})