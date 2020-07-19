class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_is_not_guest?
  validate :available?
  validate :valid_date_range?

  def date_range
    date = self.checkin
    range = []
    until range.include?(self.checkout) do
      range << date
      date += 1
    end
    range
  end

  def reserved_date?(first_date, second_date)
    self.date_range.include?(first_date) || self.date_range.include?(second_date) ? true : false
  end

  def duration
    checkout - checkin
  end

  def total_price
    (self.listing.price * self.duration).to_i
  end

  private

  def host_is_not_guest?
    if self.listing.host == self.guest
      errors.add(:guest, "can't be host")
    end
  end

  def available?
    if self.listing.reserved_dates.include?(checkin)
      errors.add(:checkin, "has been reserved")
    end
    if self.listing.reserved_dates.include?(checkout)
      errors.add(:checkout, "has been reserved")
    end
  end


  def valid_date_range?
    if !checkin
      errors.add(:checkin, "is invalid")
    elsif !checkout
      errors.add(:checkout, "is invalid")
    elsif checkout - checkin <= 0
      errors.add(:checkin, "must be before checkout date")
    end
  end

end
