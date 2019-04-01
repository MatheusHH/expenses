class Expense < ApplicationRecord
  belongs_to :provider
  belongs_to :category
  belongs_to :user
end
