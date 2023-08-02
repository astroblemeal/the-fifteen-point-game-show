class GameSession < ApplicationRecord
  has_many :players, dependent: :destroy

  validates :game_name, presence: true
  validates :questions, presence: true
  validates :answers, presence: true

  def self.create_with_players(waiting_list, game_params)
    transaction do
      game_session = create(game_params)
      game_session.create_players(waiting_list)
      game_session
    end
  end

  def create_players(waiting_list)
    players = waiting_list.map { |user_id, _| Player.new(user_id: user_id) }
    players.each(&:save)
    self.players = players
  end
end
