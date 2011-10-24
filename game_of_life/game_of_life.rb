require 'curses'

class GameOfLife

  #####################
  #                   #
  # Methods To Define #
  #                   #
  #####################

  def initialize(start_state)
    @state = start_state
    @verbose = false
  end

  def set(row, col)
    @state[row][col] = 1
  end

  def to_s
    output = ''
    @state.each do |row|
      row.each { |cell| output += (cell == 1 ? '#' : '.') }
      output += "\n"
    end
    output
  end

  def next
    new_state = []
    @state.each_with_index do |row, row_index|
      new_state[row_index] = []
      row.each_with_index do |cell, col_index|
        new_state[row_index][col_index] = next_cell_value row_index, col_index
      end
    end
    @state = new_state
  end

  def period
    states = []
    until index = states.index(@state)
      states << @state
      self.next
    end
    period = states.count - index
  end

  def animate
    i = 0
    while(i += 1)
      Curses.clear
      Curses.setpos(0, 0)
      Curses.addstr self.to_s
      Curses.addstr "#{i} generations"
      Curses.refresh
      self.next
      sleep 1.5
    end
  end

private
  def neighbors(row, col)
    # NW - subtract 1 from row & col
    # [-1, -1]
    # N  - subtract 1 from row
    # [-1, 0]
    # NE - subtract 1 from row, add 1 to column
    # [-1, 1 ]
    # E  - add 1 to column
    # [0, 1]
    # SE - add 1 to row & col
    # [1, 1]
    # S  - add 1 to row
    # [1, 0]
    # SW - add 1 to row, subtract 1 from column
    # [1, -1]
    # W  - subtract 1 from column
    # [0, -1]
    neighbors = []
    (-1..1).each do |row_modifier|
      (-1..1).each do |col_modifier|
        next if (row_modifier == 0) && (col_modifier == 0)
        neighbor_row = row + row_modifier
        next unless (0...@state.length).include? neighbor_row
        neighbor_col = col + col_modifier
        next unless (0...@state.length).include? neighbor_col
        neighbors << @state[neighbor_row][neighbor_col]
      end
    end
    neighbors
  end
  def living_neighbor_count(row, col)
    puts neighbors(row, col).inspect if @verbose
    neighbors(row, col).inject(0){ |sum, n| sum += n }
  end
  def next_cell_value(row, col)
    value = @state[row][col]
    living_neighbors = living_neighbor_count(row, col)
    puts "[#{row}, #{col}] has #{living_neighbors} living neighbors" if @verbose
    if value == 0
      value = 1 if living_neighbors == 3
    elsif value == 1
      value = 0 unless (2..3).include? living_neighbors
    end
    value
  end

  #############################
  #                           #
  # Predefined Helper Methods #
  #                           #
  #############################
public
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

if ARGV.any?
  # animate the Twin Bees Shuttle pattern for fun
  pattern = %w(.................##.......... ##...............#.#.......## ##.................#.......##
               .................###......... ............................. .............................
               ............................. .................###......... ##.................#.........
               ##...............#.#......... .................##..........)
  b = GameOfLife.empty(50, 50).copy_into(pattern, 10, 10)
  b.animate
end
