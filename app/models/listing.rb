class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  before_create :set_host
  after_destroy :host?
  
  def reserved_dates
    self.reservations.map do |reservation|
      reservation.date_range
    end.flatten
  end

  def total_reservations
    self.reservations.count
  end

  def average_review_rating
    self.reviews.sum do |review|
      review.rating
    end.to_f/self.reviews.count
  end

  private

  def set_host
    self.host.update(host: true)
  end

  def host?
    if self.host.listings.count < 1
      self.host.update(host: false)
    end
  end

end
