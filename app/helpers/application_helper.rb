# encoding: UTF-8
module ApplicationHelper
  # def carga_reciente? website
  #   tiempo_retardo = 10 #minutos
  #   nota = website.notas.last 
  #   tiempo_ultima_carga = (nota.updated_at - DateTime.now) / 60
  #   tiempo_ultima_carga = tiempo_ultima_carga*-1 if tiempo_ultima_carga < 0
  #   return tiempo_ultima_carga < tiempo_retardo
  # end
  # 
  # def importar_notas_website nombre
  #   Importer.import_notas_noticias24 if nombre.eql? "noticias24"
  #   Importer.import_notas_globovision if nombre.eql? "globovision"
  #   Importer.import_notas_union_radio if nombre.eql? "unionradio"
  #   Importer.import_notas_noticierodigital if nombre.eql? "noticierodigital"
  #   Importer.import_notas_noticierovenevision if nombre.eql? "noticierovenevision"
  #   Importer.import_notas_vtv if nombre.eql? "vtv"
  #   Importer.import_notas_laverdad if nombre.eql? "laverdad"
  #   Importer.import_notas_informe21 if nombre.eql? "informe21"
  #   Importer.import_notas_eluniversal if nombre.eql? "eluniversal"
  #   Importer.import_notas_avn if nombre.eql? "avn"
  #   Importer.import_notas_elnacional if nombre.eql? "elnacional"
  #   Importer.import_notas_rnv if nombre.eql? "rnv"
  #   Importer.import_notas_radiomundial if nombre.eql? "radiomundial"
  #   
  # end

  def notas_estructuradas resumen, url=nil, informe_id=nil
    
    mensaje = "<a href='/resumenes/#{resumen.id}?url=#{url}' class='btn btn-mini btn-danger' data-confirm='¿Esta Seguro?' data-method='delete' rel='nofollow'>
    						<i class='icon-trash icon-black'></i>
    </a> | "
    mensaje += "<a href='/wizard/paso3/#{resumen.id}' class='btn btn-mini btn-info'>
    						<i class='icon-edit icon-black'></i>
    </a>"
    mensaje += " | <strong>"
    mensaje += resumen.vocero.nombre
    mensaje += ": </strong>"
    mensaje += resumen.contenido

    if resumen.notas
			resumen.notas.each do |nota|
				mensaje += link_to_nota nota
			end
		end
		
		sub_resumenes = resumen.resumenes
		sub_resumenes.each do |sub_resumen|
		  
		  mensaje += link_to "separar", {:controller => 'resumenes', :action => "separar", :id => sub_resumen.id, :informe_id => informe_id},  {:class => 'btn btn-mini'}	if (not informe_id.nil? and action_name!="paso4")
			mensaje +=  "<strong> / #{sub_resumen.vocero.nombre}: </strong>" if not resumen.vocero_id.eql? sub_resumen.vocero_id
			mensaje += sub_resumen.contenido
			if sub_resumen.notas
				resumen.notas.each do |nota|
					mensaje += link_to nota.website.descripcion, nota.url, {:class => 'btn btn-link', :target => '_blank'}
					mensaje += "|"
				end
			end
		end		
		
    raw mensaje
  end

  def link_to_nota nota
    link_to nota.website.descripcion, nota.url, {:class => 'btn btn-link', :target => '_blank'}
  end

  def importar_notas_websites
    require "Importer"
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
    Importer.import_notas_elnacional
    Importer.import_notas_rnv
    Importer.import_notas_radiomundial

  end
  
  def limpiar_notas_antiguas_inservibles
    Nota.delete_all (["resumen_id IS ? AND created_at <= ?", nil, Date.today])
  end
  
  def flash_class(level)
      case level
          when :notice then "alert alert-info"
          when :success then "alert alert-success"
          when :error then "alert alert-error"
          when :alert then "alert alert-error"
      end
  end

end
