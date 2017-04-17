module LocationHelper
  module ClassMethods
    def highest_ratio_res_to_listings
      self.all.max_by do |location|
        listings = location.listings.count
        reservations =  location.num_of_reservations
        if listings == 0
          ratio = 0
        else
          ratio = reservations / listings
        end
      end
    end

    def most_res
      self.all.max_by do |location|
        reservations = location.num_of_reservations
      end
    end
  end

  module InstanceMethods
    def openings( checkin, checkout )
      checkin_date = Date.parse( checkin )
      checkout_date = Date.parse( checkout )
      unavailable_listings = listings.each_with_object([]) do |listing, ary|
        listing.reservations.each do |reservation|
          if (reservation.checkin >= checkin_date && reservation.checkin < checkout_date) || (reservation.checkout > checkin_date && reservation.checkout <= checkout_date)
              ary << listing
          end
        end
      end
      available_listings = listings - unavailable_listings
    end

    def num_of_reservations
      reservations =  listings.reduce(0) do |sum, listing|
        sum += listing.reservations.count
      end
    end
  end
end
