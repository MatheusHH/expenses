class Receipt < ApplicationRecord
  belongs_to :description
  belongs_to :user

  monetize :amount_cents
end
