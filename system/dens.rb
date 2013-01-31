
require '../profile/prdens'
require '../system/oscillator'
require '../util/nrand'

include Math


class Dens < Oscillator
  attr :omega

  def initialize profile = :default, args = nil
    @alpha = PR[:alpha] / (1 + PR[:omega_deviation] * nrand)
    @alpha_ = @alpha
    @omega = PR[:omega] * (1 + PR[:omega_deviation] * nrand)
    @@K = PR[:K]
    if profile == :flexible
      @alpha = args[0]
      @alpha_ = args[0]
      @@K = args[1]
    end
    if PR[:alpha_change]
      @alpha_ = PR[:alpha_] / (1 + PR[:omega_deviation] * nrand)
    end
    @coeff_z_l = (1 - dec_a_(PR[:phi_c])) / (1 - dec_a(PR[:phi_c])) * @alpha / @alpha_

    super
  end

  @@upper = 0...PR[:phi_c]
  @@lower = PR[:phi_c]...(2 * PR[:phi_c])
  @@tau = PR[:delay]

  def dec_a x
    exp(- @alpha * x)
  end

  def dec_a_ x
    exp(- @alpha_ * x)
  end
  
  def zeta x
    case x
    when @@upper
      - dec_a(- x)
    when @@lower
      @coeff_z_l * dec_a_(- x + PR[:phi_c])
    else
      puts 'something wrong in z'
    end
  end

  def pi x
    case x
    when @@upper
      - dec_a(x)
    when @@lower
      1 / @coeff_z_l * dec_a_(x - PR[:phi_c])
    else
      puts 'something wrong in p'
    end
  end

  def evolve
    perturbation = @@phases.map{|ph| pi(ph)}.inject(:+) - pi(@phase)
    interaction = @@K * zeta(@phase) * perturbation

    @phase += (@omega + interaction + PR[:noize] * nrand) * DT
    round
  end

end

