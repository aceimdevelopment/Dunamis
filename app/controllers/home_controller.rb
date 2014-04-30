# encoding: utf-8
class HomeController < ApplicationController
  def index
  end
  
  def validar
    unless params[:usuario]
      redirect_to :action => "index"
      return
    end
    login = params[:usuario][:nombre_sesion]
    clave = params[:usuario][:contrasena]
    reset_session
    if session[:usuario] = Usuario.autenticar(login,clave)
      flash[:success] = "¡Bienvenido!"
    else
      flash[:alert] = "Error en login o clave"
    end
    redirect_to :controller => "home"
  end
  
  def cerrar_sesion
    reset_session
    redirect_to :action => "index", :controller => "home"
  end
end
