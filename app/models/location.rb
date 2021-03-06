class Location < ActiveRecord::Base
  belongs_to :member


  has_many :location_images, dependent: :destroy
  has_many :reservations
  has_many :available_dates, dependent: :destroy
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, :location_images, allow_destroy: true

  validates :title, presence: true
  validates :beds, numericality: true
  validates :guests, numericality: true
  validates :price, numericality: true

  def create_available_dates(start_date, end_date)
    dates = start_date.upto(end_date)
    dates.each do |date|
      AvailableDate.find_or_create_by(available_date: date, location_id:
      self.id)
    end
  end

  def future_available_dates
    future_dates = available_dates.where("available_date >= ?", Date.
today)
    future_dates.where(reserved: false)
  end
end
