board = Array.new(3) { Array.new(3) { ' ' } }

puts "Tic tac toe"
puts "Play as X or O?"

case gets.chomp.downcase
when 'x'
  puts "Ok, you are X and computer is O. Your move first"
  human = :x
  computer = :o
when 'o'
  puts "Ok, you are O and computer is X. Computer moves first"
  human = :o
  computer = :x
else
  abort 'Invalid entry'
end

puts "   1 2 3"
puts "A |#{board[0][0]}|#{board[1][0]}|#{board[2][0]}|"
puts "B |#{board[0][1]}|#{board[1][1]}|#{board[2][1]}|"
puts "C |#{board[0][2]}|#{board[1][2]}|#{board[2][2]}|"