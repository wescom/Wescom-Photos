module OrdersHelper
  def months
    (1..12).collect{|n| ["#{n}", n]}
  end

  def years
    (Time.now.year..Time.now.year+15)
  end
  
  def amount_not_zero?
    if @order.amount > 0
      return true
    else
      return false
    end
  end
  
end
