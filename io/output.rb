
def output out_filename, data
  File.open(out_filename, 'w') do |fout|
    data[0].size.times do |i|
      data.size.times do |j|
        fout.print "#{data[j][i]}\t"
      end
      fout.puts
    end
  end
end

