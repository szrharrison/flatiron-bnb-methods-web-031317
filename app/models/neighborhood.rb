class Neighborhood < ActiveRecord::Base
  extend LocationHelper::ClassMethods
  include LocationHelper::InstanceMethods

  belongs_to :city
  has_many :listings

  def neighborhood_openings( checkin, checkout )
    openings( checkin, checkout )
  end
end
