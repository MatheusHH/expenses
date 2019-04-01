module ApplicationHelper

	def formatted_currency(value)
		ActionController::Base.helpers.number_to_currency(value)
	end
end
