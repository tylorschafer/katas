class Ukulele

  STANDARD_TUNING = [7, 0, 4, 9]
  
  def initialize(tuning = STANDARD_TUNING)
    @strings = tuning.map { |root| String.new(root) }
  end
  
  def fingerings(chord)
    chord = chord.uniq.sort
    
    notes = @strings.map { |string| string.valid_fingerings chord }
    fingerings = notes.map { |string| string.keys }
    
    potential_fingerings = Array( Combinations.new fingerings )
    valid_fingerings     = potential_fingerings.select { |fingering| is_valid_fingering? notes, chord, fingering }
    playable_fingerings  = valid_fingerings.select     { |fingering| is_playable_fingering? fingering }
    adjacent_fingerings  = playable_fingerings.select  { |fingering| is_adjacent_fingering? fingering }
  end

  def is_valid_fingering?(notes, chord, fingering)
    played_notes = []
    fingering.each_with_index { |fret, string| played_notes << notes[string][fret] }
    
    return played_notes.uniq.sort == chord
  end
  
  def is_playable_fingering?(fingering)
    played_frets = fingering.reject { |n| n == 0 }
    played_frets.max - played_frets.min <= 4
  end
  
  def is_adjacent_fingering?(fingering)
    absolute_notes = (0...4).map { |i| @strings[i].note fingering[i] }
    absolute_notes.max - absolute_notes.min <= 12
  end
  
end

class String
  
  def initialize(root)
    @root = root
  end
  
  def valid_fingerings(chord)
    fingerings = {}
    
    (0..12).each do |fret|
      note = (@root + fret) % 12

      fingerings[fret] = note if chord.include? note
    end
    
    return fingerings
  end
  
  def note(fret)
    @root + fret
  end
    
end

class Combinations

  def initialize(array)
    @possibilities = array
  end
  
  def to_ary
    @possibilities.inject(nil) { |collection, possibilities| assemble(collection, possibilities) }
  end
  
  def assemble(recurse, possibilities)
    if recurse.nil?
      possibilities.map { |pos| Array(pos) }
    else
      recurse.map { |ary| possibilities.map { |pos| ary + [pos] } }.flatten(1)
    end
  end
  
end

u = Ukulele.new
u.fingerings([0, 3, 6, 11]).sort.each { |f| puts f.inspect }
