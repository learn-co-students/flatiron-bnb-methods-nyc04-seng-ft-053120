class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.select do |listing|
      listing.reserved_dates.include?(start_date.to_date) || listing.reserved_dates.include?(end_date.to_date) ? false : true
    end
  end

  def total_reservations
    self.listings.sum do |listing|
      listing.total_reservations
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |city|
      city.total_reservations/city.listings.count
    end
  end

  def self.most_res
    self.all.max_by do |city|
      city.total_reservations
    end
  end

end

