require_relative 'board'
require 'json'
require_relative 'inputs'
class Game
  def play_game(chess_board = ChessBoard.new)
    # turn any string keys into integer keys
    game_state = {'checkmate' => false, 'stalemate' => false, 'draw' => false}
    until (game_state['checkmate'] || game_state['stalemate'] || game_state['draw'])
      chess_board.reformat_chess_board
      print chess_board.layout
      last_piece_address = chess_board.last_move[1]
      last_piece_moved = chess_board.board[last_piece_address[1]][last_piece_address[0]]
      last_turn = last_piece_moved.color
      current_turn = last_turn == 'black' ? 'white' : 'black'
      chosen_move = Inputs.user_pick_movement(current_turn)
      if chosen_move == 'save'
        to_json(chess_board) 
        next
      end

      if chosen_move == 'load'
        Game.from_json(File.read('saves/saves.json'), chess_board)
        next
      end

      if chosen_move == 'draw'
        puts `clear`
        print chess_board.layout
        current_turn = current_turn == 'black' ? 'white' : 'black'
        if Inputs.user_pick_movement(current_turn) == 'draw'
          game_state['draw'] = true
          break
        end
        next
      end

      chess_board.make_move(chosen_move[0], chosen_move[1], current_turn)
      if chess_board.checkmate?(last_turn)
        game_state['checkmate'] = true
        break
      elsif chess_board.stalemate?(last_turn)
        game_state['stalemate'] = true
        break
      end
    end
    puts "It's a draw!" if game_state['draw']
    puts "Checkmate, #{current_turn} won!!!" if game_state['checkmate']
    puts "Stalemate, #{current_turn} won!!!" if game_state['stalemate']
  end

  def to_json(current_chess_game, *_args)
    json_object = JSON.dump({
                             board: current_chess_game.board,
                             last_move: current_chess_game.last_move
                            })
    File.write('saves/saves.json', json_object)
  end

  def self.from_json(json_object, current_chess_game_object)
    saved_game_data = JSON.load(json_object)
    return if saved_game_data.nil?

    current_chess_game_object.board = saved_game_data['board']
    current_chess_game_object.last_move = saved_game_data['last_move']
  end
end
game = Game.new
game.play_game