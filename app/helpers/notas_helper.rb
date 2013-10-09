module NotasHelper
  
  def link_nota nota
    link_to nota.website.descripcion, nota.url, {:class => 'btn btn-link', :target => '_blank'}
  end
  
  def link_borrar_nota nota_id
    link_to "#", {:class => 'btn btn-mini', :onclick => "return eliminar_nota (#{nota_id})"} do
			html_tag(:i, :class => 'icon-trash icon-black')
		end		
  end
  
end

