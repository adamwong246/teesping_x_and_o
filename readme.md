#### readme

- install the gems ```bundle install```
- run the tests ```rspec```
- play the game ```ruby tic_tac_toe```

There are 3 components
- AI: the computer player
- Referee: responsible for checking legality of moves and end-of-game 
- tic_tac_toe.rb: accepts user input and directs general flow of the game

The AI simply implements the known best algorithm for playing the game as described here https://en.wikipedia.org/wiki/Tic-tac-toe#Strategy as follows

1. Win: If the player has two in a row, they can place a third to get three in a row.
The AI simply checks the 8 possible winning states, returning the first empty space which will fullfill the win.

2. Block: If the opponent has two in a row, the player must play the third themself to block the opponent.
The AI reuses the winning_moves method. Acting as it's opponent, it looks for winning moves then blocks that move with it's own mark.

3. Fork: Create an opportunity where the player has two threats to win (two non-blocked lines of 2).
AI makes forking moves are found by mutating the board in every way and once again using the winning_moves method. If a single winning move on this mutated board provides more than 1 winning situation, it is returned.

4. Blocking an opponent's fork:
-- Option 1: The player should create two in a row to force the opponent into defending, as long as it doesn't result in them creating a fork. For example, if "X" has a corner, "O" has the center, and "X" has the opposite corner as well, "O" must not play a corner in order to win. (Playing a corner in this scenario creates a fork for "X" to win.)
-- Option 2: If there is a configuration where the opponent can fork, the player should block that fork.
Similarly to blocking, the AI acts as it's opponent on a mutated board, this time using the forking method instead of winning. 

5. Center: A player marks the center. (If it is the first move of the game, playing on a corner gives "O" more opportunities to make a mistake and may therefore be the better choice; however, it makes no difference between perfect players.)
AI takes the center if available.

6. Opposite corner: If the opponent is in the corner, the player plays the opposite corner.
AI takes the first empty corner opposite an opponent's mark

7. Empty corner: The player plays in a corner square.
AI takes the first empty corner

8. Empty side: The player plays in a middle square on any of the 4 sides.
AI takes the first empty side

The AI simply performs the following checks, returning the first move which accepting of one of these criteria. 

