class CunasController < ApplicationController
  # GET /cunas
  # GET /cunas.json
  before_filter :filtro_logueado  
  require 'importer'
  def index
    @cunas = Cuna.all
    
    # Importación de Apariciones
    Importer.import_cunas if params[:import]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cunas }
    end
  end

  # GET /cunas/1
  # GET /cunas/1.json
  def show
    @cuna = Cuna.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cuna }
    end
  end

  # GET /cunas/new
  # GET /cunas/new.json
  def new
    @cuna = Cuna.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cuna }
    end
  end

  # GET /cunas/1/edit
  def edit
    @cuna = Cuna.find(params[:id])
  end

  # POST /cunas
  # POST /cunas.json
  def create
    @cuna = Cuna.new(params[:cuna])

    respond_to do |format|
      if @cuna.save
        format.html { redirect_to @cuna, notice: 'Cuna was successfully created.' }
        format.json { render json: @cuna, status: :created, location: @cuna }
      else
        format.html { render action: "new" }
        format.json { render json: @cuna.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cunas/1
  # PUT /cunas/1.json
  def update
    @cuna = Cuna.find(params[:id])

    respond_to do |format|
      if @cuna.update_attributes(params[:cuna])
        format.html { redirect_to @cuna, notice: 'Cuna was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cuna.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cunas/1
  # DELETE /cunas/1.json
  def destroy
    @cuna = Cuna.find(params[:id])
    @cuna.destroy

    respond_to do |format|
      format.html { redirect_to cunas_url }
      format.json { head :no_content }
    end
  end
end
