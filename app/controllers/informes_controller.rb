# encoding: utf-8
class InformesController < ApplicationController
  # GET /informes
  # GET /informes.json
  def index
    @informes = Informe.all
    
    if params[:mensaje] 
      @mensaje = params[:mensaje]
      if params[:tipo].eql? "error"
        @tipo_alerta = 'alert-error'
      else
        @tipo_alerta = 'alert-success'
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @informes }
    end
  end

  def enviar_por_correo
    @informe = Informe.find(params[:id])
    mensaje = 'No enviado'
    tipo = 'error'
    if InformeMailer.enviar_informe(@informe).deliver
      mensaje = 'Enviado'
      tipo = 'correcto'
    end
    redirect_to :action => 'index', :mensaje => mensaje, :tipo => tipo
  end

  # GET /informes/1
  # GET /informes/1.json
  def show
    @informe = Informe.find(params[:id])
    @resumenes = Resumen.where(:informe_id => @informe.id)
    temas = Tema.joins(:resumenes).where('resumenes.informe_id >= ?', @informe.id)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas).group(:id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @informe }
    end
  end

  # GET /informes/new
  # GET /informes/new.json
  def new

    require "Importer"
    @encabezado = " Dirección de Seguimiento de la Información Electoral \n AGENDA TEMÁTICA DE MEDIOS"
    @encabezado += " #{Date.today.strftime('%d de %B de %Y')} "
    @encabezado += "MONITOREO DE MEDIOS (de 10:00am a 05:00pm)"

    # Borra Todas las notas antiguas e inservibles
    # SELETE FROM `notas` WHERE (resumen_id IS NULL AND created_at <= 'Hoy')
    Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])
    
    @resumenes = Resumen.creados_hoy.order("vocero_id DESC")
    temas = Tema.joins(:resumenes).where('resumenes.created_at >= ?', Date.today)
    # @websites = Website.all
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas).group(:id)
    
    @informe = Informe.new
    if @resumenes
      @resumenes.each do |resumen|
        resumen.informe_id = @informe.id
        resumen.save
      end
    end
    # @informe.resumen = encabezado
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @informe }
    end
  end

  # GET /informes/1/edit
  def edit
    @informe = Informe.find(params[:id])
    @resumenes = Resumen.where(:informe_id => @informe.id)
    temas = Tema.joins(:resumenes).where('resumenes.informe_id >= ?', @informe.id)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas).group(:id)    
  end

  # POST /informes
  # POST /informes.json
  def create
    @resumenes = Resumen.creados_hoy.order("vocero_id DESC")
    @informe = Informe.new(params[:informe])

    respond_to do |format|
      if @informe.save
        @resumenes.each do |resumen|
          resumen.informe_id = @informe.id
          resumen.save
        end
        format.html { redirect_to @informe, notice: 'Informe was successfully created.' }
        format.json { render json: @informe, status: :created, location: @informe }
      else
        format.html { render action: "new" }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /informes/1
  # PUT /informes/1.json
  def update
    @informe = Informe.find(params[:id])

    respond_to do |format|
      if @informe.update_attributes(params[:informe])
        format.html { redirect_to @informe, notice: 'Informe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /informes/1
  # DELETE /informes/1.json
  def destroy
    @informe = Informe.find(params[:id])
    @informe.destroy

    respond_to do |format|
      format.html { redirect_to informes_url }
      format.json { head :no_content }
    end
  end
end
