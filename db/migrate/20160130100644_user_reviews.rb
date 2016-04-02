class UserReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :title
      t.string :product_name
      t.text :review_content
      t.integer :stars
      t.float :sentiment_score
    end
  end
end
