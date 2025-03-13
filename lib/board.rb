Dir.glob(File.join(__dir__, 'pieces', '*.rb')).each { |file| require_relative file }
require_relative 'inputs'
class ChessBoard
  attr_accessor :board, :moves_made

  def initialize
    @board = Array.new(8) { {} }
    populate_new_board
    # uses [x, y] notation
    @last_move = []
  end

  def layout
    layout = "+--+--+--+--+--+--+--+--+\n"
    board.reverse.each do |row|
      row_string = ''
      row.sort.to_h.each_value do |piece|
        piece = ' ' if piece == 'empty'
        row_string += "|#{piece} "
      end
      layout += "#{row_string}|\n"
      layout += "+--+--+--+--+--+--+--+--+\n"
    end
    layout
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
        temp_board.make_move(previous_address, possible_move)

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
        temp_board.make_move(previous_address, possible_move)

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

  def make_move(start, goal)
    moving_piece = @board[start[1]][start[0]]

    # in case of the en passant special move
    if moving_piece != 'empty' && moving_piece.possible_moves(start, @last_move,
                                                              @board).include?(goal) && (moving_piece.is_a? Pawn)
      @board[goal[1]][goal[0]] = moving_piece
      moving_piece.address = goal
      @board[start[1]][start[0]] = 'empty'
      @board[goal[1] - 1][goal[0]] = 'empty'
      moving_piece.was_moved = true
      @last_move = [start, goal, moving_piece]
    end

    # make the move if the chosen address is not empty and the move is legal
    return unless moving_piece != 'empty' && moving_piece.possible_moves(@board).include?(goal)

    # promote if a pawn reaches the end of the board
    moving_piece = promotion_choice(moving_piece.color) if (goal[1] == 7 || goal[1].zero?) && (moving_piece.is_a? Pawn)

    # change the board according to the move made and change the pieces states
    @board[goal[1]][goal[0]] = moving_piece
    moving_piece.address = goal
    @board[start[1]][start[0]] = 'empty'
    moving_piece.was_moved = true
    @last_move = [start, goal, moving_piece]

    # in case of the castle special move
    if goal == ([start[0] + 2, start[1]]) && (moving_piece.is_a? King)
      @board[goal[1]][goal[0] - 1] = Rook.new(moving_piece.color, 'rook')
      @board[goal[1]][goal[0] - 1].address = [goal[1], goal[0] - 1]
      @board[goal[1]][goal[0] + 1] = 'empty'
    elsif (goal == [start[0] - 3, start[1]]) && (moving_piece.is_a? King)
      @board[goal[1]][goal[0] + 1] = Rook.new(moving_piece.color, 'rook')
      @board[goal[1]][goal[0] + 1].address = [goal[1], goal[0] + 1]
      @board[goal[1]][goal[0] - 1] = 'empty'
    end
  end

  def populate_new_board
    (0..7).each do |column|
      @board[1][column] = Pawn.new('black', [column, 1], 'pawn')
      @board[6][column] = Pawn.new('white', [column, 6], 'pawn')
      (2..5).each { |row| @board[row][column] = 'empty' }
    end
    address = 0
    pieces_order = [Rook, Knight, Bishop, Queen, King]
    pieces_order.each do |piece|
      @board[0][address] = piece.new('black', [address, 0], piece.to_s.downcase)
      @board[7][address] = piece.new('white', [address, 7], piece.to_s.downcase)
      unless [Queen, King].include?(piece)
        @board[0][7 - address] = piece.new('black', [7 - address, 0], piece.to_s.downcase)
        @board[7][7 - address] = piece.new('white', [7 - address, 7], piece.to_s.downcase)
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
end
