require_relative 'piece'
class Pawn < Piece
  def possible_moves(start, board)
    iteration = 0
    possible_moves = []
    x_moves = [0, 0, -1, 1]
    y_moves = [1, 2, 1, 1]
    while iteration < 4
      y_position = y_moves[iteration] + start[1]
      x_position = x_moves[iteration] + start[0]

      if (x_position >= 0 && x_position <= 7) && (y_position >= 0 && y_position <= 7)
        # moving 1 position ahead
        if iteration == 0
          possible_moves << [x_position, y_position]
        # moving to eat a piece
        elsif iteration >= 2 && board[x_position][y_position] != 'empty'
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

test = Pawn.new('black', 'pawn')
board = Array.new(8) { Array.new(8, '-') }
print test.possible_moves([0,1], board)