class AddDisplayNameToVisitorSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :visitor_sessions, :display_name, :string
    add_index  :visitor_sessions, :display_name, unique: true
  end
end
