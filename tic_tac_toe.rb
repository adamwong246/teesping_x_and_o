require 'pry'
require_relative 'AI.rb'

def draw
  puts "   0 1 2"
  puts "0 |#{@binary_to_x_and_o[@board[0][0]]}|#{@binary_to_x_and_o[@board[0][1]]}|#{@binary_to_x_and_o[@board[0][2]]}|"
  puts "1 |#{@binary_to_x_and_o[@board[1][0]]}|#{@binary_to_x_and_o[@board[1][1]]}|#{@binary_to_x_and_o[@board[1][2]]}|"
  puts "2 |#{@binary_to_x_and_o[@board[2][0]]}|#{@binary_to_x_and_o[@board[2][1]]}|#{@binary_to_x_and_o[@board[2][2]]}|"
end

def check_write_check_draw(move)
  #check
  if @board[move[:y].to_i][move[:x].to_i] == 0
    #set
    @board[move[:y].to_i][move[:x].to_i] = move[:z]
    draw
  else
    raise 'NOT A VALID MOVE'
  end

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

      if @players[:human] == c
        # binding.pry
        abort "Winner is human (#{@binary_to_x_and_o[c]})"
      elsif @players[:computer] == c
        # binding.pry
        abort "Winner is computer (#{@binary_to_x_and_o[c]})"
      end
    end
  end

end

def human_move
  puts "make your move... (x, y)"
  inputs =/(\d),\s?(\d)/.match(gets.chomp.downcase)
  move = {x: inputs[1], y: inputs[2], z: @players[:human]}
  puts "Human makes move #{move[:x]}, #{move[:y]}: #{@binary_to_x_and_o[move[:z]]}"
  move
end

def computer_move
  move = AI.new.make_move(@board, @players[:computer])
  move[:z] = @players[:computer]
  puts "Computer makes move #{move[:x]}, #{move[:y]}: #{@binary_to_x_and_o[move[:z]]}"
  move
end

@board = Array.new(3) { Array.new(3) { 0 } }
quit = false
@binary_to_x_and_o = {
  1=>:x,
  0 => ' ',
  -1=> :o
}

@players = {}

puts "\e[H\e[2J"
puts "Tic tac toe"
puts "Play as x or o?"

case gets.chomp.downcase
when 'x'
  puts "Ok, you are x and computer is o. Your move first"
  @players[:human] = 1
  @players[:computer] = -1

  draw

when 'o'
  puts "Ok, you are o and computer is x. Computer moves first"
  @players[:human] = -1
  @players[:computer] = 1

  draw
  check_write_check_draw(computer_move)
else
  abort 'Invalid entry'
end

begin
  check_write_check_draw(human_move)
  check_write_check_draw(computer_move)
end until false