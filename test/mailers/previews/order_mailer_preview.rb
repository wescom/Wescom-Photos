# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Confirmation of submission
  def order_confirmation
    OrderMailer.order_confirmation(Order.first)
  end
  
  # Order history
  def order_history
    time_period = Date.today.last_month.strftime("%B")
    
    OrderMailer.order_history(Order.where(:success => true).order("created_at desc"),time_period)
  end
end
