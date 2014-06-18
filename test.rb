require 'pry'

class AI

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

          # binding.pry

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

describe AI, "#score" do

  describe "#winning_moves" do
    it "should recognize a horizontal win" do
      AI.new.winning_moves([[1,  1,  0],
                            [0,  0,  0],
                            [0,  0,  0]], 1).should include({x:2, y:0})
    end

    it "should recognize a vertical win" do
      AI.new.winning_moves([[1,  0,  0],
                            [1,  0,  0],
                            [0,  0,  0]], 1).should include({x:0, y:2})
    end
    
    it "should recognize a diagonal win" do
      AI.new.winning_moves([[1,  0,  0],
                            [0,  0,  0],
                            [0,  0,  1]
        ], 1).should include({x:1, y:1})
    end

    it "should recognize a reverse diagonal win" do
      AI.new.winning_moves([[0,  0,  1],
                            [0,  0,  0],
                            [1,  0,  0]], 1).should include({x:1, y:1})
    end

    it "should recognize a not-win" do
      AI.new.winning_moves([[1, 0, 0],
                            [0, 0, 0],
                            [0, 0, 0]],1).should be_empty
    end

    it "should recognize a not-win" do
      AI.new.winning_moves([[1, 0, 0],
                            [0, 0, 1],
                            [0, 0, 0]],1).should be_empty
    end

    it "should recognize a not-win" do
      AI.new.winning_moves([[0, 0, 0],
                            [0, 0, 0],
                            [0, 0, 0]],1).should be_empty
    end
  end

  describe "#blocking_moves" do
    it "should recognize a horizontal blocking_moves" do
      AI.new.blocking_moves([[1,  1,  0],
                            [0,  0,  0],
                            [0,  0,  0]], -1).should include({x:2, y:0})
    end

    it "should recognize a vertical blocking_moves" do
      AI.new.blocking_moves([[1,  0,  0],
                            [1,  0,  0],
                            [0,  0,  0]], -1).should include({x:0, y:2})
    end

    it "should recognize a diagonal blocking_moves" do
      AI.new.blocking_moves([[1,  0,  0],
                            [0,  0,  0],
                            [0,  0,  1]], -1).should include({x:1, y:1})
    end

    it "should recognize a reverse diagonal blocking_moves" do
      AI.new.blocking_moves([[0,  0,  1],
                            [0,  0,  0],
                            [1,  0,  0]], -1).should include({x:1, y:1})
    end

    it "should recognize a not-blocking_moves" do
      AI.new.blocking_moves([[1, 0, 0],
                            [0, 0, 0],
                            [0, 0, 0]], -1).should be_empty
    end
  end

  describe "#forking_moves" do
    it "should recognize forking_moves" do
      AI.new.forking_moves([[1,  0,  0],
                            [0,  0,  0],
                            [1,  0,  0]], 1).should include({x:2, y:0}, {x:1, y:1}, {x:2, y:2})
    end

    it "should recognize non-forking_moves" do
      AI.new.forking_moves([[0,  0,  0],
                            [0,  0,  0],
                            [0,  0,  0]], 1).should be_empty
    end
  end

  describe "#fork_blocking_moves" do
    it "should recognize fork_blocking_moves" do
      AI.new.fork_blocking_moves([[1,   0,  0],
                                  [0,   0,  0],
                                  [1,   0,  0]], -1).should include({x:2, y:0}, {x:1, y:1}, {x:2, y:2})
    end

    it "should recognize non-fork_blocking_moves" do
      AI.new.fork_blocking_moves([[0,  0,  0],
                                  [0,  0,  0],
                                  [0,  0,  0]], -1).should be_empty
    end
  end

  describe "#center_moves" do
    it "should return the center square if available" do
      AI.new.center_moves([[0,  0,  0],
                            [0,  0,  0],
                            [0,  0,  0]], 1).should eq([{x:1, y:1}])
    end

    it "should recognize when the center square is taken" do
     AI.new.center_moves([ [0,  0,  0],
                            [0,  1,  0],
                            [0,  0,  0]], 1).should be_empty
    end

    it "should recognize when the center square is taken" do
     AI.new.center_moves([ [0,  0,   0],
                            [0,  -1,  0],
                            [0,  0,   0]], 1).should be_empty
    end
  end

  describe "#opposite_corner_moves" do
     it "should recognize the NE corner" do
     AI.new.opposite_corner_moves([ [0,  0, -1],
                                    [0,  0,  0],
                                    [0,  0,  0]], 1).should  =~ [{x:0, y:2}]
    end

    it "should recognize the SE corner" do
     AI.new.opposite_corner_moves([ [0,  0,  0],
                                    [0,  0,  0],
                                    [0,  0, -1]], 1).should =~ [{x:0, y:0}]
    end
    it "should recognize the SW corner" do
     AI.new.opposite_corner_moves([ [0,  0, 0],
                                    [0,  0, 0],
                                    [-1, 0, 0]], 1).should =~ [{x:2, y:0}]
    end

    it "should recognize the NW corner" do
     AI.new.opposite_corner_moves([ [-1,  0,   0],
                                    [0,  0,  0],
                                    [0,  0,   0]], 1).should =~ [{x:2, y:2}]
    end

    it "should recognize the NW corner with SE already blocked" do
     AI.new.opposite_corner_moves([ [-1,  0,   0],
                                    [0,  0,  0],
                                    [0,  0,   1]], 1).should be_empty
    end
  end

  describe "#empty_corner_moves" do
    it "should return empty corners" do
      AI.new.empty_corner_moves([ [0, 0, 0],
                                  [0, 0, 0],
                                  [0, 0, 0]], 1).should  =~ [{x:0, y:0}, 
                                                              {x:2, y:0},
                                                              {x:0, y:2},
                                                              {x:2, y:2}]
    end

    it "should return empty corners" do
      AI.new.empty_corner_moves([ [0, 0, 0],
                                  [0, 0, 0],
                                  [0, 0, 1]], 1).should  =~ [{x:0, y:0}, 
                                                              {x:2, y:0},
                                                              {x:0, y:2}]
    end

  end

  describe "#empty_side_moves" do 
    it "should return all open sides" do 
      AI.new.empty_side_moves([ [0, 1, 0],
                                  [0, 0, 0],
                                  [0, 0, 0]], 1).should  =~ [{x:1, y:2}, 
                                                              {x:2, y:1},
                                                              {x:0, y:1}]
    end
  end
end