
require '../io/plot'
require '../io/output'
require '../system/system'
require '../system/parameter'


ALPHA_MIN = 0.5
ALPHA_MAX = 1.5
ALPHA_TIC = 0.5

K_MIN = 0.0
K_MAX = 0.15
K_TIC = 0.05

NUMBER_ITERATION = 1

phasemap = {}

File.open('../results/phasemap_res.data', 'w') do |fout|
  fout.print "alpha|K"
  (K_MIN..K_MAX).step(K_TIC){|k| fout.print "\t#{k}"}
  (ALPHA_MIN..ALPHA_MAX).step ALPHA_TIC do |alpha|
    fout.print "\n#{alpha}"
    (K_MIN..K_MAX).step K_TIC do |k|
      puts "-" * NUMBER_ITERATION

      parameter = Parameter.new alpha, k
      pm = PointMap.new
      NUMBER_ITERATION.times do |num|
        system = System.new :flexible, [alpha, k]
        system.evolve

        output "../data/#{parameter}-#{num}.data", system.results
        #plot "../data/#{parameter}-#{num}.data", system.results.size, MODE_PLOT, '../results/plot.plt'

        print '.'

        if system.oscillating?
          pm.oscillating += 1
        else
          next
        end
        if system.locked?
          pm.locked += 1
        else
          next
        end
        if system.clustering?
          pm.clustering += 1
        end
      end
      res = pm.data.map{|d| d / NUMBER_ITERATION}
      fout.print "\t(#{res[0]}, #{res[1]}, #{res[2]})"
      puts "\n#{parameter} finished (#{res[0]}, #{res[1]}, #{res[2]})"
    end
  end
end

