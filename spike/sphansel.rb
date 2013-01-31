
require '../profile/general'
require '../profile/prhansel'
require '../io/plot'
require '../io/output'
include Math


time_length = (TOTAL_TIME / DT / NUMBER_DECIMATE).to_i

phases = Array.new(NUMBER_OSCILLATORS).map{rand * 2 * PI}
diff_phases = Array.new(NUMBER_OSCILLATORS)
results = Array.new(NUMBER_OSCILLATORS + 1).map{Array.new}

s = PR[:k] / phases.size
(TOTAL_TIME / DT).to_i.times do |time|
  phases.each_with_index do |ph, i_ph|
    interaction = phases.inject(0){|sum, p|
      sum + s * (- sin(ph - p + PR[:alpha]) + PR[:r] * sin(2 * (ph - p)))
    } + s * sin(PR[:alpha])
    diff_phases[i_ph] = (PR[:omega] + interaction) * DT
  end

  count = 0
  phases.map! do |ph|
    new_ph = ph + diff_phases[count]
    count += 1
    new_ph % (2 * PI)
  end

  if time % NUMBER_DECIMATE == 0
    results[0] << time * DT
    1.upto(NUMBER_OSCILLATORS){|i| results[i] << phases[i - 1]}
  end
end

output OUT_FILENAME, results
plot OUT_FILENAME, results.size, :phasediff

