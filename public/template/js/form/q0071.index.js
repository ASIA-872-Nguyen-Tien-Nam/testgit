$(function () {
    initialize();
    initEvents();
});

function initialize() {
    try {
        //$(".content nav:first .navbar-brand").text('社員履歴照会');

        var logoHeight = $('.portrait img').height();
        if (logoHeight < 104) {
            var margintop = (104 - logoHeight) / 2;
            $('.portrait img').css('margin-top', margintop);
        }

        if (matchMedia) {
            const mq = window.matchMedia("(max-width: 1366px)");
            mq.addListener(WidthChange);
            WidthChange(mq);
        }

        _formatTooltip();
    } catch (e) {
        alert('initialize' + e.message);
    }
}

function initEvents() {
    try {
        $(document).on('click', '#btn-back', function (e) {
            backScreen();
        });
        // click 社員番号
        $(document).on('click', '.sheet_cd_link', function (e) {
            try {
                e.preventDefault();
                var tr = $(this).parents('tr');
                var fiscal_year = tr.find(".fiscal_year").text();
                var sheet_kbn = $(this).data("sheet_kbn");
                var employee_cd = $('#employee_cd').text();
                var sheet_cd = $(this).data("sheet_cd");
                // var html 		= getHtmlCondition($('.container-fluid'));
                var data = {
                    'fiscal_year': fiscal_year,
                    'employee_cd': employee_cd,
                    'sheet_cd': sheet_cd,
                    'from': 'q0071',
                    'from_source': $('#from').val(),
                };
                //
                if (sheet_kbn == 1) {
                    _redirectScreen('/master/i2010', data, true);
                } else if (sheet_kbn == 2) {
                    _redirectScreen('/master/i2020', data, true);
                }
            } catch (e) {
                alert('.sheet_cd_link: ' + e.message);
            }
        });

    } catch (e) {
        alert('initEvents' + e.message);
    }
}

// media query change
function WidthChange(mq) {
    if (mq.matches) {
        $("#tb-middle thead tr th:first").removeClass("minw150");
        $("#tb-middle tbody tr td:first").removeClass("w-120px");
    } else {

    }
}
/**
 * backScreen
 *
 * @author      :   longvv - 2018/10/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function backScreen() {
    try {
        var home_url = $('#home_url').attr('href');
        var from = $('#from').val();
        // var data = {
        //     'from': 'q0071'
        // };
        // if (from == 'q2010') {
        //     _redirectScreen('/master/q2010', data);
        // } else if (from == 'i2040') {
        //     _redirectScreen('/master/i2040', data);
        // } else if (from == 'm0070') {
        //     _redirectScreen('/basicsetting/m0070', data);
        // } else if (from == 'i2050') {
        //     _redirectScreen('/master/i2050', data);
        // } else if (from == 'q0070') {
        //     _redirectScreen('/master/q0070', data);
        // } else if (from == 'evaluator') {
        //     _redirectScreen('/master/portal/evaluator', data);
        // } else {
        //     window.location.href = home_url;
        // }
        // add by viettd 2021/01/19
        if(from == ''){            
            if(_validateDomain(window.location)){
                window.location.href = home_url;
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        }else{
            window.close();
        }
    } catch (e) {
        alert('backScreen' + e.message);
    }
}

/**
 * tooltip format
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:	error array ex ['e1','e2']
 */
function _formatTooltip() {
    try {
        $('.text-overfollow').each(function (i) {
            var i = 1;
            var colorText = '';
            var element = $(this)
                .clone()
                .css({ display: 'inline', width: 'auto', visibility: 'hidden' })
                .appendTo('body');

            if (element.width() <= $(this).width()) {
                $(this).removeAttr('data-original-title');
            }
            element.remove();
        });
    } catch (e) {
        alert('format tooltip ' + e.message);
    }
}