class CreateSearchEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :search_events, id: :uuid do |t|
      t.references :visitor_session, null: false, type: :uuid, foreign_key: true
      t.text :query, null: false
      t.datetime :typed_at, null: false
      t.string :request_id
      t.timestamps
    end

    add_index :search_events, [ :visitor_session_id, :typed_at ]
  end
end
