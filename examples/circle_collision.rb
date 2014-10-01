require 'jruby_art'

class Ball
  include Processing::Proxy
  attr_accessor :position, :r, :m, :velocity, :app
  
  def initialize(app, x = 0.0, y = 0.0, r = 0.0)
    @app = app
    @position = Vec2D.new(x, y)
    @r = r
    @m = r * 0.1
    @velocity = Vec2D.new(rand(-3.0..3), rand(-3.0..3))
  end
  
  def update
    @position += velocity
  end
  
  def check_boundary(width, height)
    if !(r..width - r).include?(position.x)
      (position.x > width - r) ? position.x = width - r : position.x = r
      velocity.x *= -1
    elsif !(r..height - r).include?(position.y)
      (position.y > height - r) ? position.y = height - r : position.y = r
      velocity.y *= -1
    end
  end
  
  def check_collision(other_ball)
    # get distances between the balls components
    difference = other_ball.position - position
    # calculate magnitude of the vector separating the balls
    return unless difference.mag < (r + other_ball.r)
    # get angle of difference
    theta  = difference.heading
    # precalculate trig values
    sine = Math.sin(theta)
    cosine = Math.cos(theta)
    # ball_array will hold rotated ball positions. You just
    # need to worry about ball_array[1] position
    ball_array = [Ball.new(app), Ball.new(app)]
    # other_ball's position is relative to ball's
    # so you can use the vector between them (difference) as the
    # reference point in the rotation expressions.
    # ball_array[0].x and ball_array[0].y will initialize
    # automatically to 0.0, which is what you want
    # since other_ball will rotate around ball
    ball_array[1].position.x  = cosine * difference.x + sine * difference.y
    ball_array[1].position.y  = cosine * difference.y - sine * difference.x
    # rotate Temporary velocities
    velocity_array = [Vec2D.new, Vec2D.new]
    velocity_array[0].x  = cosine * velocity.x + sine * velocity.y
    velocity_array[0].y  = cosine * velocity.y - sine * velocity.x
    velocity_array[1].x  = cosine * other_ball.velocity.x + sine * other_ball.velocity.y
    velocity_array[1].y  = cosine * other_ball.velocity.y - sine * other_ball.velocity.x
    # Now that velocities are rotated, you can use 1D
    # conservation of momentum equations to calculate
    # the final velocity along the x-axis.
    final_velocities = [Vec2D.new, Vec2D.new]
    # final rotated velocity for ball
    final_velocities[0].x = ((m - other_ball.m) * velocity_array[0].x + 2 * other_ball.m * velocity_array[1].x) / (m + other_ball.m)
    final_velocities[0].y = velocity_array[0].y
    # final rotated velocity for ball
    final_velocities[1].x = ((other_ball.m - m) * velocity_array[1].x + 2 * m * velocity_array[0].x) / (m + other_ball.m)
    final_velocities[1].y = velocity_array[1].y
    # HACK: to avoid clumping
    # ball_array[0].position.x += final_velocities[0].x
    # ball_array[1].position.x += final_velocities[1].x
    # Rotate ball positions and velocities back
    # Reverse signs in trig expressions to rotate
    # in the opposite direction
    # rotate balls
    final_positions = [Vec2D.new, Vec2D.new]
    final_positions[0].x = cosine * ball_array[0].position.x - sine * ball_array[0].position.y
    final_positions[0].y = cosine * ball_array[0].position.y + sine * ball_array[0].position.x
    final_positions[1].x = cosine * ball_array[1].position.x - sine * ball_array[1].position.y
    final_positions[1].y = cosine * ball_array[1].position.y + sine * ball_array[1].position.x
    # update balls to screen position
    other_ball.position = position + final_positions[1]
    @position += final_positions[0]
    # update velocities
    velocity.x = cosine * final_velocities[0].x - sine * final_velocities[0].y
    velocity.y = cosine * final_velocities[0].y + sine * final_velocities[0].x
    other_ball.velocity.x = cosine * final_velocities[1].x - sine * final_velocities[1].y
    other_ball.velocity.y = cosine * final_velocities[1].y + sine * final_velocities[1].x
  end
  
  def display
    app.no_stroke
    app.fill(204)
    app.ellipse(position.x, position.y, r * 2, r * 2)
  end
end

class CircleCollision < Processing::App
  attr_reader :balls
  
  def setup
    size 640, 360
    @balls = [Ball.new(self, 100, 40, 20), Ball.new(self, 200, 100, 80)]
  end
  
  def draw
    background(51)
    balls.each do |b|
      b.update
      b.display
      b.check_boundary width, height
    end
    balls[0].check_collision(balls[1])
  end
end

CircleCollision.new title: 'Two Balls'