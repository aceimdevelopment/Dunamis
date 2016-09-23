// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require twitter/bootstrap
//= require select2
//= require select2_locale_es
//= require jquery-sortable
//= require_self
//= require_tree .

// $(document).ready(function() {
//   $("select").select2();
// 
//   $(".get_desencientes").change(function(){
//           var aux = $(this);
//           var next_select = aux.next("select");
//           var value = $("option:selected", aux).attr("value");
//           if(value && next_select){
//                   next_select = next_select.first();
//                   $.get("/estados" + "?" + aux.attr("estado_id") + "=" + value, function(data){
//                           var municipios = eval(data);
//                           next_select.html("");
//                           var options = ""
//                           for(i=0;i<municipios.length;i++){
//                                   options += "<option value='" + municipios[i].id +"'>" + municipios[i].nombrerai + "</option>";
//                           }
//                           next_select.append(options);
//                   });
//           }
//   });
// 
// });

$(function(){
  
});


$(document).ready(function() {
  return $("#organizacion_estado_id").change(function() {
    var estado_id = $(this).val()
		$.get("controller/update_municipios_select.html?estado_id="+estado_id, 
		        function(data){ $("#municipioSelectDiv").html(data); } );
		
  });
});

// Dropdown display menu bar
$(document).ready(function() {
	$(".selects2").select2();
	$('.dropdown-toggle').dropdown();
	$('.tooltip').tooltip();
	$('.nav-tabs').button();
});
	


// 
// function myfun(estado_id){
// 	municipios = document.getElementById('organizacion_municipio_id')
// 	
// 	//<%# municipios_estado = Municipio.where(:estado_id => estado_id) %>
// 	alert("valor2:"+estado_id+municipios.options);
// 	var sel = document.createElement("select");
// 	var opt1 = document.createElement("option");
// 	var opt2 = document.createElement("option");
// 	
// 	opt1.value = "1";
// 	opt1.text = "Option: Value 1";
// 
// 	opt2.value = "2";
// 	opt2.text = "Option: Value 2";
// 
// 	sel.add(opt1, null);
// 	sel.add(opt2, null);
// 	
// 	municipios = sel
// 	// $("#organizacion_municipio_id").html('<%# options_from_collection_for_select(@municipios, "id", "nombre") %>');
// }



//function myfun(estado_id){
	//alert("valor:"+estado_id);
	//<%# @municipios = Municipio.where(:estado_id => estado_id) %>
	// $("#organizacion_municipio_id").html('<%# options_from_collection_for_select(@municipios, "id", "nombre") %>');
//}

  // note that we're assigning in reverse order
  // to allow the chaining change trigger to work
  // cat.selectChain({
  //     target: el,
  //     url: 'select-chain.php',
  //     data: { ajax: true }
  // }).trigger('change');
//});