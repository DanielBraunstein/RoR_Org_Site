class Group < ActiveRecord::Base
  validates :name, :desc, presence:true
  validates :name, length: { minimum: 6 }
  validates :desc, length: { minimum: 11 }
  belongs_to :user
  has_many :memberships
  has_many :members, through: :memberships, source: :user
end
