
require '../profile/prkuramoto'
require '../system/oscillator'

include Math


class Kuramoto < Oscillator
  @@coef = PR[:k] / NUMBER_OSCILLATORS

  def evolve
    interaction = @@phases.inject(0){|sum, ph|
      sum + @@coef * sin(@phase - ph)
    }
    @phase += (PR[:omega] + interaction) * DT
    round
  end

end

