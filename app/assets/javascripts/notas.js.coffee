# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	eliminar_nota = (nota_id) ->
		$.post "/notas/update/" + nota_id + "?resumen_id=nil"
		location.reload()
		false
