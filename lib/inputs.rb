class Inputs
  def self.promotion_choice(color)
    chosen_piece = take_user_input('To which piece will the pawn be promoted to? ') do |input|
      %w[rook knight bishop queen].include?(input)
    end
    piece_class = Object.const_get(chosen_piece.capitalize)
    piece_class.new(color, chosen_piece)
  end

  def self.user_pick_movement(color)
    start_goal = nil
    p "#{color.capitalize}'s turn"
    take_user_input("Make a move | Save/Load the game | Declare draw: ") do |input|
      user_input = input.downcase
      input_start = user_input.split(' ')[0]
      input_goal = user_input.split(' ')[1]
      if /^([a-h][1-8]) ([a-h][1-8])$/.match?(user_input)
        chosen_start = convert_chess_address(input_start)
        chosen_goal = convert_chess_address(input_goal)
        start_goal = [chosen_start, chosen_goal]
      elsif user_input == 'save' || user_input == 'load' || user_input == 'draw'
        return user_input
      end
    end
    start_goal
  end

  def self.convert_chess_address(address)
    column = address[0].ord - 97
    row = address[1].to_i - 1
    return [column, row]
  end

  def self.take_user_input(message, &block)
    print message
    user_input = gets.chomp.downcase
    until yield(user_input)
      print message
      user_input = gets.chomp.downcase
    end
    user_input
  end
end
