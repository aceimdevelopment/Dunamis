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
    @resumen = Resumen.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resumen }
    end
  end

  # GET /resumenes/1/edit
  def edit
    @resumen = Resumen.find(params[:id])
  end

  # POST /resumenes
  # POST /resumenes.json
  def create
    @resumen = Resumen.new(params[:resumen])

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

  # DELETE /resumenes/1
  # DELETE /resumenes/1.json
  def destroy
    @resumen = Resumen.find(params[:id])
    @resumen.destroy

    respond_to do |format|
      format.html { redirect_to resumenes_url }
      format.json { head :no_content }
    end
  end
end
