class OrdersAccountingMailer < ApplicationMailer
  default :from => DefaultSetting.first.confirmation_from_email

  # Confirmation of submission
  def orders_previous_month()
    subject = "WescomPhotos.com - Orders"
    mail(to: 'shoffmann@bendbulletin.com', subject: subject)
  end

end
