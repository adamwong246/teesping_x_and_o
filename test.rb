require 'pry'
require './AI.rb'

describe AI, "#score" do

  describe "#move" do
    it "should recognize this move" do
      AI.new.make_move([[:_, :_, :_],
                        [:_, :x, :_],
                        [:_, :_, :x]], :o).should eq({x:0, y:0})
    end
  end

  describe "#winning_moves" do
    it "should recognize a horizontal win" do
      AI.new.winning_moves([[:x,  :x,  :_],
                            [:_,  :_,  :_],
                            [:_,  :_,  :_]], :x).should include({x:2, y:0})
    end

    it "should recognize a vertical win" do
      AI.new.winning_moves([[:x,  :_,  :_],
                            [:x,  :_,  :_],
                            [:_,  :_,  :_]], :x).should include({x:0, y:2})
    end
    
    it "should recognize a diagonal win" do
      AI.new.winning_moves([[:x,  :_,  :_],
                            [:_,  :_,  :_],
                            [:_,  :_,  :x]], :x).should include({x:1, y:1})
    end

    it "should recognize a reverse diagonal win" do
      AI.new.winning_moves([[:_,  :_,  :x],
                            [:_,  :_,  :_],
                            [:x,  :_,  :_]], :x).should include({x:1, y:1})
    end

    it "should recognize a not-win" do
      AI.new.winning_moves([[:x, :_, :_],
                            [:_, :_, :_],
                            [:_, :_, :_]],:x).should be_empty
    end

    it "should recognize a not-win" do
      AI.new.winning_moves([[:x, :_, :_],
                            [:_, :_, :x],
                            [:_, :_, :_]],:x).should be_empty
    end

    it "should recognize a not-win" do
      AI.new.winning_moves([[:_, :_, :_],
                            [:_, :_, :_],
                            [:_, :_, :_]],:x).should be_empty
    end
  end

  describe "#blocking_moves" do
    it "should recognize a horizontal blocking_moves" do
      AI.new.blocking_moves([[:x,  :x,  :_],
                            [:_,  :_,  :_],
                            [:_,  :_,  :_]], :o).should include({x:2, y:0})
    end

    it "should recognize a vertical blocking_moves" do
      AI.new.blocking_moves([[:x,  :_,  :_],
                            [:x,  :_,  :_],
                            [:_,  :_,  :_]], :o).should include({x:0, y:2})
    end

    it "should recognize a diagonal blocking_moves" do
      AI.new.blocking_moves([[:x,  :_,  :_],
                            [:_,  :_,  :_],
                            [:_,  :_,  :x]], :o).should include({x: 1, y: 1})
    end

    it "should recognize a reverse diagonal blocking_moves" do
      AI.new.blocking_moves([[:_,  :_,  :x],
                            [:_,  :_,  :_],
                            [:x,  :_,  :_]], :o).should include({x: 1, y: 1})
    end

    it "should recognize a not-blocking_moves" do
      AI.new.blocking_moves([[:x, :_, :_],
                            [:_, :_, :_],
                            [:_, :_, :_]], :o).should be_empty
    end
  end

  describe "#forking_moves" do
    it "should recognize forking_moves" do
      AI.new.forking_moves([[:x,  :_,  :_],
                            [:_,  :_,  :_],
                            [:x,  :_,  :_]], :x).should include({x:2, y:0}, {x:1, y:1}, {x:2, y:2})
    end

    it "should recognize non-forking_moves" do
      AI.new.forking_moves([[:_,  :_,  :_],
                            [:_,  :_,  :_],
                            [:_,  :_,  :_]], :x).should be_empty
    end
  end

  describe "#fork_blocking_moves" do
    it "should recognize fork_blocking_moves" do
      AI.new.fork_blocking_moves([[:x,   :_,  :_],
                                  [:_,   :_,  :_],
                                  [:x,   :_,  :_]], :o).should include({x:2, y:0}, {x: 1, y: 1}, {x:2, y:2})
    end

    it "should recognize non-fork_blocking_moves" do
      AI.new.fork_blocking_moves([[:_,  :_,  :_],
                                  [:_,  :_,  :_],
                                  [:_,  :_,  :_]], :o).should be_empty
    end
  end

  describe "#center_moves" do
    it "should return the center square if available" do
      AI.new.center_moves([[:_,  :_,  :_],
                            [:_,  :_,  :_],
                            [:_,  :_,  :_]], :x).should eq([{x: 1, y: 1}])
    end

    it "should recognize when the center square is taken" do
     AI.new.center_moves([ [:_,  :_,  :_],
                            [:_,  :x,  :_],
                            [:_,  :_,  :_]], :x).should be_empty
    end

    it "should recognize when the center square is taken" do
     AI.new.center_moves([ [:_,  :_,   :_],
                            [:_,  :o,  :_],
                            [:_,  :_,   :_]], :x).should be_empty
    end
  end

  describe "#opposite_corner_moves" do
    it "should recognize the NE corner" do
     AI.new.opposite_corner_moves([ [:_,  :_, :o],
                                    [:_,  :_,  :_],
                                    [:_,  :_,  :_]], :x).should  =~ [{x:0, y:2}]
    end

    it "should recognize the SE corner" do
     AI.new.opposite_corner_moves([ [:_,  :_,  :_],
                                    [:_,  :_,  :_],
                                    [:_,  :_, :o]], :x).should =~ [{x:0, y:0}]
    end
    it "should recognize the SW corner" do
     AI.new.opposite_corner_moves([ [:_,  :_, :_],
                                    [:_,  :_, :_],
                                    [:o, :_, :_]], :x).should =~ [{x:2, y:0}]
    end

    it "should recognize the NW corner" do
     AI.new.opposite_corner_moves([ [:o,  :_,   :_],
                                    [:_,  :_,  :_],
                                    [:_,  :_,   :_]], :x).should =~ [{x:2, y:2}]
    end

    it "should recognize the NW corner with SE already blocked" do
     AI.new.opposite_corner_moves([ [:o,  :_,   :_],
                                    [:_,  :_,  :_],
                                    [:_,  :_,   :x]], :x).should be_empty
    end
  end

  describe "#empty_corner_moves" do
    it "should return empty corners" do
      AI.new.empty_corner_moves([ [:_, :_, :_],
                                  [:_, :_, :_],
                                  [:_, :_, :_]], :x).should  =~ [{x:0, y:0}, 
                                                              {x:2, y:0},
                                                              {x:0, y:2},
                                                              {x:2, y:2}]
    end

    it "should return empty corners" do
      AI.new.empty_corner_moves([ [:_, :_, :_],
                                  [:_, :_, :_],
                                  [:_, :_, :x]], :x).should  =~ [{x:0, y:0}, 
                                                              {x:2, y:0},
                                                              {x:0, y:2}]
    end
  end

  describe "#empty_side_moves" do 
    it "should return all open sides" do 
      AI.new.empty_side_moves([ [:_, :x, :_],
                                  [:_, :_, :_],
                                  [:_, :_, :_]], :x).should  =~ [{x: 1, y:2}, 
                                                              {x:2, y: 1},
                                                              {x:0, y: 1}]
    end
  end
end