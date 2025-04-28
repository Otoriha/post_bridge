class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post_template, foreign_key: true
      t.string :title
      t.json :content
      t.string :status
      t.boolean :is_favorite, default: false

      t.timestamps
    end
    add_index :posts, :is_favorite
    add_index :posts, :status
  end
end
