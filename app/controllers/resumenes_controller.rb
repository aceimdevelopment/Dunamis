# encoding: utf-8
class ResumenesController < ApplicationController
  # GET /resumenes
  # GET /resumenes.json
  before_filter :filtro_logueado  
  def index
    @resumenes = Resumen.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resumenes }
    end
  end

  # GET /resumenes/1
  # GET /resumenes/1.json
  def show
    @resumen = Resumen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resumen }
    end
  end

  # GET /resumenes/new
  # GET /resumenes/new.json
  def new
    # @resumen = params[:id].blank? ? Resumen.new : Resumen.find(params[:id])
    
    if params[:id].blank?
      @resumen = Resumen.new
      @resumen.save :validate => false
    else
      @resumen = Resumen.find(params[:id])
    end
    @resumenes_hoy = Resumen.where(:updated_at => Date.today)
    Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])
    @websites = Website.all
    @websites.each { |website| website.importar_notas_desactualizadas}
  end

  # GET /resumenes/1/edit
  def edit
    @resumen = Resumen.find(params[:id])
    @websites = Website.all
    @vocero = Vocero.new
    @tema = Tema.new
    @websites.each { |website| website.importar_notas_desactualizadas}

  end

  # POST /resumenes
  # POST /resumenes.json
  def create

    @resumen = Resumen.new(params[:resumen])
    # @resumen.save! :validate => false
    respond_to do |format|
      if @resumen.save
        format.html { redirect_to @resumen, notice: 'Resumen was successfully created.' }
        format.json { render json: @resumen, status: :created, location: @resumen }
      else
        format.html { render action: "new" }
        format.json { render json: @resumen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resumenes/1
  # PUT /resumenes/1.json
  def update
    @resumen = Resumen.find(params[:id])
    # @resumen.contenido = params[:contenido] if params[:contenido]
    if params[:nota_id]
      nota = Nota.find(params[:nota_id])
      if params[:borrar_nota_en_contenido]
        @resumen.contenido = @resumen.contenido.sub("| #{nota.titulo}",'') 
      else
        @resumen.contenido = "#{@resumen.contenido} | #{nota.titulo}"
      end
      
    end
    
    respond_to do |format|
      if @resumen.update_attributes(params[:resumen])
        format.html { redirect_to @resumen, notice: 'Resumen was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resumen.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def paso1
    @accion = "paso1_guardar"
    @resumenes_hoy = Resumen.where("created_at >= ?", Date.today)
    # @filtro = params[:filtro] if params[:filtro]
    if params[:mensaje] 
      @mensaje = params[:mensaje]
      if params[:tipo].eql? "error"
        @tipo_alerta = 'alert-error'
      else
        @tipo_alerta = 'alert-success'
      end
    end
    # @resumen = params[:id].blank? ? Resumen.new : Resumen.find(params[:id])
    if params[:id].blank?
      @resumen = Resumen.new
    else
      @resumen = Resumen.find(params[:id])
    end
    
    # Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])
    @websites = Website.all
    @vocero = Vocero.new
    @tema = Tema.new
    # # @websites.each { |website| website.importar_notas_desactualizadas}
    # render :paso1 do |page|
    #      page.replace_html "cargando", :partial => 'barra'
    # end
  end
  
  def paso1_guardar
    unless params[:id].blank?
      @resumen = Resumen.find(params[:id])
      @resumen.vocero_id = params[:resumen][:vocero_id]
      @resumen.tema_id = params[:resumen][:tema_id]
      # saved = @resumen.update_attributes(params[:resumen])
      
    else
      @resumen = Resumen.new(params[:resumen])
    end

    if @resumen.save
      redirect_to :action => "paso2/#{@resumen.id}" #, notice: 'Resumen was successfully created.'
    else
      render :action => "paso1"
    end
  end
  
  def paso2
    @accion = "update"
    @resumen = Resumen.find(params[:id])
    @websites = Website.all
    @vocero = Vocero.new
    @tema = Tema.new    
    # @filtro = params[:filtro] if params[:filtro]  
  end
  
  def separar
    resumen = Resumen.find params[:id]
    if resumen
      resumen.resumen_id = nil
      resumen.informe_id = params[:informe_id] if params[:informe_id]
      if resumen.save
        flash[:success] = "Separación completada con éxito" 
      else
        flash[:alert] = "Error al intentar separar los resumenes" 
      end
    end

    if params[:informe_id]
      redirect_to :controller => 'informes', :action => "paso2/#{params[:informe_id]}"
    else
      redirect_to :controller => 'informes', :action => "paso2"
    end

  end
  
  def unir
    # informe = Informe.find params[:informe_id] 
    if unir_resumenes_ids = params[:unir_resumenes_ids]
      flash[:alert] = "Debe Seleccionar al menos un par de resumenes" if unir_resumenes_ids.count.eql? 1
      primer_id = unir_resumenes_ids.first
      r1 = Resumen.find(primer_id)
      unir_resumenes_ids.shift
      unir_resumenes_ids.each do |id|
        r2 = Resumen.find id
        r2.informe_id = nil
        r2.resumen_id = r1.id
        if r2.save 
          flash[:success] = "Unión Completada Satisfactoriamente" 
        else
          flash[:alert] = "Error al Intentar unir" 
        end
      end
    else
      flash[:alert] = "Debe Seleccionar al menos un par de resumenes" 
    end
    
    if params[:id]
      redirect_to :controller => 'informes', :action => "paso2/#{params[:id]}"
    else
      redirect_to :controller => 'informes', :action => "paso2"
    end
    
  end  

  def paso2b
    @accion = "update"
    @resumen = Resumen.find(params[:id])
    @websites = Website.all
    @vocero = Vocero.new
    @tema = Tema.new    
  end
  

  def fusionar
    # Esta función es irreversible. Ingluir mensaje de alerta y confirmación en 
    if fusionar_resumenes_ids = params[:fusionar_resumenes_ids]
      flash[:alert] = "Debe Seleccionar al menos un par de resumenes" if fusionar_resumenes_ids.count.eql? 1
      primer_id = fusionar_resumenes_ids.first
      r1 = Resumen.find(primer_id)
      fusionar_resumenes_ids.shift
      fusionar_resumenes_ids.each do |id|
        r2 = Resumen.find id
        r2.notas.each do |nota|
          nota.resumen_id = r1.id
          nota.save
        end
        r1.titulo += r2.titulo if r1.titulo
        r1.contenido += " #{r2.contenido}" if r1.contenido
        r2.destroy
        if r1.save 
          flash[:success] = "Fusión Completada Satisfactoriamente" 
        else
          flash[:alert] = "Error al Intentar Fusión" 
        end
      end
    else
      flash[:alert] = "Debe Seleccionar al menos un par de resumenes" 
    end
    
    if params[:id]
      redirect_to :controller => 'informes', :action => "paso2b/#{params[:id]}"
    else
      redirect_to :controller => 'informes', :action => "paso2b"
    end
    
  end
  
  def ordenar
    orden_resumen = params[:orden_resumenes]
    orden_resumen.each_pair do |k,v|
      resumen = Resumen.find k
      resumen.orden = v
      unless resumen.save
        @mensaje = "No se pudo ordenar el tema"
      else
        @mensaje = "Notas ordenadas correctamente"
      end
    end

    # respond_to do |format|
    #   format.html {redirect_to :back}
    #   format.js
    # end
    # if params[:id]
    #   redirect_to :controller => 'informes', :action => "paso3/#{params[:id]}"
    # else
    #   redirect_to :controller => 'informes', :action => "paso3"
    # end
    
  end
  
  # DELETE /resumenes/1
  # DELETE /resumenes/1.json
  def destroy
    @resumen = Resumen.find(params[:id])
    @resumen.notas.each do |nota| 
      nota.tipo_nota_id = 2
      nota.resumen_id = nil      
      nota.save
    end
    
    @resumen.destroy
    
    respond_to do |format|
      url = params[:url] ? params[:url] : "/wizard/paso2"
      format.html { redirect_to url }
      format.json { head :no_content }
    end
  end
end
