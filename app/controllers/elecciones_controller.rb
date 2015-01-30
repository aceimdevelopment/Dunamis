class EleccionesController < ApplicationController
  # GET /elecciones
  # GET /elecciones.json
  before_filter :filtro_logueado
  def index
    @elecciones = Eleccion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @elecciones }
    end
  end

  # GET /elecciones/1
  # GET /elecciones/1.json
  def show
    @eleccion = Eleccion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eleccion }
    end
  end

  # GET /elecciones/new
  # GET /elecciones/new.json
  def new
    @eleccion = Eleccion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eleccion }
    end
  end

  # GET /elecciones/1/edit
  def edit
    @eleccion = Eleccion.find(params[:id])
  end

  # POST /elecciones
  # POST /elecciones.json
  def create
    @eleccion = Eleccion.new(params[:eleccion])

    respond_to do |format|
      if @eleccion.save
        format.html { redirect_to @eleccion, notice: 'Eleccion was successfully created.' }
        format.json { render json: @eleccion, status: :created, location: @eleccion }
      else
        format.html { render action: "new" }
        format.json { render json: @eleccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /elecciones/1
  # PUT /elecciones/1.json
  def update
    @eleccion = Eleccion.find(params[:id])

    respond_to do |format|
      if @eleccion.update_attributes(params[:eleccion])
        format.html { redirect_to @eleccion, notice: 'Eleccion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eleccion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elecciones/1
  # DELETE /elecciones/1.json
  def destroy
    @eleccion = Eleccion.find(params[:id])
    @eleccion.destroy

    respond_to do |format|
      format.html { redirect_to elecciones_url }
      format.json { head :no_content }
    end
  end
end
