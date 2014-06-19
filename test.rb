require 'pry'
require_relative 'AI.rb'

describe AI, "#score" do

  describe "#move" do
    it "should recognize this move" do
      AI.new.make_move([[0,  0,  0],
                        [0,  1,  0],
                        [0,  0,  1]], -1).should eq({x:0, y:0})
    end
  end

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