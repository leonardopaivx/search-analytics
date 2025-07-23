class CreateVisitorSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :visitor_sessions, id: :uuid do |t|
      t.inet   :ip_address, null: false
      t.text   :user_agent
      t.string :session_token, null: false
      t.timestamps
    end

    add_index :visitor_sessions, :session_token, unique: true
  end
end
