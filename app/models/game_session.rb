# app/models/game_session.rb
class GameSession < ApplicationRecord
  serialize :player_ids, Array
  serialize :answers, Array

  # Validations (adjust as per your requirements)
  validates :game_name, presence: true
  validates :questions, presence: true
  validates :answers, presence: true

puts "Player ids #{player_ids}"

end
