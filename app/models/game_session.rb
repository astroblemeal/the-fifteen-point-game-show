# app/models/game_session.rb
class GameSession < ApplicationRecord
  serialize :answers, Array
  serialize :questions, Array
  serialize :player_ids, Array

  validates :game_name, presence: true
  validates :questions, presence: true
  validates :answers, presence: true
  validates :player_ids, presence: true
end
