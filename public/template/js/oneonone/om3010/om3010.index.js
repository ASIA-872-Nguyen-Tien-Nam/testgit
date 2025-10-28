/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/02/05
 * 作成者          :   phuhv – phuhv@ans-asia.com
 *
 * @package         :   
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 * ****************************************************************************
 */
$(function(){
    try{
        initEvents();
        initialize();  
    }catch(e){
        alert('initialize: ' + e.message);
    }
});
/**
 * initialize
 *
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initialize() {
    try{
        $('#table-data tbody tr:nth-child(6) td:nth-child(3)').find('.other').show();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * initEvents
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initEvents() {
    try{
        $('#table-data tbody tr:nth-child(6) td:nth-child(3)').find('.frequency').val(4);

        // click open video
        $(document).on('change', '.frequency', function(e) {
            try{
            	if($(this).val()==4) {
                    $(this).closest('.form-inline').find('.other').show();
                } else {
                    $(this).closest('.form-inline').find('.other').hide();
                }
            }catch(e){
                alert('open video: '+e.message);
            }
        });

    } catch(e){
        alert('initEvents: ' + e.message);
    }
}