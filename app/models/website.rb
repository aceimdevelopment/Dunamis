class Website < ActiveRecord::Base
  attr_accessible :descripcion, :logo, :nombre, :url

  has_many :notas
  accepts_nested_attributes_for :notas

  def eliminar_notas_irrelevantes
    self.notas.each { |nota| nota.destroy unless nota.resumen_id }
  end

  # def importar_nota (clases, titulos, contenidos, imagenes, fecha = nil, tipo_nota = nil)
  #   require 'importer'
  #   puts nombre.upcase
  #   # Eliminando las notas no asociadas a algun resumen
  #   eliminar_notas_irrelevantes
  #   # Se Carga la Pagina Principal del WebSite
  #   index = cargar_website website
  #   
  #   tipo_nota = TipoNota.find_by_nombre("Nota de Prensa")
  #   
  #   # Se Buscan las Todas las Notas de la Web
  #   notas = ""
  #   clases.each do |clase|
  #     notas += index.search clase
  #   end
  #     
  #   notas.each do |nota|
  #     # Se buscan titulos (<a></a>) y contenidos
  #     titulos.each do |titulo|
  # 
  #     titulo = nota.search ".views-field-title span a"
  #     contenido = nota.search ".views-field-field-summary-value span"
  #     contenido = contenido.text
  #     # unless contenido.blank? && titulo.blank?
  #       # Si la Nota tiene titulo y contenido
  #     href = titulo.attr "href" unless titulo.blank?
  #     url = "#{website.url}#{(href).value}" if href
  #     
  #     titulo = titulo.text
  #     
  #     # buscamos Fechas
  #     fecha = nota.search(".fecha")
  #     fecha = fecha[0] if fecha.count > 1
  #     fecha = fecha.text if fecha
  #       
  #     # Buscamos imagenes
  #     imagen = nota.search ".views-field-field-image-fid img"
  #     imagen = nota.search ".thumb img" if imagen.blank?
  #     imagen = imagen.attr "src" unless imagen.blank?
  #     imagen = imagen.text
  # 
  #     puts "================================================<<<<<<<>>>>>>>>>>>>>>================================================"
  #     puts "Titulo: #{titulo}\n"
  #     puts "Url: #{url}\n"
  #     puts "Fecha: #{fecha}\n"
  #     puts "Contenido: #{contenido}\n"
  #     puts "Imágen: #{imagen}\n"
  # 
  #     # # Se guarda la nota_local
  #     # nota_local = Nota.new
  #     # nota_local.titulo = titulo
  #     # nota_local.fecha_publicacion = fecha
  #     # nota_local.contenido = contenido
  #     # nota_local.url = url
  #     # nota_local.website_id = website.id
  #     # nota_local.tipo_nota_id = tipo_nota.id
  #     # nota_local.imagen = imagen
  #     # nota_local.save
  # 
  #   end
  # end
  # 


end
