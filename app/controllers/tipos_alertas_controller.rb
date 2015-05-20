class TiposAlertasController < ApplicationController
  # GET /tipos_alertas
  # GET /tipos_alertas.json
  def index
    @tipos_alertas = TipoAlerta.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipos_alertas }
    end
  end

  # GET /tipos_alertas/1
  # GET /tipos_alertas/1.json
  def show
    @tipo_alerta = TipoAlerta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_alerta }
    end
  end

  # GET /tipos_alertas/new
  # GET /tipos_alertas/new.json
  def new
    @tipo_alerta = TipoAlerta.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_alerta }
    end
  end

  # GET /tipos_alertas/1/edit
  def edit
    @tipo_alerta = TipoAlerta.find(params[:id])
  end

  # POST /tipos_alertas
  # POST /tipos_alertas.json
  def create
    @tipo_alerta = TipoAlerta.new(params[:tipo_alerta])

    respond_to do |format|
      if @tipo_alerta.save
        format.html { redirect_to @tipo_alerta, notice: 'Tipo alerta was successfully created.' }
        format.json { render json: @tipo_alerta, status: :created, location: @tipo_alerta }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_alerta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipos_alertas/1
  # PUT /tipos_alertas/1.json
  def update
    @tipo_alerta = TipoAlerta.find(params[:id])

    respond_to do |format|
      if @tipo_alerta.update_attributes(params[:tipo_alerta])
        format.html { redirect_to @tipo_alerta, notice: 'Tipo alerta was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_alerta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos_alertas/1
  # DELETE /tipos_alertas/1.json
  def destroy
    @tipo_alerta = TipoAlerta.find(params[:id])
    @tipo_alerta.destroy

    respond_to do |format|
      format.html { redirect_to tipos_alertas_url }
      format.json { head :no_content }
    end
  end
end
