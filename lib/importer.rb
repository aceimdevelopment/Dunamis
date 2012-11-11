# coding: utf-8
module Importer
  def cadidates
    require "uri"
    require 'mechanize'

    a = Mechanize.new
    page = login_sigecup a
    page2 = page.link_with(:href => "http://sigecup.cne.gob.ve/index.php/general/political_representative_controller/show_all_political_representatives").click

    page2_form = page2.forms.first
    page2_form.fields.each { |f| puts f.name }
    
    page2_form.limit = -1
    page3 = a.submit(page2_form, page2_form.buttons.first)
    
    page3_form2 = page3.search("table")[2]
        
  end
  
  def login_sigecup a
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
  
  private
end