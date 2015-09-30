module ReportsHelper

  def filter_label(filter)
    case filter
    when 'yesterday'
      'Yesterday'
    when 'last_7_days'
      'Last 7 Days'
    when 'this_month'
      'This Month'
    when 'last_month'
      (Date.today - 1.months).strftime("%B %Y")
    when 'last_2_month'
      (Date.today - 2.months).strftime("%B %Y")
    end
  end

end