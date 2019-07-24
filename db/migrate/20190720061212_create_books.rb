class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :book_name
      t.text :short_description
      t.text :long_description
      t.text :book_chapter_index
      t.date :date_of_publication
      t.text :genre
      t.references :author, foreign_key: true

      t.timestamps
    end
  end
end
