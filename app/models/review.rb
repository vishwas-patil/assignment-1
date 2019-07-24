class Review < ApplicationRecord

  scope :search, lambda { |search_param|
    where('name_of_reviewer like :search_name or review_title like :search_name or review_description like :search_name',search_name: "%#{search_param}%" )
  }
end
