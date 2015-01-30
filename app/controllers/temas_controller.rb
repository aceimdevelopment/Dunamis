class TemasController < ApplicationController
  # GET /temas
  # GET /temas.json
  before_filter :filtro_logueado  
  def index
    @temas = Tema.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @temas }
    end
  end

  # GET /temas/1
  # GET /temas/1.json
  def show
    @tema = Tema.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tema }
    end
  end

  # GET /temas/new
  # GET /temas/new.json
  def new
    @tema = Tema.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tema }
    end
  end

  # GET /temas/1/edit
  def edit
    @tema = Tema.find(params[:id])
  end

  # POST /temas
  # POST /temas.json
  def create
    if params[:asunto_id]
      @asunto = Asunto.find(params[:asunto_id])
      @tema = @asunto.temas.create(params[:tema])
      redirect_to asunto_path(@asunto)
    else
      @tema = Tema.new(params[:tema])

      respond_to do |format|
        if params[:controlador]
          if @tema.save
            flash[:success] = "Tema Creado Satisfactoriamente"
          else
            flash[:alert] = @tema.errors.full_messages.join(" | ")
          end
          format.html { redirect_to :controller => params[:controlador], :action => params[:accion], :mensaje => @mensaje, :tipo => @tipo }
        else
          if @tema.save
            flash[:success] = "Tema Creado Satisfactoriamente" 
            format.html { redirect_to @tema}
            format.json { render json: @tema, status: :created, location: @tema }
          else
            format.html { render action: "new" }
            format.json { render json: @tema.errors, status: :unprocessable_entity }
          end
        end # params[:controlador]
      end # response_to
    end # params[:asunto_id]
  end

  # PUT /temas/1
  # PUT /temas/1.json
  def update
    @tema = Tema.find(params[:id])

    respond_to do |format|
      if @tema.update_attributes(params[:tema])
        flash[:success] = "Tema Actualizado Satisfactoriamente" 
        format.html { redirect_to @tema}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /temas/1
  # DELETE /temas/1.json
  def destroy
    @tema = Tema.find(params[:id])
    @tema.destroy

    respond_to do |format|
      flash[:notice] = "Tema completamente eliminado"
      format.html { redirect_to temas_url}
      format.json { head :no_content }
    end
  end
end
