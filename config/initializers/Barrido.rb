$stdout.puts "Barriendo..."
begin
  
  job1 = fork do
  exec "RAILS_ENV=production rake importar_notas_website"
  end

  Process.detach(job1)
  system 'echo "post parrido..."'
  
rescue 
  puts "** Oops! No se pudo importar! **"
end
$stdout.puts "fin de barrido"