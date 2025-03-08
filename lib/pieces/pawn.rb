require_relative 'piece'
class Pawn < Piece
  # uses and returns [x, y] board notation
  # the board class uses [y, x] access
  def possible_moves(start, board)
    iteration = 0
    possible_moves = []
    x_moves = [0, 0, -1, 1]
    y_moves = [1, 2, 1, 1]
    while iteration < 4
      x_position = x_moves[iteration] + start[0]
      y_position = y_moves[iteration] + start[1]
      piece_at_address = board[y_position][x_position]

      if (x_position >= 0 && x_position <= 7) && (y_position >= 0 && y_position <= 7) &&
         !(piece_at_address != 'empty' && piece_at_address.color == color)
        # moving 1 position ahead
        if iteration.zero?
          possible_moves << [x_position, y_position]
        # moving to eat a piece
        elsif iteration >= 2 && piece_at_address != 'empty'
          possible_moves << [x_position, y_position]
        # pawn wasn't moved and it's possible to go ahead
        elsif iteration == 1 && !was_moved
          possible_moves << [x_position, y_position]
        end
      end
      iteration += 1
    end
    possible_moves
  end
end
