# encoding: utf-8
module NotasHelper
  
  def link_nota nota
    link_to nota.website.descripcion, nota.url, {:class => 'btn btn-link', :target => '_blank'}
  end

  def link_descartar_nota nota_id, resumen_id=nil
		link_to "/wizard/invalidar/#{nota_id}?resumen_id=#{resumen_id}&action_name=#{action_name}", :resumen_id => resumen_id, :class => 'btn btn-mini btn-danger', :data => {:confirm => '¿Descartar nota?', :method => 'delete'} do
      raw "<i class='icon-minus icon-file	icon-white'></i>"

		end
  end
  
  def link_borrar_nota nota_id
    link_to "#", {:class => 'btn btn-mini', :onclick => "return eliminar_nota (#{nota_id})"} do
			html_tag(:i, :class => 'icon-trash icon-black')
		end		
  end
  
end

