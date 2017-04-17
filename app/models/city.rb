class City < ActiveRecord::Base
  extend LocationHelper::ClassMethods
  include LocationHelper::InstanceMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings( checkin, checkout )
    openings( checkin, checkout )
  end
end
