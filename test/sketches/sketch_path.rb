java_alias :background_int, :background, [Java::int]

def setup
  frame_rate(10)  
  puts sketchPath
end

def draw
  background_int 0
  if frame_count == 3    
    exit
  end
end

def settings
  size(300, 300)
  sketchPath SKETCH_ROOT
end

