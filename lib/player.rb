# frozen_string_literal: true

require_relative 'board'

# class player for player functionality
class Player
  attr_accessor :name, :piece

  # initalize name, piece and board
  def initialize(name, piece, board)
    @name = name
    @piece = piece
    @board = board
  end

  # assigns player names
  def update_player_name(name)
    @name = name
  end
end
