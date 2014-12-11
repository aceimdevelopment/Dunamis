# $stdout.puts "Barriendo..."
# begin
#   
#   job1 = fork do
#     system 'exec RAILS_ENV=production rake -f /Library/WebServer/Documents/Dunamis/Rakefile importar_notas_website --trace'
#     system 'echo "DENTRO DEL job1..."'
#   end
# 
#   Process.detach(job1)
#   system 'echo "post barrido..."'
#   
# rescue 
#   $stdout.puts "** Oops! No se pudo importar! **"
# end
# $stdout.puts "fin de barrido"