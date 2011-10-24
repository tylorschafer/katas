require 'benchmark'
require 'digest/md5'

class GameOfLife

  OUTPUT = [' ', '#']
  
  #####################
  #                   #
  # Methods To Define #
  #                   #
  #####################
  
  def initialize(start_state)
    @current_state = start_state
    @next_state    = Array.new(@current_state.length) { Array.new(@current_state[0].length, 0) }
    
    @height = @current_state.length
    @width  = @current_state[0].length
    
    generate_next_method
  end

  def set(row, col)
    @current_state[row][col] = 1
  end
  
  def to_s
    ary = []
    ary << "+" + "-" * @current_state[0].length + "+"
    @current_state.each do |row|
      ary << "|" + row.map { |state| OUTPUT[state] }.join + "|"
    end
    ary << "+" + "-" * @current_state[0].length + "+"
    
    ary.join "\n"
  end
  
  # def next
  #   # Implement me!
  # end
  
  def period
    analysis = {}
    generation = 0
    current_md5 = Digest::MD5.hexdigest(to_s)
    
    until analysis[ current_md5 ]
      analysis[ current_md5 ] = generation
      self.next
      generation += 1
      current_md5 = Digest::MD5.hexdigest(to_s)
    end
    
    generation - analysis[current_md5]
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

  ##############
  #            #
  # My Methods #
  #            #
  ##############
  
  def valid_neighbors(row, col)
    valid = []

    (-1..1).each do |dr|
      (-1..1).each do |dc|
        nr = row + dr
        nc = col + dc

        not_original_cell = dr != 0 || dc != 0
        on_board = nr >= 0 && nr < @height && nc >= 0 && nc < @width

        valid << [ row + dr, col + dc ] if not_original_cell && on_board
      end
    end

    return valid
  end
  
  def generate_next_method
    code = []
    
    code << "def next"
    @height.times do |row|
      code << "  current_row = @current_state[#{row}]"
      code << "  next_row    = @next_state[#{row}]"
      
      @width.times do |col|
        pairs = valid_neighbors(row, col)
        expr = pairs.map { |r2, c2| "@current_state[#{r2}][#{c2}]" }
        
        code << "  neighbors = " + expr.join(' + ')
        code << "  next_row[#{col}] = neighbors == 3 || current_row[#{col}] + neighbors == 3 ? 1 : 0"
        
      end
    end
    code << "  @next_state, @current_state = @current_state, @next_state"
    code << "end"
    
    metaclass = class << self; self; end
    metaclass.class_eval code.join '; '
  end
  
end