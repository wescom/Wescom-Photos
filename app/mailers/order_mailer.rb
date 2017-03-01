class OrderMailer < ApplicationMailer
  default :from => "shoffmann@wescomphotos.com"

  # Confirmation of submission
  def order_confirmation(order)
    @order = order
    subject = "Wescom Photos - Order Confirmation"
puts "********"+ENV["GMAIL_USERNAME"].to_s
    mail(to: @order.email, subject: subject)
  end

end
