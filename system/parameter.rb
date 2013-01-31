
class Parameter
  attr :alpha, :k

  def initialize alpha, k
    @alpha = alpha
    @k = k
  end

  def to_s
    sprintf "alpha%1.2f_k%1.2f", @alpha, @k
  end
end

class PointMap
  attr_accessor :oscillating, :locked, :clustering

  def initialize
    @oscillating = 0
    @locked = 0
    @clustering = 0
  end

  def data
    [@oscillating, @locked, @clustering]
  end
end

