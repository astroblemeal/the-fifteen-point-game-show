class GameSession < ApplicationRecord
  has_many :players, dependent: :destroy

  validates :game_name, presence: true
  validates :questions, presence: true
  validates :answers, presence: true

  def save_with_players(waiting_list)
    transaction do
      save && create_players(waiting_list)
    end
  end

  private

  def create_players(waiting_list)
    players = waiting_list.map { |user_id, _| Player.new(user_id: user_id) }
    players.each(&:save)
    self.players = players
  end
end
