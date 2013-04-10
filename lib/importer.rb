# coding: utf-8
module Importer
  require 'uri'
  require 'mechanize'
  
  
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
  
  
  def self.change_register
    url = 'http://sigem.cne.gob.ve/index.php/general/political_representative_controller/edit_political_representative?to_edit='

    # Se Crea el Objeto Mechanize para comunicarse con la Aplicación Externa (Sigem)
    a = Mechanize.new
    i = 1
    n = 1328
    # login_sigecup devuelve la pagina de inicio logeado
    page = login_sigecup a
    
    while i < n  do
      url_temp = url
      url_temp += i.to_s
      candidate_page = a.get url_temp
      if candidate_form = candidate_page.forms.first
        puts " #{i} <#{candidate_form['election']}>".center(30,"=")
        if aplicable candidate_form['election'].strip
          puts "original: #{candidate_form['election']}".center(30,"=")
          candidate_form['election'] = "NoAplica"
          puts "despues: #{candidate_form['election']}".center(30,"=")
          response = a.submit(candidate_form, candidate_form.buttons[2])
          puts "EXITO! #{response}".center(30,"=") if response
        end
      end
      i +=1
    end

  end
  
  
  def self.change_register_political_representative
    url = 'http://sigem.cne.gob.ve/index.php/general/political_representative_controller/edit_political_representative?to_edit='
    # Se Crea el Objeto Mechanize para comunicarse con la Aplicación Externa (Sigem)
    a = Mechanize.new
    i = 177
    n = 1795
    # login_sigecup devuelve la pagina de inicio logeado
    page = login_sigecup a
    
    while i < n  do
      url_temp = url
      url_temp += i.to_s
      candidate_page = a.get url_temp
      if candidate_form = candidate_page.forms.first
        puts " #{i} <#{candidate_form['names']} | #{candidate_form['last_names']}>".center(30,"=")     
        apellido_corregido = chequear_apellido candidate_form['last_names'] # Apellido Corregido
        nombre_corregido = chequear_nombre candidate_form['names'] # Nombre Corregido
        
        puts " Original ".center(30,"=")
        puts "Nombre: #{candidate_form['names']}".center(30,"=")
        puts "Apellido: #{candidate_form['last_names']}".center(30,"=")
        
        candidate_form['last_names'] = apellido_corregido # cambio
        candidate_form['names'] = nombre_corregido # cambio
        
        puts " Después ".center(30,"=")
        puts "Nombre: #{candidate_form['names']}".center(30,"=")
        puts "Apellido: #{candidate_form['last_names']}".center(30,"=")
        
        begin
          response = a.submit(candidate_form, candidate_form.buttons[2])
          puts "EXITO! #{response}".center(30,"=") if response
        rescue
          puts "ERROR! #{$!}".center(30,"=")
        end
          
        
      end
      i +=1
    end
  end
  
  
  def self.change_rif_register_infomercial
    
    url = 'http://sigem.cne.gob.ve/index.php/infomercial/infomercial_controller/edit_infomercial?to_edit='
    # Se Crea el Objeto Mechanize para comunicarse con la Aplicación Externa (Sigem)
    a = Mechanize.new
    i = 107
    n = 270
    # login_sigecup devuelve la pagina de inicio logeado
    page = login_sigecup a
    
    while i < n  do
      url_temp = url
      url_temp += i.to_s
      infomercial_page = a.get url_temp
      if infomercial_form = infomercial_page.forms.first
        rif = infomercial_form['rif']
        infomercial_form['rif'] = 'No Aplica' if not rif.include? "J"
        
        puts " #{i} RIF: <#{rif} ".center(30,"=")
        # apellido_corregido = chequear_apellido candidate_form['last_names'] # Apellido Corregido
        # nombre_corregido = chequear_nombre candidate_form['names'] # Nombre Corregido
        # 
        # puts " Original ".center(30,"=")
        # puts "Nombre: #{candidate_form['names']}".center(30,"=")
        # puts "Apellido: #{candidate_form['last_names']}".center(30,"=")
        # 
        # candidate_form['last_names'] = apellido_corregido # cambio
        # candidate_form['names'] = nombre_corregido # cambio
        # 
        # puts " Después ".center(30,"=")
        # puts "Nombre: #{candidate_form['names']}".center(30,"=")
        # puts "Apellido: #{candidate_form['last_names']}".center(30,"=")
        # 
        begin
          response = a.submit(infomercial_form, infomercial_form.buttons[9])
          if response  
            puts "EXITO! #{response}".center(30,"=")
            puts " #{i} RIF: <#{rif} ".center(30,"=")
          end
        rescue
          puts "ERROR! #{$!}".center(30,"=")
        end
      end
      i +=1
    end
  end
  
  def self.chequear_nombre nombre
    nombre[3] = 'é' if nombre.include? "Jose "
    nombre[3] = 'é' if nombre.include? "Andres "
    nombre = "Andrés" if nombre.eql? "Andres"
    nombre = "Héctor" if nombre.eql? "Hector"
    nombre = "José" if nombre.eql? "Jose"
    nombre = "Ángel" if nombre.eql? "Angel"
    nombre = "Miguel Ángel" if nombre.eql? "Miguel Angel"
    nombre = "Jesús" if nombre.eql? "Jesus"
    return nombre
  end
  
  def self.chequear_apellido apellido
    apellido = "Pérez" if apellido.eql? "Perez"
    apellido = "Hernández" if apellido.eql? "Hernandez"
    apellido = "Fernández" if apellido.eql? "Fernandez"
    apellido  = "González" if apellido.eql? "Gonzalez"
    apellido = "García" if apellido.eql? "Garcia"
    apellido = "Márquez" if apellido.eql? "Marquez"
    apellido = "Álvarez" if apellido.eql? "Alvarez"
    apellido = "Rodríguez" if apellido.eql? "Rodriguez"
    apellido = "Martínez" if apellido.eql? "Martinez"    
    return apellido
  end
  
  def self.change_general_register url
    
    organizacion = "http://sigem.cne.gob.ve/index.php/political_party/political_party_controller/edit_political_party?to_edit=54"
    vocero = "http://sigem.cne.gob.ve/index.php/general/political_representative_controller/edit_political_representative?to_edit=786"
    cuña = "http://sigem.cne.gob.ve/index.php/cunas_en_vivo/editar?to_edit=301"
    tv = "http://sigem.cne.gob.ve/index.php/tv_program/tv_program_controller/edit_tv_program?to_edit=4598"
    error = "¡Acción inválida!"
    
    url = 'http://sigem.cne.gob.ve/index.php/general/political_representative_controller/edit_political_representative?to_edit='
    
    # Se Crea el Objeto Mechanize para comunicarse con la Aplicación Externa (Sigem)
    a = Mechanize.new
    i = 1
    n = 1328
    # login_sigecup devuelve la pagina de inicio logeado
    page = login_sigecup a
    
    while i < n  do
      url_temp = url
      url_temp += i.to_s
      candidate_page = a.get url_temp
      if candidate_form = candidate_page.forms.first
        puts " #{i} <#{candidate_form['election']}>".center(30,"=")
        if aplicable candidate_form['election'].strip
          puts "original: #{candidate_form['election']}".center(30,"=")
          candidate_form['election'] = "NoAplica"
          puts "despues: #{candidate_form['election']}".center(30,"=")
          response = a.submit(candidate_form, candidate_form.buttons[2])
          puts "EXITO! #{response}".center(30,"=") if response
        end
      end
      i +=1
    end

  end


  
  def rollback aplica
    aplica.eql? "Regionales 2012"
  end
  def self.aplicable_reg2012 aplica
    aplica.include? "Regionales"
  end
  
  def self.aplicable aplica
    ((aplica.casecmp "no aplica").eql? 0 or (aplica.casecmp "no").eql? 0 or (aplica.casecmp "na").eql? 0) ? true : false
  end
    
  def self.login_sigecup a
    username = "DMOROS"
    password = "48992675"
    url = URI.parse('http://sigem.cne.gob.ve/')
    
    begin
      
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
    
      response = a.submit(login_form, login_form.buttons.first)
      error = !((response.search 'label.error').blank?)
      puts "El Capcha en incorrecto intente nuevamente" if error
      puts response.search 'label.error'
    end while error
    puts "Login Completado ... "
    response
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
  
  # Error Number:
  # 
  # ERROR: secuencia de bytes no válida para codificación «UTF8»: 0xc320
  # 
  # INSERT INTO "bitacora_actividad" ("ip", "fecha", "objeto", "detalle", "usuario_fk", "bitacora_accion_fk", "tabla_fk", "tabla_id_fk") VALUES ('10.100.199.47', '2013-03-04 18:28:07', 'Andrés Velasco Bra� ...', 'Nombres&& ##Andrés&&Apellidos&& ##Velasco Brañes', '16', 46, 'representante_politico', '531')
  # 
  # Filename: /var/www/html/sigem/models/security/bitacora_model.php
  # 
  # Line Number: 570
  # 
  
end