# coding: utf-8
class Pdf
  require 'iconv'
  def self.to_utf16(valor)
    ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    ic_ignore.iconv(valor)
  end
  
  def self.generar_reporte_candidatos
    require 'pdf/writer'
    require 'pdf/simpletable'
    
    pdf = PDF::Writer.new(:paper => "letter", :orientation => :landscape, )
    
    ss = PDF::Writer::StrokeStyle.new(2)
		ss.cap = :round
		pdf.stroke_style ss
		
    # pdf.select_font "Times-Roman"
    # pdf.text "Hello, Ruby.", :font_size => 72, :justification => :center
    
    tab = PDF::SimpleTable.new
    tab.bold_headings = true
    tab.show_lines    = :inner
    tab.show_headings = true
    tab.shade_rows = :none
    tab.orientation   = :center
    tab.heading_font_size = 8
    tab.font_size = 8
    tab.row_gap = 3
    tab.minimum_space = 0
    column_order  = []
    column_order << %w(fecha alianza candidato)
    Canal.all.each{ |c| column_order << c.siglas}
    column_order = column_order.flatten
    
    tab.column_order = column_order
    tab.columns["fecha"] = PDF::SimpleTable::Column.new("fecha") { |col|
      col.width = 80
      col.justification = :center
      col.heading = "Fecha"
      col.heading.justification= :center
    }
    tab.columns["alianza"] = PDF::SimpleTable::Column.new("alianza") { |col|
      col.width = 50
      col.justification = :left
      col.heading = "Alizanza"
      col.heading.justification= :center
    }
    tab.columns["candidato"] = PDF::SimpleTable::Column.new("candidato") { |col|
      col.width = 90
      col.justification = :left
      col.heading = "Candidato"
      col.heading.justification= :center
    }
    
    
    Canal.all.each do |canal|
      tab.columns[canal.siglas] = PDF::SimpleTable::Column.new(canal.siglas) { |col|
        col.width = 50
        col.justification = :left
        col.heading = (to_utf16 canal.siglas).capitalize
        col.heading.justification= :center
      }      
    end
    
    # Inicialización de Variables
    data = []
    fecha = Date.new(2012,11,1)
    candidatos = Candidate.all
    canales = Canal.all
    
    for fecha in fecha..Date.today
      puts "Fecha_search: #{fecha}"
      # Client.where(:created_at => (params[:start_date].to_date)..(params[:end_date].to_date))
      # Candidate.select(:name).uniq
      
      alianza = "Gobierno Oposicion"
      
      apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha.to_datetime, fecha+1.day-1.second])
      pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 2 || a.cuna.organizacion.tolda_id == 2}

      candidatos.each do |candidato|
        aparicion_candidato = 0
        canales_conteo = Hash.new
        canales.each {|c| canales_conteo["#{c.siglas}"]=0}
        puts "canales: #{canales_conteo}."
        pars_opos.each do |par_opo|
          if par_opo.cuna.candidates.include? candidato
            aparicion_candidato += par_opo.cuna.duracion
            canales_conteo["#{par_opo.canal.siglas}"] += par_opo.cuna.duracion
            # canales[1][0].siglas
          end

        end
        presente = false
        canales_conteo.each_value{|v| presente = true if v > 0}
        if presente
          aux = {"fecha" => fecha, "alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
          aux = canales_conteo.merge aux
          data << aux
          puts aux
        end
        
      end
        
      # apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
      # par_ch = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 2 || a.cuna.organizacion.tolda_id == 1}
      # apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
      # gob_opo = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 1 || a.cuna.organizacion.tolda_id == 2}
      # apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
      # gob_ch = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 1 || a.cuna.organizacion.tolda_id == 1}      
      
    end
    puts data
    # canales: {"TVES"=>0, "VENEVISIÓN"=>0, "VTV"=>0, "TELEVEN"=>0, "GLOBOVISIÓN"=>0, "MERIDIANO"=>0}.
      # data << {
      #   "fecha" => "qweqeqe",
      #   "alianza" => "Daniel",
      #   "candidato" => 15573230,
      #   "globo" => "danielo@gmail",
      #   "meridiano" => "5555555",
      #   "televen" => "5555555",
      #   "tves" => "5555555",
      #   "venevision" => "5555555",
      #   "vtv" => "5555555"
      # }
    
    
    tab.data.replace data
    tab.render_on(pdf)
    
    pdf.save_as "prueba.pdf"
    
  end


end