class WizardController < ApplicationController
  
  def paso1
    @websites = Website.all
  end

  def paso1_guardar
    if notas_validas_ids = params[:notas_validas_ids]
      notas_validas_ids.each do |nota_id|
        nota = Nota.find nota_id
        nota.tipo_nota_id = 2
        nota.save
      end
      redirect_to :action => "paso2"
    else
      render :action => "paso1"
    end
  end
  
  def paso2
    @notas = Nota.creadas_hoy.validas
  end

end