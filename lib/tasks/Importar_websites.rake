desc "Importa las notas de las Websites"
task :importar_notas_website => :environment do
  puts 'Iniciando Barrido...'
  # Nota.delete_all (["resumen_id IS ? AND created_at < ?", nil, Date.today])
  # puts 'Borrando notas anteriores a hoy...'
  for i in (1..10000)
    puts "Inicio Vuelta: <#{i}>"
    Website.all.each do |website|
      begin
        puts "------------------------------------"
        puts "\tIntentando cargar paginas de: #{website.nombre}" 
        website.importar_notas_website
        puts "\tCarga exitosa de paginas de #{website.nombre}" 
      rescue Exception => ex
        puts "\tError al intenter importar notas de #{website.nombre}. Error: #{ex}"
        puts "Se continua la carga ..."
      end
    end
    puts "Fin de vuelta <#{i}>"
    sleep(5.minutes)
  end
end
