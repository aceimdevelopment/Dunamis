# coding: utf-8
class Pdf

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
    tab.column_order = ["fecha", "alianza", "candidato", "globo","meridiano", "televen", "tves", "venevision", "vtv"]
    tab.columns["fecha"] = PDF::SimpleTable::Column.new("fecha") { |col|
      col.width = 25
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
      col.width = 50
      col.justification = :left
      col.heading = "Candidato"
      col.heading.justification= :center
    }
    
    
    Canal.all.each do |canal|
      tab.columns["#{canal.siglas}"] = PDF::SimpleTable::Column.new("#{canal.siglas}") { |col|
        col.width = 50
        col.justification = :left
        col.heading = "#{canal.siglas}"
        col.heading.justification= :center
      }      
    end




    
    # tab.columns["globo"] = PDF::SimpleTable::Column.new("globo") { |col|
    #   col.width = 50
    #   col.justification = :left
    #   col.heading = "Globovisión"
    #   col.heading.justification= :center
    # }
    # tab.columns["meridiano"] = PDF::SimpleTable::Column.new("meridiano") { |col|
    #   col.width = 50
    #   col.justification = :left
    #   col.heading = "Meridiano"
    #   col.heading.justification= :center
    # }
    # 
    # tab.columns["televen"] = PDF::SimpleTable::Column.new("televen") { |col|
    #   col.width = 50
    #   col.justification = :left
    #   col.heading = "Televen"
    #   col.heading.justification= :center
    # }
    # data = []
    # tab.columns["tves"] = PDF::SimpleTable::Column.new("tves") { |col|
    #   col.width = 50
    #   col.justification = :left
    #   col.heading = "TVes"
    #   col.heading.justification= :center
    # }
    # tab.columns["venevision"] = PDF::SimpleTable::Column.new("venevision") { |col|
    #   col.width = 50
    #   col.justification = :left
    #   col.heading = "Venevisión"
    #   col.heading.justification= :center
    # }
    # tab.columns["vtv"] = PDF::SimpleTable::Column.new("vtv") { |col|
    #   col.width = 50
    #   col.justification = :left
    #   col.heading = "VTV"
    #   col.heading.justification= :center
    # }
    
    
    
    # historial.each_with_index{|reg,ind|
    data = []
    fecha = Date.new(2012,11,1)
    for fecha in fecha..Date.today
      # Client.where(:created_at => (params[:start_date].to_date)..(params[:end_date].to_date))
      # Candidate.select(:name).uniq
      
      alianza = "Gobierno Oposicion"
      
      apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
      pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 2 || a.cuna.organizacion.tolda_id == 2}

      candidatos = Candidate.all
      candidatos.each do |candidato|
        aparicion_candidato = 0
        canales = Hash.new
        Canal.all.each {|c| canales["#{c.siglas}"]=0}
        puts "canales: #{canales}."
        pars_opos.each do |par_opo|  
          if par_opo.cuna.candidates.include? candidato
            aparicion_candidato += par_opo.cuna.duracion
            canales["#{par_opo.canal.siglas}"] += par_opo.cuna.duracion
            # canales[1][0].siglas
          end

        end
        presente = false
        canales.each_value{|v| presente = true if v > 0}
        if presente
          aux = {"fecha" => fecha, "alianza" => alianza, "candidato" => candidato.name}
          aux = canales.merge aux
          data << aux
        end
        
      end
        
      # apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
      # par_ch = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 2 || a.cuna.organizacion.tolda_id == 1}
      # apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
      # gob_opo = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 1 || a.cuna.organizacion.tolda_id == 2}
      # apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
      # gob_ch = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 1 || a.cuna.organizacion.tolda_id == 1}      
      
    end
    
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