# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
private  
  def filtro_logueado
    unless session[:usuario]
      flash[:alert] = "Debe iniciar sesión"  
      redirect_to :root
      return false
    end
  end
end
