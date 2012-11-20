# coding: utf-8
module Importer
  require 'uri'
  require 'mechanize'
  
  def self.import_cunas

    cunas_fichas_url = "http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/consultar/por_ficha"
    aparicion_cunas  = "http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/reportes/aparicion_de_cunas"
  
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
    puts rows.shift
    Cuna.delete_all_candidates
    Aparicion.delete_all
    Cuna.delete_all
    
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
        
        candidates.each do |c|
          candidate = Candidate.all(:conditions =>"name like '%#{c.text}%' or name like '%#{c.text.split[0]}%'").first
          cuna.candidates.push candidate if not candidate.nil?
        end
        cuna.save
      rescue
        puts "no se pudo cargar la cuña"
      end
    end      
  end
  
  def self.import_apariciones

    aparicion_cunas_url = "http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/reportes/aparicion_de_cunas"
  
    a = Mechanize.new
    page = login_sigecup a
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
    rows.each do |tr|
      begin
        aparicion = Aparicion.new
        tds = tr.search("td")
        fecha = tds[1].search('a').text
        
        hora = tds[2].text
        cuna = tds[4].search('a').text
        canal = tds[9].search('a').text
        
        aparicion.momento = "#{fecha} #{hora} -0430"
        aparicion.cuna_id = (Cuna.find_by_sigecup_id cuna).id 
        aparicion.canal_id = (Canal.find_by_siglas canal).id
        
        if aparicion.save
          puts "=============== RESULTADO IMPORTACION APARICIONES ============="
          puts "Fecha: <#{aparicion.momento}>"
          puts "Cuña: <#{aparicion.cuna.sigecup_id}>"
          puts "Canal: <#{aparicion.canal.nombre}>"
          puts "====================================================="
        else
          puts "IMPORTACIÓN NO COMPLETADA"
          puts "Fecha: <#{fecha}>"
          puts "Hora: <#{hora}>"
          puts "Cuña: <#{cuna}>"
          puts "Canal: <#{canal}>"
          puts "====================================================="
        end
        
        
      rescue
        puts "no se pudo cargar la cuña"
        puts "Fecha: <#{fecha} | #{hora}>"
        puts "Cuña: <#{cuna}>"
        puts "Canal: <#{canal}>"
        puts "====================================================="
      end
    end      
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
    a.submit(login_form, login_form.buttons.first)
  end  
end