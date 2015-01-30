class AparicionesController < ApplicationController
  # GET /apariciones
  # GET /apariciones.json
  before_filter :filtro_logueado
  
  require 'importer'
  
  def index
    @apariciones = Aparicion.all
    if params[:import]
      # Importación de Apariciones
      Importer.import_apariciones
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apariciones }
    end
  end

  # GET /apariciones/1
  # GET /apariciones/1.json
  def show
    canal_id, cuna_id, momento = params[:id].split(",")
    @aparicion = Aparicion.where(:cuna_id => cuna_id, :canal_id => canal_id, :momento => momento.to_datetime).first

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @aparicion }
    end
  end

  # GET /apariciones/new
  # GET /apariciones/new.json
  def new
    @aparicion = Aparicion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @aparicion }
    end
  end

  # GET /apariciones/1/edit
  def edit
    canal_id, cuna_id, momento = params[:id].split(",")
    @aparicion = Aparicion.where(:cuna_id => cuna_id, :canal_id => canal_id, :momento => momento.to_datetime).first
  end

  # POST /apariciones
  # POST /apariciones.json
  def create

    @aparicion = Aparicion.new(params[:aparicion])

    respond_to do |format|
      if @aparicion.save
        format.html { redirect_to @aparicion, notice: 'Aparicion was successfully created.' }
        format.json { render json: @aparicion, status: :created, location: @aparicion }
      else
        format.html { render action: "new" }
        format.json { render json: @aparicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apariciones/1
  # PUT /apariciones/1.json
  def update
    canal_id, cuna_id, momento = params[:id].split(",")
    @aparicion = Aparicion.where(:cuna_id => cuna_id, :canal_id => canal_id, :momento => momento.to_datetime).first

    respond_to do |format|
      if @aparicion.update_attributes(params[:aparicion])
        format.html { redirect_to @aparicion, notice: 'Aparicion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @aparicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apariciones/1
  # DELETE /apariciones/1.json
  def destroy
    canal_id, cuna_id, momento = params[:id].split(",")
    @aparicion = Aparicion.where(:cuna_id => cuna_id, :canal_id => canal_id, :momento => momento.to_datetime).first
    @aparicion.destroy

    respond_to do |format|
      format.html { redirect_to apariciones_url }
      format.json { head :no_content }
    end
  end
  
  
  
  
  
end
