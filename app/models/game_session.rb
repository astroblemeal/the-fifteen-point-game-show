class GameSession < ApplicationRecord
  has_many :players, dependent: :destroy

  validates :game_name, presence: true
  validates :questions, presence: true
  validates :answers, presence: true
end
