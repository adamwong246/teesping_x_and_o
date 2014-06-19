require 'pry'

class AI

  def make_move(board, key)
    (
      winning_moves(board, key) +
      blocking_moves(board, key) +
      forking_moves(board, key) +
      forking_moves(board, key) +
      fork_blocking_moves(board, key) +
      center_moves(board, key) +
      opposite_corner_moves(board, key) +
      empty_corner_moves(board, key) +
      empty_side_moves(board, key) 
    ).first
  end

  def switcheroo(key)
    if key == :x
      :o
    elsif key == :o
      :x
    end
  end

  def winning_moves(board, key)

    wins = []

    (0..2).each do |i|
      # horizontal
      if "#{board[i][0]}#{board[i][1]}#{board[i][2]}".count(:x.to_s) == 2
        if board[i][0] == :_
          wins << {x:0, y:i}
        elsif board[i][1] == :_
          wins << {x:1, y:i}
        elsif board[i][2] == :_
          wins << {x:2, y:i}
        end
      end

      # vertical
      if "#{board[0][i]}#{board[1][i]}#{board[2][i]}".count(:x.to_s) == 2
        if board[0][i] == :_
          wins << {x:i, y:0}
        elsif board[1][i] == :_
          wins << {x:i, y:1}
        elsif board[2][i] == :_
          wins << {x:i, y:2}
        end
      end

    end

    #diagonal
    if "#{board[0][0]}#{board[1][1]}#{board[2][2]}".count(:x.to_s) == 2
      if board[0][0] == :_
        wins << {x:0, y:0}
      elsif board[1][1] == :_
        wins << {x:1, y:1}
      elsif board[2][2] == :_
        wins << {x:2, y:2}
      end
    end

    # reverse diagonal
    if "#{board[0][2]}#{board[1][1]}#{board[2][0]}".count(:x.to_s) == 2
      if board[0][2] == :_
        wins << {x:2, y:0}
      elsif board[1][1] == :_
        wins << {x:1, y:1}
      elsif board[2][0] == :_
        wins << {x:0, y:2}
      end
    end

    wins
  end

  def blocking_moves(board, key)
    winning_moves(board, switcheroo(key))
  end

  # to test for forking moves
  # mutate the board with a every possible move
  # if a move produces multiple wins, return both moves
  # else return none
  def forking_moves(board, key)
    forking_moves =[]

    (0..2).each do |y|
      (0..2).each do |x|
        if board[y][x] == :_
          mutated_board = Marshal.load(Marshal.dump(board))
          mutated_board[y][x] = key
          mutated_winning_moves = winning_moves(mutated_board, key).uniq
          if mutated_winning_moves.count > 1
            forking_moves << mutated_winning_moves
          end
        end
      end
    end

    forking_moves.flatten
    
  end

  def fork_blocking_moves(board, key)
    forking_moves(board, switcheroo(key)).uniq
  end

  def center_moves(board, key)
    if board[1][1] == :_
      return [{x:1, y:1}]
    else
      []
    end
  end

  def opposite_corner_moves(board, key)
    moves = []
    moves << {x:2, y:2} if board[0][0] == switcheroo(key) && board[2][2] == :_
    moves << {x:0, y:0} if board[2][2] == switcheroo(key) && board[0][0] == :_
    moves << {x:0, y:2} if board[0][2] == switcheroo(key) && board[2][0] == :_
    moves << {x:2, y:0} if board[2][0] == switcheroo(key) && board[0][2] == :_
    moves
  end

  def empty_corner_moves(board, key)
    moves = []
    moves << {x:2, y:2} if board[2][2] == :_
    moves << {x:0, y:0} if board[0][0] == :_
    moves << {x:0, y:2} if board[2][0] == :_
    moves << {x:2, y:0} if board[0][2] == :_
    moves
  end

  def empty_side_moves(board, key)
    moves = []
    moves << {x:0, y:1} if board[1][0] == :_
    moves << {x:2, y:1} if board[1][2] == :_
    moves << {x:1, y:2} if board[2][1] == :_
    moves << {x:1, y:0} if board[0][1] == :_
    moves
  end
end
