class AddGameSessionRefToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_reference :players, :game_session, null: false, foreign_key: true
  end
end
