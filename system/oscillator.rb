
include Math
require '../profile/general'


class Oscillator
  attr :phase
  @@phases = []
  @@number = 0

  def initialize _, __
    @phase = 2 * PI * rand
    @@phases << @phase
    @number = @@number
    @@number += 1
  end

  def round
    @phase = @phase % (PI * 2)
  end

  def evolve
  end

  def update
    @@phases[@number] = @phase
  end

end

