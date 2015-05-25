class AsuntosController < ApplicationController
  # GET /asuntos
  # GET /asuntos.json
  before_filter :filtro_logueado
  
  def index
    @asuntos = Asunto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @asuntos }
    end
  end

  # GET /asuntos/1
  # GET /asuntos/1.json
  def show
    @asunto = Asunto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @asunto }
    end
  end

  # GET /asuntos/new
  # GET /asuntos/new.json
  def new
    @asunto = Asunto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @asunto }
    end
  end

  # GET /asuntos/1/edit
  def edit
    @asunto = Asunto.find(params[:id])
  end

  # POST /asuntos
  # POST /asuntos.json
  def create
    @asunto = Asunto.new(params[:asunto])

    respond_to do |format|
      if @asunto.save
        format.html { redirect_to @asunto, notice: 'Asunto creado satisfactoriamente.' }
        format.json { render json: @asunto, status: :created, location: @asunto }
      else
        format.html { render action: "new" }
        format.json { render json: @asunto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /asuntos/1
  # PUT /asuntos/1.json
  def update
    @asunto = Asunto.find(params[:id])

    respond_to do |format|
      if @asunto.update_attributes(params[:asunto])
        format.html { redirect_to @asunto, notice: 'Asunto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @asunto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asuntos/1
  # DELETE /asuntos/1.json
  def destroy
    @asunto = Asunto.find(params[:id])
    @asunto.destroy

    respond_to do |format|
      format.html { redirect_to asuntos_url }
      format.json { head :no_content }
    end
  end
end
