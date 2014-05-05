class InformeMailer < ActionMailer::Base
  default from: "salaseguimiento@gmail.com"
  
  def enviar_informe(informe)
    @informe = informe
    @resumenes = Resumen.where(:informe_id => @informe.id)
    temas = Tema.joins(:resumenes).where('resumenes.informe_id >= ?', @informe.id)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas).group(:id)
    titulo = "#{@informe.fecha} - #{@informe.tema}"
    mail(to: 'development.cne@gmail.com', subject: titulo)
    
  end
end
