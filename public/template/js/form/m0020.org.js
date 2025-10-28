$(document).ready(function() {
    $('.ck-value').on('change', function() {
        if ($(this).is(':checked')) {
            $(this).parents('.row-x').find('.ck-nm').addClass('required');
        }
        else {
            $(this).parents('.row-x').find('.ck-nm').removeClass('required');
        }
    });
	$('#btn-save-x').on('click', function() {
		var data = [];
		for (var i=1; i<=5; i++) {
			var organization_group_nm = $('#organization_group_nm'+i.toString()).val();
			var use_typ = $('#use_typ'+i.toString()).is(':checked')?1:0;
			data.push({use_typ: use_typ, organization_group_nm: organization_group_nm});
		}
		$.ajax({
            type        :   'POST',
            data        :   JSON.stringify(data),
            url         :   '/basicsetting/m0020/saveorg',
            loading: true,
            contentType: "json",
    		processData: false,
            success: function(res) {
                $('.boder-error').removeClass('.boder-error');
                $('.textbox-error').remove();
                $('.sept').remove();
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(2, function(r) {
                            $('#btn-close-popup').trigger('click');
                        });
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
                            processError(res['errors']);
                        }
                        $('.textbox-error').after('<div class="sept" style="height: 1px;"></div>');
                        break;
                    case 405:
                        jMessage(27, function () {
                        });
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }

            }
        });
	});
});