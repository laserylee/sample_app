class User < ApplicationRecord
  before_save { email.downcase! }
  validates(
    :name,
    presence:true,
    uniqueness: true,
    length: { maximum:50 } )
  validates(
    :email,
    presence:true,
    uniqueness: { case_sensitive:false },
    length: { maximum:255},
    format: { with: /\A[\w\d\-.]+@([a-z\d\-]+\.)+[a-z]+\z/i } )
  has_secure_password
  validates(
    :password,
    presence:true,
    length: { minimum:6 } )
end
