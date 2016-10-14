class Pagina < ActiveRecord::Base
  attr_accessible :articulo, :contenido, :fecha, :imagen, :titulo, :url, :website_id

  belongs_to :website
  accepts_nested_attributes_for :website  

  require 'uri'
  require 'mechanize'


  def importar_notas 
    index = cargar_website url
    notas_web = index.search articulo

    notas_cargadas = 0

    notas_web.each do |nota_web|
      # Creación del Hash para la Nota
      nota_temp = Hash.new
      nota_temp[:website_id] = website.id
      nota_temp[:tipo_nota_id] = 1

      # Gestión de titulo y url
      nota_temp[:titulo] = nota_web.search(titulo).first

      unless nota_temp[:titulo].blank?
        nota_temp[:url] = (nota_temp[:titulo].attr "href")
        nota_temp[:url].slice! 0 if (nota_temp[:url][0].eql? "/")
        nota_temp[:url] = website.url+nota_temp[:url] if !(nota_temp[:url].include? website.descripcion)
        
        unless nota_temp[:titulo].blank?
          titulo_temp = nota_temp[:titulo].text
          titulo_temp = nota_temp[:titulo].attr "title" if titulo_temp.blank?
          nota_temp[:titulo] = limpio titulo_temp
          # nota_temp[:titulo] = nota_temp[:titulo].toutf8
        end

      end

      # Gestión de Resumen de la nota
      nota_temp[:contenido] = nota_web.search(contenido).text

      # Gestión de la Imagen
      nota_temp[:imagen] = nota_web.search(imagen)
      # nota_temp[:imagen] = (nota_temp[:imagen].attr "src").text unless nota_temp[:imagen].blank? or !(nota_temp[:imagen].attr "src")

      unless nota_temp[:imagen].blank?
        aux = nota_temp[:imagen].attr "data-src"
        unless aux.blank?
          nota_temp[:imagen] = aux.text
        else
          aux = nota_temp[:imagen].attr "src"
          nota_temp[:imagen] = aux.value if aux
        end
      end

      nota_temp[:imagen] = nota_temp[:imagen].to_s
      nota_temp[:imagen] = url_limpio nota_temp[:imagen]
      puts "IMAGEN: #{nota_temp[:imagen]}"
      nota_temp[:imagen] = website.url+nota_temp[:imagen] if !nota_temp[:imagen].blank? and !(nota_temp[:imagen].include? website.descripcion)
      nota_temp[:imagen] = nil if nota_temp[:imagen].eql? "http://anonymouse.org/images/stop.gif"

      # Gestión de la Fecha de publicación
      fecha_temp = nota_web.search(fecha).first
      nota_temp[:fecha_publicacion] = fecha_temp.text unless fecha_temp.blank?

      # Crear Nota
      nota = Nota.new nota_temp

      puts "".center(100,"-")
      puts nota_temp
      puts "Nota: #{nota.id}"
      puts "Titular: #{nota.titulo}"
      puts "url: #{nota.url}"
      puts "contenido: #{nota.contenido}"
      puts "imagen: #{nota.imagen}"      
      puts nota.save
      puts "".center(100,"-")

      notas_cargadas +=1 if nota.save
    end
    puts " Resumen en #{url}: ".center(100,"=")
    puts "Total de Notas a Cargar: #{notas_web.count}"
    puts "Total de Notas Cargadas: #{notas_cargadas}"
    puts "".center(100,"=")
    return notas_cargadas
  end
  
  def limpio text
    text.gsub(/[\t\n\r]/, '')
  end

  def url_limpio text
    text.gsub(/[\t\n\r\ ]/, '')
  end

  def cargar_website dir_url
    dir_url = URI.parse dir_url
    agente = Mechanize.new
    # Importante para los tiempos
      agente.open_timeout = 10
      agente.read_timeout = 10
    begin
      return agente.get(dir_url)
    rescue Exception => ex
      return ex
    end
  end

  
end
