class AddAnswersToGameSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :game_sessions, :answers, :text
  end
end
