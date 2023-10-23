class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_many :shoes, dependent: :destroy
  has_many :runs, dependent: :destroy

  enum :unit, { mi: 0, km: 1 }
end
