# encoding: utf-8
class HomeController < ApplicationController
  def index
  end
  
  def validar
    unless params[:usuario]
      flash[:alert] = "Debe Iniciar Sesión"
      redirect_to :action => "index"
      return
    end
    login = params[:usuario][:nombre_sesion]
    clave = params[:usuario][:contrasena]
    reset_session
    session[:usuario] = Usuario.autenticar(login,clave)
    if session[:usuario].nil?
      flash[:alert] = "Error en login o clave #{session[:usuario]}"
    else
      flash[:success] = "¡Bienvenido! #{session[:usuario].nombre}"
    end
    redirect_to :back
  end
  
  def cerrar_sesion
    reset_session
    flash[:success] = "Sesión Cerrada ¡Hasta pronto!"
    redirect_to :action => "index", :controller => "home"
  end
  
end
