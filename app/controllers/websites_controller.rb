# encoding: utf-8
class WebsitesController < ApplicationController
  # GET /websites
  # GET /websites.json
  before_filter :filtro_logueado
  def index
    @websites = Website.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @websites }
    end
  end

  def barrer
    if params[:id]
      @website = Website.find(params[:id])
      total = @website.importar_notas_website_2

      if total.is_a? Numeric and total > 0 
        flash[:success] = "Barrido exitoso de #{total} página(s)."
      else
        flash[:alert] = "No se cargaron nuevas páginas"
      end
      
    else
      @websites = Website.all
      total = ""
      @websites.each do |web|
        total += "#{web.descripcion}: #{web.importar_notas_website_2}"
      end
      flash[:success] = "Resultado: #{total}."
    end
            
    redirect_to :back
  end

  # GET /websites/1
  # GET /websites/1.json
  def show
    @website = Website.find(params[:id])
    @pagina = Pagina.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @website }
    end
  end

  # GET /websites/new
  # GET /websites/new.json
  def new
    @website = Website.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @website }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = Website.find(params[:id])
  end

  # POST /websites
  # POST /websites.json
  def create
    @website = Website.new(params[:website])

    respond_to do |format|
      if @website.save
        format.html { redirect_to @website, notice: 'Website creada correctamente.' }
        format.json { render json: @website, status: :created, location: @website }
      else
        format.html { render action: "new" }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /websites/1
  # PUT /websites/1.json
  def update
    @website = Website.find(params[:id])

    respond_to do |format|
      if @website.update_attributes(params[:website])
        format.html { redirect_to @website, notice: 'Website was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.json
  def destroy
    @website = Website.find(params[:id])
    @website.destroy

    respond_to do |format|
      format.html { redirect_to websites_url }
      format.json { head :no_content }
    end
  end
end
