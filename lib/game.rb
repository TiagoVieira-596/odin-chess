require_relative 'board'
def make_move(current_game, start, goal)
  piece_at_address = current_game.board[start[1]][start[0]]
  # make the move if the chosen address is not empty and the move is legal
  if piece_at_address != 'empty' && piece_at_address.possible_moves(start, current_game.board).include?(goal)
    # promote if a pawn reaches the end of the board
    if (goal[1] == 7 || goal[1].zero?) && (piece_at_address.is_a? Pawn)
      piece_at_address = promotion_choice(piece_at_address.color)
    end

    # change the board according to the move made and change the pieces states
    current_game.board[goal[1]][goal[0]] = piece_at_address
    current_game.board[start[1]][start[0]] = 'empty'
    piece_at_address.was_moved = true
    current_game.moves_made += 1

    # in case of the castle special move
    if goal == ([start[0] + 2, start[1]]) && (piece_at_address.is_a? King)
      current_game.board[goal[1]][goal[0] - 1] = Rook.new(piece_at_address.color, 'rook')
      current_game.board[goal[1]][goal[0] + 1] = 'empty'
    elsif (goal == [start[0] - 3, start[1]]) && (piece_at_address.is_a? King)
      current_game.board[goal[1]][goal[0] + 1] = Rook.new(piece_at_address.color, 'rook')
      current_game.board[goal[1]][goal[0] - 1] = 'empty'
    end

    # ! make this function able to take the en passant move
  else
    p "you can't make this move"
  end
end

def promotion_choice(color)
  chosen_piece = nil
  take_user_input('To which piece will the pawn be promoted to? ') do |input|
    chosen_piece = input if %w[rook knight bishop queen].include?(input)
  end
  piece_class = Object.const_get(chosen_piece.capitalize)
  piece_class.new(color, chosen_piece)
end

def take_user_input(message, &block)
  user_input = nil
  until valid_user_input(user_input, &block)
    print message
    user_input = gets.chomp.downcase
  end
end

def valid_user_input(input)
  yield(input)
end

board = ChessBoard.new
board.board[7][0] = 'empty'
board.board[6][0] = Pawn.new('black', 'pawn')
print board.layout
make_move(board, [0, 6], [0, 7])
print board.layout
