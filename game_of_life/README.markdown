### Game of Life

This Kata is about implementing John H Conway's *Game of Life*, and determining the period of *oscillators* in the simulator.

The Game of Life is a simple cellular automata—a mathematical simulation played on a 2D grid of cells.  Each cell can be in one of two states: *alive* or *dead*.  Time advances in discrete chunks called *generations*.  The rules for whether a cell is alive or dead in a generation depend on the state of it and its 8 adjacent *neighbors*.  There are four rules to determine the state of cells:

1. A dead cell with exactly 3 living neighbors will become alive. (*Growth*)
2. A living cell with 0 or 1 living neighbors will become dead. (*Isolation*)
3. A living cell with more than 3 living neighbors will become dead. (*Overpopulation*)
4. Otherwise, a cell will remain the same as it was in the previous generation.

### Code Kata

This kata contains two files: `game_of_life.rb` and `game_of_life_test.rb`.  `game_of_life.rb` defines a class `GameOfLife`, with eight methods: `initialize`, `next`, `to_s`, `analyze`, and `set` are all empty, and `GameOfLife.board`, `GameOfLife.empty` and `copy_into` are all predefined.  Your task is to implement the first five methods, so that when you run:

    ruby game_of_life_test.rb
    
all of the tests it contains pass.  The methods are to be defined as follows:

1. `initialize` will receive a 2D array of integers, where 0 = dead and 1 = alive.
2. `set` will receive a *row* and *column*, and needs to set that cell to alive.
3. `next` should advance the simulation to the next generation, as specified in the rules above.
4. `to_s` should provide some sort of string representation of the board.  The details are up to you, but two simulations in the same state should return the same value for `to_s`, regardless of the generation each simulation is at.
5. `period` should calculate the period of the pattern.  Some simulations will eventually repeat a state.  The difference in time between the first and second occurrence of a state is called the period of that state.  Note that the provided initial state might not be one of the ones in the repeating loop.

The three provided methods are defined as follows:

1. `GameOfLife.board` generates a board by parsing an array of strings.  '.' is dead, everything else is alive.  It calls `initialize`.
2. `GameOfLife.empty` generates an empty board of the dimensions provided.  It calls `initialize`.
3. `copy_into` copies a provided array of strings onto the board at the specified top-left coordinate.  It calls `set`.

