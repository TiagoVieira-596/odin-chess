require_relative 'board'
class Game
  def make_move(current_game, start, goal)
    moving_piece = current_game.board[start[1]][start[0]]
    # make the move if the chosen address is not empty and the move is legal
    if moving_piece != 'empty' && moving_piece.possible_moves(current_game.board).include?(goal)
      # promote if a pawn reaches the end of the board
      if (goal[1] == 7 || goal[1].zero?) && (moving_piece.is_a? Pawn)
        moving_piece = promotion_choice(moving_piece.color)
      end

      # change the board according to the move made and change the pieces states
      current_game.board[goal[1]][goal[0]] = moving_piece
      moving_piece.address = goal
      current_game.board[start[1]][start[0]] = 'empty'
      moving_piece.was_moved = true
      current_game.moves_made += 1

      # in case of the castle special move
      if goal == ([start[0] + 2, start[1]]) && (moving_piece.is_a? King)
        current_game.board[goal[1]][goal[0] - 1] = Rook.new(moving_piece.color, 'rook')
        current_game.board[goal[1]][goal[0] - 1].address = [goal[1], goal[0] - 1]
        current_game.board[goal[1]][goal[0] + 1] = 'empty'
      elsif (goal == [start[0] - 3, start[1]]) && (moving_piece.is_a? King)
        current_game.board[goal[1]][goal[0] + 1] = Rook.new(moving_piece.color, 'rook')
        current_game.board[goal[1]][goal[0] + 1].address = [goal[1], goal[0] + 1]
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

  def check?(color, current_game)
    king_address = current_game.find_pieces_addresses('king', color)[0]
    king_in_check = false
    current_game.all_pieces do |piece|
      if piece != 'empty' && piece.possible_moves(current_game.board).include?(king_address) && piece.color != color
        king_in_check = true
      end
    end
    king_in_check
  end
end
