class OrderMailer < ApplicationMailer
  default :from => AdminOrder.first.confirmation_from_email

  # Confirmation of submission
  def order_confirmation(order)
    @order = order
		
    subject = "Wescom Photos - Order Confirmation #{@order.id}"
    mail(to: @order.email, subject: subject)
  end
  
end
