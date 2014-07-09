# encoding: utf-8
class InformesController < ApplicationController
  # GET /informes
  # GET /informes.json

  
  def agregar
    resumen = Resumen.find(params[:id])
    resumen.tema_id = params[:resumen][:tema_id]

    if resumen.save
      flash[:success] = "Resumen agregado" 
    else
      flash[:alert] = "Disculpe, el resumen no pudo ser agregado"
    end
    
    redirect_to :action => params[:accion]
      
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
    @titulo = "Asignar Tema"
    @resumenes_con_tema = Resumen.creados_hoy.sin_informe.con_tema#.order("vocero_id DESC")
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @tema = Tema.new
    
  end
  
  def paso2 #unir Resumenes
    @titulo = "Unir Resumenes"
    @resumenes = Resumen.creados_hoy.sin_informe.con_tema#.order("vocero_id DESC")
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)    
  end
  
  def paso3 #Ordenar entre temas
    @titulo = "Ordenar entre Temas"
    @resumenes = Resumen.creados_hoy.sin_informe.con_tema.order("orden ASC")
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    
    # Después de aqui los pasos o procesos son dependientes del informe
  end
  
  def paso4
    
    unless session[:compilando_informe_id]
      @informe = Informe.new
      @informe.save!
      inicializar_orden_temas(@informe.id)
      session[:compilando_informe_id] = @informe.id
    else
      @informe = Informe.find(session[:compilando_informe_id])
    end

    @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    @titulo = "Ordenar Temas entre Asunto"
    @resumenes = Resumen.creados_hoy.sin_informe.con_tema.order("orden ASC")#.order("vocero_id DESC")
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)    
  end
  
  def paso5
    # session[:paso5] = nil
    unless session[:compilando_informe_id]
      @informe = Informe.new
      @informe.save!
      session[:compilando_informe_id] = @informe.id
    else
      @informe = Informe.find(session[:compilando_informe_id])
    end
    
    # unless session[:paso5]
    #   inicializar_orden_asuntos(@informe.id)
    #   session[:paso5] = true
    # end
    
    @informes_temas = InformeTema.where(:informe_id => @informe.id).order(:orden)
    @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)
    
    if @informes_asuntos.count < 1
      inicializar_orden_asuntos(@informe.id)
      @informes_asuntos = InformeAsunto.where(:informe_id => @informe.id).order(:orden)
    end
    
    @titulo = "Ordenar Temas entre Asunto"
    @resumenes = Resumen.creados_hoy.sin_informe.con_tema#.order("vocero_id DESC")
    @resumenes_sin_tema = Resumen.creados_hoy.sin_informe.sin_tema#.order("vocero_id DESC")
    temas_id = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas_id).group(:id)
    @asuntos = @asuntos.joins(:informes_asuntos).where('informes_asuntos.informe_id' => @informe.id).order(:orden)
    
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
    informe_id = params[:informe_id]
    orden_temas = params[:orden_temas]
    orden_temas.each_pair do |tema_id,orden|
      informe_tema = InformeTema.find_or_create_by_tema_id_and_informe_id(tema_id, informe_id)
      informe_tema.orden = orden
      informe_tema.save
    end
    flash[:success] = "Temas Ordenados"
    redirect_to :action => "paso4"
    
  end  
  


  def inicializar_orden_asuntos(informe_id)      
    temas_hoy = Tema.joins(:resumenes).where('resumenes.created_at >= ? and resumenes.informe_id IS NULL', Date.today).uniq
    asuntos = Asunto.joins(:temas).where('temas.id' => temas_hoy).uniq
    
    
    asuntos.each_with_index do |asunto, orden_inicial|
      orden_inicial += 1
      informe_asunto = InformeAsunto.find_or_create_by_asunto_id_and_informe_id(asunto.id, informe_id)
      informe_asunto.orden = orden_inicial
      informe_asunto.save      
    end  
  end

  def ordenar_asuntos
    informe_id = params[:informe_id]
    orden_asuntos = params[:orden_asuntos]
    orden_asuntos.each_pair do |asunto_id,orden|
      informe_asunto = InformeAsunto.find_or_create_by_asunto_id_and_informe_id(asunto_id, informe_id)
      informe_asunto.orden = orden
      informe_asunto.save
    end
    flash[:success] = "Asuntos Ordenados"
    redirect_to :action => "paso5"
    
  end


  def paso6
    session[:compilando_informe_id] = nil
    @titulo = "Generar Informe"
    @informe = Informe.new
    @informe.autor = "Dirección de Seguimiento de la Información Electoral"
    @informe.tema = "AGENDA TEMÁTICA DE MEDIOS"
    @informe.titulo = "MONITOREO DE MEDIOS (de 10:00am a 04:00pm)"
    @resumenes = Resumen.creados_hoy.con_tema.sin_informe.order("orden ASC")
    temas = Tema.joins(:resumenes).where('resumenes.created_at >= ?', Date.today)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas).group(:id)
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

    if InformeMailer.enviar_informe(@informe).deliver
      flash[:success] = 'Correo Enviado Satisfactoriamente'
    else
      flash[:error] = 'El informe no pude ser enviado por correo'
    end
    redirect_to :action => 'index'
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
