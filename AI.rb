require 'pry'

class Referee

  attr_accessor :board, :binary_to_xo, :players

  def initialize
    @players = {}
    @board = Array.new(3) { Array.new(3) { 0 } }

    @binary_to_xo = 
    {
      1=>:x,
      0 => ' ',
      -1=> :o
    }
  end

  def draw
    puts "   0 1 2"
    puts "0 |#{@binary_to_xo[@board[0][0]]}|#{@binary_to_xo[@board[0][1]]}|#{@binary_to_xo[@board[0][2]]}|"
    puts "1 |#{@binary_to_xo[@board[1][0]]}|#{@binary_to_xo[@board[1][1]]}|#{@binary_to_xo[@board[1][2]]}|"
    puts "2 |#{@binary_to_xo[@board[2][0]]}|#{@binary_to_xo[@board[2][1]]}|#{@binary_to_xo[@board[2][2]]}|"
  end

  def check_write_check_draw(move)
    #check
    if @board[move[:y].to_i][move[:x].to_i] == 0
      #set
      @board[move[:y].to_i][move[:x].to_i] = move[:z]
      draw
    else
      abort 'NOT A VALID MOVE'
    end

    abort "CAT" if @board.all? {|sub_array|
      sub_array.all?{|elem|
        elem != 0
      }
    }

    #check
    ## for both players
    [-1, 1].each do |c|

      if (
        (0..2).any? { |i|
          # horizontal
          @board[i][0] + @board[i][1] + @board[i][2] == move[:z]*3 ||
          # vertical
          @board[0][i] + @board[1][i] + @board[2][i] == move[:z]*3
        }
      ) ||
      # diagonal
      @board[0][0] + @board[1][1] + @board[2][2] == move[:z]*3 ||
      # reverse diagonal
      @board[0][2] + @board[1][1] + @board[2][0] == move[:z]*3

        if @players[:human] == move[:z]
          abort "Winner is human (#{@binary_to_xo[c]})"
        elsif @players[:computer] == move[:z]
          abort "Winner is computer (#{@binary_to_xo[c]})"
        end
      end
    end

  end
end

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

  def winning_moves(board, key)

    wins = []

    (0..2).each do |i|
      # horizontal
      if board[i][0] + board[i][1] + board[i][2] == key*2
        if board[i][0] == 0
          wins << {x:0, y:i}

        elsif board[i][1] == 0
          wins << {x:1, y:i}

        elsif board[i][2] == 0
          wins << {x:2, y:i}

        else 
          raise 'wtf?'
        end
      end

      # vertical
      if board[0][i] + board[1][i] + board[2][i] == key*2
        if board[0][i] == 0
          wins << {x:i, y:0}
        elsif board[1][i] == 0
          wins << {x:i, y:1}
        elsif board[2][i] == 0
          wins << {x:i, y:2}
        else 
          raise 'wtf?'
        end
      end

    end

    #diagonal
    if board[0][0] + board[1][1] + board[2][2] == key*2
      if board[0][0] == 0
        wins << {x:0, y:0}
      elsif board[1][1] == 0
        wins << {x:1, y:1}
      elsif board[2][2] == 0
        wins << {x:2, y:2}
      else 
        raise 'wtf?'
      end
    end

    # reverse diagonal
    if board[0][2] + board[1][1] + board[0][2] == key*2
      if board[0][2] == 0
        wins << {x:2, y:0}
      elsif board[1][1] == 0
        wins << {x:1, y:1}
      elsif board[2][0] == 0
        wins << {x:0, y:2}
      else 
        raise 'wtf?'
      end
    end


    wins
  end

  def blocking_moves(board, key)
    winning_moves(board, key*-1)
  end

  # to test for forking moves
  # mutate the board with a every possible move
  # if a move produces multiple wins, return both moves
  # else return none
  def forking_moves(board, key)
    forking_moves =[]

    (0..2).each do |y|
      (0..2).each do |x|
        if board[y][x] == 0
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
    forking_moves(board, key*-1).uniq
  end

  def center_moves(board, key)
    if board[1][1] == 0
      return [{x:1, y:1}]
    else
      []
    end
  end

  def opposite_corner_moves(board, key)
    moves = []
    moves << {x:2, y:2} if board[0][0] == key * -1 && board[2][2] == 0
    moves << {x:0, y:0} if board[2][2] == key * -1 && board[0][0] == 0
    moves << {x:0, y:2} if board[0][2] == key * -1 && board[2][0] == 0
    moves << {x:2, y:0} if board[2][0] == key * -1 && board[0][2] == 0
    moves
  end

  def empty_corner_moves(board, key)
    moves = []
    moves << {x:2, y:2} if board[2][2] == 0
    moves << {x:0, y:0} if board[0][0] == 0
    moves << {x:0, y:2} if board[2][0] == 0
    moves << {x:2, y:0} if board[0][2] == 0
    moves
  end

  def empty_side_moves(board, key)
    moves = []
    moves << {x:0, y:1} if board[1][0] == 0
    moves << {x:2, y:1} if board[1][2] == 0
    moves << {x:1, y:2} if board[2][1] == 0
    moves << {x:1, y:0} if board[0][1] == 0
    moves
  end
end
