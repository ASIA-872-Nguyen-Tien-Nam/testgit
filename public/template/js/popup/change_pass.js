/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 2018/07/03
 * 作成者    : longvv - longvv@ans-asia.com
 *
 *  作成日    : 2018/09/11
 * 作成者    : tuantv - tuantv@ans-asia.com
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
var _obj = {
    'user_id'            : {'type':'text', 'attr':'id'},
    'old_password'      : {'type':'text', 'attr':'id'},
    'new_password'      : {'type':'text', 'attr':'id'},
    'cf_new_password'   : {'type':'text', 'attr':'id'},
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
      var screen_emp_info = ''
      if(parent.$('#employee_cd').attr('screen') != undefined) {
      screen_emp_info = parent.$('#employee_cd').attr('screen')
      $('body').addClass(screen_emp_info)
      }
       $('#old_password').focus();
      //Remove Password Pop Up For Firefox
      if(navigator.userAgent.indexOf("Firefox") != -1 ){
          $("#old_password").attr('type','password');
          $("#new_password").attr('type','password');
          $("#cf_new_password").attr('type','password');
          $(document).on('click','#btn-close-popup',function(){
              $("#old_password").attr('type','text');
              $("#new_password").attr('type','text');
              $("#cf_new_password").attr('type','text');
          });
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
    document.addEventListener('keydown', function (e) {
        if (e.keyCode  === 9) {
          if (e.shiftKey) {
           if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
            e.preventDefault();
            if($('#end_tab a:not([readonly],[disabled],:hidden)').last().length!=0){
              $('#end_tab a:not([readonly],[disabled],:hidden)').last()[0].focus();
            }
             else{
              var max = -1;
               $(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
                max = Math.max(max, +b);
              });
              $(":input:not([readonly],[disabled],:hidden)[tabindex="+max+"]").focus();
            }
            return;
          }
            if($(':focus')[0] === $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first()[0]){
              $('#btn_search').focus();
              return;
            }
          var max = -1;
          $(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
            max = Math.max(max, +b);
          });

          if ($(':focus')[0] === $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first()[0]) {
            e.preventDefault();
            $(":input:not([readonly],[disabled],:hidden)[tabindex="+max+"]").focus();
          } 
        }else{
          if ($(':focus')[0] === $('#end_tab a:not([readonly],[disabled],:hidden)').last()[0]) {
                e.preventDefault();
                $(':input:not(.disabled,.no-focus,.disable,:hidden,[disabled])').first().focus();
              }
        
        }
            
        }
    });
      $(document).on('click', '#btn-save', function(e) {
          // demo-message.js
          jMessage(1, function(r) {
              if ( r && _validate($('body')) ) {
                  saveData();
              }
          });
      });
      //
      $(document).on('keyup','#old_password,#new_password,#cf_new_password',function(){
        var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
        if (regex.test($(this).val()) ) {
          $(this).val('');
        }
      });
      //
      $(document).on('blur','#old_password,#new_password,#cf_new_password',function(){
        var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
        if (regex.test($(this).val()) ) {
          $(this).val('');
        }
      });
  }catch(e){
        alert('initEvents: ' + e.message);
  }
}
/*
**
* save
*
* @author      :   tuantv - 2018/09/11 - create
* @author      :
* @return      :   null
* @access      :   public
* @see         :
    */
function saveData() {
    try {
        var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/common/popup/change_pass/save',
            dataType    :   'json',
            loading     :   false,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                        });
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
                            //processError(res['errors']);
                            if(res['errors'][0].message_no == '50') {
                                jMessage(50, function () {
                                    /*$("#old_password").val("");*/
                                    $("#old_password").focus();
                                });
                            }
                            if(res['errors'][0].message_no == '51') {
                                jMessage(51, function () {
                                    /*$("#new_password").val("");
                                    $("#cf_new_password").val("");*/
                                    $("#new_password").focus();
                                });
                            }
                            if(res['errors'][0].message_no == '52') {
                                jMessage(52, function () {
                                    /*$("#new_password").val("");*/
                                    $("#new_password").focus();
                                });
                            }
                            if(res['errors'][0].message_no == '53') {
                                jMessage(53, function () {
                                   /* $("#new_password").val("");
                                    $("#cf_new_password").val("");*/
                                    $("#new_password").focus();
                                });
                            }
                            console.log(res['errors']);
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
