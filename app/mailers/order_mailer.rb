class OrderMailer < ApplicationMailer
  default :from => DefaultSetting.first.confirmation_from_email

  # Confirmation of submission
  def order_confirmation(order)
    @order = order
		
    subject = "Wescom Photos - Order Confirmation #{@order.id}"
    mail(to: @order.email, subject: subject)
  end
  
  # Order history
  def order_history(orders,time_period)
    @orders = orders
    @time_period = time_period
    @orders_total = orders.sum(:amount)

    subject = "WescomPhotos.com - #{time_period} Orders"
    mail(to: 'shoffmann@bendbulletin.com', subject: subject)
  end
  
  
end
