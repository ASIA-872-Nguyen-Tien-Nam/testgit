var _obj = {
    // 'company_cd'                            : {'type':'text', 'attr':'id'},
    // 'm0001_user_id'                         : {'type':'text', 'attr':'id'},
    // 'password'                              : {'type':'text', 'attr':'id'},
    // 'sso_user'                              : {'type':'text', 'attr':'id'},
};
$(document).ready(function () {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});

/**
 * initialize
 * 
 * @author      :   viettd - 2023/02/13 - create
 * @return      :   null
 */
function initialize() {
    try {

    } catch (e) {
        alert('initialize: ' + e.message);
    }
}

/**
 * initEvents
 * 
 * @author      :   viettd - 2023/02/13 - create
 * @author      :   
 * @return      :   null
 */
function initEvents() {
    try {
        $(document).on("click", ".dropdown dt a", function () {
			try {
				if ($(this).hasClass('disabled')) {
					return
				} else {
					$("#data-select").toggle();
				}
			} catch (e) {
				alert('.dropdown dt a' + e.message);
			}
		});
        $(document).mouseup(function (e) {
			try {
				var container = $(".table-select");
				// if the target of the click isn't the container nor a descendant of the container
				if (!container.is(e.target) && container.has(e.target).length === 0) {
					$("#data-select").hide();
				}
			} catch (e) {
				alert('mouseup' + e.message);
			}
		});
        $(document).on("click", ".tr-select", function () {
			try {
				var text = $(this).find(".image_select").html();
				$(".dropdown").find("span").html(text);
				$("#data-select").hide();
			} catch (e) {
				alert('tr-select' + e.message);
			}
		});
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}