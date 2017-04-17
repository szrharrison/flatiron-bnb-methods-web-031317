class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_isnt_host, :checkin_available, :checkout_available, :checkin_before_checkout

  def duration
    duration = checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

  def guest_isnt_host
    if listing.host.id == guest_id
      errors.add( :guest, "can't be reserved by the host." )
    end
  end

  def checkin_available
    if !!checkin
      listing.reservations.each do |reservation|
        if checkin > reservation.checkin && checkin < reservation.checkout
          errors.add( :checkin, "listing already reserved.")
        end
      end
    end
  end

  def checkout_available
    if !!checkout
      listing.reservations.each do |reservation|
        if checkout > reservation.checkin && checkout < reservation.checkout
          errors.add( :checkout, "listing already reserved.")
        end
      end
    end
  end

  def checkin_before_checkout
    if !!checkin && !!checkout
      if checkin >= checkout
        errors.add( :checkin, "must be before checkout." )
      end

      if checkin.year == checkout.year && checkin.yday == checkout.yday
        errors.add( :checkin, "must be a different day than checkout." )
      end
    end
  end
end
