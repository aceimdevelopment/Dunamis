$stdout.puts "Barriendo..."
begin
  `RAILS_ENV=production rake importar_notas_website`
rescue 
  puts "** Oops! No se pudo importar! **"
end
$stdout.puts "fin de barrido"