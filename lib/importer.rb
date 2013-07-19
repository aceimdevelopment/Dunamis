# coding: utf-8
module Importer
  require 'uri'
  require 'mechanize'
  
  def self.import_notas_noticias24
    puts "NOTICAS 24"
    website = Website.find_by_nombre("noticias24")

    # Eliminando las notas no asociadas a algun resumen
    website.eliminar_notas_irrelevantes
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website

    tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
    postsGroup = index.search ".postGroup"
    postsGroup.each_with_index do |posts, i|
      puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "#{i}) #{posts}"
      titulo = posts.search(".post h2 a")
      contenido = posts.search(".post.x text")
      fecha = posts.search(".postTime p")
      fecha = posts.search(".postTime") if fecha.blank?
      url = (titulo.attr "href").value
      titulo = titulo.text
      fecha = fecha.text
      puts "titulo: #{titulo}"
      puts "url: #{url}"
      puts "Fecha: #{fecha}"
      puts "Contenido: #{contenido}"
      puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      
      nota = Nota.new
      nota.titulo = titulo
      nota.fecha_publicacion = fecha
      nota.contenido = contenido.text
      nota.url = url
      nota.website_id = website.id
      nota.tipo_nota_id = tipo_nota.id
      nota.save
    end
  end
  
  def self.import_notas_globovision
    puts "GLOBOVISION"
    website = Website.find_by_nombre("globovision")
    # Eliminando las notas no asociadas a algun resumen
    website.eliminar_notas_irrelevantes
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website_id
    tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
    notas = index.search ".espacio1"
    notas = index.search ".divnoticiasn2"
    notas += index.search ".divnoticiasn4"
    notas += index.search ".divnoticiasn5"
    puts "<cantidad de Notas: #{notas.count}>"
    notas.each_with_index do |nota, i|

      titulo = nota.search("h1 a")
      titulo = nota.search("h2 a") if titulo.blank?
      titulo = nota.search(".h3titulo") if titulo.blank?
      fecha = nota.search(".h5s")
      href = titulo.attr "href"
      url = "#{website.url}#{(href).value}" if href
      titulo = titulo.text
      fecha = fecha.text
      contenido = nota.search(".sumario_nota p")
      contenido = nota.search(".sumarioh3 p") if contenido.blank?
      contenido = nota.search("ctl10_lblMostra") if contenido.blank?      
      nota_local = Nota.new
      nota_local.titulo = titulo
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.text
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = tipo_nota.id
      nota_local.save
    end
  end
  
  def self.import_notas_union_radio
    puts "UNION RADIO"
    website = Website.find_by_nombre "unionradio"
    # Eliminando las notas no asociadas a algun resumen
    website.eliminar_notas_irrelevantes
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website
    
    tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".TPHomeContent"
    notas += index.search "#ctl00_columnaPrinc_otrosVitrina div"
    notas += index.search "#ctl00_columnaPrinc_otrasnotasdevitrina3 div"
    notas += index.search "#ctl00_columnaPrinc_otrasnotasvit2 div"
    notas += index.search "#ctl00_columnaPrinc_otrasnotasdevitrina4 div" 
    
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search ".ttlPrinc"
      titulo = nota.search ".ttlPrinc2" if titulo.blank?
      contenido = nota.search ".contenidoVit"
      unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
        href = titulo.attr "href"
        url = "#{website.url}#{(href).value}" if href
        titulo = titulo.text
        fecha = nota.search(".fechaVit")
        fecha = fecha.text if fecha
        
        puts "div:\nfecha:#{fecha}\nurl:#{url}\ntitulo:#{titulo}\ncontenido:#{contenido.text}"
        puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
        # Se guarda la nota_local
        nota_local = Nota.new
        nota_local.titulo = titulo
        nota_local.fecha_publicacion = fecha
        nota_local.contenido = contenido.text
        nota_local.url = url
        nota_local.website_id = website.id
        nota_local.tipo_nota_id = tipo_nota.id
        nota_local.save
      
      end
    end

  end  

  def self.import_notas_noticierodigital
    puts "NOTICIERO DIGITAL"
    website = Website.find_by_nombre "noticierodigital"
    # Eliminando las notas no asociadas a algun resumen
    website.eliminar_notas_irrelevantes
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website
    
    tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
    
    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".principal"    
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h2 a"
      # contenido = nota.search ".contenidoVit"
      # unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
      href = titulo.attr "href"
      url = (href).value if href
      titulo = titulo.text
      fecha = nota.search(".fecha")
      fecha = fecha[0] if fecha.count > 1
      fecha = fecha.text if fecha
        
      puts "div:\nfecha:#{fecha}\nurl:#{url}\ntitulo:#{titulo}"
      puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # Se guarda la nota_local
      nota_local = Nota.new
      nota_local.titulo = titulo
      nota_local.fecha_publicacion = fecha
      # nota_local.contenido = contenido.text
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = tipo_nota.id
      nota_local.save

    end
  end
    
  def self.import_notas_noticierovenevision
    puts "NOTICIERO VENEVISION"
    website = Website.find_by_nombre "noticierovenevision"
    # Eliminando las notas no asociadas a algun resumen
    website.eliminar_notas_irrelevantes
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website

    tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")

    # Se Buscan las Todas las Notas de la Web
    notas = index.search ".MainNews li"
    # notas += index.search ".MainNews.MoreSummary "
    notas.each do |nota|
      # Se buscan titulos (<a></a>) y contenidos
      titulo = nota.search "h1 a"
      # contenido = nota.search ".contenidoVit"
      # unless contenido.blank? && titulo.blank?
        # Si la Nota tiene titulo y contenido
      href = titulo.attr "href"
      url = "#{website.url}#{(href).value}" if href
      titulo = titulo.text
      fecha = nota.search("h1 span")
      fecha = fecha[0] if fecha.count > 1
      fecha = fecha.text if fecha
      contenido = nota.search "p"
      puts "div:\nfecha:#{fecha}\nurl:#{url}\ntitulo:#{titulo}\ncontenido:#{contenido.text}"
      puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # Se guarda la nota_local
      
      nota_local = Nota.new
      nota_local.titulo = titulo
      nota_local.fecha_publicacion = fecha
      nota_local.contenido = contenido.text
      nota_local.url = url
      nota_local.website_id = website.id
      nota_local.tipo_nota_id = tipo_nota.id
      nota_local.save

    end

  end  



  def self.importar_notas_general (nombre_website, class_div)
    puts nombre_website
    website = Website.find_by_nombre nombre_website

    # Eliminando las notas no asociadas a algun resumen
    website.eliminar_notas_irrelevantes
    # Se Carga la Pagina Principal del WebSite
    index = cargar_website website

    tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
    postsGroup = index.search class_div
    postsGroup.each_with_index do |posts, i|
      puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      # puts "#{i}) #{posts}"
      titulo = posts.search(".post h1 a")
      titulo = posts.search(".post h2 a") if titulo.blank?
      
      contenido = posts.search(".post.x text")
      fecha = posts.search(".postTime p")
      fecha = posts.search(".postTime") if fecha.blank?
      url = (titulo.attr "href").value
      titulo = titulo.text
      fecha = fecha.text
      puts "titulo: #{titulo}"
      puts "url: #{url}"
      puts "Fecha: #{fecha}"
      puts "Contenido: #{contenido}"
      puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
      
      nota = Nota.new
      nota.titulo = titulo
      nota.fecha_publicacion = fecha
      nota.contenido = contenido.text
      nota.url = url
      nota.website_id = website.id
      nota.tipo_nota_id = tipo_nota.id
      nota.save
    end
  end

# page2 = page.link_with(:href => cunas_fichas_url).click

  
  def self.cargar_website website
    url = URI.parse website.url
    agente = Mechanize.new
    return agente.get(url)
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