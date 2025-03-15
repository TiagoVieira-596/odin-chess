require_relative 'inputs'
Dir.glob(File.join(__dir__, 'pieces', '*.rb')).each { |file| require_relative file }

class ChessBoard
  attr_accessor :board, :last_move

  def initialize
    @board = Array.new(8) { {} }
    populate_new_board
    # uses [x, y] notation
    @last_move = [[0, 0], [0, 7]]
  end

  def layout
    layout = "    a  b  c  d  e  f  g  h  \n  +--+--+--+--+--+--+--+--+\n"
    row_number = 8
    board.reverse.each do |row|
      row_string = "#{row_number} "
      row.sort.to_h.each_value do |piece|
        piece = ' ' if piece == 'empty'
        row_string += "|#{piece} "
      end
      layout += "#{row_string}| #{row_number}\n"
      layout += "  +--+--+--+--+--+--+--+--+\n"
      row_number -= 1
    end
    layout +=  "    a  b  c  d  e  f  g  h  \n"
  end

  def all_pieces(&block)
    @board.reverse.each do |row|
      row.sort.to_h.each_value(&block)
    end
  end

  def check?(color)
    king_address = find_pieces_addresses('king', color)[0]
    king_in_check = false
    all_pieces do |piece|
      if piece != 'empty' && piece.possible_moves(@board).include?(king_address) && piece.color != color
        king_in_check = true
      end
    end
    king_in_check
  end

  def checkmate?(color)
    return false unless check?(color)

    all_pieces do |piece|
      next if piece == 'empty' || piece.color != color

      previous_address = piece.address

      piece.possible_moves(@board).each do |possible_move|
        temp_board = deep_clone_board
        opponent_color = color == 'black' ? 'white' : 'black'
        temp_board.make_move(previous_address, possible_move, opponent_color, true)

        return false unless temp_board.check?(color)
      end
    end

    true
  end

  def stalemate?(color)
    return false if check?(color)

    all_pieces do |piece|
      next if piece == 'empty' || piece.color != color

      previous_address = piece.address

      piece.possible_moves(@board).each do |possible_move|
        temp_board = deep_clone_board
        opponent_color = color == 'black' ? 'white' : 'black'
        temp_board.make_move(previous_address, possible_move, opponent_color, true)

        return false unless temp_board.check?(color)
      end
    end

    true
  end

  def find_pieces_addresses(piece, color)
    piece_class = Object.const_get(piece.downcase.capitalize)
    piece_addresses = []
    @board.each_with_index do |row, index|
      column_index = 0
      row.sort.to_h.each_value do |piece|
        piece_addresses << [column_index, index] if (piece.is_a? piece_class) && piece.color == color
        column_index += 1
      end
    end
    piece_addresses
  end

  def make_move(start, goal, color, move_testing = false)
    moving_piece = @board[start[1]][start[0]]

    return if moving_piece == 'empty' || (moving_piece.color != color && move_testing == false) || in_check_after_move?(start, goal, color)
    # in case of the en passant special move
    en_passant(start, goal)

    # make the move if the move is legal
    return unless moving_piece.possible_moves(@board).include?(goal)

    # promote if a pawn reaches the end of the board
    moving_piece = Inputs.promotion_choice(moving_piece.color) if (goal[1] == 7 || goal[1].zero?) && (moving_piece.is_a? Pawn) && !move_testing

    # in case of the castle special move
    castle_swap(start, goal)

    # change the board according to the move made and change the pieces states
    @board[goal[1]][goal[0]] = moving_piece
    moving_piece.address = goal
    @board[start[1]][start[0]] = 'empty'
    moving_piece.was_moved = true
    @last_move = [start, goal, moving_piece]
  end

  def en_passant(start, goal)
    moving_piece = @board[start[1]][start[0]]
    return unless (goal == [start[0] + 1, start[1] + 1] || goal == [start[0] - 1, start[1] + 1] || goal == [start[0] - 1, start[1] - 1] || goal == [start[0] + 1, start[1] - 1]) &&
                  @board[goal[1]][goal[0]] == 'empty'
    return unless (moving_piece.is_a? Pawn) && moving_piece.possible_moves(start, @last_move,
                                                              @board).include?(goal)
    # change the board according to the en passant move
    @board[goal[1]][goal[0]] = moving_piece
    moving_piece.address = goal
    @board[start[1]][start[0]] = 'empty'
    moving_piece.color == 'black' ? @board[goal[1] - 1][goal[0]] = 'empty' : @board[goal[1] + 1][goal[0]] = 'empty'
    moving_piece.was_moved = true
    @last_move = [start, goal, moving_piece]
  end

  def castle_swap(start, goal)
    # put the tower in it's new place after the castle
    moving_piece = @board[start[1]][start[0]]
    if goal == ([start[0] + 2, start[1]]) && (moving_piece.is_a? King) && @board[goal[1]][goal[0]] == 'empty'
      @board[goal[1]][goal[0] - 1] = Rook.new(moving_piece.color, [goal[1], goal[0] - 1])
      @board[goal[1]][goal[0] + 1] = 'empty'
    elsif (goal == [start[0] - 3, start[1]]) && (moving_piece.is_a? King)
      @board[goal[1]][goal[0] + 1] = Rook.new(moving_piece.color, [goal[1], goal[0] + 1])
      @board[goal[1]][goal[0] - 1] = 'empty'
    end
  end

  def in_check_after_move?(start, goal, color)
    test_board = deep_clone_board
    moving_piece = test_board.board[start[1]][start[0]]
    # simulate move
    test_board.en_passant(start, goal)
    test_board.castle_swap(start, goal)
    test_board.board[goal[1]][goal[0]] = moving_piece
    test_board.board[start[1]][start[0]] = 'empty'
    return true if test_board.check?(color)
    false
  end

  def populate_new_board
    (0..7).each do |column|
      @board[1][column] = Pawn.new('black', [column, 1])
      @board[6][column] = Pawn.new('white', [column, 6])
      (2..5).each { |row| @board[row][column] = 'empty' }
    end
    address = 0
    pieces_order = [Rook, Knight, Bishop, Queen, King]
    pieces_order.each do |piece|
      @board[0][address] = piece.new('black', [address, 0])
      @board[7][address] = piece.new('white', [address, 7])
      unless [Queen, King].include?(piece)
        @board[0][7 - address] = piece.new('black', [7 - address, 0])
        @board[7][7 - address] = piece.new('white', [7 - address, 7])
      end
      address += 1
    end
  end

  def deep_clone_board
    cloned_board = ChessBoard.new
    cloned_board.board = @board.map do |row|
      row.transform_values do |piece|
        if piece == 'empty'
          'empty'
        else
          piece.clone
        end
      end
    end
    cloned_board
  end

  def reformat_chess_board
    @board.each do |row|
      row.transform_keys! do |key|
        key.to_i
      end
      row.transform_values! do |key|
        if key.is_a? Hash
          revert_json_piece(key)
        else
          key = key
        end
      end
    end
    @last_move[2] = revert_json_piece(@last_move[2]) if !@last_move[2].nil? && (@last_move[2].is_a? Hash)
  end

  def revert_json_piece(piece)
    piece_type = Object.const_get(piece['type'])
    piece_color = piece['color']
    piece_address = piece['address']
    piece_name = piece['name']
    piece_was_moved = piece['was_moved']
    piece = piece_type.new(piece_color, piece_address, piece_name, piece_was_moved)
  end
end
