class Book < ApplicationRecord
  #associations
  belongs_to :author

  scope :search, lambda { |search_param|
    where('book_name like :search_name or short_description like :search_name or long_description like :search_name or book_chapter_index like :search_name or genre like :search_name',search_name: "%#{search_param}%" )
  }

end
