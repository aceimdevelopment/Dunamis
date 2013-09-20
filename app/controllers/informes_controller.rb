# encoding: utf-8
class InformesController < ApplicationController
  # GET /informes
  # GET /informes.json
  def index
    @informes = Informe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @informes }
    end
  end

  # GET /informes/1
  # GET /informes/1.json
  def show
    @informe = Informe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @informe }
    end
  end

  # GET /informes/new
  # GET /informes/new.json
  def new

    require "Importer"
    encabezado = " Dirección de Seguimiento de la Información Electoral \n AGENDA TEMÁTICA DE MEDIOS"
    encabezado += "#{Date.today}"
    encabezado += "MONITOREO DE MEDIOS (de 10:00am a 05:00pm)
    El presiente Nicolás Maduro continúa visita oficial en Rusia. Se firmaron cinco acuerdos de cooperación mixta, luego ofreció una entrevista al canal Actualidad Russia Today y después encabezó acto cultural en homenaje a la memoria del presidente Chávez. El vicepresidente Arreaza estuvo en el estado Apure como parte del gobierno de calle. El ministro Haiman El Troudi presentó el plan rector 2013- 2019 en materia de movilidad terrestre; y el presidente de Indepabis, Eduardo Samán, fue entrevistado en Venevisión. Por la oposición, el gobernador Henrique Capriles, durante su programa en Capriles.TV, informó que el Comando “Simón Bolívar” recusó a todos los magistrados de la Sala Constitucional avocados a la impugnación del 14-A. En cuanto al sector universitario, el ministro Héctor Rodríguez se reunió con estudiantes en el Teatro Teresa Carreño. Huelguistas y dirigentes de oposición insisten en mantener la lucha."

    # Borra Todas las notas antiguas e inservibles
    # SELETE FROM `notas` WHERE (resumen_id IS NULL AND created_at <= 'Hoy')
    Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])

    if Nota.creadas_hoy.count == 0 #provisional para cargar notas de hoy si no existen
      Importer.import_notas_noticias24
      Importer.import_notas_globovision
      Importer.import_notas_union_radio
      Importer.import_notas_noticierodigital
      Importer.import_notas_noticierovenevision
      Importer.import_notas_vtv
      Importer.import_notas_laverdad
      Importer.import_notas_informe21
      Importer.import_notas_eluniversal
      Importer.import_notas_avn
      @error = Importer.import_notas_radiomundial
      @error = @error.nil? ? "Demasiado tiempo esperando respuesta de las Página " : ""
      Importer.import_notas_elnacional
      Importer.import_notas_rnv
    end


    @websites = Website.all
    @informe = Informe.new
    @informe.resumen = encabezado
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @informe }
    end
  end

  # GET /informes/1/edit
  def edit
    @informe = Informe.find(params[:id])
  end

  # POST /informes
  # POST /informes.json
  def create
    @informe = Informe.new(params[:informe])

    respond_to do |format|
      if @informe.save
        format.html { redirect_to @informe, notice: 'Informe was successfully created.' }
        format.json { render json: @informe, status: :created, location: @informe }
      else
        format.html { render action: "new" }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /informes/1
  # PUT /informes/1.json
  def update
    @informe = Informe.find(params[:id])

    respond_to do |format|
      if @informe.update_attributes(params[:informe])
        format.html { redirect_to @informe, notice: 'Informe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /informes/1
  # DELETE /informes/1.json
  def destroy
    @informe = Informe.find(params[:id])
    @informe.destroy

    respond_to do |format|
      format.html { redirect_to informes_url }
      format.json { head :no_content }
    end
  end
end
