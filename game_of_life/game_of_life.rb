class GameOfLife

  #####################
  #                   #
  # Methods To Define #
  #                   #
  #####################

  def initialize(grid)
    @cells = []
    
    grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        @cells << LifeCell.new(cell, row_index, column_index)
      end
    end
    
    @cells.each { |cell| cell.identify_neighbors @cells }
  end
  
  def next
    @cells.each { |cell| cell.calculate_next_state }
    @cells.each { |cell| cell.update               }
  end
  
  def period
    states = { to_s => 0 }
    self.next
    generation = 1

    until states[to_s]
      states[to_s] = generation
      self.next
      generation += 1
    end
    
    return generation - states[to_s]
  end

  def set(row, col)
    @cells.detect { |cell| cell.row == row && cell.column == col }.set_alive
  end
  
  def to_s
    @cells.join
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

class LifeCell
  
  attr_accessor :row, :column
  
  def initialize(status, row, column)
    set_alive if status == 1
    @row = row
    @column = column
  end
  
  def identify_neighbors(cells)
    @neighbors = cells.select { |cell| LifeCell.distance(self, cell) == 1 }
  end
  
  def self.distance(cell1, cell2)
    [ (cell1.row - cell2.row).abs, (cell1.column - cell2.column).abs ].max
  end
  
  def living_neighbors
    @neighbors.select { |cell| cell.is_alive? }.length
  end
  
  def is_alive?
    @current
  end
  
  def set_alive
    @current = true
  end
  
  def calculate_next_state
    strategy = is_alive? ? AliveStrategy : DeadStrategy
    
    @next = strategy.next_state(self)
  end
  
  def update
    @current = @next
  end
  
  def to_s
    is_alive? ? '#' : '.' 
  end
  
end

class AliveStrategy
  
  def self.next_state(cell)
    [2, 3].include? cell.living_neighbors
  end
  
end

class DeadStrategy

  def self.next_state(cell)
    cell.living_neighbors == 3
  end  
  
end
