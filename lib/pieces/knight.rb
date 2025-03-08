require_relative 'piece'
class Knight < Piece
  # uses and returns [x, y] board notation
  # the board class uses [y, x] access
  def possible_moves(start, board)
    iteration = 0
    possible_moves = []
    x_moves = [2, 1, -1, -2, -2, -1, 1, 2]
    y_moves = [1, 2, 2, 1, -1, -2, -2, -1]
    while iteration < 8
      x_position = x_moves[iteration] + start[0]
      y_position = y_moves[iteration] + start[1]
      piece = board[y_position][x_position]

      if (x_position >= 0 && x_position <= 7) && (y_position >= 0 && y_position <= 7) &&
         !(piece != 'empty' && piece.color == color)
          possible_moves << [x_position, y_position]
      end
      iteration += 1
    end
    possible_moves
  end
end
