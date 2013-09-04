class VocerosController < ApplicationController
  # GET /voceros
  # GET /voceros.json
  def index
    @voceros = Vocero.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @voceros }
    end
  end

  # GET /voceros/1
  # GET /voceros/1.json
  def show
    @vocero = Vocero.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vocero }
    end
  end

  # GET /voceros/new
  # GET /voceros/new.json
  def new
    @vocero = Vocero.new
    @organizacion = Organizacion.

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vocero }
    end
  end

  # GET /voceros/1/edit
  def edit
    @vocero = Vocero.find(params[:id])
  end

  # POST /voceros
  # POST /voceros.json
  def create
    @vocero = Vocero.new(params[:vocero])

    respond_to do |format|
      if @vocero.save
        format.html { redirect_to @vocero, notice: 'Vocero was successfully created.' }
        format.json { render json: @vocero, status: :created, location: @vocero }
      else
        format.html { render action: "new" }
        format.json { render json: @vocero.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /voceros/1
  # PUT /voceros/1.json
  def update
    @vocero = Vocero.find(params[:id])

    respond_to do |format|
      if @vocero.update_attributes(params[:vocero])
        format.html { redirect_to @vocero, notice: 'Vocero was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vocero.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /voceros/1
  # DELETE /voceros/1.json
  def destroy
    @vocero = Vocero.find(params[:id])
    @vocero.destroy

    respond_to do |format|
      format.html { redirect_to voceros_url }
      format.json { head :no_content }
    end
  end
end
