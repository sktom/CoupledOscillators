
require '../profile/pravdens'
require '../system/oscillator'
require '../util/nrand'

include Math


class Avdens < Oscillator

  def initialize
    super
    @omega = PR[:omega] * (1 + PR[:omega_deviation] * nrand)
  end

  @@upper = 0...PI
  @@lower = PI...(2 * PI)

  def dec_a x
    exp(- PR[:alpha] * x)
  end

  def gamma x
    x = x % (2 * PI)
    case x
    when @@upper
      - PR[:K] / PI * (x * dec_a(x - PI) + (x - PI) * dec_a(x))
    when @@lower
      PR[:K] / PI * ((x - PI) * dec_a(x - 2 * PI) + (x - 2 * PI) * dec_a(x - PI))
    else
      p x
      p 'error!'
    end
  end

  def evolve
    interaction = @@phases.inject(0){|sum, ph|
      sum += gamma(ph - @phase)
    } - gamma(0)
   
    @phase += (@omega + interaction + PR[:noize] * nrand) * DT
    round
  end

end

