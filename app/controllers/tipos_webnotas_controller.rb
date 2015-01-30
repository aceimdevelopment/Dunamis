class TiposWebnotasController < ApplicationController
  # GET /tipos_webnotas
  # GET /tipos_webnotas.json
  before_filter :filtro_logueado
  def index
    @tipos_webnotas = TipoWebnota.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipos_webnotas }
    end
  end

  # GET /tipos_webnotas/1
  # GET /tipos_webnotas/1.json
  def show
    @tipo_webnota = TipoWebnota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_webnota }
    end
  end

  # GET /tipos_webnotas/new
  # GET /tipos_webnotas/new.json
  def new
    @tipo_webnota = TipoWebnota.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_webnota }
    end
  end

  # GET /tipos_webnotas/1/edit
  def edit
    @tipo_webnota = TipoWebnota.find(params[:id])
  end

  # POST /tipos_webnotas
  # POST /tipos_webnotas.json
  def create
    @tipo_webnota = TipoWebnota.new(params[:tipo_webnota])

    respond_to do |format|
      if @tipo_webnota.save
        format.html { redirect_to @tipo_webnota, notice: 'Tipo webnota was successfully created.' }
        format.json { render json: @tipo_webnota, status: :created, location: @tipo_webnota }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_webnota.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipos_webnotas/1
  # PUT /tipos_webnotas/1.json
  def update
    @tipo_webnota = TipoWebnota.find(params[:id])

    respond_to do |format|
      if @tipo_webnota.update_attributes(params[:tipo_webnota])
        format.html { redirect_to @tipo_webnota, notice: 'Tipo webnota was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_webnota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos_webnotas/1
  # DELETE /tipos_webnotas/1.json
  def destroy
    @tipo_webnota = TipoWebnota.find(params[:id])
    @tipo_webnota.destroy

    respond_to do |format|
      format.html { redirect_to tipos_webnotas_url }
      format.json { head :no_content }
    end
  end
end
