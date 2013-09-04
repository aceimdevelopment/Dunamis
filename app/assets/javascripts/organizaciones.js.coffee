# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# $ ->
#   
#     $("#horario_id").change ->
#       valor = $(this).val()    
#       unless valor is ""
#         $.ajax
#           url: "/aceim/admin_seccion/elegir_ubicacion_segun_horario?identificador=#{valor}",
#           success: (datos) ->
#             $('#ubicacion').html(datos)  
#             return
# 
# 
# 
# 						<div class="btn-group" data-toggle="buttons-radio">
# 						  <%= @toldas.each do |tolda| %>
# 							<%= f.button "#{tolda.nombre}", :type => 'button', :class=> "btn btn-primary", :value => "#{tolda.id}", :id => "organizacion_tolda_id_#{tolda.id}", :name => "organizacion[#{tolda.id}]" %>
# 						  <% end %>
# 						</div>
# 
# $ ->
#   menu = $("ul.dropdown")
#   
#   displayOptions = (e) ->
#     e.show()
#   hideOptions = (e) ->
#     e.find("li").hide()
#     e.find("li.active").show()
#   
#   menu.click ->
#     displayOptions $(this).find("li")
# 
#   menu.find("li").click ->
#     hideOptions $(this)


