class Reservation < ActiveRecord::Base
  belongs_to :location
  belongs_to :member
  validate :dates_are_available, :dates_are_not_in_past

  def dates_are_available
    start_date_overlap = location.reservations.where(start_date:
    start_date..end_date - 1.day)
    end_date_overlap = location.reservations.where(end_date:
    start_date..end_date - 1.day)
    if start_date_overlap.exists? || end_date_overlap.exists?
      errors[:base] << "Some of the dates of your reservation are not
      available. Please try different dates."
    end
  end

  def dates_are_not_in_past
    if start_date < Date.today || end_date < Date.today
      errors[:base] << "The reservation should not be in the past. Please try different dates."
    end
  end
end
