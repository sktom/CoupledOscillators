
require '../io/plot'
require '../io/output'
require '../system/system'


system = System.new
system.evolve

output OUT_FILENAME, system.results
plot OUT_FILENAME, system.results.size, MODE_PLOT, '../results/plot.plt'

default_pltmake OUT_FILENAME, system.results.size, '../results/default.plt'
phasediff_pltmake OUT_FILENAME, system.results.size, '../results/phasediff.plt'

