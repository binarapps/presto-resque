class CreateAccessLogStatusStats < ActiveRecord::Migration
  def change
    create_table :access_log_status_stats do |t|
      t.string :host
      t.integer :status
      t.string :request
      t.integer :count, limit: 8

      t.timestamps
    end
  end
end
