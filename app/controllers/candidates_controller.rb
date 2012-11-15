class CandidatesController < ApplicationController
  # GET /candidates
  # GET /candidates.json
  def index
    @candidates = Candidate.all
    import
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @candidates }
    end
  end

  # GET /candidates/1
  # GET /candidates/1.json
  def show
    @candidate = Candidate.find(params[:id])

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
  
  
  # ===================== DEFINIDAS INTERNAMENTE =============================== #
  
  def import
    require 'uri'
    require 'mechanize'
  
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
    puts page3_form2
    rows = page3_form2.search("tr")
    rows.each do |tr|
      tds = tr.search("td")
      puts "num: #{tds[1].get_attribute('a')}"
      
    end
    # puts page3_form2
    
    
    # 
    # <td>5</td>
    # <td id="NroCuna_column_4"><a href="http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/consultar/registro/172">CUÑA-0025</a></td>
    # <td id="Fecha_column_4">13-11-2012</td>
    # <td id="Tiempo_column_4">30 seg.</td>
    # <td id="NombreClave_column_4"><a href="http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/consultar/registro/172">EJaua PSUV Marta González Prod Cacao</a></td>
    # <td id="Grupo_column_4"><a href="http://sigecup.cne.gob.ve/index.php/cunas_en_vivo/grupo_de_cuna/registro/1">Sin Grupo</a></td>
    # <td id="Partido_column_4" style="display: none;"><a href="http://sigecup.cne.gob.ve/index.php/political_party/political_party_controller/show_political_party/2">Psuv</a></td>
    # <td id="Tolda_column_4">Chavismo</td>
    # <td id="Adj_column_4">1</td>
    # <td id="Ilicitos_column_4">No</td>
    # <td id="Voceros_column_4" style="display: none;"> </td>
    # <td id="Candidatos_column_4" style="display: none;"><a href="http://sigecup.cne.gob.ve/index.php/general/political_representative_controller/show_political_representative/8" title="Ver datos de vocero">Elías  Jaua</a></td>
    
    
    # ======================= VIEW ========================#
    
    
    
    
    
      
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
  
  
  
end

