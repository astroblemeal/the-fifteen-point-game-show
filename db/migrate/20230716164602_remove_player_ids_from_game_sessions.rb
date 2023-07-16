class RemovePlayerIdsFromGameSessions < ActiveRecord::Migration[7.0]
  def change
    remove_column :game_sessions, :player_ids
  end
end
