desc "Importa las notas de las Websites"
task :importar_notas_website => :environment do
  Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])
  for i in(1..100)
    puts "Vuelta: <#{i}>"
    websites = Website.all
    websites.each { |website| website.importar_notas_website}
    sleep(10.minutes)
  end
end
