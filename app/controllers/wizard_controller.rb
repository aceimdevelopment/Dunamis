# encoding: utf-8
class WizardController < ApplicationController
  before_filter :filtro_logueado
  def cambiar_seleccion_websites
    session[:website_selecionada] = nil
    redirect_to :action => 'paso1'
  end

  def asignar_websites
    
    if websites_seleccionadas = params[:websites]
    
      @websites = Website.where(:id => websites_seleccionadas.values)
      error_ocupada = ""
    
      @websites.each do |w|
        error_ocupada += "#{w.usuario.nombre} ya tomó la página #{w.nombre}. //" if (not (w.usuario_id.eql? session[:usuario].id) and not (w.usuario_id.nil?))
      end
    
      unless error_ocupada.eql? ""
        flash[:alert] = error_ocupada
      else
        Website.all.each do |w|        
          if websites_seleccionadas.include? w.nombre
            w.usuario_id = session[:usuario].id
          else
            w.usuario_id = nil if w.usuario_id.eql? session[:usuario].id
          end
          w.save
        end
        flash[:success] = "Selección guardada"
      end
    else
      Website.all.each do |w|
        w.usuario_id = nil if w.usuario_id.eql? session[:usuario].id
        w.save
      end
    end
    
    session[:website_selecionada] = true
    
    # if params[:url]
    #   redirect_to params[:url]
    # else
      redirect_to :action => 'paso1'
    # end
  end

  def paso1
    # Website.limpiar_usuario session[:usuario].id if session[:website_selecionada].blank?
    @websites = Website.all
    #@websites.each{|web| web.importar_notas_website_2}
    @websites_disponibles = Website.all.delete_if {|w| (not (w.usuario_id.eql? session[:usuario].id) and not (w.usuario_id.nil?)) }
    @titulo = "Paso 1: Seleccionar Notas"
    #manejo de website activa mediante el uso de la sesion
    @total_notas = 0
  	@websites.each {|website| @total_notas += website.notas.creadas_hoy.count}    
    @website_activa = session[:website_activa] ? session[:website_activa] : @websites.first.nombre
    
    @accion = "paso1"
  end

  def paso1_guardar
    if params[:notas_validas_ids]
      params[:notas_validas_ids].each do |nota_id|
        nota = Nota.find nota_id
        nota.tipo_nota_id = 2
        flash[:success] = "Notas Guardadas" 
        nota.save
      end
    end
    #manejo de website activa mediante el uso de la sesion
    session[:website_activa] = params[:website_activa]
    redirect_to :action => "paso2"
  end
  
  def paso2
    @websites_disponibles = Website.all.delete_if {|w| (not (w.usuario_id.eql? session[:usuario].id) and not (w.usuario_id.nil?)) }
    @titulo = "Paso 2: Seleccionar Vocero"
    # params[:mensaje] = nil
    unless params[:id]
      @resumen = Resumen.new
    else
      @resumen = Resumen.find(params[:id])
    end
    if params[:vocero_id]
      @resumen.vocero_id = params[:vocero_id] 
      # ("holaslas?vocero_id=57?vocero_id=58".first
    end   
      
    # @voceros = Vocero.joins(:resumenes).where('resumenes.created_at >= ?', Date.today)
    @resumenes = Resumen.joins(:vocero).where("resumenes.created_at >= ?", Date.today).where("resumenes.informe_id IS ?", nil).order "voceros.nombre ASC, resumenes.created_at DESC"
    @vocero = Vocero.new
    @nota = Nota.new
    @websites = Website.all

    @total_notas = 0
  	@websites.each {|website| @total_notas += website.notas.creadas_hoy.validas.sin_resumen.count}
    flash[:notice] = "No hay notas pendientes por agregar a resumenes" if @total_notas.eql? 0

    # Manejo de website activa mediante el uso de la sesion
    @website_activa = session[:website_activa] ? session[:website_activa] : @websites.first.nombre
  end

  def paso2_guardar

    #manejo de website activa mediante el uso de la sesion
    session[:website_activa] = params[:website_activa]
    
    unless params[:id].blank?
      @resumen = Resumen.find(params[:id])
      @resumen.otro_vocero = params[:resumen][:otro_vocero] if params[:resumen][:otro_vocero]
      @resumen.vocero_id = params[:resumen][:vocero_id]
      # DEbo crear un vocero llamado otro_vocero con id fijo el cual sirva para identificar los resumenes con otros voceros
      
      # saved = @resumen.update_attributes(params[:resumen])
    else
      @resumen = Resumen.new(params[:resumen])
    end
    
    # Primero debo preguntar por vocero inusual y luego por el vocero_id
    # if params[:resumen][:otro_vocero]

    if @resumen.save
      flash[:success] = "Vocero Seleccionado" 
      redirect_to :action => "paso3/#{@resumen.id}" #, notice: 'Resumen was successfully created.'
    else
      flash[:alert] = "No se puedo agregar el Vocero"
      render :action => "paso2"
    end
  end
  
  def paso3
    @titulo = "Paso 3 : Unificar Notas"
    @url = params[:url] if params[:url]
    @websites_disponibles = Website.all.delete_if {|w| (not (w.usuario_id.eql? session[:usuario].id) and not (w.usuario_id.nil?)) }
    #manejo de website activa mediante el uso de la sesion
    # @website_activa = session[:website_activa] ? session[:website_activa] : @websites.first.nombre
    # session[:website_activa] = @websites.first.nombre if session[:website_activa].nil?
    @resumen = Resumen.find(params[:id])
    @resumen.vocero_id = params[:vocero_id] if params[:vocero_id]
    @nota = Nota.new    
    @websites = Website.all
    @total_notas = 0
  	@websites.each {|website| @total_notas += website.notas.creadas_hoy.validas.sin_resumen.count}  
    flash[:notice] = "No hay notas pendientes por agregar a resumenes" if @total_notas.eql? 0
    @vocero = Vocero.new
  end

  def invalidar
    nota = Nota.find params[:id]
    nota.tipo_nota_id = 1
    resultado = ""
    
    if nota.resumen
      resumen = nota.resumen
      resumen.contenido = resumen.contenido.sub("| #{nota.titulo}",'') 
      if resumen.save
        resultado = "Nota liberada del resumen."
      else 
        resultado = "No se pudo liberar la nota asociada al resumen."
      end
    end
    nota.resumen_id = nil
    
    if nota.save 
      
      flash[:notice] = resultado+"Nota descartada" 
    else
      flash[:alert] = resultado"La nota no pudo ser descartada"
    end
    redirect_to :action => "#{params[:action_name]}/#{params[:resumen_id]}"
  end
  
  def paso3_guardar
    @resumen = Resumen.find(params[:id])
    # @resumen.vocero_id = params[:resumen][:vocero_id]
    # @resumen.contenido = params[:resumen][:contenido]

    respond_to do |format|
      if @resumen.update_attributes(params[:resumen])
        flash[:success] = "#{Resumen.creados_hoy.sin_informe.count} Resumenes agregados"
        if params[:url]
          format.html { redirect_to params[:url]}
        else
          format.html { redirect_to :action => "paso2"}
        end
        format.json { head :no_content }
      else
        flash[:alert] = "Resumen no pudo ser guardado"
        format.html { render :action => "paso3"}
        format.json { render json: @resumen.errors, status: :unprocessable_entity }
      end
    end


    # if @resumen.save
    #   redirect_to :action => "paso2", :mensaje => "Resumen generado Satisfactoriamente", :tipo_alerta => "alert-success"
    # else
    #   render :action => "paso3", :mensaje => "Resumen no pudo ser guardado", :tipo_alerta => "alert-error"
    # end
  end
  
  def desagregar_nota
    nota = Nota.find params[:nota_id]
    resumen = Resumen.find params[:resumen_id]
    if (nota and resumen)
      nota.resumen_id = nil
      resumen.contenido = resumen.contenido.sub("#{nota.titulo}",'') unless resumen.contenido.blank?
      session[:website_activa] = params[:website_name]
      if nota.save and resumen.save
        flash[:notice] = " Nota desagregada del resumen actual" 
        redirect_to :action => "paso3/#{resumen.id}"
      else
        flash[:alert] = "No se puedo desagregar la nota"
        render :action => "paso3"
      end
      
      
    else
      render :action => "paso3"
    end
  end
  
  def agregar_nota
    nota = Nota.find params[:nota_id]
    resumen = Resumen.find params[:resumen_id]
    if (nota and resumen)
      nota.resumen_id =resumen.id
      if params[:nota]
        if resumen.contenido.blank?
            resumen.contenido = "#{nota.titulo}"
        else
            resumen.contenido += ". #{nota.titulo}"          
        end 
      end

      session[:website_activa] = params[:website_name]
      if nota.save and resumen.save
        flash[:success] = "#{resumen.notas.count} Notas Agregadas a este resumen" 
        redirect_to :action => "paso3/#{resumen.id}"
      else
        flash[:alert] = "No se puedo agregar la nota"
        render :action => "paso3"
      end
      
      
    else
      render :action => "paso3"
    end
  end
  
  def actualizar_website_activa 

    puts "------------------------------------------------------------------------------------------------"
    puts "parametro: <#{params[:id]}>"
    puts "------------------------------------------------------------------------------------------------"    
    session[:website_activa] = params[:id]

    
  end

end