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
    
    pdf = PDF::Writer.new(:paper => "letter") #:orientation => :landscape,
    
    ss = PDF::Writer::StrokeStyle.new(2)
		ss.cap = :round
		pdf.stroke_style ss
		
    # pdf.select_font "Times-Roman"
    # pdf.text "Hello, Ruby.", :font_size => 72, :justification => :center

    
    fecha = Date.new(2012,11,1)
    candidatos = Candidate.all
    canales = Canal.all
    
    for fecha in fecha..Date.today
      # data << {"fecha" => fecha}
      pdf.text fecha.to_s, :justification => :center
      
      
      
      
      tab = encabezado_tabla
      tab.data
      tab.data = [{ "alianza" => ""}]
      tab.render_on(pdf)

      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :outer
      tab.shade_color = Color::RGB.new(230,238,238)
      tab.shade_color2 = Color::RGB::White
      tab.shade_rows = :striped
      tab.split_rows = true
      # tab.outer_line_style = 1
      tab.show_headings = false
      tab.shade_rows = :none
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 8
      tab.row_gap = 2
      tab.title_gap = 10
      tab.minimum_space = 1
      column_order  = []
      column_order << %w(alianza candidato)
      Canal.all.each{ |c| column_order << c.siglas}
      column_order = column_order.flatten

      tab.column_order = column_order
      # tab.columns["fecha"] = PDF::SimpleTable::Column.new("fecha") { |col|
      #   col.width = 80
      #   col.justification = :center
      #   col.heading = "Fecha"
      #   col.heading.justification= :center
      # }
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
      
      
      
      
      
      
      
      for i in 1..4
        case i
        when 1
            alianza = "Gobierno Opo"; tipo = 2; tolda = 1
        when 2
            alianza = "Gobierno Cha"; tipo = 2; tolda = 2
        when 3
            alianza = "Partidos Opo"; tipo = 1; tolda = 1
        else
            alianza = "Partidos Cha"; tipo = 1; tolda = 2
        end
        
        apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha.to_datetime, fecha+1.day-1.second])
        pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id != tipo || a.cuna.organizacion.tolda_id != tolda}
        data = []
        
        candidatos.each_with_index do |candidato, index_candi|
          aparicion_candidato = 0
          canales_conteo = Hash.new
          canales.each {|c| canales_conteo["#{c.siglas}"]=0}
          puts "canales: #{canales_conteo}."
          
          pars_opos.each do |par_opo|
            if par_opo.cuna.candidates.include? candidato
              aparicion_candidato += par_opo.cuna.duracion
              canales_conteo["#{par_opo.canal.siglas}"] += par_opo.cuna.duracion
            end

          end # end do par_opo
          presente = false
          canales_conteo.each_value{|v| presente = true if v > 0}
          
          if presente
            # aux = {"fecha" => fecha, "alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
            # alianza = "" if index_candi != 0
            aux = {"alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
            aux = canales_conteo.merge aux
            aux.delete_if {|key, value| value == 0 } 
            data << aux
            puts aux
          end #end if presente
          
        end #end do candidato
        (tab.data.replace data; tab.render_on(pdf)) if not data.empty?
      end #end for i
       pdf.text "________________________________________________________", :justification => :center
       pdf.text "\n"
      # break
    end # end for fecha
    
    pdf.save_as "prueba.pdf"
    
  end
  def self.encabezado_tabla
      require 'pdf/writer'
      require 'pdf/simpletable'

      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :none
      tab.show_headings = true
      tab.shade_headings = true
      tab.shade_heading_color = Color::RGB.new(230,238,238)
      tab.shade_rows = :none
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 6
      tab.row_gap = 3
      tab.minimum_space = 0
      column_order  = []
      column_order << %w(alianza candidato)
      Canal.all.each{ |c| column_order << c.siglas}
      column_order = column_order.flatten

      tab.column_order = column_order
      # tab.columns["fecha"] = PDF::SimpleTable::Column.new("fecha") { |col|
      #   col.width = 80
      #   col.justification = :center
      #   col.heading = "Fecha"
      #   col.heading.justification= :center
      # }
      tab.columns["alianza"] = PDF::SimpleTable::Column.new("alianza") { |col|
        col.width = 50
        col.justification = :left
        col.heading = "Alizanza"
        col.heading.justification= :center
        # col.heading.background_color = Color::RGB::Black
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
          col.heading = (to_utf16 canal.siglas)
          col.heading = "VV" if canal.siglas.eql? "VENEVISIÓN"
          col.heading = "GLOBO" if canal.siglas.eql? "GLOBOVISIÓN"
          col.heading = "MERI" if canal.siglas.eql? "MERIDIANO"
          col.heading.justification= :center
        }      
      end
      return tab
  end


end

# puts "Fecha_search: #{fecha}"
# Client.where(:created_at => (params[:start_date].to_date)..(params[:end_date].to_date))
# Candidate.select(:name).uniq

# pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id != 2 || a.cuna.organizacion.tolda_id != 1} # "Gobierno Oposicion"
# pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id != 1 || a.cuna.organizacion.tolda_id != 1} # "Partidos Oposición"
# pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id != 1 || a.cuna.organizacion.tolda_id != 2} # "Partidos Chavismo"
# pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id != 2 || a.cuna.organizacion.tolda_id != 2} # "Gobierno Chavismo"
  
# apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
# par_ch = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 2 || a.cuna.organizacion.tolda_id == 1}
# apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
# gob_opo = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 1 || a.cuna.organizacion.tolda_id == 2}
# apariciones = Aparicion.where(["momento >= ? AND momento <= ?",fecha, fecha+1.day-1.second])
# gob_ch = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id == 1 || a.cuna.organizacion.tolda_id == 1}