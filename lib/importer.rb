# encoding: utf-8
module Importer
  
  require 'uri'
  require 'mechanize'
  
  def self.temporal
    index = cargar_website "http://www.ultimasnoticias.com.ve/"
    return index
  end
  
  def self.limpio text
    text.gsub(/[\t\n\r]/, '')
  end

  def self.url_limpio text
    text.gsub(/[\t\n\r\ ]/, '')
  end

  def self.cargar_website url
    url = URI.parse url
    agente = Mechanize.new
    # Importante para los tiempos
    # agente.open_timeout = 1
    # agente.read_timeout = 5
    begin
      return agente.get(url)
    rescue Exception => ex
      return ex
    end
  end

#   POSIBLE FUNCIÓN PARA INCLUIR EN ERROR DE CARGA
  def self.cargar_website_low website
    begin
      url = URI.parse website.url
      agente = Mechanize.new
    rescue Exception => ex
      puts "Time out connection request#{ex}"
      agente = nil
    end 

    return agente if agente.nil?
    return agente.get(url)

  end

  def self.importar_notas_noticias24
    
    website = Website.find_by_nombre("noticias24")
    index = cargar_website website.url
    notas_web = index.search ".postGroup"
    index = cargar_website "#{website.url}venezuela/"
    notas_web += index.search ".initialPost"
    
     notas_web.each do |nota_web|
       # Creación del Hast para la Nota
       nota_temp = Hash.new
       nota_temp[:website_id] = website.id
       nota_temp[:tipo_nota_id] = 1
       
       # Gestión de titulo y url
       nota_temp[:titulo] = nota_web.search("a")
       nota_temp[:url] = (nota_temp[:titulo].attr "href").value unless nota_temp[:titulo].blank?
       nota_temp[:url] = website.url + nota_temp[:url] unless nota_temp[:url].include? website.url
       nota_temp[:titulo] = (limpio nota_temp[:titulo].text) unless nota_temp[:titulo].blank?
       
       # Gestión de Resumen de la nota
       nota_temp[:contenido] = nota_web.search(".post")
       nota_temp[:contenido] = nota_web.search("p") if nota_temp[:contenido].blank?
       nota_temp[:contenido] = (limpio nota_temp[:contenido].text) unless nota_temp[:contenido].blank?
       
       # Gestión de la Imagen
       nota_temp[:imagen] = nota_web.search(".post img")
       nota_temp[:imagen] = nota_web.search("img") if nota_temp[:imagen].blank?
       nota_temp[:imagen] = (nota_temp[:imagen].attr "src").text unless nota_temp[:imagen].blank?
       
       # Gestión de la Fecha de publicación
       nota_temp[:fecha_publicacion] = nota_web.search(".postTime p")
       nota_temp[:fecha_publicacion] = nota_web.search(".postTime") if nota_temp[:fecha_publicacion].blank?
       nota_temp[:fecha_publicacion] = nota_web.search(".postMeta") if nota_temp[:fecha_publicacion].blank?
       nota_temp[:fecha_publicacion] = (limpio nota_temp[:fecha_publicacion].text) unless nota_temp[:fecha_publicacion].blank?
       
       # Crear Nota
       Nota.create nota_temp
       
     end
    
  end
  # Correcto
  def self.import_notas_globovision
    website = Website.find_by_nombre("globovision")
    # PÁGINA PRINCIPAL DEL SITIO WEB
    index = cargar_website website.url
    notas_web = index.search ".nota"

    # PÁGINA NACIONALES 
    enlace = index.link_with(:text => 'Nacionales')
    pagina = enlace.click
    notas_web += pagina.search ".article"
    
    # PÁGINA ECONOMÍA
    enlace = index.link_with(:text => 'Economía')
    pagina = enlace.click
    notas_web += pagina.search ".article"

    #Pruebas
    puts "Iniciando carga página particulares"
    begin
      # index = cargar_website "#{website.url}programas/analisis-situacional"
      # notas_web += index.search ".article"
      index = cargar_website "#{website.url}programas/vladimir-a-la-1"
      notas_web += index.search ".article"
      # index = cargar_website "#{website.url}programas/primera-pagina"
      # notas_web += index.search ".article"

      # index = cargar_website "#{website.url}programas/primera-pagina/"
      # notas_web += index.search ".article"
      # 
      # index = cargar_website "#{website.url}programas/vladimir-a-la-1/"
      # notas_web += index.search ".article"
      # index = cargar_website "#{website.url}programas/con-todo-y-penzini/"
      # notas_web += index.search ".article"

    rescue Exception => ex
      puts "----------------ERROR----------------------"
      puts "-------------------------------------------"
      puts ex
      puts "-------------------------------------------"
      puts "-------------------------------------------"            
    end

    # PÁGINA PROGRAMAS PENDIENTE
    # enlace = index.link_with(:text => 'Programas')
    # pagina = enlace.click
    # enlace = pagina.link_with(:text => 'Todos los programas')
    # pagina = enlace.click
    # enlace = pagina.link_with(:text => 'Todos los programas')
    # 
    # notas_web += pagina.search ".article"
    # index = cargar_website "#{website.url}programas/primera-pagina/"
    # notas_web += index.search ".article"
    # index = cargar_website "#{website.url}programas/vladimir-a-la-1/"
    # notas_web += index.search ".article"
    # index = cargar_website "#{website.url}programas/con-todo-y-penzini/"
    # notas_web += index.search ".article"
        
     notas_web.each do |nota_web|
       # Creación del Hast para la Nota
       nota_temp = Hash.new
       nota_temp[:website_id] = website.id
       nota_temp[:tipo_nota_id] = 1
       
       # Gestión de titulo y url
       nota_temp[:titulo] = nota_web.search(".title a")
       nota_temp[:url] = (nota_temp[:titulo].attr "href").value unless nota_temp[:titulo].blank?
       nota_temp[:url] = website.url_sin_backslash + nota_temp[:url] unless nota_temp[:url].include? website.url
       nota_temp[:titulo] = nota_temp[:titulo].text unless nota_temp[:titulo].blank?

       # nota_temp[:titulo] = nota_temp[:titulo].attr "text" if nota_temp[:titulo].attributes
       # Gestión de Resumen de la nota
       aux = nota_web.search(".description")
       if aux.count > 0
         nota_temp[:contenido] = aux
       else
         aux = nota_web.search("p")
         nota_temp[:contenido] = aux if aux.count > 0
       end
       nota_temp[:contenido] = (limpio nota_temp[:contenido].text) if not nota_temp[:contenido].blank?
       
       # Gestión de la Imagen
       nota_temp[:imagen] = nota_web.search(".image img")
       nota_temp[:imagen] = nota_web.search("img") if nota_temp[:imagen].blank?
       
       unless nota_temp[:imagen].blank?
         
         aux = nota_temp[:imagen].attr "data-src"
         unless aux.blank?
           nota_temp[:imagen] = aux.text
         else
           aux = nota_temp[:imagen].attr "src"
           nota_temp[:imagen] = aux.value if aux
         end
       end
       # nota_temp[:imagen] = (nota_temp[:imagen].attr "data-src").text if (nota_temp[:imagen].blank? or nota_temp[:imagen].attr "data-src")
       
       # Gestión de la Fecha de publicación
       aux = nota_web.search(".date")
       nota_temp[:fecha_publicacion] = aux if aux.count > 0
       # nota_temp[:fecha_publicacion] = nota_web.search(".postTime") if nota_temp[:fecha_publicacion].blank?
       # nota_temp[:fecha_publicacion] = nota_web.search(".postMeta") if nota_temp[:fecha_publicacion].blank?
       nota_temp[:fecha_publicacion] = (limpio nota_temp[:fecha_publicacion].text) unless nota_temp[:fecha_publicacion].blank?
       
       # Crear Nota
       Nota.create nota_temp
       
     end
  end

  # Correcto

  def self.import_notas_globovision_old
    website = Website.find_by_nombre("globovision")
    puts website.nombre
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url

    # Buscamos todos los posibles tipos de notas
    notas = index.search ".first_A"
    notas += index.search ".first_post"
        
    notas.each_with_index do |nota,i|
      titulo = nota.search("h3").text
      url = (nota.attr "href") unless nota.blank?
      imagen = nota.search "img"
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = imagen.text
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save      
    end  
    
    notas = index.search ".T_post"

    notas.each_with_index do |nota,i|
      # buscamos el título
      titulo = nota.search("h1 a")
      titulo = nota.search("h2 a") if titulo.blank?
      titulo = nota.search("h3 a") if titulo.blank?
      # titulo = nota.search(".sumariovideo a") if titulo.blank?
      titulo = nota.search("a") if titulo.blank?
      # buscamos url de la Nota
      url = (titulo.attr "href").value unless titulo.blank?
      # Título en texto plano
      titulo = (titulo.attr "title").value unless titulo.blank?
      titulo = titulo.text if titulo.blank?
      #buscamos fecha      
      fecha = nota.search(".date_c").text
      # Buscamos imagen
      imagen = nota.search "img"
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = imagen.text      
      #Creamos nota local y transferimos      
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save
    end
  end


  
  def self.import_notas_globovision_old_old

    website = Website.find_by_nombre("globovision")
    puts website.nombre
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url

    # Buscamos todos los posibles tipos de notas
    notas = index.search ".thumbnail_videos"    
    notas += index.search ".noticia_ultimahora"
    notas += index.search ".espacio1"
    notas += index.search ".divnoticiasn2"
    notas += index.search ".divnoticiasn4"
    notas += index.search ".divnoticiasn5"

    notas.each do |nota|
      # buscamos el título
      titulo = nota.search("h1 a")
      titulo = nota.search("h2 a") if titulo.blank?
      titulo = nota.search(".h3titulo") if titulo.blank?
      titulo = nota.search(".sumariovideo a") if titulo.blank?
      titulo = nota.search("a") if titulo.blank?
      
      # buscamos url de la Nota
      url = (titulo.attr "href").value unless titulo.blank?
      # como la ruta es relativa, incluimos root si hay url
      url = "#{website.url}#{url}" if url
      
      # Título en texto plano
      titulo = titulo.text
      
      # titulo = "Video: " + titulo if nota.values[0].eql? "thumbnail_videos"
      # titulo = "Última hora: " + titulo if nota.values[0].eql? "noticia_ultimahora"
      # titulo = "Principal: " + titulo if nota.values[0].eql? "espacio1"

      
      # Buscamos Contenido o resumen de la Nota      
      contenido = nota.search(".sumario_nota p")
      contenido = nota.search(".sumarioh3 p") if contenido.blank?
      contenido = nota.search(".h4sumario p") if contenido.blank?
      contenido = nota.search("ctl10_lblMostra") if contenido.blank?      
      
      #buscamos fecha
      fecha = nota.search(".h5s")
      fecha = nota.search(".h6s") if fecha.blank?
      fecha = fecha.text unless fecha.blank?
      # fecha = "Video" if fecha.blank?

			case nota.values[0]
			when "thumbnail_videos"
			  titulo = "Video: " + titulo
			  fecha = ""
			when "noticia_ultimahora"
			  titulo = "Última hora: " + titulo
			when "espacio1"
			  titulo = "Principal: " + titulo
			end
      
      #tratamientop de imagen
      imagen = nota.search(".divnoticiasn2img")
      imagen = nota.search(".divnoticiasn4img") if imagen.blank?
      imagen = nota.search("img") if imagen.blank?
      if imagen.count > 1
        imagen = imagen.last.attr "src"
      else  
        imagen = imagen.text
      end
      
      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "Titulo: #{titulo}\n"
      # puts "Url: #{url}\n"
      # puts "Fecha: #{fecha}\n"
      # puts "Contenido: #{contenido}\n"
      # puts "Imágen: #{imagen}\n"
      
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.text.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save
    end
  end



  def self.import_notas_union_radio

    website = Website.find_by_nombre "unionradio"
    puts website.nombre
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas_web = index.search ".col-xs-4"
    notas_web += index.search ".row.polymer-box-sm"
    notas_web += index.search "col-xs-6.col-md-12"

    index = cargar_website "http://unionradio.net/category/pais/politica/"
    notas_web += index.search ".col-xs-4"
    total_notas_importadas = 0
    total_notas_no_importadas = 0
    notas_web.each do |nota_web|
      # Se buscan titulos (<a></a>) y contenidos
      nota_temp = Hash.new
      nota_temp[:website_id] = website.id
      nota_temp[:tipo_nota_id] = 1
            
      titulo = nota_web.search "a"
      
      unless titulo.blank?
        # Si la Nota tiene titulo y contenido
        nota_temp[:url] = (titulo.search("a").attr "href").value
        
        nota_temp[:titulo] = titulo.text.gsub(/[\t\n\r\s+]/, '')
        # Buscamos Fecha
        nota_temp[:fecha_publicacion] = (nota_web.search ".text-size-08").text
        
        # Buscamos Imagen
        nota_temp[:imagen] = (nota_web.search("img").attr "src").value        

        # Se guarda la nota_local
        if Nota.create nota_temp
          total_notas_importadas += 1 
        else
          total_notas_no_importadas += 1
        end
      else
        total_notas_no_importadas += 1
      end
    end
    puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"    
    puts "Total de notas encontradas: #{notas_web.count}"
    puts "Total de notas importadas: #{total_notas_importadas}"
    puts "Total de notas No Importadas: #{total_notas_no_importadas}"
  end

  
  def self.import_notas_union_radio_old

    website = Website.find_by_nombre "unionradio"
    puts website.nombre
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas_web = index.search ".TPHomeContent"
    notas_web += index.search "#ctl00_columnaPrinc_otrosVitrina div"
    notas_web += index.search "#ctl00_columnaPrinc_otrasnotasdevitrina3 div"
    notas_web += index.search "#ctl00_columnaPrinc_otrasnotasvit2 div"
    notas_web += index.search "#ctl00_columnaPrinc_otrasnotasdevitrina4 div" 
    
    notas_web.each do |nota_web|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota_web.search ".ttlPrinc"
      titulo = nota_web.search ".ttlPrinc2" if titulo.blank?
      
      # Se buscan contenido
      contenido = nota_web.search ".contenidoVit"
      
      unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
        href = titulo.attr "href"
        url = href.value if href
        url = website.url + url unless url.include? website.url
        
        titulo = titulo.text
        
        # Buscamos Fecha
        fecha = nota_web.search ".fechaVit"
        fecha = fecha.text if fecha

        # Buscamos Imagen
        imagen = nota_web.search "img"
        imagen = imagen.attr "src" unless imagen.blank?
        imagen = imagen.text
        # imagen = "http://www1.unionradio.net#{imagen}" unless imagen.blank?
        

        # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
        # puts "Titulo: #{titulo}\n"
        # puts "Url: #{url}\n"
        # puts "Fecha: #{fecha}\n"
        # puts "Contenido: #{contenido}\n"
        # puts "Imágen: #{imagen}\n"

        # Se guarda la nota_local
        nota = Nota.new
        nota.titulo = titulo.gsub(/[\t\n\r]/, '')
        nota.fecha_publicacion = fecha
        nota.contenido = contenido.text.gsub(/[\t\n\r]/, '')
        nota.url = url
        nota.website_id = website.id
        nota.tipo_nota_id = 1
        nota.imagen = imagen
        nota.save
      
      end
    end

  end  

  def self.import_notas_noticierodigital


    website = Website.find_by_nombre "noticierodigital"
    index = cargar_website website.url
    # notas_web = index.search ".a"
    notas_web = index.search ".highlighted, .mainnotes"
    # notas_web = index.search "li.a"
    notas_cargadas = 0
    # .search(".a").at("span").parent.text
     notas_web.each do |nota_web|
       # Creación del Hast para la Nota
       nota_temp = Hash.new
       nota_temp[:website_id] = website.id
       nota_temp[:tipo_nota_id] = 1
       
       # Gestión de titulo y url
       

       # Se buscan titulos (<a></a>) y contenidos       
       nota_temp[:titulo] = nota_web.search("h2 a").first
       nota_temp[:url] = (nota_temp[:titulo].attr "href") unless nota_temp[:titulo].blank?
       nota_temp[:titulo] = (limpio nota_temp[:titulo].text) unless nota_temp[:titulo].blank?
       
       # Gestión de Resumen de la nota
       nota_temp[:contenido] = nota_web.search("p.lead").text
       # nota_temp[:contenido] = nota_temp[:contenido].text if nota_temp[:contenido].blank? 
       # nota_temp[:contenido] = (limpio nota_temp[:contenido].text) unless nota_temp[:contenido].blank?

       #Limpieza del contenido, quitamos titulos y fechas
       # msg = contenido[1].text
       # msg = nota.text if msg.include? "ver artículo completo »"      
       # msg.slice! titulo if msg.include? titulo
       # msg.slice! fecha if msg.include? fecha
       # 
       # if msg.include? "opinan los foristas"  
       #   indice = msg.index "opinan los foristas"
       #   aux = msg[indice..-1]
       #   msg.slice! aux
       # end
       # 
       # contenido = msg#.slice! "ver artículo completo »"
       # 
       
       # Gestión de la Imagen
       nota_temp[:imagen] = nota_web.search("img")
       # nota_temp[:imagen] = nota_web.search("img") if nota_temp[:imagen].blank?
       nota_temp[:imagen] = (nota_temp[:imagen].attr "src").text unless nota_temp[:imagen].blank?
       
       # Gestión de la Fecha de publicación
       # nota_temp[:fecha_publicacion] = nota_web.search(".fecha")
       # nota_temp[:fecha_publicacion] = nota_temp[:fecha_publicacion].text unless nota_temp[:fecha_publicacion].blank?
       
       # Crear Nota
       notas_cargadas +=1 if Nota.create nota_temp
     end
     puts "Resumen en #{website.nombre}:".center(100,"=")
     puts "Total de Notas a Cargar: #{notas_web.count}"
     puts "Total de Notas Cargadas: #{notas_cargadas}"
     puts "".center(100,"=")
    
  end


  def self.import_notas_noticierodigital_old
    
    # Noticiero Digital = ".highlighted, .mainnotes"
    website = Website.find_by_nombre "noticierodigital"
    puts website.nombre
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    
    notas = index.search ".principal"
    # notas =+ index.search "//div[@id='noticiadestacada']"
    
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h2 a"

      href = titulo.attr "href"
      url = (href).value if href
      titulo = titulo.text

      # Buscamos la fecha
      fecha = nota.search(".fecha")
      fecha = fecha[0] if fecha.count > 1
      fecha = fecha.text if fecha

      
      contenido = nota.search "div"
      
      #Limpieza del contenido, quitamos titulos y fechas
      msg = contenido[1].text
      msg = nota.text if msg.include? "ver artículo completo »"      
      msg.slice! titulo if msg.include? titulo
      msg.slice! fecha if msg.include? fecha
      
      if msg.include? "opinan los foristas"  
        indice = msg.index "opinan los foristas"
        aux = msg[indice..-1]
        msg.slice! aux
      end
      
      contenido = msg#.slice! "ver artículo completo »"

      # unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido

      # Buscamos imagen
      imagen = nota.search "img"
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = imagen.text
      
      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "Titulo: #{titulo}\n"
      # puts "Url: #{url}\n"
      # puts "Fecha: #{fecha}\n"
      # 
      # # puts "Contenido:\n"
      # # contenido.each_with_index {|c,i| puts "#{i}.- #{c.text}"}
      # # puts "=========================="
      # puts "Contenido: #{contenido}\n"
      # puts "Imágen: #{imagen}\n"

      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save

    end
  end

    
  def self.import_notas_noticierovenevision
    website = Website.find_by_nombre "noticierovenevision"
    puts website.nombre
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".MainNews li"
    
    # Notas adicionales
    index = cargar_website "#{website.url}/politica"
    notas += index.search ".MainNews li"
    
    # notas += index.search ".MainNews.MoreSummary "
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h1 a"
      
      href = titulo.attr "href"
      url = "#{website.url}#{(href).value}" if href
      titulo = titulo.text
      fecha = nota.search("h1 span")
      fecha = fecha[0] if fecha.count > 1
      fecha = fecha.text if fecha
      contenido = nota.search "p"
      # Se cargan la imagen
      imagen = nota.search ".Photo"
      
      unless imagen.blank? and not imagen.search ".full-frame"
        imagen = imagen.attr("style").to_s
        imagen = imagen[16...imagen.length-1]
        imagen = "#{website.url}#{imagen}" unless imagen.blank?
      end
      # Se guarda la nota_local      
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.text.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save
    end



  end  

  def self.import_notas_vtv
    website = Website.find_by_nombre "vtv"
    puts website.nombre    
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".carousel-button"    
    notas += index.search ".vtv-nitf-principal-item"
       
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h4 a"
      titulo = nota.search "a" if titulo.blank?
      
      contenido = nota.search ".principal-description"
      # unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
      href = titulo.attr "href" unless titulo.blank?
      url = (href).value if href
      titulo = titulo.text
      # fecha = nota.search(".fecha")
      # fecha = fecha[0] if fecha.count > 1
      # fecha = fecha.text if fecha
        

      imagen = nota.search ".vtv-nitf-principal-image-container img"
      imagen = nota.search "img" if imagen.blank?
      imagen = imagen.attr "data-original" unless imagen.blank?
      imagen = imagen.text
      
      # puts "================================================<<<<<<<<<<< imagen >>>>>>>>>>>>>>================================================"
      # puts imagen
      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "Titulo: #{titulo}\n"
      # puts "Url: #{url}\n"
      # puts "Fecha: #{fecha}\n"
      # puts "Contenido: #{contenido}\n"
      # puts "Imágen: #{imagen}\n"
      
      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      # nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.text.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save

    end
  end

  def self.import_notas_laverdad
    
    website = Website.find_by_nombre("laverdad")
    index = cargar_website website.url
    # notas_web = index.search ".a"
    notas_web = index.search "li.a,li.b"
    # notas_web = index.search "li.a"
    notas_cargadas = 0
    # .search(".a").at("span").parent.text
     notas_web.each do |nota_web|
       # Creación del Hast para la Nota
       nota_temp = Hash.new
       nota_temp[:website_id] = website.id
       nota_temp[:tipo_nota_id] = 1
       
       # Gestión de titulo y url
       nota_temp[:titulo] = nota_web.search("h2 a").first
       nota_temp[:url] = (nota_temp[:titulo].attr "href") unless nota_temp[:titulo].blank?
       nota_temp[:titulo] = (limpio nota_temp[:titulo].text) unless nota_temp[:titulo].blank?
       
       # Gestión de Resumen de la nota
       nota_temp[:contenido] = nota_web.search("p").text
       # nota_temp[:contenido] = nota_temp[:contenido].text if nota_temp[:contenido].blank? 
       # nota_temp[:contenido] = (limpio nota_temp[:contenido].text) unless nota_temp[:contenido].blank?
       
       # Gestión de la Imagen
       nota_temp[:imagen] = nota_web.search(".loader")
       # nota_temp[:imagen] = nota_web.search("img") if nota_temp[:imagen].blank?
       nota_temp[:imagen] = (nota_temp[:imagen].attr "data-original").text unless nota_temp[:imagen].blank?
       
       # Gestión de la Fecha de publicación
       nota_temp[:fecha_publicacion] = nota_web.search(".fecha")
       nota_temp[:fecha_publicacion] = nota_temp[:fecha_publicacion].text unless nota_temp[:fecha_publicacion].blank?
       
       
       # Crear Nota
       notas_cargadas +=1 if Nota.create nota_temp
     end
     puts "Resumen en #{website.nombre}:".center(100,"=")
     puts "Total de Notas a Cargar: #{notas_web.count}"
     puts "Total de Notas Cargadas: #{notas_cargadas}"
     puts "".center(100,"=")

  end


  def self.import_notas_laverdad_old
    website = Website.find_by_nombre "laverdad"
    puts website.nombre
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".item"
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h2 a"
      contenido = nota.search "p span"
      contenido = nota.search "p" if contenido.blank?
      contenido = contenido.text
      # unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
      href = titulo.attr "href"
      url = "#{website.url}#{(href).value}" if href
      
      titulo = titulo.text
      
      # buscamos Fechas
      fecha = nota.search(".fecha")
      fecha = fecha[0] if fecha.count > 1
      fecha = fecha.text if fecha 
      # Buscamos imagenes
      imagen = nota.search ".dest_thumb img"
      imagen = nota.search ".thumb img" if imagen.blank?
      imagen = nota.search "img" if imagen.blank?
      # imagen = imagen.attr "src" unless imagen.blank?
      
      imagen = "#{website.url}#{imagen.attr("src")}" if imagen

      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "Titulo: #{titulo}\n"
      # puts "Url: #{url}\n"
      # puts "Fecha: #{fecha}\n"
      # puts "Contenido: #{contenido}\n"
      # puts "Imágen: #{imagen}\n"

      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save

    end
  end



  def self.import_notas_informe21
    
    website = Website.find_by_nombre("informe21")
    index = cargar_website website.url
    notas_web = index.search "li"

    notas_cargadas = 0
    # .search(".a").at("span").parent.text
    notas_web.each do |nota_web|
      # Creación del Hash para la Nota
      nota_temp = Hash.new
      nota_temp[:website_id] = website.id
      nota_temp[:tipo_nota_id] = 1

      # Gestión de titulo y url
      nota_temp[:titulo] = nota_web.search("h3 a").first
      nota_temp[:url] = (nota_temp[:titulo].attr "href") unless nota_temp[:titulo].blank?
      nota_temp[:titulo] = (limpio nota_temp[:titulo].text) unless nota_temp[:titulo].blank?

      # Gestión de Resumen de la nota
      nota_temp[:contenido] = nota_web.search("p").text

      # Gestión de la Imagen
      nota_temp[:imagen] = nota_web.search("img")
      nota_temp[:imagen] = (nota_temp[:imagen].attr "src").text unless nota_temp[:imagen].blank?

      # Gestión de la Fecha de publicación
      fecha_temp = nota_web.search("span.created").first
      nota_temp[:fecha_publicacion] = fecha_temp.text unless fecha_temp.blank?

      # Crear Nota
      notas_cargadas +=1 if Nota.create nota_temp
    end
    puts "Resumen en #{website.nombre}:".center(100,"=")
    puts "Total de Notas a Cargar: #{notas_web.count}"
    puts "Total de Notas Cargadas: #{notas_cargadas}"
    puts "".center(100,"=")
  end

  def self.import_notas_informe21_old
    website = Website.find_by_nombre "informe21"
    puts website.nombre    
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".views-row"
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search ".views-field-title span a"
      contenido = nota.search ".views-field-field-summary-value span"
      contenido = contenido.text
      # unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
      href = titulo.attr "href" unless titulo.blank?
      url = "#{website.url}#{(href).value}" if href
      
      titulo = titulo.text
      
      # buscamos Fechas
      fecha = nota.search(".fecha")
      fecha = fecha[0] if fecha.count > 1
      fecha = fecha.text if fecha
        
      # Buscamos imagenes
      imagen = nota.search ".views-field-field-image-fid img"
      imagen = nota.search ".thumb img" if imagen.blank?
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = imagen.text

      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "Titulo: #{titulo}\n"
      # puts "Url: #{url}\n"
      # puts "Fecha: #{fecha}\n"
      # puts "Contenido: #{contenido}\n"
      # puts "Imágen: #{imagen}\n"

      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save

    end
  end

  def self.plantilla_general website_nombre, formato
    f_notas = formato[:notas]
    f_titulo = formato[:titulo]
    f_contenido = formato[:contenido]
    f_fecha = formato[:fecha]
    f_imagen = formato[:imagen]
        
    website = Website.find_by_nombre(website_nombre)
    index = cargar_website website.url
    notas_web = index.search f_notas

    notas_cargadas = 0
    # .search(".a").at("span").parent.text
    notas_web.each do |nota_web|
      # Creación del Hash para la Nota
      nota_temp = Hash.new
      nota_temp[:website_id] = website.id
      nota_temp[:tipo_nota_id] = 1

      # Gestión de titulo y url
      nota_temp[:titulo] = nota_web.search(f_titulo).first

      unless nota_temp[:titulo].blank?
        nota_temp[:url] = (nota_temp[:titulo].attr "href")
        
        nota_temp[:url] = website.url+nota_temp[:url] if !(nota_temp[:url].include? website.descripcion)
        unless nota_temp[:titulo].blank?
          titulo = nota_temp[:titulo].text
          titulo = nota_temp[:titulo].attr "title" if titulo.blank?
          nota_temp[:titulo] = limpio titulo
        end

      end

      # Gestión de Resumen de la nota
      nota_temp[:contenido] = nota_web.search(f_contenido).text

      # Gestión de la Imagen
      nota_temp[:imagen] = nota_web.search(f_imagen)
      nota_temp[:imagen] = (nota_temp[:imagen].attr "src").text unless nota_temp[:imagen].blank? or !(nota_temp[:imagen].attr "src")
      nota_temp[:imagen] = nota_temp[:imagen].to_s
      nota_temp[:imagen] = url_limpio nota_temp[:imagen]
      nota_temp[:imagen] = website.url+nota_temp[:imagen] unless nota_temp[:imagen].blank? or !(nota_temp[:imagen].include? website.descripcion)

      # Gestión de la Fecha de publicación
      fecha_temp = nota_web.search(f_fecha).first
      nota_temp[:fecha_publicacion] = fecha_temp.text unless fecha_temp.blank?

      # Crear Nota
      nota = Nota.new nota_temp

      puts "".center(100,"-")
      puts nota_temp
      puts "Nota: #{nota.id}"
      puts "Titular: #{nota.titulo}"
      puts "url: #{nota.url}"
      puts "contenido: #{nota.contenido}"
      puts nota.save
      puts "".center(100,"-")

      notas_cargadas +=1 if nota.save
    end
    puts " Resumen en #{website.nombre}: ".center(100,"=")
    puts "Total de Notas a Cargar: #{notas_web.count}"
    puts "Total de Notas Cargadas: #{notas_cargadas}"
    puts "".center(100,"=")
    
  end

# BARRIDOS 2.0

  def self.importar_notas_noticias24

    @website = Website.find 34
    
    @website.paginas.each do |pagina|
      formato = Hash.new
      formato[:notas] = pagina.articulo
      formato[:titulo] = pagina.titulo
      formato[:contenido] = pagina.contenido
      formato[:fecha] = pagina.fecha
      formato[:imagen] = pagina.imagen
      plantilla_general @website.nombre, formato
    end
  end

  def self.importar_notas_laverdad
    formato = Hash.new
    formato[:notas] = 'li.a,li.b'
    formato[:titulo] = 'h2 a'
    formato[:contenido] = 'p'
    formato[:fecha] = '.fecha'
    formato[:imagen] = '.loader'

    plantilla_general "laverdad", formato
  end



  def self.importar_notas_caraotadigital
    formato = Hash.new
    formato[:notas] = '.td_module_1'
    formato[:titulo] = 'h3 a'
    formato[:contenido] = 'p'
    formato[:fecha] = '.td-post-date'
    formato[:imagen] = 'img'

    plantilla_general "caraotadigital", formato
  end


  def self.importar_notas_ultimasnoticias
    formato = Hash.new
    formato[:notas] = 'article'
    formato[:titulo] = 'a'
    formato[:contenido] = 'p'
    formato[:fecha] = '.updated'
    formato[:imagen] = 'img'

    plantilla_general "ultimasnoticias", formato
  end

  def self.importar_notas_panorama
    formato = Hash.new
    formato[:notas] = 'article'
    formato[:titulo] = 'a'
    formato[:contenido] = 'p'
    formato[:fecha] = '.n3_creditos span'
    formato[:imagen] = 'img'

    plantilla_general "panorama", formato
  end

  def self.importar_notas_eluniversal
    formato = Hash.new
    formato[:notas] = 'article'
    formato[:titulo] = 'h3 a'
    formato[:contenido] = 'p'
    formato[:fecha] = '.epigraph span'
    formato[:imagen] = 'img'

    Importer.plantilla_general "eluniversal", formato

  end

  def self.import_notas_eluniversal_old
    website = Website.find_by_nombre "eluniversal"
    puts website.nombre    
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".pod_chorro3_hm"
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h1 a"
      titulo = nota.search ".titulo2.color000.TDno" if titulo.blank?
      
      # Si la Nota tiene titulo
      unless titulo.blank?
        href = titulo.attr "href"
        url = "#{website.url}#{(href).value}" if href
        titulo = titulo.text
      end
      
      # Buscamos los contenidos
      contenido = nota.search ".contenido333"
      # contenido = nota.search ".contenido333.LH17.LS06"
      # contenido = nota.search ".contenido333.LS06" if contenido.blank?
      contenido = contenido.text unless contenido.blank?

      
      # buscamos Fechas
      fecha = nota.search(".hora2")
      # fecha = fecha[0] if fecha.count > 1
      fecha = fecha.text if fecha
        
      # Buscamos imagenes
      imagen = nota.search "a img"
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = imagen.text if imagen

      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "Titulo: #{titulo}\n"
      # puts "Url: #{url}\n"
      # puts "Fecha: #{fecha}\n"
      # puts "Contenido: #{contenido}\n"
      # puts "Imágen: #{imagen}\n"

      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save

    end
  end

  def self.import_notas_avn
    website = Website.find_by_nombre "avn"
    puts website.nombre    
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".views_slideshow_thumbnailhover_slide.views_slideshow_slide"
    notas += index.search ".index3-6noticias"
    notas += index.search ".index3-9noticias"
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search ".titulo a"
      titulo = nota.search "a" if titulo.blank?
      # titulo = nota.search ".titulo2.color000.TDno" if titulo.blank?
      
      # Si la Nota tiene titulo
      unless titulo.blank?
        href = titulo.attr "href"
        url = "#{website.url}#{(href).value}" if href
        titulo = titulo.text
      end
      
      # Buscamos los contenidos
      # contenido = nota.search ".contenido333"
      contenido = nota.search ".sumario"
      # contenido = nota.search ".contenido333.LS06" if contenido.blank?
      contenido = contenido.text if contenido#unless contenido.blank?
      
      # buscamos Fechas
      # fecha = nota.search(".hora2")
      # fecha = fecha[0] if fecha.count > 1
      # fecha = fecha.text if fecha
        
      # Buscamos imagenes
      imagen = nota.search "img"
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = imagen.text unless imagen.blank?

      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "Titulo: #{titulo}\n"
      # puts "Url: #{url}\n"
      # # puts "Fecha: #{fecha}\n"
      # puts "Contenido: #{contenido}\n"
      # puts "Imágen: #{imagen}\n"

      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      # nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save

    end
  end

  def self.import_notas_radiomundial
    website = Website.find_by_nombre "radiomundial"
    puts website.nombre    
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    unless index.nil?
    
      # Se Buscan las Todas las Notas de la Web
      notas = index.search ".views-row"
      notas.each do |nota|
        # Se buscan titulos (<a></a>) y contenidos
        titulo = nota.search ".views-field-title span a"
        titulo = nota.search ".views-showcase-subitem.views-showcase-big-box-field_main_image_fid span a" if titulo.blank?
      
      
        contenido = nota.search ".field-content p"
        contenido = contenido.text
        # unless contenido.blank? && titulo.blank?
          # Si la Nota tiene titulo y contenido
        href = titulo.attr "href" unless titulo.blank?
        url = "#{website.url}#{(href).value}" if href
      
        titulo = titulo.text
      
        # buscamos Fechas
        fecha = nota.search(".views-field-created span")
        fecha = fecha[0] if fecha.count > 1
        fecha = fecha.text if fecha
        
        # Buscamos imagenes
        imagen = nota.search "img"
        # imagen = nota.search ".thumb img" if imagen.blank?
        imagen = imagen.attr "src" unless imagen.blank?
        imagen = imagen.text
      
        # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
        # unless titulo.blank?
        #   puts "Titulo: #{titulo}\n"
        #   puts "Url: #{url}\n"
        #   puts "Fecha: #{fecha}\n"
        #   puts "Contenido: #{contenido}\n"
        #   puts "Imágen: #{imagen}\n"
        # else
        #   puts nota
        # end

        # Se guarda la nota_local
        nota_local = Nota.new
        nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
        nota_local.fecha_publicacion = fecha
        nota_local.contenido = contenido.gsub(/[\t\n\r]/, '')
        nota_local.url = url
        nota_local.website_id = website.id
        nota_local.tipo_nota_id = 1
        nota_local.imagen = imagen
        nota_local.save
      end
    end
    return index
  end

  def self.import_notas_elnacional
    website = Website.find_by_nombre "elnacional"
    puts website.nombre    
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes
    
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".md-24h-nws"
    notas += index.search ".bd"
    
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search ".headline a"

      
      contenido = nota.search ".teaser"
      contenido = contenido.text
      # unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
      href = titulo.attr "href" unless titulo.blank?
      url = "#{website.url}#{(href).value}" if href
      
      titulo = titulo.text
      
      # buscamos Fechas
      fecha = nota.search(".timestamp")
      fecha = fecha.text if fecha
        
      # Buscamos imagenes
      imagen = nota.search "img"
      # imagen = nota.search ".thumb img" if imagen.blank?
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = "#{website.url}#{imagen}" if imagen
      # imagen = imagen.text
      
      # puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # unless titulo.blank?
      #   puts "Titulo: #{titulo}\n"
      #   puts "Url: #{url}\n"
      #   puts "Fecha: #{fecha}\n"
      #   puts "Contenido: #{contenido}\n"
      #   puts "Imágen: #{imagen}\n"
      # else
      #   puts nota
      # end

      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.gsub(/[\t\n\r]/, '')
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      nota_local.save

    end
  end

  def self.import_notas_rnv
    website = Website.find_by_nombre "rnv"
    puts website.nombre
    # Eliminando las notas no asociadas a algun resumen
    # website.eliminar_notas_irrelevantes

    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website.url
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".categorypanel"
    notas += index.search ".slide"
    # notas += index.search ".thumbsup-image"
    
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h2 a"
      titulo = nota.search "h1 a" if titulo.blank?

      contenido = nota.search ".excerpt"
      contenido = nota.search ".slideDes" if contenido.blank?
      contenido = contenido.text

      # Buscamos imagenes
      imagen = nota.search "img"
      imagen = imagen.attr "src" unless imagen.blank?
      imagen = imagen.text unless imagen.blank?
      
      # Buscamos titulos y urls
      href = titulo.attr "href" unless titulo.blank?
      url = "#{(href).value}" if href
      titulo = titulo.text
      puts "==================================="
      puts "titulo: #{titulo}"
      puts "url: #{url}"
      puts "contenido: #{contenido}"
      puts "==================================="      
      
      # buscamos Fechas # Nohay Fechas
      # fecha = nota.search(".timestamp")
      # fecha = fecha.text if fecha
        

      # imagen = imagen.text

      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo.gsub(/[\t\n\r]/, '')
      # nota_local.fecha_publicacion = fecha unless fecha.blank?
      nota_local.contenido = contenido if contenido
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = 1
      nota_local.imagen = imagen
      
      begin
          nota_local.save      
      rescue Exception => ex
        puts "Error al intenter guardar: #{ex}"
      end
      
      
      
      # PROPUESTA DE VALIDAR URL
      # nota_local = website.notas.find_by_url url
      # if nota_local.nil?
      #   # Se guarda la nota_local
      #   nota_local = Nota.new
      #   nota_local.titulo = titulo
      #   nota_local.fecha_publicacion = fecha
      #   nota_local.contenido = contenido
      #   nota_local.url = url
      #   nota_local.website_id = website.id
      #   nota_local.tipo_nota_id = tipo_nota.id
      #   nota_local.imagen = imagen
      #   nota_local.save
      # # else
      # #   nota_local.destroy if nota_local.resumen_id.nil?
      # end
    end
  end

  # 
  # def self.import_notas_rnv
  #   website = Website.find_by_nombre "rnv"
  #   puts website.nombre
  #   # Eliminando las notas no asociadas a algun resumen
  #   # website.eliminar_notas_irrelevantes
  # 
  #   # Se Carga la Pagina Principal del WebSite
  #   index = cargar_website website.url
  #   
  #   tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
  #   
  #   # Se Buscan las Todas las Notas de la Web
  #   notas = index.search ".gk_is_slide"
  #   notas += index.search ".thumbsup-image"
  #   
  #   notas.each do |nota|
  #     # Se buscan titulos (<a></a>) y contenidos
  #     titulo = nota.search ".thumbsup-title a"
  #     
  #     if titulo.blank?
  #       
  #       titulo = nota.attr "title"
  #       imagen = nota.children[0].text
  #       titulo.slice! "(+AUDIO)" unless titulo.blank?
  #       href = nota.children[1].attr "href"
  #       url = "#{website.url}#{href}" if href
  #     else
  #       
  #       contenido = nota.search ".thumbsup-intro"
  #       contenido = contenido.text
  # 
  #       # Buscamos imagenes
  #       imagen = nota.search "img"
  #       imagen = imagen.attr "src" unless imagen.blank?
  #       imagen = imagen.text unless imagen.blank?
  #       
  #       # Buscamos titulos y urls
  #       href = titulo.attr "href" unless titulo.blank?
  #       url = "#{website.url}#{(href).value}" if href
  #       titulo = titulo.text
  #     end
  #     
  #     # buscamos Fechas # Nohay Fechas
  #     # fecha = nota.search(".timestamp")
  #     # fecha = fecha.text if fecha
  #       
  # 
  #     # imagen = imagen.text
  #  
  #       # Se guarda la nota_local
  #       nota_local = Nota.new
  #       nota_local.titulo = titulo
  #       # nota_local.fecha_publicacion = fecha unless fecha.blank?
  #       nota_local.contenido = contenido if contenido
  #       nota_local.url = url
  #       nota_local.website_id = website.id
  #       nota_local.tipo_nota_id = tipo_nota.id
  #       nota_local.imagen = imagen
  #       nota_local.save
  #  
  #     
  #     # PROPUESTA DE VALIDAR URL
  #     # nota_local = website.notas.find_by_url url
  #     # if nota_local.nil?
  #     #   # Se guarda la nota_local
  #     #   nota_local = Nota.new
  #     #   nota_local.titulo = titulo
  #     #   nota_local.fecha_publicacion = fecha
  #     #   nota_local.contenido = contenido
  #     #   nota_local.url = url
  #     #   nota_local.website_id = website.id
  #     #   nota_local.tipo_nota_id = tipo_nota.id
  #     #   nota_local.imagen = imagen
  #     #   nota_local.save
  #     # # else
  #     # #   nota_local.destroy if nota_local.resumen_id.nil?
  #     # end
  #   end
  # end
  # 



# page2 = page.link_with(:href => cunas_fichas_url).click

  

  
  # BARRER WEBSITES PRUEBA
  
  def self.barrer_todos
    puts 'Iniciando Barrido...'
    # Nota.delete_all (["resumen_id IS ? AND created_at < ?", nil, Date.today])
    puts 'Borrando notas anteriores a hoy...'
    for i in (1..10000)
      puts "Inicio Vuelta: <#{i}>"
      Website.all.each do |website|
        begin

          puts "\tIntentando cargar paginas de:" 
          website.importar_notas_website
          puts "\tCarga exitosa de paginas de #{website.nombre}" 
        rescue
          puts "\tError al intenter importar notas de #{website.nombre}"
          puts "Se continua la carga ..."
        end
      end
      puts "Fin de vuelta <#{i}>"
      sleep(5.minutes)
    end
  end
  
  
  
  
  
  
  
  def self.import_candidatos
    voceros_url = "http://sigecup.cne.gob.ve/index.php/general/political_representative_controller/show_all_political_representatives"
    a = Mechanize.new
    page = login_sigecup a
    
    page2 = page.link_with(:href => cunas_fichas_url).click
    
    page2_form = page2.forms.first
    page2_form.fields.each { |f| puts f.name }
    puts "Inicio......"
    page2_form.limit = -1
    page3 = a.submit(page2_form, page2_form.buttons.first)
      
    page3_form2 = page3.search("table")[2]
    # puts page3_form2
    rows = page3_form2.search("tr")
    rows.shift
    
    
    rows.each do |tr|
      organizacion = Organizacion.new
      tds = tr.search("td")
      vocero_pag = tds[1].search('a').click
      puts raw vocero_pag
    end
    
    
  end

  def self.import_cunas

    cunas_fichas_url = "http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/consultar/por_ficha"
    # a = Mechanize.new
    # page = login_sigecup a
    # rows = load_data_rows cunas_fichas_url, page, a

    a = Mechanize.new
    page = login_sigecup a
    page2 = page.link_with(:href => cunas_fichas_url).click
    
    page2_form = page2.forms.first
    page2_form.fields.each { |f| puts f.name }
    puts "Inicio......"
    page2_form.limit = -1
    page3 = a.submit(page2_form, page2_form.buttons.first)
      
    page3_form2 = page3.search("table")[2]
    # puts page3_form2
    rows = page3_form2.search("tr")
    rows.shift
    
    #-------- Limpiesa de Datos ---------#
    Cuna.delete_all_candidates
    Aparicion.delete_all
    Cuna.delete_all
    #-------- Fin Limpiesa de Datos ---------#
    
    importadas = 0
    no_importadas = 0
    errores = 0
        
    rows.each do |tr|
      begin
        cuna = Cuna.new
        tds = tr.search("td")
        
        cuna.sigecup_id = tds[1].search('a').text
        cuna.sigecup_creacion = tds[2].text
        cuna.duracion = tds[3].text.split[0]
        cuna.nombre = tds[4].search('a').text
        cuna.grupo = tds[5].search('a').text
        organizacion = Organizacion.find_by_nombre_corto(tds[6].search('a').text)
        cuna.organizacion_id = organizacion.id if not organizacion.nil?
        candidates = tds[11].search('a')
        puts candidates
        puts candidates.count
        if candidates.count > 0
          candidates.each do |c|
            # candidate = Candidate.all(:conditions =>"name like '#{c.text.squeeze(" ")}'").first
            candidate = Candidate.find_by_name c.text.squeeze(" ")
            if not candidate.nil?
              cuna.candidates.push candidate
            else
              a.get(c)
            end
          end
        else
          case cuna.grupo
          when 'MUD'
              candidate = Candidate.oposicion
          when 'PSUV'
              candidate = Candidate.chavismo
          when 'Sin Grupo'
              candidate = Candidate.independiente
          end
          cuna.candidates.push candidate if not candidate.nil?
        end
        
        
        if mssg = cuna.save
          puts "=============== IMPORTACIÓN DE CUÑA CORRECTA ============="
          importadas += 1
        else
          puts "IMPORTACIÓN NO COMPLETADA"
          puts "tds #{tr}"
          puts "Error: #{cuna.errors}" if cuna.errors.any?
          puts "=================================================="
          no_importadas += 1
        end
        
      rescue Exception => msg
        puts "=============== ERROR DE IMPORTACIÓN ============="
        puts msg
        puts "tds #{tr}"
        puts "=================================================="
        errores += 1
      end
    end 
    puts "============================================="
    puts "============RESULTADOS======================="
    puts "=== IMPORTADOS: #{importadas}             ==="
    puts "=== NO IMPORTADOS: #{no_importadas}       ==="
    puts "=== ERRORES: #{errores}                   ==="
    puts "=============================================" 
  end
  
  def self.import_apariciones

    aparicion_cunas_url = "http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/reportes/aparicion_de_cunas"
  
    a = Mechanize.new
    page = login_sigecup a
    # rows = load_data_rows aparicion_cunas_url, page, a
    
    page2 = page.link_with(:href => aparicion_cunas_url).click
    
    page2_form = page2.forms.first
    page2_form.fields.each { |f| puts f.name }
    puts "Inicio......"
    page2_form.limit = -1
    page3 = a.submit(page2_form, page2_form.buttons.first)
      
    page3_form2 = page3.search("table")[2]
    # puts page3_form2
    rows = page3_form2.search("tr")
    puts rows.shift
    
    Aparicion.delete_all
    importadas = 0
    no_importadas = 0
    errores = 0
    rows.each do |tr|
      begin
        aparicion = Aparicion.new
        tds = tr.search("td")
        fecha = tds[1].search('a').text
        
        hora = tds[2].text
        cuna = tds[4].search('a').text
        canal = tds[9].search('a').text
        
        aparicion.fecha = fecha
        aparicion.momento = "#{fecha} #{hora} -0430"
        aparicion.cuna_id = (Cuna.find_by_sigecup_id cuna).id 
        aparicion.canal_id = (Canal.find_by_siglas canal).id
        
        if aparicion.save
          puts "=============== IMPORTACION APARICION CORRECTA ============="
          importadas += 1
        else
          puts "IMPORTACIÓN NO COMPLETADA"
          puts "Error: #{cuna.errors}" if cuna.errors.any?
          puts "====================================================="
          no_importadas += 1
        end
        
        
      rescue Exception => msg
        errores += 1
        puts "=============== ERROR DE IMPORTACIÓN ============="
        puts msg
        puts "tds #{tr}"
        puts "====================================================="
      end
    end
    
    puts "============================================="
    puts "============RESULTADOS======================="
    puts "=== IMPORTADOS: #{importadas}             ==="
    puts "=== NO IMPORTADOS: #{no_importadas}       ==="
    puts "=== ERRORES: #{errores}                   ==="
    puts "============================================="
  end
    
  def self.login_sigecup a
    username = "DMOROS"
    password = "dm893585"
    url = URI.parse('http://sigecup.cne.gob.ve')
  
    index = a.get(url)
    # captura de Imagen Captcha
    img = index.search("img")
    puts "#{img}"
  
    puts "Introduzca el Valor del Captcha:"
    captcha = gets.chomp # lectura por consola de valor Captcha
  
  
    # captura de form login
    login_form = index.forms.first
  
    login_form.login = username
    login_form.password = password
    login_form.captcha = captcha
  
    # Carga de principal de la aplicación
    puts "Login Completado"
    a.submit(login_form, login_form.buttons.first)
  end  
  
  def self.load_data_rows url, page, a
        
    page2 = page.link_with(:href => url).click

    page2_form = page2.forms.first
    page2_form.fields.each { |f| puts f.name }
    puts "Inicio......"
    puts "Gargando ......"
    page2_form.limit = -1
    page3 = a.submit(page2_form, page2_form.buttons.first)
  
    page3_form2 = page3.search("table")[2]
    rows = page3_form2.search("tr")
    puts "Carga de Rows Completada"
    rows.shift
  end
  
end