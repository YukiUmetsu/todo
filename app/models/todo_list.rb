class TodoList < ActiveRecord::Base
  # Todoの作成日の新しい順に取得する
  has_many :todos, -> { order "position" }, dependent: :destroy

  validates :name, presence: true
end
