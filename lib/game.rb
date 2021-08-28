# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'string'

# controls the game sequence
class ConnectFour
  def initialize
    # setup new board
    @board = Board.new

    # setup the players
    @player_x = Player.new('Player_1', 'R', @board)
    @player_y = Player.new('Player_2', 'W', @board)

    # get player names
    player_names

    # assign current player
    @current_player = @player_x
  end

  # loops turns till game over
  def play
    # loop till game over
    loop do
      # renders board (board)
      @board.render
      # gets current player move (player)
      @board.add_piece(@current_player, @current_player.piece)
      # check if game is over
      if game_over?
        play_again? ? (@board = Board.new) : break
      end
      # switch players
      @current_player = switch_current_player(@current_player)
    end
  end

  def play_again?
    loop do
      puts 'Would you like to play again?'
      input = gets.chomp.downcase

      return true if input.include?('y')
      return false if input.include?('n')

      puts "Invalid choice.  Please select 'y' or 'n'"
    end
  end

  # check if game_over?
  def game_over?
    # check draw or victory
    check_draw || check_victory
  end

  # get player names
  def player_names
    puts "\e[H\e[2J"
    # update player 1 name
    puts "Name of player 1 playing with 'R'"
    player1_name = gets.chomp
    @player_x.update_player_name(player1_name)

    # update player 2 name
    puts "Name of player 2 playing with 'W'"
    player2_name = gets.chomp
    @player_y.update_player_name(player2_name)
  end

  # switch players
  def switch_current_player(player)
    @current_player = player == @player_x ? @player_y : @player_x
  end

  def check_draw
    if @board.board_full?
      @board.render
      @board.message('Draw!!!  No more moves', 'red')
      true
    else
      false
    end
  end

  def check_victory
    if @board.winning_combination?
      @board.render
      @board.message("Congratulation #{@current_player.name}.  You win!!!", 'blue')
      true
    else
      false
    end
  end
end
