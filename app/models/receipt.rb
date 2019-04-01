class Receipt < ApplicationRecord
  belongs_to :description
  belongs_to :user
end
