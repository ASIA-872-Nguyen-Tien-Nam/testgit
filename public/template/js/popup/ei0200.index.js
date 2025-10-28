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
var _obj = {
  initial_floor_id: { type: "text", attr: "id" },
  employee_cd: { type: "text", attr: "id" },
  tr: {
    attr: "list",
    item: {
      field_cd: { type: "text", attr: "class" },
      registered_value: { type: "text", attr: "class" },
    },
  },
};
var _clearFile = 0;
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
    // set focus
    if ($("#initial_floor_id").closest('.col.mw-3st').hasClass('d-none')) {
      $('#ei0200_popup .btn-upload').focus();
    }
    else {
      $("#initial_floor_id").focus();
    }
    // 
    $("#ei0200_popup")
      .closest(".popup-wrapper")
      .find(".header-right-function.nav-menubar-pc .nav-item a")
      .attr("tabindex", "3")
      .addClass("btn-save-popup-ei0200-pc");
    $("#ei0200_popup")
      .closest(".popup-wrapper")
      .find(".header-right-function.nav-menubar-mobile img")
      .attr("tabindex", "3")
      .addClass("btn-open-fncbtns");
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
    // start handle action for pc
    // tab btn 登録
    $(document).on("keydown", ".btn-save-popup-ei0200-pc", function (event) {
      try {
        if (!event.shiftKey && event.keyCode == 9) {
          event.preventDefault();
          $("#initial_floor_id").focus();
        }
      } catch (e) {
        alert("tab btn 登録: " + e.message);
      }
    });
    // shift tab item 座席表に初期表示するフロア
    $(document).on(
      "keydown",
      "#initial_floor_id",
      function (event) {
        try {
          if (event.shiftKey && event.keyCode == 9) {
            event.preventDefault();
            $(".btn-save-popup-ei0200-pc").focus();
          }
        } catch (e) {
          alert("tab item 座席表に初期表示するフロア: " + e.message);
        }
      }
    );
    // end handle action for pc

    // start handle action for mobile
    // press enter or space when focus btn open list function btns in popup
    $(document).on("keydown", ".btn-open-fncbtns", function (event) {
      try {
        if (event.keyCode == 13 || event.keyCode == 32) {
          event.preventDefault();
          $(this).trigger("click");
        }
      } catch (e) {
        console.log(
          "press enter or space when focus btn open list function btns in popup: " +
            e.message
        );
      }
    });
    // tab btn open list function-btns in popup
    $(document).on("keydown", ".btn-open-fncbtns", function (event) {
      try {
        if (!event.shiftKey && event.keyCode == 9) {
          event.preventDefault();
          $("#initial_floor_id").focus();
        }
      } catch (e) {
        alert("tab btn open list function-btns in popup: " + e.message);
      }
    });
    // shift tab item 座席表に初期表示するフロア
    $(document).on(
      "keydown",
      "#initial_floor_id",
      function (event) {
        try {
          if (event.shiftKey && event.keyCode == 9) {
            event.preventDefault();
            $(".btn-open-fncbtns").focus();
          }
        } catch (e) {
          alert("tab item 座席表に初期表示するフロア: " + e.message);
        }
      }
    );

    // end handle action for mobile

    // click btn-upload
    $(document).on("click", "#ei0200_popup .btn-upload", function () {
      try {
        $("#image-input").trigger("click");
      } catch (e) {
        console.log("click btn upload: " + e.message);
      }
    });
    // change input image (hidden)
    $(document).on("change", "#image-input", function () {
      try {
        readURL(this);
      } catch (e) {
        console.log("change input image (hidden): " + e.message);
      }
    });
    // click btn-clearfile
    $(document).on("click", "#ei0200_popup .btn-clearfile", function () {
      try {
        var img_message = $("#ei0200_popup .img .flex-box").attr("img_message");
        var html = `<p class="w-100">${img_message}</p><img src="" alt="">`;
        $("#ei0200_popup .img .flex-box").empty();
        $("#ei0200_popup .img .flex-box").append(html);
        // update status
        _clearFile = 1;
      } catch (e) {
        alert("click btn-clearfile: " + e.message);
      }
    });

    // click btn-save
    $(document).on('click', '#btn-save-ei0200', function () {
      try {
        jMessage(1, function (r) {
          if (r) {
            saveData();
          }
        });
      } catch (e) {
        console.log('click btn-save: ' + e.message);
      }
    });
  } catch (e) {
    alert("initEvents: " + e.message);
  }
}

/**
 * readURL
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function readURL(input) {
  try {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $("#ei0200_popup .img img").attr("src", e.target.result);
        $("#ei0200_popup .img img").closest("div").find("p").remove();
      };
      reader.readAsDataURL(input.files[0]);
      // update status
      _clearFile = 0;
    }
  } catch (e) {
    console.log("readURL: " + e.message);
  }
}

/**
 * save
 * @author      :   manhnd - 2024/04/02 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
  try {
    var data = getData(_obj);
    data.data_sql['clear_file'] = _clearFile;
    var formData = new FormData();
    formData.append("body", JSON.stringify(data));
    var file = $('#image-input').prop('files');
    if (file.length > 0) {
        formData.append('file', file[0]);
    }
    // send data to post
    $.ajax({
      type: "POST",
      data: formData,
      url: "/common/popup/ei0200",
      enctype: "multipart/form-data",
      cache: false,
      contentType: false,
      processData: false,
      success: function (res) {
        switch (res["status"]) {
          // success
          case OK:
            //
            jMessage(2, function (r) {
              // do something
            });
            break;
          // error
          case NG:
            if (typeof res["errors"] != "undefined") {
              processError(res["errors"]);
            }
            break;
          // Exception
          case EX:
            jError(res["Exception"]);
            break;
          default:
            break;
        }
      },
    });
  } catch (e) {
    console.log('click btn-save: ' + e.message);
  }
}