class CreatePostTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :post_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.json :content
      t.boolean :is_favorite, default: false

      t.timestamps
    end
    add_index :post_templates, :is_favorite
  end
end
