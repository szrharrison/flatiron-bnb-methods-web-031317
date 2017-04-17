class User < ActiveRecord::Base
  has_many :listings, foreign_key: 'host_id', dependent: :destroy
  has_many :reservations, through: :listings
  has_many :trips, foreign_key: 'guest_id', class_name: "Reservation", dependent: :destroy
  has_many :reviews, foreign_key: 'guest_id', dependent: :destroy

  def guests
    @guests = listings.each_with_object([]) do |listing, ary|
      ary.concat( listing.guests )
    end
  end

  def hosts
    @hosts = trips.each_with_object([]) do |trip, ary|
      ary << trip.listing.host
    end
  end

  def host_reviews
    @host_reviews = guests.each_with_object([]) do |guest, ary|
      ary.concat( guest.reviews )
    end
  end
end
