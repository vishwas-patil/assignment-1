# frozen_string_literal: true

load_seed('authors').each do |s|
  Author.create(s)
end

puts("Created Authors on #{Rails.env} environment")

load_seed('books').each do |s|
  Book.create(s)
end

puts("Created Books on #{Rails.env} environment")

