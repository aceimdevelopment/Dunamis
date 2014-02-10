# encoding: utf-8
class InformesController < ApplicationController
  # GET /informes
  # GET /informes.json
  def paso1
    # @informe = Informe.new
    @resumenes_con_tema = Resumen.creados_hoy.con_tema.order("vocero_id DESC")
    @resumenes_sin_tema = Resumen.creados_hoy.sin_tema.order("vocero_id DESC")
    @tema = Tema.new
    temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ?', Date.today)
    # @websites = Website.all
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @informe }
    # end    
    
  end
  
  def agregar
    resumen = Resumen.find(params[:id])
    resumen.tema_id = params[:resumen][:tema_id]
    @mensaje = resumen.save ? "Agregado" : "No Agregado"
    
    redirect_to :action => "paso1"
      
  end
  
  def desagregar_resumen
    resumen = Resumen.find(params[:id])
    resumen.tema_id = nil
    resumen.save 
    redirect_to :action => "paso1"
  end
  
  def paso2
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

    # Borra Todas las notas antiguas e inservibles
    # SELETE FROM `notas` WHERE (resumen_id IS NULL AND created_at <= 'Hoy')
    # Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])
    
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
    # @resumenes = Resumen.creados_hoy.order("vocero_id DESC")
    resumenes_ids = params[:resumenes_ids]
    
    puts "RESUMEN: #{resumenes_ids}"
    @informe = Informe.new(params[:informe])

    respond_to do |format|
      if @informe.save
        resumenes_ids.each do |id|
          resumen = Resumen.find id
          if resumen
            resumen.informe_id = @informe.id
            resumen.save
          end
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

    resumenes_ids = params[:resumenes_ids].split if params[:resumenes_ids]
    @informe = Informe.find(params[:id])      
    respond_to do |format|
      if @informe.update_attributes(params[:informe])
        if resumenes_ids
          resumenes_ids.each do |id|
            resumen = Resumen.where(:id => id).first
            if resumen
              resumen.informe_id = @informe.id
              resumen.save
            end
          end
        end
        format.html { redirect_to @informe, notice: 'Informe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # def fusionar_resumenes # (fusionar_resumenes_ids, informe_id)
  #   primer_id = fusionar_resumenes_ids.first
  #   
  #   r1 = Resumen.find(primer_id)
  #   fusionar_resumenes_ids.shift
  #   resumenes_fusionar_ids.each do |id| 
  #     r2 = Resumen.find id
  #     
  #     r1.titulo += r2.titulo
  #     r1.contenido += r2.contenido
  #     
  #     r2.notas.each do |nota| 
  #       nota.resumen_id = r1.id
  #       unless nota.save
  #         @mensaje = "Error al Intentar Fusionar" 
  #         @tipo_alerta = 'alert-error'
  #         break
  #       end
  #     end
  #   end # each_resumenes_fusionar_ids
  #   
  #   if r1.save
  #     @mensaje = "Fusión Completada Satisfactoriamente" 
  #     @tipo_alerta = 'alert-success'
  #   else
  #     @mensaje = "Error al Intentar Fusionar" 
  #     @tipo_alerta = 'alert-error'
  #   end
  # end

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
