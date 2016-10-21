module GroupsHelper

  def date_range(date=DateTime.now)
    (date.beginning_of_month..date.end_of_month).to_a
  end

end
