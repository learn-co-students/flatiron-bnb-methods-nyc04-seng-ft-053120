class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    self.city.city_openings(start_date, end_date).select do |listing|
      listing.neighborhood == self
    end
  end

  def total_reservations
    self.listings.sum do |listing|
      listing.total_reservations
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |neighborhood|
      if neighborhood.listings.count == 0
        0
      else 
        neighborhood.total_reservations/neighborhood.listings.count
      end
    end
  end

  def self.most_res
    self.all.max_by do |neighborhood|
      neighborhood.total_reservations
    end
  end

end
