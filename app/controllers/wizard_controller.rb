class WizardController < ApplicationController
  
  def paso1
    @websites = Website.all
    
    #manejo de website activa mediante el uso de la sesion
    @website_activa = session[:website_activa] ? session[:website_activa] : @websites.first.nombre
    
    @accion = "paso1"
  end

  def paso1_guardar
    if params[:notas_validas_ids]
      params[:notas_validas_ids].each do |nota_id|
        nota = Nota.find nota_id
        nota.tipo_nota_id = 2
        nota.save
      end
    end
    #manejo de website activa mediante el uso de la sesion
    session[:website_activa] = params[:website_activa]
    
    redirect_to :action => "paso2"
  end
  
  def paso2
    
    @mensaje = params[:mensaje]
    @tipo_alerta = params[:tipo_alerta]
    
    # params[:mensaje] = nil
    unless params[:id]
      @resumen = Resumen.new
    else
      @resumen = Resumen.find(params[:id])
    end

    @vocero = Vocero.new
    @websites = Website.all
    
    # Manejo de website activa mediante el uso de la sesion
    @website_activa = session[:website_activa] ? session[:website_activa] : @websites.first.nombre
  end

  def paso2_guardar
    #manejo de website activa mediante el uso de la sesion
    session[:website_activa] = params[:website_activa]
    
    unless params[:id].blank?
      @resumen = Resumen.find(params[:id])
      @resumen.vocero_id = params[:resumen][:vocero_id]
      # saved = @resumen.update_attributes(params[:resumen])
      
    else
      @resumen = Resumen.new(params[:resumen])
    end
    
    if @resumen.save
      redirect_to :action => "paso3/#{@resumen.id}" #, notice: 'Resumen was successfully created.'
    else
      render :action => "paso2"
    end
  end
  
  def paso3
    #manejo de website activa mediante el uso de la sesion
    # @website_activa = session[:website_activa] ? session[:website_activa] : @websites.first.nombre
    # session[:website_activa] = @websites.first.nombre if session[:website_activa].nil?
    @resumen = Resumen.find(params[:id])
    @websites = Website.all
    @vocero = Vocero.new
  end
  
  def paso3_guardar
    @resumen = Resumen.find(params[:id])
    # @resumen.vocero_id = params[:resumen][:vocero_id]
    # @resumen.contenido = params[:resumen][:contenido]

    respond_to do |format|
      if @resumen.update_attributes(params[:resumen])
        format.html { redirect_to :action => "paso2", :params => {:mensaje => "Resumen generado Satisfactoriamente", :tipo_alerta => "alert-success"}  }
        format.json { head :no_content }
      else
        format.html { render :action => "paso3", :mensaje => "Resumen no pudo ser guardado", :tipo_alerta => "alert-error"}
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
      resumen.contenido = resumen.contenido.sub("| #{nota.titulo}",'') 
      session[:website_activa] = params[:website_name]
      if nota.save and resumen.save
        redirect_to :action => "paso3/#{resumen.id}"
      else
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
      resumen.contenido = "#{resumen.contenido} | #{nota.titulo}"
      session[:website_activa] = params[:website_name]
      if nota.save and resumen.save
        redirect_to :action => "paso3/#{resumen.id}"
      else
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