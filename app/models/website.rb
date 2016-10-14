# encoding: UTF-8
class Website < ActiveRecord::Base
  attr_accessible :descripcion, :logo, :nombre, :url

  belongs_to :usuario
  accepts_nested_attributes_for :usuario

  has_many :notas
  accepts_nested_attributes_for :notas

  has_many :paginas, dependent: :destroy
  accepts_nested_attributes_for :paginas

  has_many :tipos_webnotas
  accepts_nested_attributes_for :tipos_webnotas

  def url_sin_backslash
    url[0..url.length-2]
  end

  def self.limpiar_usuario usuario_id
    Website.all.each{|w| w.usuario_id = nil if (w.usuario_id.eql? usuario_id) ; w.save}
  end

  def self.limpiar_todos_usuarios
    Website.all.each{|w| w.usuario_id = nil; w.save}
  end
  
  def descripcion_con_notas
    "#{descripcion}-#{(notas.creadas_hoy).count}"
  end
  
  def eliminar_notas_irrelevantes
    notas.each { |nota| nota.destroy unless nota.resumen_id }
  end
  
  def eliminar_notas_irrelevantes_antiguas
    notas.creadas_antes.each { |nota| nota.destroy unless nota.resumen_id }
  end
  
  def importar_notas_desactualizadas
    begin
      importar_notas_website if not fueron_cargadas_reciente?
    rescue Exception => ex
    end  
  end
  
  def fueron_cargadas_reciente?
    tiempo_retardo = 10 #minutos
    nota = notas.last
    if nota.nil?
      return false
    else
      tiempo_ultima_carga = (nota.updated_at - DateTime.now) / 60
      tiempo_ultima_carga = tiempo_ultima_carga*-1 if tiempo_ultima_carga < 0
      return tiempo_ultima_carga < tiempo_retardo
    end
  end

  def importar_notas_website_2
    total = 0
    begin
      paginas.each do |pagina|
        total = pagina.importar_notas
      end
      return total
    rescue Exception => ex
      return ex
    end
  end

  def importar_notas_website 
    Importer.importar_notas_noticias24 if nombre.eql? "noticias24"
    Importer.import_notas_globovision if nombre.eql? "globovision"
    Importer.import_notas_union_radio if nombre.eql? "unionradio"
    Importer.import_notas_noticierodigital if nombre.eql? "noticierodigital"
    Importer.import_notas_noticierovenevision if nombre.eql? "noticierovenevision"
    Importer.import_notas_vtv if nombre.eql? "vtv"
    Importer.import_notas_laverdad if nombre.eql? "laverdad"
    Importer.import_notas_informe21 if nombre.eql? "informe21"
    Importer.import_notas_eluniversal if nombre.eql? "eluniversal"
    Importer.import_notas_avn if nombre.eql? "avn"
    Importer.import_notas_elnacional if nombre.eql? "elnacional"
    Importer.import_notas_rnv if nombre.eql? "rnv"
    Importer.import_notas_radiomundial if nombre.eql? "radiomundial"
    
  end
  
  # ================ PRUEBAS ======================
  
  def buscar_titulo nota
    web_titulo = Nokogiri::XML::NodeSet.new nota.document
    titulos.each do |titulo|
      puts "ANTES TITULOS:#{titulo.nombre} #{titulo.website.nombre}"
      web_titulo += nota.search titulo.nombre
      puts "DESPUES TITULOS:#{titulo.nombre} #{titulo.website.nombre}"
      break unless web_titulo.blank?
    end
    return web_titulo.first #if web_titulo
  end
  
  def buscar_contenido nota
    web_contenido = Nokogiri::XML::NodeSet.new nota.document
    tipos_contenidos.each do |contenido|
      web_contenido += nota.search contenido.nombre
      break unless web_contenido.blank?
    end
    return web_contenido.first.text #if web_contenido
  end  
  
  def buscar_imagen nota
    web_imagen = Nokogiri::XML::NodeSet.new nota.document
    imagenes.each do |imagen|
      web_imagen += nota.search imagen.nombre
      break unless web_imagen.blank?
    end
    web_imagen = web_imagen.attr "src" unless web_imagen.blank?
    return web_imagen.first.text #if web_imagen
  end

  def buscar_fecha nota
    web_fecha = []
    fechas.each do |fecha|
      web_fecha += nota.search fecha.nombre
      web_fecha = web_fecha[0] if web_fecha.count > 1
      break unless web_fecha.blank?
    end
    return web_fecha.text #if web_fecha
  end 

  def cargar_website
    url = URI.parse self.url
    agente = Mechanize.new
    return agente.get(url)
  end
  
  def buscar_notas pagina_web
    require 'importer' # no deberia hacer falta
    # require 'uri'
    # require 'mechanize'
    notas = []
    tipos_webnotas.each do |webnota| 
      puts "ANTES POSTS:#{webnota.div_nota} #{webnota.website.nombre}"
      notas += pagina_web.search webnota.div_nota
      puts "DESPUES POST:#{webnota} NOTAS: #{notas}"
    end
    return notas
  end
  
  def importar_webnota
    eliminar_notas_irrelevantes
    pagina_web = cargar_website
    tipos_webnotas.each do |tipo_webnota|
      webnotas = pagina_web.search tipo_webnota.div_nota      
      webnotas.each do |webnota|
        # Titulo
        t = webnota.search tipo_webnota.div_titulo

        href = t.attr "href" unless t.blank?
        titulo = t.text
        
        # Contenido
        contenido = webnota.search tipo_webnota.div_contenido

        fecha = webnota.search "#{tipo_webnota.div_fecha} p"
        fecha = webnota.search tipo_webnota.div_fecha if fecha.blank?

        imagen = webnota.search tipo_webnota.div_imagen
        imagen = imagen.attr "src" unless imagen.blank?
        
        puts "=========================== WEB SITE ==========================="
        puts "url: \n#{href}"
        puts "titulo:\n #{titulo}"
        puts "Contenido:\n#{contenido}"
        puts "imagen:\n #{imagen}"
        puts "fecha:\n #{fecha}"
        
        break
      end
    end
  end
  
  def importar_nota 
    require 'importer'
    puts self.nombre.upcase
    # Eliminando las notas no asociadas a algun resumen
    self.eliminar_notas_irrelevantes
  
    # Se Carga la Pagina Principal del WebSite
    pagina_web = cargar_website
  
    tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
    
    # Se Buscan las Todas las Notas de la Web
    notas_web = buscar_notas pagina_web
    
    notas_web.each do |nota_web|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota_web.search self.nota.div_titulo
      titulo = pagina_web.search self.nota.div_titulo
      # titulo
      href = titulo.attr "href" unless titulo.blank?
      nota_url = "#{url}#{href}" if href
      titulo = titulo.text
            
      # buscamos contenidos
      contenidos = nota.search nota.div_titulo
      
      # Buscamos imagenes
      imagen = buscar_imagen nota
      
      # buscamos fechas
      fecha = buscar_fecha nota


      puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      puts "Titulo: #{titulo}\n"
      puts "Url: #{url}\n"
      puts "Fecha: #{fecha}\n"
      puts "Contenido: #{contenido}\n"
      puts "Imágen: #{imagen}\n"
  
      # # Se guarda la nota_local
      # nota_local = Nota.new
      # nota_local.titulo = titulo
      # nota_local.fecha_publicacion = fecha
      # nota_local.contenido = contenido
      # nota_local.url = url
      # nota_local.website_id = website.id
      # nota_local.tipo_nota_id = tipo_nota.id
      # nota_local.imagen = imagen
      # nota_local.save
  
    end
  end

end
