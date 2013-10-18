class InformeMailer < ActionMailer::Base
  default from: "salaseguimiento@example.com"
  
  def enviar_informe(informe)
    @informe = informe
    @resumenes = Resumen.where(:informe_id => @informe.id)
    temas = Tema.joins(:resumenes).where('resumenes.informe_id >= ?', @informe.id)
    @asuntos = Asunto.joins(:temas).where('temas.id' => temas).group(:id)
    titulo = "#{@informe.fecha} MONITOREO DE MEDIOS (de 10:00 am a 05:00 pm)"
    mail(to: 'development.cne@gmail.com', subject: titulo)
    
  end
end
