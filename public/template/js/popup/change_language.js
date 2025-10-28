/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 2022/08/09
 * 作成者    : namnt
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */

$(document).ready(function() {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});
function initialize() {
  try{
    var screen_emp_info = ''
    if(parent.$('#employee_cd').attr('screen') != undefined) {
    screen_emp_info = parent.$('#employee_cd').attr('screen')
    $('body').addClass(screen_emp_info)
    }
  }catch(e){
        alert('initialize: ' + e.message);
  }
}

/*
 * INIT EVENTS
 */
function initEvents(){
  try{
      $(document).on('click', '#btn-save-language', function(e) {
          // demo-message.js
          jMessage(1, function(r) {
              if ( r && _validate($('body')) ) {
                  saveData();
              }
          });
      });
  }catch(e){
        alert('initEvents: ' + e.message);
  }
}
/*
**
* save
*
* @author      :   namnt
* @author      :
* @return      :   null
* @access      :   public
* @see         :
    */
function saveData() {
    try {
        var language_id = $("#option_language option:selected").val();
        $.ajax({
            type        :   'POST',
            url         :   '/common/popup/change_language/save',
            dataType    :   'json',
            loading     :   false,
            data        :   { 'id' : language_id },
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                           var path = $(window.parent.location).attr('href');
                            if (path[path.length - 1] == '#') {
                                path = path.replace("#", "")
                            }
                            window.parent.location.replace(path);      
                        });
                        break;
                    // error
                    case NG:
                        jError(res['Exception']);
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
    } catch (e) {
        alert('save');
    }
}
