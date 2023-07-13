class User < ApplicationRecord
  has_secure_password

  validates :admin, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
