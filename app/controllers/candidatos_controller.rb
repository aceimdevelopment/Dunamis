class CandidatosController < ApplicationController
  # GET /candidatos
  # GET /candidatos.json
  before_filter :filtro_logueado
  def index
    @candidatos = Candidato.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @candidatos }
    end
  end

  # GET /candidatos/1
  # GET /candidatos/1.json
  def show
    @candidato = Candidato.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @candidato }
    end
  end

  # GET /candidatos/new
  # GET /candidatos/new.json
  def new
    @candidato = Candidato.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @candidato }
    end
  end

  # GET /candidatos/1/edit
  def edit
    @candidato = Candidato.find(params[:id])
  end

  # POST /candidatos
  # POST /candidatos.json
  def create
    @candidato = Candidato.new(params[:candidato])

    respond_to do |format|
      if @candidato.save
        format.html { redirect_to @candidato, notice: 'Candidato was successfully created.' }
        format.json { render json: @candidato, status: :created, location: @candidato }
      else
        format.html { render action: "new" }
        format.json { render json: @candidato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /candidatos/1
  # PUT /candidatos/1.json
  def update
    @candidato = Candidato.find(params[:id])

    respond_to do |format|
      if @candidato.update_attributes(params[:candidato])
        format.html { redirect_to @candidato, notice: 'Candidato was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidatos/1
  # DELETE /candidatos/1.json
  def destroy
    @candidato = Candidato.find(params[:id])
    @candidato.destroy

    respond_to do |format|
      format.html { redirect_to candidatos_url }
      format.json { head :no_content }
    end
  end
end
