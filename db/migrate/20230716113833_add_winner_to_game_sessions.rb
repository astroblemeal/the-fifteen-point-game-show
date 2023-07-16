class AddWinnerToGameSessions < ActiveRecord::Migration[7.0]
  def change
    add_reference :game_sessions, :winner, foreign_key: { to_table: :players }
  end
end
