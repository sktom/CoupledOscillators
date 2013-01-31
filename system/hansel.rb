
require '../profile/prhansel'
require '../system/oscillator'

include Math


class Hansel < Oscillator
  @@coef = PR[:k] / NUMBER_OSCILLATORS 

  def evolve
    interaction = @@phases.inject(0){|sum, ph|
      sum + @@coef * gamma(@phase - ph)
    }
    @phase += (PR[:omega] + interaction) * DT
    round
  end

  def gamma x
    - sin(x + PR[:alpha]) + PR[:r] * sin(2 * x)
  end

end
