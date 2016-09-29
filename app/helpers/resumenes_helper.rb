# encoding: UTF-8
module ResumenesHelper

  def notas_estructuradas resumen, url=nil, informe_id=nil
    
    # Se agregan los botones de editar y eliminar resumen
    mensaje = ""
    mensaje += crud_botones resumen, url unless (controller_name=="informes" and (action_name=="show"))
    if resumen.vocero and resumen.vocero.nombre.downcase.eql? 'otro'
      vocero, contenido = resumen.contenido.split(":")
      vocero, contenido = resumen.contenido.split(",") if (vocero.blank? or contenido.blank?)
      if (vocero.blank? or contenido.blank?)
        vocero = resumen.vocero.nombre
        contenido = resumen.contenido
      end
      resumen.contenido = contenido
    else
      vocero = resumen.vocero.nombre_descripcion if resumen.vocero
    end
    mensaje += " <strong>#{vocero}</strong>" 
    # resumen.contenido = resumen.contenido[1..resumen.contenido.size-1]
    # mensaje += "<strong><#{resumen.contenido[1]}></strong>"
    if resumen.contenido
      # resumen.contenido = resumen.contenido#.squeeze
      # if resumen.contenido[0].eql? '"' or resumen.contenido[1].eql? '"'
      #   resumen.contenido = ": " + resumen.contenido
      # else
      #   resumen.contenido = ", " + resumen.contenido
      # end
      mensaje += " "+resumen.contenido
    end
    mensaje += enlaces_notas resumen 
		sub_resumenes = resumen.resumenes
		sub_resumenes.each do |sub_resumen|
		  if action_name.eql? "paso2"
		    mensaje += link_to "separar", {:controller => 'resumenes', :action => "separar", :id => sub_resumen.id, :informe_id => informe_id},  {:class => 'btn btn-mini'} 	#if (not informe_id.nil? and action_name!="paso4")
		    mensaje += " "
	    else
	      mensaje += " / "
      end
      mensaje += crud_botones sub_resumen, url unless (controller_name=="informes" and (action_name=="show"))
			mensaje +=  "<strong> / #{sub_resumen.vocero.nombre}: </strong>" if not resumen.vocero_id.eql? sub_resumen.vocero_id
			mensaje += " "+sub_resumen.contenido
			mensaje += enlaces_notas sub_resumen
		end		
		
    raw mensaje
  end
  
  def crud_botones resumen, url=nil # Agregan los botones de editar y eliminar resumen
    url_val = url.nil? ? "" : "?url=#{url}"
    mensaje = "<a href='/resumenes/#{resumen.id}#{url_val}' class='btn btn-mini btn-danger' data-confirm='¿Esta Seguro?' data-method='delete' rel='nofollow'>
    						<i class='icon-trash icon-black'></i>
    </a> | "
    mensaje += "<a href='/wizard/paso3/#{resumen.id}#{url_val}' class='btn btn-mini btn-info'>
    						<i class='icon-edit icon-white'></i>
    </a>"
    return mensaje
  end
  
   # Agrega enlaces de notas 
  def enlaces_notas resumen
    mensaje = ""
    notas = resumen.notas.order "updated_at DESC"
    if notas.count > 0
			notas.each_with_index do |nota,i|
				mensaje += link_nota nota
				mensaje += "-" if i < resumen.notas.count-1
			end
		end
		return mensaje
  end
  
end
