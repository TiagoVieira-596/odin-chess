require_relative 'board'
class Inputs
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
end

