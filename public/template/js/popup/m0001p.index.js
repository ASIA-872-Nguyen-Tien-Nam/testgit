/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 2018/07/03
 * 作成者    : longvv - longvv@ans-asia.com
 *
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : url customer
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
 var _obj = {
    'company_cd'                            : {'type':'text', 'attr':'id'},
    'm0001_user_id'                         : {'type':'text', 'attr':'id'},
    'password'                              : {'type':'text', 'attr':'id'},
    'sso_user'                              : {'type':'text', 'attr':'id'},
};
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
       $('#m0001_user_id').focus();
       console.log($('#check_sso').val());
       if($('#check_sso').val() == 1){
            $('#password').prop({disabled: true});
       }else{
            $('#sso_user').prop({disabled: true});
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
       $(document).on('click', '#btn-save', function(e) {
         try{
            jMessage(1, function(r) {
              if ( r && _validate($('body')) ) {
                saveData();
              }
            });
          }catch(e){
            alert('btn-save: ' + e.message);
          }
        });
  }catch(e){
        alert('initEvents: ' + e.message);
  }
}
/**
 * save
 * 
 * @author      :   longvv - 2018/09/05 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function saveData() {
    try {
        var data = getData(_obj);
        var url = _customerUrl('master/m0001/savepopup');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url, 
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            $('#btn-close-popup').trigger('click');
                            var company_cd = $('#company_cd').val();
                            parent.$('.list-search-child[id="'+company_cd+'"]').trigger('click');
                            parent.$('body').css('overflow','scroll');
                        });
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
                            processError(res['errors']);
                        }
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
        alert('save' + e.message);
    }
}