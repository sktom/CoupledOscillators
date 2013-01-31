
require '../io/plot'
require '../io/output'
require '../system/system'


System.init
System.evolve

output OUT_FILENAME, System.results
plot OUT_FILENAME, System.results.size, MODE_PLOT, '../results/plot.plt'

default_pltmake OUT_FILENAME, System.results.size, '../results/default.plt'
phasediff_pltmake OUT_FILENAME, System.results.size, '../results/phasediff.plt'

