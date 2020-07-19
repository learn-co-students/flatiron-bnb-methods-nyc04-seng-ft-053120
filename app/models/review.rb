class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reservation_happened?

  private

  def reservation_happened?
    if reservation.nil?
      errors.add(:reservation, "can not be nil")
    elsif reservation.checkout > Date.today
      errors.add(:rating, "has not happened yet")
    end
  end

end
