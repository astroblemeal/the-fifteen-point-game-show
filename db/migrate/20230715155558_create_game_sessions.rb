class CreateGameSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :game_sessions do |t|
      t.text :player_ids
      t.string :game_name
      t.text :questions

      t.timestamps
    end
  end
end
