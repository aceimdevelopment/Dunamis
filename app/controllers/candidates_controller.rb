# coding: utf-8
class CandidatesController < ApplicationController
  # GET /candidates
  # GET /candidates.json
  require 'importer'
  def index
    # Importer.import_candidatos if params[:import_candi]
    @candidates = Candidate.all.sort_by {|c| c.name}
    if params[:generar_reporte]
      # Pdf.generar_reporte_candidatos 
      
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @candidates }
    end
  end

  # GET /candidates/1
  # GET /candidates/1.json
  def show
    @candidate = Candidate.find(params[:id])
    @cunas = @candidate.cunas
    @apariciones = []
    @tiempo = 0
    @cunas.each do |cuna|
    aux = Aparicion.por_cuna cuna.id
    @tiempo += aux.count * cuna.duracion if aux
    @apariciones += aux
    end
     
    apariciones = 
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @candidate }
    end
  end

  # GET /candidates/new
  # GET /candidates/new.json
  def new
    @candidate = Candidate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @candidate }
    end
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.find(params[:id])
  end

  # POST /candidates
  # POST /candidates.json
  def create
    @candidate = Candidate.new(params[:candidate])

    respond_to do |format|
      if @candidate.save
        format.html { redirect_to @candidate, notice: 'Candidate was successfully created.' }
        format.json { render json: @candidate, status: :created, location: @candidate }
      else
        format.html { render action: "new" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /candidates/1
  # PUT /candidates/1.json
  def update
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        format.html { redirect_to @candidate, notice: 'Candidate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.json
  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy

    respond_to do |format|
      format.html { redirect_to candidates_url }
      format.json { head :no_content }
    end
  end
  
  def generar_reporte
    # Pdf.generar_reporte_candidatos pa if params[:generar_reporte]
    
  end
  
  def generar_reporte_exportar
    if params[:dp4].blank? or params[:dp5].blank?
      respond_to do |format|
        format.html { redirect_to generar_reporte_url, flash[:mensaje] => 'fecha invalida'}
        format.json { head :no_content }
      end
    else
      Pdf.generar_reporte_candidatos params[:dp4], params[:dp5]
      respond_to do |format|
        format.html { redirect_to candidates_url, notice: 'Reporte Generado'}
        format.json { head :no_content }
      end
    end
  end
  # ===================== DEFINIDAS INTERNAMENTE =============================== #
  
  # def import
  #   require 'uri'
  #   require 'mechanize'
  #   require 'importer'
  # 
  #   cunas_fichas_url = "http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/consultar/por_ficha"
  #   aparicion_cunas  = "http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/reportes/aparicion_de_cunas"
  # 
  #   a = Mechanize.new
  #   page = Importer.login_sigecup a
  #   page2 = page.link_with(:href => cunas_fichas_url).click
  # 
  #   page2_form = page2.forms.first
  #   page2_form.fields.each { |f| puts f.name }
  #   puts "Inicio......"
  #   page2_form.limit = -1
  #   page3 = a.submit(page2_form, page2_form.buttons.first)
  # 
  #   page3_form2 = page3.search("table")[2]
  #   # puts page3_form2
  #   rows = page3_form2.search("tr")
  #   puts rows.shift
  # 
  #   rows.each do |tr|
  #     puts "================DATOS de FILA========"
  #     begin
  #       cuna = Cuna.new
  #       tds = tr.search("td")
  #       cuna.sigecup_id = tds[1].search('a').text
  #       cuna.sigecup_creacion = tds[2].text
  #       cuna.duracion = tds[3].text.split[0]
  #       cuna.nombre = tds[4].search('a').text
  #       cuna.grupo = tds[5].search('a').text
  #       organizacion = Organizacion.find_by_nombre_corto(tds[6].search('a').text)
  #       cuna.organizacion_id = organizacion.id if not organizacion.nil?
  #       candidates = tds[11].search('a')
  #       
  #       candidates.each do |c|
  #         candidate = Candidate.all(:conditions =>"name like '%#{c.text}%' or name like '%#{c.text.split[0]}%'").first
  #         cuna.candidates.push candidate if not candidate.nil?
  #         puts "candidato: #{c.text.split[0]}"
  #       end
  #       cuna.save
  #     rescue
  #       puts "no se pudo cargar la cuña"
  #     end
  #   end      
  # end
  
  # def login_sigecup a
  #   username = "DMOROS"
  #   password = "dm893585"
  #   url = URI.parse('http://sigecup.cne.gob.ve')
  # 
  #   index = a.get(url)
  #   # captura de Imagen Captcha
  #   img = index.search("img")
  #   puts "#{img}"
  # 
  #   puts "Introduzca el Valor del Captcha:"
  #   captcha = gets.chomp # lectura por consola de valor Captcha
  # 
  # 
  #   # captura de form login
  #   login_form = index.forms.first
  # 
  #   login_form.login = username
  #   login_form.password = password
  #   login_form.captcha = captcha
  # 
  #   # Carga de principal de la aplicación
  #   a.submit(login_form, login_form.buttons.first)
  # end
  
  
  
end

