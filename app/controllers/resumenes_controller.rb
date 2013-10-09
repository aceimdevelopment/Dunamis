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
      @resumen.contenido = "#{@resumen.contenido} | #{nota.titulo}"  #if nota
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
    @resumenes_hoy = Resumen.where("updated_at >= ?", Date.today)
    # @resumen = params[:id].blank? ? Resumen.new : Resumen.find(params[:id])
    if params[:id].blank?
      @resumen = Resumen.new
    else
      @resumen = Resumen.find(params[:id])
    end
    
    Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])
    @websites = Website.all
    # @websites.each { |website| website.importar_notas_desactualizadas}
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
      redirect_to :action => "paso2", :id => @resumen.id #, notice: 'Resumen was successfully created.'
    else
      render :action => "paso1"
    end
  end
  
  def paso2
    @resumen = Resumen.find(params[:id])
    @websites = Website.all    
  end
  
  def paso2_guardar
    1/0
  end
  
  # DELETE /resumenes/1
  # DELETE /resumenes/1.json
  def destroy
    @resumen = Resumen.find(params[:id])
    @resumen.notas.delete_all
    @resumen.destroy

    respond_to do |format|
      format.html { redirect_to resumenes_url }
      format.json { head :no_content }
    end
  end
end
