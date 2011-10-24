require 'test/unit'
require './game_of_life'
begin; require 'turn'; rescue LoadError; end

class GameOfLifeTest < Test::Unit::TestCase

  ###############
  #             #
  # Testing set #
  #             #
  ###############
  
  SINGLE_CELLS = {
    [0, 1] => %w(.#. ... ...),
    [1, 1] => %w(... .#. ...),
    [2, 0] => %w(... ... #..)
  }
  
  def test_set
    SINGLE_CELLS.each do |(row, col), after|
      via_set = GameOfLife.empty(3, 3)
      via_set.set(row, col)
      
      direct = GameOfLife.board(after)
      
      assert_equal direct.to_s, via_set.to_s, "row = #{ row }, col = #{ col }"
    end
  end
  
  ################
  #              #
  # Testing to_s #
  #              #
  ################
  
  PATTERN_TO_CHANGE = %w(.#.# #.#. .#.# #.#.)
  
  def test_change
    life = GameOfLife.board(PATTERN_TO_CHANGE)
    board = life.to_s
    
    life.next

    assert_not_equal life.to_s, board
  end
  
  ################
  #              #
  # Testing next #
  #              #
  ################
  
  PATTERNS = {
    %w(.#. .#. .#.) => %w(... ### ...),
    %w(##.. ##.. ..## ..##) => %w(##.. #... ...# ..##),
    %w(##.. #... ...# ..##) => %w(##.. ##.. ..## ..##),
    %w(..#.##.. .###..#. ##..#.#. ...##... #.#.#.#. ..#...## .######. .##.....) => %w(.##.##.. #.....#. ##..#... #.#.#... .##.#.## .......# ....#### .#..##..)
  }

  def test_patterns
    PATTERNS.each do |before, after|
      life_before = GameOfLife.board(before)
      life_after  = GameOfLife.board(after)
      
      life_before.next
      
      assert_equal life_after.to_s, life_before.to_s
    end
  end

  GLIDER = %w(.#. ..# ###)

  def test_glider
    before = GameOfLife.empty(5, 5).copy_into(GLIDER, 0, 0)
    after  = GameOfLife.empty(5, 5).copy_into(GLIDER, 2, 2)
    
    8.times do
      assert_not_equal before.to_s, after.to_s
      before.next
    end

    assert_equal before.to_s, after.to_s
  end

  ##################
  #                #
  # Testing period #
  #                #
  ##################

  OSCILLATORS = {
    %w(.#. .#. .#.) => 2,                                                             # Blinker
    %w(.#........#. #.#......#.# .#.##..##.#. ....#..#.... ....#..#....) => 3,        # Bent Keys
    %w(#####.#####) => 3,                                                             # Pulsar
    %w(...##. ..#..# #..#.# ....#. #.##.. .#....) => 4,                               # Mold
    %w(...##... ..#..#.. .#....#. #......# #......# .#....#. ..#..#.. ...##...) => 5, # Octagon 2
    %w(.##..... .##..... ........ .#...... #.#..... #..#..## ....#.## ..##....) => 6, # Unix
    %w(.................##.......... ##...............#.#.......## ##.................#.......##
       .................###......... ............................. .............................
       ............................. .................###......... ##.................#.........
       ##...............#.#......... .................##..........) => 46             # Twin Bees Shuttle
  }

  def test_oscillators
    OSCILLATORS.each do |pattern, period|
      b = GameOfLife.empty(50, 50).copy_into(pattern, 10, 10)
      assert_equal period, b.period, pattern.inspect
    end
  end
  
end
