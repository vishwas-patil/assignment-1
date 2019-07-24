class Author < ApplicationRecord
  #associations
  has_many :books, dependent: :destroy


  scope :search, lambda { |search_param|
    where('name like :search_name or author_bio like :search_name or academics like :search_name or awards like :search_name',search_name: "%#{search_param}%" )
  }

end
