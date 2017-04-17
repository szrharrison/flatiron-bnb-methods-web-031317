class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, class_name: "User"
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: "User", through: :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_create :convert_user_to_host
  after_destroy :convert_host_to_user

  def average_review_rating
    total_rating = reviews.reduce(0) do |sum, review|
      sum += review.rating
    end
    average_rating = total_rating.to_f / reviews.count.to_f
  end

  private
  def convert_user_to_host
    host.host = true
    host.save
  end

  def convert_host_to_user
    if host.listings.length == 0
      host.host = false
      host.save
    end
  end
end
