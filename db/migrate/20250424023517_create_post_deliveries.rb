class CreatePostDeliveries < ActiveRecord::Migration[7.2]
  def change
    create_table :post_deliveries do |t|
      t.references :post, null: false, foreign_key: true
      t.references :authentication, null: false, foreign_key: true
      t.string :status, null: false
      t.string :platform_post_id
      t.string :platform_post_url
      t.datetime :sent_at
      t.datetime :scheduled_at
      t.datetime :processing_started_at
      t.integer :retry_count, default: 0
      t.text :error_message

      t.timestamps
    end
    add_index :post_deliveries, :status
    add_index :post_deliveries, :scheduled_at
  end
end
