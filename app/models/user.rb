class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, :password, presence:true
  has_many :memberships
  has_many :groups
  has_many :joined_groups, through: :memberships, source: :group
  before_save { |user| user.email = user.email.downcase } 
  validates :email, :format => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates_uniqueness_of :email
  has_secure_password
end