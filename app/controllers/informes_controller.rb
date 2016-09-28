# encoding: utf-8
class InformesController < ApplicationController
  # GET /informes
  # GET /informes.json
  before_filter :filtro_logueado
  
  def agregar
    resumen = Resumen.find(params[:id])
    resumen.tema_id = params[:resumen][:tema_id]
    resumen.informe_id = params[:informe_id] if params[:informe_id]

    if resumen.save
      flash[:success] = "Resumen agregado" 
    else
      flash[:alert] = "Disculpe, el resumen no pudo ser agregado"
    end
    url = params[:accion]
    url +=  "/#{params[:informe_id]}" if params[:informe_id]
    redirect_to :action => url
    
  end

  def agregar_vocero
    @resumenes_vocero = Resumen.creados_hoy.sin_informe.where(vocero_id: params[:id])
    resultado = ""
    total_exitos = 0
    total_errores = 0
    @resumenes_vocero.each do |resumen|
      resumen.tema_id = params[:resumen][:tema_id]
      resumen.informe_id = params[:informe_id] if params[:informe_id]

      if resumen.save
        total_exitos += 1
      else
        total_errores +=1
      end

    end

    
    flash[:success] = "#{total_exitos} resumen(es) agregado(s)." if total_exitos > 0
    flash[:alert] = "#{total_exitos} Disculpe, #{total_errores} resumen(es) no fue posible agregarlo(s)." if total_errores > 0
      
    url = params[:accion]
    url +=  "/#{params[:informe_id]}" if params[:informe_id]
    redirect_to :action => url

  end

  def desagregar_vocero

    @resumenes_vocero = Resumen.creados_hoy.sin_informe.where(vocero_id: params[:id])
    resultado = ""
    total_exitos = 0
    total_errores = 0
    @resumenes_vocero.each do |resumen|
      resumen.tema_id = nil
      resumen.informe_id = nil

      if resumen.save
        total_exitos += 1
      else
        total_errores +=1
      end

    end
    
    flash[:success] = "#{total_exitos} resumen(es) desagregado(s)." if total_exitos > 0
    flash[:alert] = "#{total_exitos} Disculpe, #{total_errores} resumen(es) no fue posible desagregarlo(s)." if total_errores > 0
      
    url = params[:accion]
    url +=  "/#{params[:informe_id]}" if params[:informe_id]
    redirect_to :action => 'paso1'
    
  end

  
  def desagregar_resumen
    resumen = Resumen.find(params[:id])
    resumen.tema_id = nil

    if resumen.save
      flash[:notice] = "Resumen desagregado" 
    else
      flash[:alert] = "Disculpe, el resumen no pudo ser desagregado"
    end
    redirect_to :action => "paso1"
  end


  def paso1 #Agrupar por Tema

    if params[:id]
      @informe = Informe.where(:id => params[:id]).limit(1).first
      @resumenes_con_tema = @informe.resumenes
      temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    else
      @resumenes_con_tema = Resumen.creados_hoy.sin_informe.con_tema.order("vocero_id DESC")
      temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)

    end
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @titulo = "Asignar Tema"
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema.order("vocero_id DESC")
    @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL and tema_id IS NULL', Date.today).order('nombre ASC').group(:vocero_id)
    # @voceros_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema.group(:vocero_id).order("vocero_id ASC")
    @tema = Tema.new
  end
  
  def paso2 #unir Resumenes

    @controlador = 'resumenes'
    @proceso = 'unir'
    
    if params[:id]
      @informe = Informe.where(:id => params[:id]).limit(1).first
      @resumenes = @informe.resumenes
      temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    else
      @resumenes = Resumen.creados_hoy.sin_informe.con_tema.order("vocero_id DESC")
      temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)

    end    
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)    
    @titulo = "Unir Resumenes"
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema.order("vocero_id DESC")
    @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL and tema_id IS NULL', Date.today).order('nombre ASC').group(:vocero_id)
    @tema = Tema.new
  end

  def paso2b #unir Resumenes
		@controlador = 'resumenes'
		@proceso = 'fusionar'

    if params[:id]
      @informe = Informe.where(:id => params[:id]).limit(1).first
      @resumenes = @informe.resumenes
      temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    else
      @resumenes = Resumen.creados_hoy.sin_informe.con_tema.order("vocero_id DESC")
      temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    end
    @titulo = "Fusionar Resumenes"
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema.order("vocero_id DESC")
    @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL and tema_id IS NULL', Date.today).order('nombre ASC').group(:vocero_id)
    @tema = Tema.new
  end


  
  def paso3 #Ordenar entre temas
	  @controlador = 'resumenes'
		@proceso = 'ordenar'
    @remote = true
    if params[:id]
      @informe = Informe.where(:id => params[:id]).limit(1).first
      @resumenes = @informe.resumenes
      temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    else
      @resumenes = Resumen.creados_hoy.sin_informe.con_tema#.order("vocero_id DESC")
      temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    end
    
    @titulo = "Ordenar resúmenes dentro de los Temas"
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema.order("vocero_id DESC")
    @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL and tema_id IS NULL', Date.today).order('nombre ASC').group(:vocero_id)
    @tema = Tema.new
  end
  
  def paso3_guardar
    @informe = Informe.new
    @informe.save!
    inicializar_orden_temas(@informe.id)
    @resumenes = Resumen.creados_hoy.sin_informe.con_tema
    @resumenes.each{|resumen| resumen.informe_id = @informe.id; resumen.save}
    redirect_to :action => "paso4/#{@informe.id}"
  end
  
  # Después de aqui los pasos o procesos son dependientes del informe

  def paso4

		@controlador = 'informes'
		@proceso = 'ordenar_temas'
		
    @informe = Informe.where(:id => params[:id]).limit(1).first
    @resumenes = @informe.resumenes
    temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
        
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    @titulo = "Ordenar Temas entre Asunto"
    @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL and tema_id IS NULL', Date.today).order('nombre ASC').group(:vocero_id)
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema
    @tema = Tema.new
  end


  def paso5
		@controlador = 'informes'
		@proceso = 'ordenar_asuntos'

    @informe = Informe.where(:id => params[:id]).limit(1).first

    @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)
    
    if @informes_asuntos.count < 1
      inicializar_orden_asuntos(@informe.id)
      @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)
    end
    
    @titulo = "Ordenar Asuntos"
    @resumenes = @informe.resumenes
    @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL and tema_id IS NULL', Date.today).order('nombre ASC').group(:vocero_id)    
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @asuntos = @asuntos.joins(:informes_asuntos).where('informes_asuntos.informe_id' => @informe.id).order(:orden)
    @tema = Tema.new
  end


  def paso6

    # SI HAY INFORME HAY QUE CARGAR LOS RESUMENES Y CORREGIR ORDEN DE ASUNTO Y TEMA. como en el paso 5
    @titulo = "Completar Informe"
    @informe = Informe.where(:id => params[:id]).limit(1).first
    @informe.autor = "Dirección de Seguimiento de la Información Electoral"
    @informe.tema = "AGENDA TEMÁTICA DE MEDIOS"
    @informe.titulo = "MONITOREO DE MEDIOS (de 10:00am a 04:00pm)"

    @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)
    
    if @informes_asuntos.count < 1
      inicializar_orden_asuntos(@informe.id)
      @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)
    end
    
    @resumenes = @informe.resumenes.order(:orden)
    @resumenes = Resumen.creados_hoy.sin_informe.con_tema if @resumenes.count < 1#.order("vocero_id DESC")
    @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL and tema_id IS NULL', Date.today).order('nombre ASC').group(:vocero_id)
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today) if temas_id.count < 1
    
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @asuntos = @asuntos.joins(:informes_asuntos).where('informes_asuntos.informe_id' => @informe.id).order(:orden)
    @tema = Tema.new
  end


  def inicializar_orden_temas(informe_id)
    temas_hoy = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    asuntos = Asunto.joins(:temas).where('temas.id' => temas_hoy)
    asuntos.each do |asunto|
      temas = temas_hoy.where(:asunto_id => asunto.id).group(:id)
      temas.each_with_index do |tema, orden_inicial|
        orden_inicial += 1
        informe_tema = InformeTema.find_or_create_by_tema_id_and_informe_id(tema.id, informe_id)
        informe_tema.orden = orden_inicial
        informe_tema.save
      end  
    end  
  end
  
  def ordenar_temas
    # informe_id = session[:compilando_informe_id]
    informe_id = params[:id]
    orden_temas = params[:orden_temas]
    orden_temas.each_pair do |tema_id,orden|
      informe_tema = InformeTema.find_or_create_by_tema_id_and_informe_id(tema_id, informe_id)
      informe_tema.orden = orden
      informe_tema.save
    end
    flash[:success] = "Temas Ordenados"
    redirect_to :action => "paso4/#{params[:id]}"
    
  end  
  


  def inicializar_orden_asuntos(informe_id)
    # temas_hoy = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today).uniq
    temas_hoy = Tema.joins(:resumenes).where('resumenes.informe_id = ?', informe_id).uniq
    # temas_hoy = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today).uniq    
    asuntos = Asunto.joins(:temas).where('temas.id' => temas_hoy).uniq
    
    
    asuntos.each_with_index do |asunto, orden_inicial|
      orden_inicial += 1
      informe_asunto = InformeAsunto.find_or_create_by_asunto_id_and_informe_id(asunto.id, informe_id)
      informe_asunto.orden = orden_inicial
      informe_asunto.save      
    end  
  end

  def ordenar_asuntos
    informe_id = params[:id]
    orden_asuntos = params[:orden_asuntos]
    orden_asuntos.each_pair do |asunto_id,orden|
      informe_asunto = InformeAsunto.find_or_create_by_asunto_id_and_informe_id(asunto_id, informe_id)
      informe_asunto.orden = orden
      informe_asunto.save
    end
    flash[:success] = "Asuntos Ordenados"
    redirect_to :action => "paso5/#{params[:id]}"
    
  end



  
  def index
    @informes = Informe.order('created_at DESC')
    
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
    begin
      InformeMailer.enviar_informe(params[:id]).deliver
      flash[:success] = 'Correo Enviado Satisfactoriamente'
    rescue Exception => ex
      puts "Error al intenter enviar: #{ex}"
      flash[:success] = "Error al intenter enviar: #{ex}"
    end
    redirect_to :action => 'index'
  end

  # GET /informes/1
  # GET /informes/1.json
  def show
    @informe = Informe.where(:id => params[:id]).limit(1).first
    @resumenes = @informe.resumenes.order(:orden)

    temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @asuntos = @asuntos.joins(:informes_asuntos).where('informes_asuntos.informe_id' => @informe.id).order(:orden)
    @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)    

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
    @informe.save
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
    @titulo = "Editar Informe"
    @informe = Informe.where(:id => params[:id]).limit(1).first
    @resumenes = Resumen.where(:informe_id => @informe.id).order(:orden)
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.informe_id = ?', @informe.id)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @asuntos = @asuntos.joins(:informes_asuntos).where('informes_asuntos.informe_id' => @informe.id).order(:orden)

    @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)
    # 
    # @titulo = "Completar Informe"
    # @informe = Informe.where(:id => params[:id]).limit(1).first
    # @informe.autor = "Dirección de Seguimiento de la Información Electoral"
    # @informe.tema = "AGENDA TEMÁTICA DE MEDIOS"
    # @informe.titulo = "MONITOREO DE MEDIOS (de 10:00am a 04:00pm)"
    # 
    # @resumenes = Resumen.creados_hoy.sin_informe.con_tema#.order("vocero_id DESC")
    # @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    # temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    # @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    # @asuntos = @asuntos.joins(:informes_asuntos).where('informes_asuntos.informe_id' => @informe.id).order(:orden)
    # 
    # @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    # @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)    
    # 
    
    
    
  end

  # POST /informes
  # POST /informes.json
  def create
    # @resumenes = Resumen.creados_hoy.order("vocero_id DESC")
    resumenes_ids = params[:resumenes_ids]
    
    # puts "RESUMEN: #{resumenes_ids}"
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
        Website.limpiar_todos_usuarios
        session[:website_selecionada] = nil
        flash[:success] = 'Informe creado Satisfactoriamente.'
        format.html { redirect_to @informe }
        format.json { render json: @informe, status: :created, location: @informe }
      else
        format.html { render action: "paso5" }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /informes/1
  # PUT /informes/1.json
  def update
    resumenes_ids = params[:resumenes_ids] if params[:resumenes_ids]
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
        # Website.all.each{|w| w.usuario_id = nil; w.save}
        # session[:website_selecionada] = nil
        flash[:success] = 'Informe Actualizado.'
        format.html { redirect_to @informe }
        format.json { }
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
    # @informe.resumenes.each { |resumen| resumen.destroy}
    # 
    # @informe.informes_temas.each{|it| it.destroy}
    # @informe.informes_asuntos.each{|ia| ia.destroy}
    
    flash[:success] = 'Informe completamente eliminado del sistema.' if @informe.destroy
    
    respond_to do |format|
      format.html { redirect_to informes_url }
      format.json { head :no_content }
    end
  end
  
  # def unir_resumenes # (unir_resumenes_ids, informe_id)
  #   primer_id = unir_resumenes_ids.first
  #   
  #   r1 = Resumen.find(primer_id)
  #   unir_resumenes_ids.shift
  #   resumenes_unir_ids.each do |id| 
  #     r2 = Resumen.find id
  #     
  #     r1.titulo += r2.titulo
  #     r1.contenido += r2.contenido
  #     
  #     r2.notas.each do |nota| 
  #       nota.resumen_id = r1.id
  #       unless nota.save
  #         @mensaje = "Error al Intentar unir" 
  #         @tipo_alerta = 'alert-error'
  #         break
  #       end
  #     end
  #   end # each_resumenes_unir_ids
  #   
  #   if r1.save
  #     @mensaje = "Fusión Completada Satisfactoriamente" 
  #     @tipo_alerta = 'alert-success'
  #   else
  #     @mensaje = "Error al Intentar unir" 
  #     @tipo_alerta = 'alert-error'
  #   end
  # end  
  
end
