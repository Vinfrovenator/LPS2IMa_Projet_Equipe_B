$(document)
.ajaxStart(function () {
	$('#ajax-spinner').show();
})
.ajaxStop(function () {
	$('#ajax-spinner').hide();
})
.ready(function() {
	
	var oldTab = null;
	var tab = null;
	
    $('#I_TEMPS .lv2, #I_REGION .lv2').each(function() {
        $(this).html('&nbsp;&nbsp;&nbsp;' + $(this).html());
    });

    $('#I_TEMPS .lv3, #I_REGION .lv3').each(function() {
        $(this).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + $(this).html());
    });

    $('#I_TEMPS .lv4, #I_REGION .lv4').each(function() {
        $(this).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + $(this).html());
    });

	$('ul#main-tabs li a').on('click', function() {
		tab = $(this).attr('href').substr(1);
		
		/* Titre onglet */
		var title = $(this).html();
		title += ' | '+$('#I_REGION option:selected').html().replace(/&nbsp;/gi,'');
		title += ' | '+$('#I_ENSEIGNE option:selected').html();
		title += ' | '+$('#I_INDICATEUR option:selected').html();
		title += $('#I_CUMUL:checked').val() ? ' (cumulé)':'',
		title += ' | '+$('#I_FAMPROD option:selected').html();
		if ($('#I_TEMPS option:selected').hasClass('lv1')) {
			title += ' | Année';
		}
		else {
			title += ' | '+$('#I_TEMPS option:selected').html().replace(/&nbsp;/gi,'');
		}
		if (tab == 'historique') {
			title += ' '+(parseInt($('#I_TEMPS option:selected').val()) - 1);
			title += '/'+$('#I_TEMPS option:selected').val().substr(0,4);
		}
		else {
			title += ' '+$('#I_TEMPS option:selected').val().substr(0,4);
		}
		$('#ajax_'+tab+'_tabtitle').html(title);
		
		// Si changement d'onglet
		if (tab != oldTab) {
			/* Reset Filtres */
			$('#I_INDICATEUR option[value="0"]').show();
			$('#I_CUMUL').prop('disabled', false);
			$('#I_INDICATEUR').prop('disabled', false);
			$('#I_INDICATEUR option[value="0"]').prop('selected', true);
			$('#I_FAMPROD').prop('disabled', false);
			
			/* Altération Filtres */
			switch(tab) {
				case 'accueil':
					$('#I_INDICATEUR').prop('disabled', true);
					$('#I_FAMPROD').prop('disabled', true);
					break;
				case 'historique':
					$('#I_INDICATEUR option[value="0"]').hide();
					$('#I_INDICATEUR option[value="1"]').prop('selected', true);
					$('#I_CUMUL').prop('disabled', true);
					break;
			}
		}
		oldTab = tab;
		
		/* Contenu onglet via Ajax*/
		$.ajax({
			cache: false,
			data: getFiltresData($),
			dataType: 'json',
			//dataType: 'text',
			method: 'POST',
			url: window.location.pathname+'index.php/ajax/tab/'+tab+'?TIME='+(new Date()).getTime(),
		})
		.done(function(response) {
			$.each(response, function(key,value){
				//$('#'+key).html(value);
				if (key != 'ajax_accueil_imgsrc') {
					$('#'+key).html(value);
					if (key.slice(-5) == 'table') {
						
						$('#'+key+' table').tablesorter();
						
						$('#'+key+' table td[data-mnt]').each(function() {
							if($(this).html() != '—') {
								$(this).html($.number($(this).data('mnt'), 2)+'&nbsp;€');
							}
						});
						
						$('#'+key+' table td[data-op="%"]').each(function() {
							var reel = $(this).prev().data('mnt');
							var obj = $(this).prev().prev().data('mnt');
							if (reel == '—' || obj == '—') {
								$(this).html('—');
							}
							else {
								var per = (obj/reel*100);
								$(this).html($.number(per, 2)+'&nbsp;%');
								if (per >= 105) {
									$(this).addClass('bg-success');
								}
								else if (per <= 95) {
									$(this).addClass('bg-danger');
								}
								else {
									$(this).addClass('bg-warning');
								}
							}
						});
						
					}				
				}
				else {
					//$('#ajax_accueil_img').attr('src', value);
				}
			});
		});
	});
	
	$('#I_ENSEIGNE, #I_INDICATEUR, #I_CUMUL, #I_FAMPROD, #I_TEMPS, #I_REGION').on('change', function() {
		$('ul#main-tabs li.active a').trigger('click');
	});

	$('#RAZ_FILTRES').on('click', function() {
		$('#I_ENSEIGNE, #I_INDICATEUR, #I_FAMPROD, #I_TEMPS, #I_REGION').each(function() {
			$(this).val($(this).find("option:visible:first").val());
		});
		$('#I_CUMUL').prop('checked', false);
		$('ul#main-tabs li.active a').trigger('click');
	});
	
	$('#print').on('click', function() {
		$('#'+tab).print();
	});
	
    var tour = new Tour({
      template:  "<div class='popover tour'><div class='arrow'></div><h3 class='popover-title'></h3><div class='popover-content'></div><div class='popover-navigation'><div class='btn-group'><button class='btn btn-sm btn-default' data-role='prev'>« Précédent</button><button class='btn btn-sm btn-default' data-role='next'>Suivant »</button></div><button class='btn btn-sm btn-default' data-role='end'>Fin</button></div></div>",
      steps: [{
        element: "#I_REGION",
        title: "Zone géographique",
        content: "Cette liste permet de choisir la zone géographique utilisée dans les rapports"
      }, {
        element: "#I_ENSEIGNE",
        title: "Enseigne",
        content: "Cette liste permet de choisir l'enseigne utilisée dans les rapports"
      }, {
        element: "#I_INDICATEUR",
        title: "Indicateur",
        content: "Cette liste permet de choisir l'indicateur utilisée dans les rapports"
      }, {
        element: "#I_CUMUL",
        title: "Cumul",
	    content: "Cette case permet d'utiliser le cumul dans les rapports si elle est cochée"
	  }, {
        element: "#I_FAMPROD",
        title: "Famille produit",
	    content: "Cette liste permet de choisir la famille de produit utilisée dans les rapports"
	  }, {
        element: "#I_TEMPS",
        title: "Période",
	    content: "Cette liste permet de choisir la période utilisée dans les rapports"
	  }, {
        element: "#main-tabs",
        title: "Navigation",
		placement: "bottom",
	    content: "Vous pouvez naviguer entre les quatre onglets"
	  }, {
        element: "#right-tabs",
        title: "Options",
		placement: "bottom",
	    content: "Boutons d'options (impression, envoie par mail, déconnexion, aide utilisateur)"
	  } ]
    })
	.init();

	$('#help').on('click', function() {
		tour.restart();
	});

	/* Init */
	$('ul#main-tabs li:first a').trigger('click');

  }
);


function getFiltresData($) {
	return {
		'I_ENSEIGNE'  : $('#I_ENSEIGNE').val(),
		'I_INDICATEUR': $('#I_INDICATEUR').val(),
		'I_CUMUL'	  : $('#I_CUMUL:checked').val() ? 0:1,
		'I_FAMPROD'   : $('#I_FAMPROD').val(),
		'I_TEMPS'	  : $('#I_TEMPS').val(),
		'I_REGION' 	  : $('#I_REGION').val(),
	};
}