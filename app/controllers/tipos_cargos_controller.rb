class TiposCargosController < ApplicationController
  # GET /tipos_cargos
  # GET /tipos_cargos.json
  before_filter :filtro_logueado
  def index
    @tipos_cargos = TipoCargo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipos_cargos }
    end
  end

  # GET /tipos_cargos/1
  # GET /tipos_cargos/1.json
  def show
    @tipo_cargo = TipoCargo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_cargo }
    end
  end

  # GET /tipos_cargos/new
  # GET /tipos_cargos/new.json
  def new
    @tipo_cargo = TipoCargo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_cargo }
    end
  end

  # GET /tipos_cargos/1/edit
  def edit
    @tipo_cargo = TipoCargo.find(params[:id])
  end

  # POST /tipos_cargos
  # POST /tipos_cargos.json
  def create
    @tipo_cargo = TipoCargo.new(params[:tipo_cargo])

    respond_to do |format|
      if @tipo_cargo.save
        format.html { redirect_to @tipo_cargo, notice: 'Tipo cargo was successfully created.' }
        format.json { render json: @tipo_cargo, status: :created, location: @tipo_cargo }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipos_cargos/1
  # PUT /tipos_cargos/1.json
  def update
    @tipo_cargo = TipoCargo.find(params[:id])

    respond_to do |format|
      if @tipo_cargo.update_attributes(params[:tipo_cargo])
        format.html { redirect_to @tipo_cargo, notice: 'Tipo cargo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos_cargos/1
  # DELETE /tipos_cargos/1.json
  def destroy
    @tipo_cargo = TipoCargo.find(params[:id])
    @tipo_cargo.destroy

    respond_to do |format|
      format.html { redirect_to tipos_cargos_url }
      format.json { head :no_content }
    end
  end
end
