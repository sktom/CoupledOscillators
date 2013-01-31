
def plot filename, number_columns, mode_plot = :default, plt_filename = 'plot.plt'
  send (mode_plot.to_s << '_pltmake').to_sym, filename, number_columns, plt_filename
  `gnuplot "#{plt_filename}" -persist`
end

def default_pltmake filename, number_columns, plt_filename, set_key = true
  File.open(plt_filename, 'w') do |fout|
    fout.puts 'unset key' unless set_key
    fout.puts "plot '#{filename}' u 1:2 w l lw 5"
    (number_columns - 2).times do |i|
      fout.puts "replot '#{filename}' u 1:#{i + 3} w l lw 5"
    end
  end
end

def phasediff_pltmake filename, number_columns, plt_filename, set_key = false, basis_line = number_columns
  File.open(plt_filename, 'w') do |fout|
    fout.puts 'unset key' unless set_key
    fout.puts 'set ytic pi'
    fout.puts 'set yr [0:2*pi]'
    if basis_line == 2 
      dif = "$3-$#{basis_line}"
      fout.puts "plot '#{filename}' u 1:((#{dif})>=0.0)? (#{dif}):(#{dif}+2*pi) w l lw 5"
      start = 4
    else
      dif = "$2-$#{basis_line}"
      fout.puts "plot '#{filename}' u 1:((#{dif})>=0.0)? (#{dif}):(#{dif}+2*pi) w l lw 5"
      start = 3
    end
    start.upto(number_columns - 1) do |i|
      dif = "$#{i}-$#{basis_line}"
      fout.puts "replot '#{filename}' u 1:((#{dif})>=0.0)? (#{dif}):(#{dif}+2*pi) w l lw 5"
    end
  end
end

