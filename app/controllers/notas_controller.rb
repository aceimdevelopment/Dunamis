# encoding: utf-8
class NotasController < ApplicationController
  # GET /notas
  # GET /notas.json
  before_filter :filtro_logueado  
  def index
    @notas = Nota.limit(100).order('created_at ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notas }
    end
  end

  # GET /notas/1
  # GET /notas/1.json
  def show
    @nota = Nota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nota }
    end
  end

  # GET /notas/new
  # GET /notas/new.json
  def new
    @modal = false
    @nota = Nota.new
    @websites = Website.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nota }
    end
  end

  # GET /notas/1/edit
  def edit
    @nota = Nota.find(params[:id])
  end

  # POST /notas
  # POST /notas.json
  def create
    params[:nota][:contenido] = params[:nota][:contenido].squeeze 
    @nota = Nota.new(params[:nota])

    if params[:url]
      if @nota.save 
        flash[:notice] = 'Nota creada correctamente.'
        # format.json { render json: @nota, status: :created, location: @nota }
      else
        flash[:alert] = ""
        @nota.errors.full_messages.each do |msg|
          flash[:alert] += msg
        end
        # format.json { render json: @nota.errors, status: :unprocessable_entity }
      end
      redirect_to params[:url]
    else
      if @nota.save
        flash[:notice] = 'Nota creada correctamente.'
        redirect_to :back
        # format.json { render json: @nota, status: :created, location: @nota }
      else
        @modal = false
        # @tipo_nota = TipoNota.all
        @websites = Website.all
        flash[:alert] = ""
        @nota.errors.full_messages.each do |msg|
          flash[:alert] += msg
        end
        
        format.html { render action: "new" }
        format.json { render json: @nota.errors, status: :unprocessable_entity }
      end
    end

  end

  # PUT /notas/1
  # PUT /notas/1.json
  def update
    @nota = Nota.find(params[:id])
    
    if params[:resumen_id]
      if params[:resumen_id].eql? "-1"
        @nota.resumen_id = nil
      else
        @nota.resumen_id = params[:resumen_id] 
      end
    end
    @nota.tipo_nota_id = params[:tipo_nota_id] if params[:tipo_nota_id]
    

    respond_to do |format|
      if @nota.update_attributes(params[:nota])
        format.html { redirect_to @nota, notice: 'Nota was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notas/1
  # DELETE /notas/1.json
  def destroy
    @nota = Nota.find(params[:id])
    @nota.destroy

    respond_to do |format|
      format.html { redirect_to notas_url }
      format.json { head :no_content }
    end
  end
end
