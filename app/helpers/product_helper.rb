module ProductHelper
  def monetize(number)
    number_to_currency(number, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
  def installments_format(v, i)
   "#{i}X #{monetize(v.to_f / i)}" if i > 0     
  end
end
