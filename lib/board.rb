# frozen_string_literal: true

require_relative 'string'

# class Board controls the pieces on the board
# and check for winning combinations
class Board
  # Define what is considered an empty positon
  EMPTY_POS = ' '

  def initialize(board_size = 7)
    # setup default array
    board_arr = Array.new(board_size - 1) { Array.new(board_size) { EMPTY_POS } }
    @board = board_arr + [[*1..7]]
  end

  # render board
  def render
    puts "\e[H\e[2J"
    # loop through data structure
    @board.each_with_index do |row_val, row|
      print '|'
      row_val.each_with_index do |_col_val, col|
        # display an existing marker any, else blank
        s = @board[row][col]
        render_cell(s)
        print '|'
      end
      puts "\n+-------------+"
    end
  end

  # cell contents
  def render_cell(cell)
    if cell.is_a?(Integer)
      print cell
    else
      (cell == 'R' ? (print cell.red) : (print cell.blue))
    end
  end

  # board message template
  def message(message, color = 'black')
    # puts ''
    case color
    when 'blue'
      puts message.blue
    when 'red'
      puts message.red
    else
      puts message
    end
    # puts ' '
  end

  # validate input range
  def number_input_range(msg, min, max)
    loop do
      message(msg)
      input = gets.chomp
      return input.to_i unless input.to_i < min || input.to_i > max

      message("Invalid selection #{input}.  Please enter a value between #{min} and #{max}", 'red')
    end
  end

  # add a piece
  def add_piece(player, piece)
    col = nil
    loop do
      # ask of selected column and check if column is full
      col = number_input_range("Select Column to play, #{player.name}", 1, 7)
      break if column_free?(col)
    end

    # find free row and add piece
    row = row_free?(col)
    @board[row][col - 1] = piece
  end

  # column free?
  def column_free?(col)
    return true if @board[0][col - 1] == EMPTY_POS

    message("Column #{col} is full.  Please select another column", 'red')
  end

  # piece location available?
  def row_free?(col)
    col -= 1
    @board.each_with_index do |_, row_index|
      return row_index - 1 if @board[row_index][col] != EMPTY_POS
    end
  end

  # check full board
  def board_full?
    @board.all? do |row|
      row.none?(EMPTY_POS)
    end
  end

  # possible winning combinations
  def winning_combination?(grid = @board)
    # rows
    four_in_a_row_by_row(grid) ||
      # columns by transposing grid
      four_in_a_row_by_row(grid.transpose) ||
      # diagonals
      four_in_a_row_by_row(diagonals(grid)) ||
      # opposite diagonal by rotating grid
      four_in_a_row_by_row(diagonals(rotate90(grid)))
  end

  # check for four in a row
  def four_in_a_row_by_row(arr)
    arr.each do |row|
      result = row.each_cons(4).find { |a| a.uniq.size == 1 && a.first != ' ' }
      return result.first unless result.nil?
    end
    nil
  end

  # half diagonal
  def diagonals(grid)
    (0..grid.size - 4).map do |i|
      (0..grid.size - 1 - i).map { |j| grid[i + j][j] }
    end.concat((1..grid.first.size - 4).map do |j|
      (0..grid.size - j - 1).map { |i| grid[i][j + i] }
    end)
  end

  # rotate for other half of diagonal
  def rotate90(grid)
    ncols = grid.first.size
    grid.each_index.with_object([]) do |i, a|
      a << ncols.times.map { |j| grid[j][ncols - 1 - i] }
    end
  end
end
