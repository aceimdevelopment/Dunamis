# encoding: utf-8
class PaginasController < ApplicationController
  # GET /paginas
  # GET /paginas.json
  def index
    @paginas = Pagina.all
    @pagina = Pagina.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @paginas }
    end
  end

  # GET /paginas/1
  # GET /paginas/1.json
  def show
    @pagina = Pagina.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pagina }
    end
  end

  # GET /paginas/new
  # GET /paginas/new.json
  def new
    @pagina = Pagina.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pagina }
    end
  end

  # GET /paginas/1/edit
  def edit
    @pagina = Pagina.find(params[:id])
  end

  # POST /paginas
  # POST /paginas.json
  def create
    if params[:website_id]
      @website = Website.find(params[:website_id])
      @pagina = @website.paginas.create(params[:pagina])
      flash[:notice] = 'Página creada correctamente.'
      redirect_to website_path(@website)
    else
      @pagina = Pagina.new(params[:pagina])
      respond_to do |format|
        if @pagina.save
          
          format.html { redirect_to @pagina, notice: 'Municipio was successfully created.' }
          format.json { render json: @pagina, status: :created, location: @pagina }
        else
          format.html { render action: "new" }
          format.json { render json: @pagina.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /paginas/1
  # PUT /paginas/1.json
  def update
    @pagina = Pagina.find(params[:id])

    respond_to do |format|
      if @pagina.update_attributes(params[:pagina])
        format.html { redirect_to :back, notice: 'Pagina was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pagina.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paginas/1
  # DELETE /paginas/1.json
  def destroy
    @pagina = Pagina.find(params[:id])
    @pagina.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
