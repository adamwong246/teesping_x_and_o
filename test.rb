#my_model.rb
class AI
  def hit(pins)
  end

  def score
    0
  end

  def win(board, key)

    (0..2).each do |i|
      if board[i][0] + board[i][1] + board[i][2] == key*2
        if board[i][0] == 0
          return {x:i, y:0}
        elsif board[i][1] == 0
          return {x:i, y:1}
        elsif board[i][2] == 0
          return {x:i, y:2}
        else 
          raise 'wtf?'
        end
      end
    end

    false

  end
end

describe AI, "#score" do
  it "returns 0 for all gutter game" do
    bowling = AI.new
    20.times { bowling.hit(0) }
    bowling.score.should eq(0)
  end

  describe "#win" do
    it "should recognize a win" do
      AI.new.win(
        [
          [1, 1, 0],
          [0, 0, 0],
          [0, 0, 0]
        ], 1).should eq({x:0, y:2})
    end

    it "should recognize a win" do
      AI.new.win(
        [
          [-1, -1, 0],
          [0, 0, 0],
          [0, 0, 0]
        ], -1).should eq({x:0, y:2})
    end

    it "should recognize a not-win" do
      AI.new.win(
        [
          [1, 0, 0],
          [0, 0, 0],
          [0, 0, 0]
        ],
        1
      ).should eq(false)
    end
  end
end