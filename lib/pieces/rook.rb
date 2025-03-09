require_relative 'piece'
class Rook < Piece
  # uses and returns [x, y] board notation
  # the board class uses [y, x] access
  def possible_moves(start, board)
    possible_moves = []

    # check right line
    start_row = start[1]
    next_column = start[0]
    iteration = 0
    while next_column + 1 <= 7
      iteration += 1
      next_column = start[0] + iteration
      piece = board[start_row][next_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [next_column, start_row]
      break if piece != 'empty' && piece.color != color
    end

    # check left line
    start_row = start[1]
    prev_column = start[0]
    iteration = 0
    while prev_column - 1 >= 0
      iteration += 1
      prev_column = start[0] - iteration
      piece = board[start_row][prev_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [prev_column, start_row]
      break if piece != 'empty' && piece.color != color
    end

    # check upward line
    next_row = start[1]
    start_column = start[0]
    iteration = 0
    while next_row + 1 <= 7
      iteration += 1
      next_row = start[1] + iteration
      piece = board[next_row][start_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [start_column, next_row]
      break if piece != 'empty' && piece.color != color
    end

    # check downward line
    next_row = start[1]
    start_column = start[0]
    iteration = 0
    while next_row - 1 >= 0
      iteration += 1
      next_row = start[1] - iteration
      piece = board[next_row][start_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [start_column, next_row]
      break if piece != 'empty' && piece.color != color
    end
    possible_moves
  end
end
