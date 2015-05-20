class AlertasController < ApplicationController
  # GET /alertas
  # GET /alertas.json
  def index
    @alertas = Alerta.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alertas }
    end
  end

  # GET /alertas/1
  # GET /alertas/1.json
  def show
    @alerta = Alerta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alerta }
    end
  end

  # GET /alertas/new
  # GET /alertas/new.json
  def new
    @alerta = Alerta.new
    
    @tipos_alertas = TipoAlerta.all
    
    @voceros = Vocero.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alerta }
    end
  end

  # GET /alertas/1/edit
  def edit
    @alerta = Alerta.find(params[:id])
  end

  # POST /alertas
  # POST /alertas.json
  def create
    @alerta = Alerta.new(params[:alerta])

    respond_to do |format|
      if @alerta.save
        format.html { redirect_to @alerta, notice: 'Alerta registrada.' }
        format.json { render json: @alerta, status: :created, location: @alerta }
      else
        format.html { render action: "new" }
        format.json { render json: @alerta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /alertas/1
  # PUT /alertas/1.json
  def update
    @alerta = Alerta.find(params[:id])

    respond_to do |format|
      if @alerta.update_attributes(params[:alerta])
        format.html { redirect_to @alerta, notice: 'Alerta was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alerta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alertas/1
  # DELETE /alertas/1.json
  def destroy
    @alerta = Alerta.find(params[:id])
    @alerta.destroy

    respond_to do |format|
      format.html { redirect_to alertas_url }
      format.json { head :no_content }
    end
  end
end
