
THRS_OSC = 0.2
THRS_LOCK = 2 * Math::PI * 0.01
THRS_CL = 2 * Math::PI * 0.01

require '../profile/general'
require "../system/#{TYPE_OSCILLATOR}"


class System
  attr :results

  PresentOscillator = Object.const_get(TYPE_OSCILLATOR.capitalize)
  def initialize mode = :default, arg = nil
    case mode
    when :default
      @oscillators = Array.new(NUMBER_OSCILLATORS).map{PresentOscillator.new}
    when :flexible
      @oscillators = Array.new(NUMBER_OSCILLATORS).map{PresentOscillator.new mode, arg}
    end
    @results = Array.new(NUMBER_OSCILLATORS + 1).map{Array.new}
  end

  def evolve 
    (TOTAL_TIME / DT).to_i.times do |i|
      @oscillators.each do |os|
        os.evolve 
      end
      @oscillators.each do |os|
        os.update
      end

      if i % NUMBER_DECIMATE == 0
        @results.first << i * DT
        @oscillators.each_with_index do |os, j|
          @results[j + 1] << os.phase
        end
      end
    end
  end

  @@start_det = (TOTAL_TIME / DT / NUMBER_DECIMATE * 0.8).to_i
  @@fin_det = (TOTAL_TIME / DT / NUMBER_DECIMATE * 0.9).to_i

  def oscillating?
    flag = nil
    count = 0
    old = 0
    @results[1][@@start_det...@@fin_det].each do |a|
      new = a
      if flag
        count += 1 if (new - old).abs > THRS_OSC * @oscillators[0].omega * DT * NUMBER_DECIMATE
      end
      old = new
      flag = true
    end
    if count > (@@start_det...@@fin_det).to_a.length * 0.5
      true
    else
      false
    end
  end

  def locked?
    arr_det = @results[1][@@start_det...@@fin_det].map.with_index do |a, i|
      (a - @results[2][@@start_det + i]).abs % (2 * Math::PI)
    end
    flag = nil

    count = 0
    old = 0
    arr_det.each do |a|
      new = a
      if flag
        count += 1 if (new - old).abs < THRS_LOCK
      end
      old = new
      flag = true
    end
    if count > arr_det.length * 0.8
      true
    else
      false
    end
  end
  
  def clustering?
    det = false
    (1..NUMBER_OSCILLATORS).each do |i|
      ((i + 1)..NUMBER_OSCILLATORS).each do |j|
        arr_det = @results[i][@@start_det...@@fin_det].map.with_index do |a, k|
          (a - @results[j][@@start_det + k]).abs % (2 * Math::PI)
        end

        count = 0
        flag = nil
        arr_det.each{|a| count += 1 if a < THRS_CL}
        p count, arr_det.size*0.8
        if count > arr_det.size * 0.8
          det = det || true
          p det
        end
      end
    end
    det
  end

end

