class GameOfLife

  #####################
  #                   #
  # Methods To Define #
  #                   #
  #####################

  def initialize(start_state)
    # Implement me!
  end

  def set(row, col)
    # Implement me!
  end

  def to_s
    # Implement me!
  end

  def next
    # Implement me!
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
