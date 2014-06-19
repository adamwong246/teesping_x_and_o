require 'pry'
require_relative 'AI.rb'

def human_move
  puts "make your move... (x, y)"
  inputs =/(\d),\s?(\d)/.match(gets.chomp.downcase)
  move = {x: inputs[1], y: inputs[2], z: @referee.players[:human]}
  puts "Human makes move #{move[:x]}, #{move[:y]}: #{@referee.binary_to_xo[move[:z]]}"
  move
end

def computer_move
  move = AI.new.make_move(@referee.board, @referee.players[:computer])
  move[:z] = @referee.players[:computer]
  puts "Computer makes move #{move[:x]}, #{move[:y]}: #{@referee.binary_to_xo[move[:z]]}"
  move
end

@referee = Referee.new

puts "\e[H\e[2J"
puts "Tic tac toe"
puts "Play as x or o?"

case gets.chomp.downcase
when 'x'
  puts "Ok, you are x and computer is o. Your move first"
  @referee.players[:human] = 1
  @referee.players[:computer] = -1

  @referee.draw

when 'o'
  puts "Ok, you are o and computer is x. Computer moves first"
  @referee.players[:human] = -1
  @referee.players[:computer] = 1

  @referee.check_write_check_draw(computer_move)
else
  abort 'Invalid entry'
end

begin
  @referee.check_write_check_draw(human_move)
  @referee.check_write_check_draw(computer_move)
end until false