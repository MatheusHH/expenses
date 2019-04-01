class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum kind: [ :manager, :client ]
  
  has_many :providers
  has_many :expenses
  has_many :categories
  has_many :receipts
  has_many :descriptions
end
