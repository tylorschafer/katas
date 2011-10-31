
class GameOfLife

  #####################
  #                   #
  # Methods To Define #
  #                   #
  #####################

  def initialize(start_state)
    @the_board = start_state
  end

  def set(row, col)
    @the_board[row,col] = 1
  end

  def to_s
    @the_board.map{|a| a.inspect}.join("")
  end

  def next
    @the_board.each_with_index {|value, index| puts "#{value} => #{index}"}
  end

  def period
    # Implement me!
  end

  #############################
  #                           #
  # Predefined Helper Methods #
  #                           #
  #############################
  
  def self.board(array)
    start_state = array.map { |string| string.split('').map { |char| " ."[char] ? 0 : 1 }}
    GameOfLife.new(start_state)
  end
  
  def self.empty(rows, cols)
    start_state = Array.new(rows) { Array.new(cols, 0) }
    GameOfLife.new(start_state)
  end
  
  def copy_into(pattern, row, col)
    pattern.each_with_index do |pattern_row, ir|
      pattern_row.split('').each_with_index do |pattern_cell, ic|
        set(row + ir, col + ic) unless pattern_cell == '.'
      end
    end
    self
  end
end

SINGLE_CELLS = {
  [0, 1] => %w(.#. ... ...),
  [1, 1] => %w(... .#. ...),
  [2, 0] => %w(... ... #..)
}
  SINGLE_CELLS.each do |(row, col), after|
    via_set = GameOfLife.empty(3, 3)
    puts "row: " + row.inspect
    puts "col: " + col.inspect
    puts 
    #via_set.set(row, col)
    #via_set.next
    #puts via_set.to_s
    
  end