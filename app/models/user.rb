class User < ApplicationRecord
    has_secure_password

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, on: :create
    validates :image, presence: true
end
