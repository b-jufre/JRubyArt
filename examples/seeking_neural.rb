# Based on SeekingNeural example by Daniel Shiffman
# The Nature of Code
# http://natureofcode.com

require 'jruby_art'

module SeekingNeural

  class Perceptron
    # Perceptron is created with n weights and learning constant
    def initialize(n, c)
      @weights = Array.new(n) { rand(0..1.0) }
      @c = c
    end

    # Function to train the Perceptron
    # Weights are adjusted based on vehicle's error
    def train(forces, error)
      trained = @weights.zip(forces.map(&:to_a)
        .map { |a, b| (a * error.x + b * error.y) * @c })
      .map { |w, c| (0.0..1.0).clip(w + c)  }
      @weights = trained
    end

    # Give me a steering result
    def feedforward(forces)
      # Sum all values
      forces.zip(@weights).map { |a, b| a * b }.reduce(Vec2D.new, :+)
      # forces.zip(@weights).map { |a, b| a * b }.reduce(:+)
    end
  end

  # Seek
  # Daniel Shiffman <http://www.shiffman.net>

  class Vehicle
    MAX_SPEED = 4
    MAX_FORCE = 0.1

    attr_reader :brain, :sz, :location, :targets, :desired

    def initialize(n, x, y)
      @brain = Perceptron.new(n, 0.001)
      @acceleration = Vec2D.new
      @velocity = Vec2D.new
      @location = Vec2D.new(x, y)
      @sz = 6.0
    end

    # Method to update location
    def update(width, height)
      # Update velocity
      @velocity += @acceleration
      # Limit speed
      @velocity.set_mag(MAX_SPEED) { @velocity.mag > MAX_SPEED }
      @location += @velocity
      # Reset acceleration to 0 each cycle
      @acceleration *= 0
      @location.x = (0..width).clip location.x
      @location.y = (0..height).clip location.y
    end

    def apply_force(force)
      # We could add mass here if we want A = F / M
      @acceleration += force
    end

    # Here is where the brain processes everything
    def steer(targets, desired)
      # Steer towards all targets
      forces = targets.map { |target| seek(target) }
      # That array of forces is the input to the brain
      result = brain.feedforward(forces)
      # Use the result to steer the vehicle
      apply_force(result)
      # Train the brain according to the error
      error = desired - location
      brain.train(forces, error)
    end

    # A method that calculates a steering force towards a target
    # STEER = DESIRED MINUS VELOCITY
    def seek(target)
      # A vector pointing from the location to the target
      desired = target - location
      # Normalize desired and scale to the maximum speed
      desired.normalize!
      desired *= MAX_SPEED
      # Steering = Desired minus velocity
      steer = desired - @velocity
      # Limit to a maximum steering force
      steer.set_mag(MAX_FORCE) { steer.mag > MAX_FORCE }
      steer
    end

    def display(app)
      # Draw a triangle rotated in the direction of velocity
      theta = @velocity.heading + Math::PI / 2
      app.fill(175)
      app.stroke(0)
      app.stroke_weight(1)
      app.push_matrix
      app.translate(location.x, location.y)
      app.rotate(theta)
      app.begin_shape
      app.vertex(0, -sz)
      app.vertex(-sz * 0.5, sz)
      app.vertex(sz * 0.5, sz)
      app.end_shape(Java::ProcessingCore.PConstants::CLOSE)
      app.pop_matrix
    end
  end
end

class Seeking < Processing::App
  include SeekingNeural
  # A Vehicle controlled by a Perceptron
  attr_reader :targets, :desired, :v

  def setup
    size(640, 360)
    # The Vehicle's desired location
    @desired = Vec2D.new(width / 2, height / 2)
    # Create a list of targets
    make_targets
    # Create the Vehicle (it has to know about the number of targets
    # in order to configure its brain)
    @v = Vehicle.new(targets.size, rand(width), rand(height))
  end

  # Make a random ArrayList of targets to steer towards
  def make_targets
    @targets = Array.new(8) { Vec2D.new(rand(width), rand(height)) }
  end

  def draw
    background(255)
    # Draw a circle to show the Vehicle's goal
    stroke(0)
    stroke_weight(2)
    fill(0, 100)
    ellipse(desired.x, desired.y, 36, 36)
    # Draw the targets
    targets.each do |target|
      no_fill
      stroke(0)
      stroke_weight(2)
      ellipse(target.x, target.y, 16, 16)
      line(target.x, target.y - 16, target.x, target.y + 16)
      line(target.x - 16, target.y, target.x + 16, target.y)
    end
    # Update the Vehicle
    v.steer(targets, desired)
    v.update(width, height)
    v.display self
  end

  def mouse_pressed
    make_targets
  end
end

Seeking.new title: 'Seeking Neural'