class Referee

  attr_accessor :board, :binary_to_xo, :players

  def initialize
    @players = {}
    @board = Array.new(3) { Array.new(3) { :_ } }
  end

  def draw
    puts "   0 1 2"
    puts "0 |#{@board[0][0]}|#{@board[0][1]}|#{@board[0][2]}|"
    puts "1 |#{@board[1][0]}|#{@board[1][1]}|#{@board[1][2]}|"
    puts "2 |#{@board[2][0]}|#{@board[2][1]}|#{@board[2][2]}|"
  end

  def check_write_check_draw(move)
    #check
    if @board[move[:y].to_i][move[:x].to_i] == :_
      #set
      @board[move[:y].to_i][move[:x].to_i] = move[:z]
      draw
    else
      abort 'NOT A VALID MOVE'
    end

    abort "CAT" if @board.all? {|sub_array|
      sub_array.all?{|elem|
        elem != :_
      }
    }

    match = "#{move[:z]}#{move[:z]}#{move[:z]}"

    #check
    ## for both players
    [-1, 1].each do |c|

      if (
        (0..2).any? { |i|
          # horizontal
          "#{@board[i][0]}#{@board[i][1]}#{@board[i][2]}" == match ||
          # vertical
          "#{@board[0][i]}#{@board[1][i]}#{@board[2][i]}" == match
        }
      ) ||
      # diagonal
      "#{@board[0][0]}#{@board[1][1]}#{@board[2][2]}" == match ||
      # reverse diagonal
      "#{@board[0][2]}#{@board[1][1]}#{@board[2][0]}" == match

        if @players[:human] == move[:z]
          abort "Winner is human (#{@players[:human]})"
        elsif @players[:computer] == move[:z]
          abort "Winner is computer (#{@players[:computer]})"
        end
      end
    end

  end
end