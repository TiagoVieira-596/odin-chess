require_relative 'piece'
class Bishop < Piece
  def possible_moves(start = address, board)
    # uses and returns [x, y] board notation
    # the board class uses [y, x] access
    possible_moves = []

    # check upward right diagonal
    next_row = start[1]
    next_column = start[0]
    iteration = 0
    while next_column + 1 <= 7 && next_row + 1 <= 7
      iteration += 1
      next_column = start[0] + iteration
      next_row = start[1] + iteration
      piece = board[next_row][next_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [next_column, next_row]
      break if piece != 'empty' && piece.color != color
    end

    # check upward left diagonal
    next_row = start[1]
    prev_column = start[0]
    iteration = 0
    while prev_column - 1 >= 0 && next_row + 1 <= 7
      iteration += 1
      prev_column = start[0] - iteration
      next_row = start[1] + iteration
      piece = board[next_row][prev_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [prev_column, next_row]
      break if piece != 'empty' && piece.color != color
    end

    # check downward right diagonal
    prev_row = start[1]
    next_column = start[0]
    iteration = 0
    while prev_row - 1 >= 0 && next_column + 1 <= 7
      iteration += 1
      prev_row = start[1] - iteration
      next_column = start[0] + iteration
      piece = board[prev_row][next_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [next_column, prev_row]
      break if piece != 'empty' && piece.color != color
    end

    # check downward left diagonal
    prev_row = start[1]
    prev_column = start[0]
    iteration = 0
    while prev_row - 1 >= 0 && prev_column - 1 >= 0
      iteration += 1
      prev_row = start[1] - iteration
      prev_column = start[0] - iteration
      piece = board[prev_row][prev_column]
      break if piece != 'empty' && piece.color == color

      possible_moves << [prev_column, prev_row]
      break if piece != 'empty' && piece.color != color
    end
    possible_moves
  end
end
