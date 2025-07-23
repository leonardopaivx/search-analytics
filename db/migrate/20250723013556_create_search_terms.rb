class CreateSearchTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :search_terms, id: :uuid do |t|
      t.references :visitor_session, null: false, type: :uuid, foreign_key: true
      t.string :term, null: false
      t.integer :occurences, null: false, default: 1
      t.datetime :first_seen_at, null: false
      t.datetime :last_seen_at, null: false
      t.timestamps
    end

    add_index :search_terms, :term
  end
end
