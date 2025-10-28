/**
 * ****************************************************************************
 * MIRAI
 *
 * 作成日               : 2024/03/05
 * 作成者               : manhnd - manhnd@ans-asia.com
 *
 * @package             : MODULE EMPLOYEEINFO
 * @copyright           : Copyright (c) ANS-ASIA
 * @version             : 2.1.0
 * ****************************************************************************
 */
$(document).ready(function () {
  try {
    initialize();
    initEvents();
  } catch (e) {
    alert("ready: " + e.message);
  }
});
/**
 * initialize
 *
 * @author		:	manhnd - 2024/03/05 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
  try {
    $("#eq0200_board_popup ul.nav li.nav-item:first a").focus();
    _formatTooltip();
  } catch (e) {
    alert("initialize: " + e.message);
  }
}

/**
 * initEvents
 *
 * @author		:	manhnd - 2024/03/05 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
  try {
    // tab item 保有資格
    $(document).on(
      "keydown",
      "#eq0200_board_popup ul.nav li.nav-item:last a",
      function (event) {
        try {
          if (!event.shiftKey && event.keyCode == 9) {
            event.preventDefault();
            $("#eq0200_board_popup ul.nav li.nav-item:first a").focus();
          }
        } catch (e) {
          alert("tab item 保有資格: " + e.message);
        }
      }
    );
    // shift tab item プロフィール
    $(document).on(
      "keydown",
      "#eq0200_board_popup ul.nav li.nav-item:first a",
      function (event) {
        try {
          if (event.shiftKey && event.keyCode == 9) {
            event.preventDefault();
            $("#eq0200_board_popup ul.nav li.nav-item:last a").focus();
          }
        } catch (e) {
          alert("shift tab item プロフィール: " + e.message);
        }
      }
    );
  } catch (e) {
    alert("initEvents: " + e.message);
  }
}

function _formatTooltip(){
  try{
      $('.text-overfollow').each(function(i) {
          var i = 1;
          var colorText = '';
          var element = $(this)
              .clone()
              .css({display: 'inline', width: 'auto', visibility: 'hidden'})
              .appendTo('body');

          if( element.width() <= $(this).width() ) {
              $(this).removeAttr('data-original-title');
          }
          element.remove();
      });
  }catch(e){
      alert('format tooltip '+e.message);
  }
}