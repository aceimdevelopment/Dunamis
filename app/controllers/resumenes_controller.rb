# encoding: utf-8
class ResumenesController < ApplicationController
  # GET /resumenes
  # GET /resumenes.json
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
      if resumen.save
        flash[:info] = "Separación completada" 
      else
        flash[:alert] = "Error al intentar separar los resumenes" 
      end
    end
    redirect_to :controller => 'informes', :action => "paso2"
  end
  
  def unir
    # informe = Informe.find params[:informe_id] 
    if unir_resumenes_ids = params[:unir_resumenes_ids]
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
    end
    redirect_to :controller => 'informes', :action => "paso2"
  end  
  
  def ordenar
    orden_resumen = params[:orden_resumenes]
    orden_resumen.each_pair do |k,v|
      resumen = Resumen.find k
      resumen.orden = v
      unless resumen.save
        flash[:alert] = "No se Pudo ordenar el tema"
      else
        flash[:success] = "Notas ordenadas de correctamente"
      end
    end
    redirect_to :controller => 'informes', :action => "paso3"
  end
  
  # DELETE /resumenes/1
  # DELETE /resumenes/1.json
  def destroy
    @resumen = Resumen.find(params[:id])
    @resumen.notas.each {|nota| nota.tipo_nota_id = 1; nota.save}
    
    @resumen.destroy
    
    respond_to do |format|
      url = params[:url] ? params[:url] : paso1_resumenes_path
      format.html { redirect_to url }
      format.json { head :no_content }
    end
  end
end
