class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    listings.map do |listing|
      listing.guests
    end.flatten.uniq
  end

  def hosts
    trips.map do |trip|
      trip.listing.host
    end.uniq
  end

  def host_reviews
    listings.map do |listing|
      listing.reviews
    end.flatten
  end
  
end
