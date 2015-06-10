# encoding: utf-8
class Pdf
  require 'iconv'
  def self.to_utf16(valor)
    ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    ic_ignore.iconv(valor)
  end
  
  def self.descargar_alertas_excel alertas
    require 'spreadsheet'
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet :name => "reporte de alertas"
    # @sheet = @book.create_worksheet :name => "reporte de alertas#{DateTime.now.strftime('%d %m %Y %h')}"
    data = %w{ID FECHA CONTENIDO RESUMEN ASUNTO TEMA TIPO VOCERO}
    @sheet.row(0).concat data
    
    data = []
    
    alertas.each_with_index do |alerta,i|
      aux = {"ID" => alerta.id, "FECHA" => alerta.fecha, "CONTENIDO" => alerta.contenido, "RESUMEN" => alerta.resumen, "ASUNTO" => alerta.tema.asunto.nombre, "TEMA" => alerta.tema.nombre, "TIPO" => alerta.tipo_alerta.descripcion, "VOCERO" => alerta.vocero.nombre}
      @sheet.row(i+1).concat aux.values
    end
    file_name = "Reporte_alertas_#{DateTime.now.strftime('%d_%m_%Y_%H_%M')}.xls"
    return file_name if @book.write file_name
    
  end
  
  
  def self.generar_reporte_candidatos_excel fecha_inicial, fecha_final
      require 'spreadsheet'
      
      @book = Spreadsheet::Workbook.new
       
      # row = @sheet1.row(0)
      # row.push %w{Casa Cualquier Cosa} 
      
      fecha = fecha_inicial.to_date
      fecha_2 = fecha_final.to_date
      candidatos = Candidate.order :name
      canales = Canal.order :siglas
      index = 0
      
      for fecha in fecha..fecha_2
        @sheet = @book.create_worksheet :name => "Apariciones: #{fecha.to_s}"
        @sheet.row(0).push "#{fecha.strftime("%a- %d de %b de %Y")}"
        # @sheet.writer 0,0, to_utf16("#{fecha.strftime("%a, %d de %b de %Y")}")
        data = %w{Alianza Candidato}
        
        canales.each {|c| data << c.siglas}
        @sheet.row(1).concat data
      
        for i in 1..3
          apariciones = Aparicion.por_fecha fecha # Aparicion.where(["momento >= ? AND momento <= ?",fecha.to_datetime, (fecha+1.day-1.second).to_s])

          case i
            when 1
                alianza = "MUD"
            when 2
                alianza = "PSUV"
            else
                alianza = "Sin Grupo"
          end
          apariciones_alianza = apariciones.delete_if {|a| a.cuna.grupo != alianza}
      #     # alianza = pars_opos.first.cuna.organizacion.alianza if pars_opos.first
          data = []
          primera = 0
          candidatos.each do |candidato|
            canales_conteo = candidato.apariciones_candidatos apariciones_alianza
            presente = false

            canales_conteo.each_value { |value| presente = true if value > 0}
            if presente
              # aux = {"fecha" => fecha, "alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
              alianza = "" if primera > 0
              aux = {"alianza" => "#{alianza}", "candidato" =>  (candidato.name).capitalize }
              # canales_conteo.each_value {|v| (v = "<b> #{v} </b> "; puts v) if v.to_i > 180}
              aux = aux.merge canales_conteo
              # aux.delete_if {|key, value| value == 0 }
              data << aux
              puts aux
              primera += 1
            end #end if presente
          end #end do candidato

          if not data.empty?
            data.each_with_index do |d,i=2|
                break if d.include? "Sin Grupo"
                @sheet.row(i).concat d.values
                puts "Data: #{d.values}"
                # d.each_value{|v| @sheet.row(i).push v; puts "VALUE:!!#{i}:#{to_utf16 v.to_s}"}
            end
          end
          
        end #end for i
        # break
      end # end for fecha

      @book.write "Reporte_apariciones_candidatos desde #{fecha_inicial} hasta #{fecha_final}.xls"
    
  end
  
  
  def self.generar_reporte_candidatos_excel_cantidad fecha_inicial, fecha_final
      require 'spreadsheet'
      
      @book = Spreadsheet::Workbook.new
       
      # row = @sheet1.row(0)
      # row.push %w{Casa Cualquier Cosa} 
      
      fecha = fecha_inicial.to_date
      fecha_2 = fecha_final.to_date
      candidatos = Candidate.order :name
      canales = Canal.order :siglas
      index = 0
      
      for fecha in fecha..fecha_2
        @sheet = @book.create_worksheet :name => "#{fecha.strftime('%d %m %Y')}"
        @sheet.row(0).push "#{fecha.strftime("%a- %d de %b de %Y")}"
        # @sheet.writer 0,0, to_utf16("#{fecha.strftime("%a, %d de %b de %Y")}")
        data = %w{Alianza Candidato Apariciones_total Apariciones_solo Apariciones_combo Apariciones_nacional}
        
        canales.each {|c| data << c.siglas}
        @sheet.row(1).concat data
        data = []     
        for i in 1..3
          apariciones = Aparicion.por_fecha fecha # Aparicion.where(["momento >= ? AND momento <= ?",fecha.to_datetime, (fecha+1.day-1.second).to_s])

          case i
            when 1
                alianza = "MUD"
            when 2
                alianza = "PSUV"
            else
                alianza = "Sin Grupo"
          end
          apariciones_alianza = apariciones.delete_if {|a| a.cuna.grupo != alianza}
      #     # alianza = pars_opos.first.cuna.organizacion.alianza if pars_opos.first

          primera = 0
          candidatos.each do |candidato|
            canales_conteo = candidato.apariciones_candidatos_cantidad apariciones_alianza
            presente = false

            canales_conteo.each_value { |value| presente = true if value > 0}
            if presente
              # aux = {"fecha" => fecha, "alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
              alianza = "" if primera > 0
              
              solo = candidato.solo
              nacional = candidato.nacional
              total = candidato.cunas.count
              combo = total - (solo + nacional)

              aux = {"alianza" => "#{alianza}", "candidato" =>  (candidato.name) }
              # canales_conteo.each_value {|v| (v = "<b> #{v} </b> "; puts v) if v.to_i > 180}
              aux = aux.merge canales_conteo
              # aux.delete_if {|key, value| value == 0 }
              data << aux
              puts aux
              primera += 1
            end #end if presente
          end #end do candidato
        end #end for i
        i=2
        if not data.empty?
          data.each do |d|
              @sheet.row(i).concat d.values
              # d.each_value{|v| @sheet.row(i).push v; puts "VALUE:!!#{i}:#{to_utf16 v.to_s}"}
              i+=1
          end
        end
      end # end for fecha

      @book.write "Reporte_apariciones_candidatos_cantidades desde #{fecha_inicial} hasta #{fecha_final}.xls"
    
  end
  
  
  def self.generar_reporte_candidatos_excel_2 fecha_inicial, fecha_final
      require 'spreadsheet'
      
      @book = Spreadsheet::Workbook.new
       
      # row = @sheet1.row(0)
      # row.push %w{Casa Cualquier Cosa} 
      
      fecha = fecha_inicial.to_date
      fecha_2 = fecha_final.to_date
      candidatos = Candidate.order :name
      canales = Canal.order :siglas
      index = 0
      
      for fecha in fecha..fecha_2
        @sheet = @book.create_worksheet :name => "#{fecha.strftime('%d %m %Y')}"
        @sheet.row(0).push "#{fecha.strftime("%a- %d de %b de %Y")}"
        # @sheet.writer 0,0, to_utf16("#{fecha.strftime("%a, %d de %b de %Y")}")
        data = %w{Alianza Candidato}
        
        canales.each {|c| data << c.siglas}
        @sheet.row(1).concat data
        data = []     
        for i in 1..3
          apariciones = Aparicion.por_fecha fecha # Aparicion.where(["momento >= ? AND momento <= ?",fecha.to_datetime, (fecha+1.day-1.second).to_s])

          case i
            when 1
                alianza = "MUD"
            when 2
                alianza = "PSUV"
            else
                alianza = "Sin Grupo"
          end
          apariciones_alianza = apariciones.delete_if {|a| a.cuna.grupo != alianza}
      #     # alianza = pars_opos.first.cuna.organizacion.alianza if pars_opos.first

          primera = 0
          candidatos.each do |candidato|
            canales_conteo = candidato.apariciones_candidatos apariciones_alianza
            presente = false

            canales_conteo.each_value { |value| presente = true if value > 0}
            if presente
              # aux = {"fecha" => fecha, "alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
              alianza = "" if primera > 0
              aux = {"alianza" => "#{alianza}", "candidato" =>  (candidato.name) }
              # canales_conteo.each_value {|v| (v = "<b> #{v} </b> "; puts v) if v.to_i > 180}
              aux = aux.merge canales_conteo
              # aux.delete_if {|key, value| value == 0 }
              data << aux
              puts aux
              primera += 1
            end #end if presente
          end #end do candidato
        end #end for i
        i=2
        if not data.empty?
          data.each do |d|
              @sheet.row(i).concat d.values
              # d.each_value{|v| @sheet.row(i).push v; puts "VALUE:!!#{i}:#{to_utf16 v.to_s}"}
              i+=1
          end
        end
      end # end for fecha

      @book.write "Reporte_apariciones_candidatos desde #{fecha_inicial} hasta #{fecha_final}.xls"
    
  end
  
  
  def self.generar_reporte_candidatos fecha_inicial, fecha_final
    require 'pdf/writer'
    require 'pdf/simpletable'
    puts "INICIANDO ............."
    pdf = PDF::Writer.new(:paper => "letter") #:orientation => :landscape,
    
    ss = PDF::Writer::StrokeStyle.new(2)
		ss.cap = :round
		pdf.stroke_style ss
		
    # pdf.select_font "Times-Roman"
    # pdf.text "Hello, Ruby.", :font_size => 72, :justification => :center

    
    # fecha = Date.new(2012,11,28)
    fecha = fecha_inicial.to_date
    fecha_2 = fecha_final.to_date
    candidatos = Candidate.order :name
    canales = Canal.order :siglas
    pdf.start_page_numbering(450, 765, 7, nil, to_utf16("Página: <PAGENUM> de <TOTALPAGENUM>"), 1)
    pdf.text (to_utf16 ("Tiempo de Exposición de Candidatos por Día")), :justification => :center, :font_size => 10
    pdf.text "Desde '#{fecha.strftime("%d %b %Y")}' hasta '#{fecha_2.strftime("%d %b %Y")}'", :justification => :center, :font_size => 9
    pdf.text "\n"
    for fecha in fecha..fecha_2
      # data << {"fecha" => fecha}
        pdf.text (to_utf16("#{fecha.strftime("%a, %d de %b de %Y")}")), :justification => :center, :font_size => 8
      pdf.text "\n"

      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :outer
      tab.show_headings = true
      tab.shade_headings = true
      tab.shade_heading_color = Color::RGB::Metallic::Iron
      tab.heading_color = Color::RGB.new(255,255,255)
      tab.shade_rows = :striped
      tab.shade_color = Color::RGB.new(230,238,238)
      tab.shade_color2 = Color::RGB.new(250,250,250)
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 6
      tab.row_gap = 2
      tab.minimum_space = 0
      # =================== ORDEN DE COLUMNAS ===================#
      column_order  = []
      column_order << %w(alianza candidato)
      canales.each{ |c| column_order << c.siglas}
      tab.column_order = column_order.flatten

      # =================== COLUMNAS ===================#
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

      canales.each do |canal|
        tab.columns[canal.siglas] = PDF::SimpleTable::Column.new(canal.siglas) { |col|
          col.width = 50
          col.justification = :center
          col.heading = (to_utf16 canal.siglas)
          col.heading = "VV" if canal.siglas.eql? "VENEVISIÓN"
          col.heading = "GLOBO" if canal.siglas.eql? "GLOBOVISIÓN"
          col.heading = "MERI" if canal.siglas.eql? "MERIDIANO"
          col.heading.justification= :center
        }      
      end
      
      # ================================================#      
      
      
      for i in 1..3
        apariciones = Aparicion.por_fecha fecha # Aparicion.where(["momento >= ? AND momento <= ?",fecha.to_datetime, (fecha+1.day-1.second).to_s])
        # i==1 ? alianza = "MUD" : (alianza = "PSUV"; tab.show_headings = false;)
        case i
        when 1
            alianza = "MUD"
        when 2
            alianza = "PSUV"
        else
            alianza = "Sin Grupo"
        end
        #     tipo = 1; tolda = 1
        # when 4
        #     tipo = 1; tolda = 2
        # when 5
        #     tipo = 2; tolda = 3
        # else
        #     tipo = 2; tolda = 3
        # end
        tab.show_headings = false if i!=1
        
        # pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id != tipo || a.cuna.organizacion.tolda_id != tolda}
        pars_opos = apariciones.delete_if {|a| a.cuna.grupo != alianza}
        # alianza = pars_opos.first.cuna.organizacion.alianza if pars_opos.first
        data = []
        primera = 0
        candidatos.each do |candidato|
          aparicion_candidato = 0
          canales_conteo = Hash.new
          canales.each {|c| canales_conteo["#{c.siglas}"]=0}
          
          
          pars_opos.each do |par_opo|
            if par_opo.cuna.candidates.include? candidato
              aparicion_candidato += par_opo.cuna.duracion
              canales_conteo["#{par_opo.canal.siglas}"] += par_opo.cuna.duracion
            end
          end # end do par_opo
          presente = false
          canales_conteo.each_value{|v| presente = true if v > 0}
          
          
          canales_conteo.each_value do |value|
            presente = true if value > 0
            # puts "ALERTA!!!!:#{value}" if value.to_i > 180 # (value = "<b>#{value}</b>"; puts value if value.to_i > 180
            
          end
          
          if presente
            # aux = {"fecha" => fecha, "alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
            alianza = "" if primera > 0
            aux = {"alianza" => "#{alianza}", "candidato" =>  (to_utf16 candidato.name).capitalize }
            canales_conteo.each_value {|v| (v = "<b> #{v} </b> "; puts v) if v.to_i > 180}
            aux = canales_conteo.merge aux
            aux.delete_if {|key, value| value == 0 }
            data << aux
            puts aux
            primera += 1
          end #end if presente
        end #end do candidato
        if not data.empty?
          # data.each do |d|
          #   d.each do |key, value|
          #      tab.text_color = Color::RGB::Red if key != 'Alianza' && key != 'Candidato' && value.to_i > 180
          #   end 
          # end
          tab.data.replace data
          # tab.text_ 
          tab.render_on(pdf)
        end
      end #end for i
       # pdf.text "___________________________________________________________________________________________", :justification => :center
       pdf.text "\n\n"
      # break
    end # end for fecha
    
    pdf.save_as "Reporte_apariciones_candidatos desde #{fecha_inicial} hasta #{fecha_final}.pdf"
    
  end
  
  
  
  
  
  def self.generar_reporte_candidatos_2
    require 'pdf/writer'
    require 'pdf/simpletable'
    
    pdf = PDF::Writer.new(:paper => "letter") #:orientation => :landscape,
    
    ss = PDF::Writer::StrokeStyle.new(2)
		ss.cap = :round
		pdf.stroke_style ss
		
    # pdf.select_font "Times-Roman"
    # pdf.text "Hello, Ruby.", :font_size => 72, :justification => :center

    
    fecha = Date.new(2012,11,28)
    candidatos = Candidate.order :name
    canales = Canal.order :siglas
    pdf.start_page_numbering(255, 722, 7, nil, to_utf16("#{fecha.strftime("%d %b %Y")}       Página: <PAGENUM> de <TOTALPAGENUM>"), 1)
    pdf.text (to_utf16 ("Tiempo de Exposición de Candidatos por Día")), :justification => :center, :font_size => 10
    pdf.text "Desde '#{fecha.strftime("%d %b %Y")}' hasta '#{Date.today.strftime("%d %b %Y")}'", :justification => :center, :font_size => 9
    pdf.text "\n"
    for fecha in fecha..Date.yesterday
      # data << {"fecha" => fecha}
        pdf.text (to_utf16("#{fecha.strftime("%a, %d de %b de %Y")}")), :justification => :center, :font_size => 8
      pdf.text "\n"

      tab = PDF::SimpleTable.new
      tab.bold_headings = true
      tab.show_lines    = :outer
      tab.show_headings = true
      tab.shade_headings = true
      tab.shade_heading_color = Color::RGB::Metallic::Iron
      tab.heading_color = Color::RGB.new(255,255,255)
      tab.shade_rows = :striped
      tab.shade_color = Color::RGB.new(230,238,238)
      tab.shade_color2 = Color::RGB.new(250,250,250)
      tab.orientation   = :center
      tab.heading_font_size = 8
      tab.font_size = 6
      tab.row_gap = 2
      tab.minimum_space = 0
      # =================== ORDEN DE COLUMNAS ===================#
      column_order  = []
      column_order << %w(alianza candidato)
      canales.each{ |c| column_order << c.siglas}
      tab.column_order = column_order.flatten

      # =================== COLUMNAS ===================#
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

      canales.each do |canal|
        tab.columns[canal.siglas] = PDF::SimpleTable::Column.new(canal.siglas) { |col|
          col.width = 50
          col.justification = :center
          col.heading = (to_utf16 canal.siglas)
          col.heading = "VV" if canal.siglas.eql? "VENEVISIÓN"
          col.heading = "GLOBO" if canal.siglas.eql? "GLOBOVISIÓN"
          col.heading = "MERI" if canal.siglas.eql? "MERIDIANO"
          col.heading.justification= :center
        }      
      end
      
      # ================================================#      
      
      
      for i in 1..3
        apariciones = Aparicion.por_fecha fecha # Aparicion.where(["momento >= ? AND momento <= ?",fecha.to_datetime, (fecha+1.day-1.second).to_s])
        # i==1 ? alianza = "MUD" : (alianza = "PSUV"; tab.show_headings = false;)
        case i
        when 1
            alianza = "MUD"
        when 2
            alianza = "PSUV"
        else
            alianza = "Sin Grupo"
        end
        #     tipo = 1; tolda = 1
        # when 4
        #     tipo = 1; tolda = 2
        # when 5
        #     tipo = 2; tolda = 3
        # else
        #     tipo = 2; tolda = 3
        # end
        tab.show_headings = false if i!=1
        
        # pars_opos = apariciones.delete_if {|a| a.cuna.organizacion.tipo_id != tipo || a.cuna.organizacion.tolda_id != tolda}
        pars_opos = apariciones.delete_if {|a| a.cuna.grupo != alianza}
        # alianza = pars_opos.first.cuna.organizacion.alianza if pars_opos.first
        data = []
        primera = 0
        candidatos.each do |candidato|
          aparicion_candidato = 0
          canales_conteo = Hash.new
          canales.each {|c| canales_conteo["#{c.siglas}"]=0}
          
          
          pars_opos.each do |par_opo|
            if par_opo.cuna.candidates.include? candidato
              aparicion_candidato += par_opo.cuna.duracion
              canales_conteo["#{par_opo.canal.siglas}"] += par_opo.cuna.duracion
            end
          end # end do par_opo
          presente = false
          canales_conteo.each_value{|v| presente = true if v > 0}
          
          
          canales_conteo.each_value do |value|
            presente = true if value > 0
            puts "ALERTA!!!!:#{value}" if value.to_i > 180 # (value = "<b>#{value}</b>"; puts value if value.to_i > 180
            
          end
          
          if presente
            # aux = {"fecha" => fecha, "alianza" => alianza, "candidato" =>  (to_utf16 candidato.name).capitalize }
            alianza = "" if primera > 0
            aux = {"alianza" => "<b>#{alianza}</b>", "candidato" =>  (to_utf16 candidato.name).capitalize }
            aux = canales_conteo.merge aux
            aux.delete_if {|key, value| value == 0 } 
            data << aux
            puts aux
            primera += 1
          end #end if presente
        end #end do candidato
        if not data.empty?
          # data.each do |d|
          #   d.each do |key, value|
          #      tab.text_color = Color::RGB::Red if key != 'Alianza' && key != 'Candidato' && value.to_i > 180
          #   end 
          # end
          tab.data.replace data
          # tab.text_ 
          tab.render_on(pdf)
        end
      end #end for i
       # pdf.text "___________________________________________________________________________________________", :justification => :center
       pdf.text "\n\n"
      # break
    end # end for fecha
    
    pdf.save_as "Reporte_apariciones_candidatos hasta #{fecha.to_s}.pdf"
    
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