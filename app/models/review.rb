class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :reservation_passed

  private

  def reservation_passed
    if !!reservation
      unless reservation.checkout < Date.today && reservation.status == "accepted"
        errors.add( :reservation, "must have successfully checked out.")
      end
    end
  end
end
