# encoding: utf-8
class AlertasController < ApplicationController
  # GET /alertas
  # GET /alertas.json
  before_filter :filtro_logueado

  def descargas

    ids = params[:id]
    alertas = Alerta.where(:id => ids.split(","))
    file_name = Pdf.descargar_alertas_excel(alertas)
    send_file file_name, :type => "application/vnd.ms-excel", :filename => "reporte_alertas.xls", :stream => false

    File.delete(file_name)
  end
  
  def index
    @alertas = Alerta.order('fecha DESC')

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
    @tema = Tema.new
    @voceros = Vocero.all
    @vocero = Vocero.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alerta }
    end
  end

  # GET /alertas/1/edit
  def edit
    @alerta = Alerta.find(params[:id])
    @tipos_alertas = TipoAlerta.all
    @tema = Tema.new
    @voceros = Vocero.all
    @vocero = Vocero.new
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
        @tipos_alertas = TipoAlerta.all
        @tema = Tema.new
        @voceros = Vocero.all
        @vocero = Vocero.new
        flash[:alert] = ""
        @alerta.errors.full_messages.each do |msg|
          flash[:alert] += msg
        end
        
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
        format.html { redirect_to @alerta, notice: 'Alerta actualizada correctamente.' }
        format.json { head :no_content }
      else
        @tipos_alertas = TipoAlerta.all
        @tema = Tema.new
        @voceros = Vocero.all
        @vocero = Vocero.new
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
    flash[:alert] = "La alerta ha sido eliminada"
    respond_to do |format|
      format.html { redirect_to alertas_url }
      format.json { head :no_content }
    end
  end
end
