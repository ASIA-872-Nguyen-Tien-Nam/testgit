/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/25
 * 作成者          :   longvv – longvv@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
  qualification_nm: { type: "text", attr: "id" },
  qualification_typ: { type: "text", attr: "id" },
  arrange_order: { type: "text", attr: "id" },
};
var _flgLeft = 0;
$(document).ready(function () {
  try {
    initialize();
    initEvents();
  } catch (e) {
    alert("ready" + e.message);
  }
});

/**
 * initialize
 *
 * @author      :   longvv - 2018/06/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
  try {
    $("#qualification_nm").focus();
    //
    _formatTooltip();
  } catch (e) {
    alert("initialize: " + e.message);
  }
}
/*
 * INIT EVENTS
 * @author      :   longvv - 2018/06/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
  try {
    /* paging */
    // click page-link
    $(document).on(
      "click",
      "li.page-prev a.page-link:not(.pagging-disable)",
      function () {
        try {
          var page = $(this).attr("page");
          var search = $("#search_key").val();
          getLeftContent(page, search);
        } catch (e) {
          console.log("click page-link: " + e.message);
        }
      }
    );
    // click page-link
    $(document).on(
      "click",
      "li.page-next a.page-link:not(.pagging-disable)",
      function () {
        try {
          var page = $(this).attr("page");
          var search = $("#search_key").val();
          getLeftContent(page, search);
        } catch (e) {
          console.log("click page-link: " + e.message);
        }
      }
    );
    // click btn-search
    $(document).on("click", "#btn-search-key", function () {
      try {
        var page = 1;
        var search = $("#search_key").val();
        getLeftContent(page, search);
      } catch (e) {
        console.log("click btn-search: " + e.message);
      }
    });
    // change search-input
    $(document).on("change", "#search_key", function () {
      try {
        var page = 1;
        var search = $("#search_key").val();
        getLeftContent(page, search);
      } catch (e) {
        console.log("change search-input: " + e.message);
      }
    });
    // enter when focus search-input
    $(document).on("enterKey", "#search_key", function () {
      try {
        var page = 1;
        var search = $("#search_key").val();
        getLeftContent(page, search);
      } catch (e) {
        console.log("enter when focus search-input: " + e.message);
      }
    });
    /* end paging */

    // refer data when click item list search
    $(document).on("click", ".list-search-child", function () {
      try {
        $(".list-search-child").removeClass("active");
        $(this).addClass("active");
        getRightContent($(this).attr("id"));
      } catch (e) {
        console.log("refer data when click item list search: " + e.message);
      }
    });
    // click btn-add-new
    $(document).on("click", "#btn-add-new", function () {
      try {
        jMessage(5, function () {
          $("#qualification_nm").focus();
          $("#qualification_cd, #qualification_nm, #arrange_order").val("");
          $("#qualification_typ option:first").prop("selected", true);
          $('#mode').val(0);
          //
          $("#qualification_nm").removeClass("boder-error");
          $("#qualification_nm").next(".textbox-error").remove();
          $(".list-search-child").removeClass("active");
        });
      } catch (e) {
        console.log("click btn-add-new: " + e.message);
      }
    });
    // click btn-save
    $(document).on("click", "#btn-save", function (e) {
      try {
        jMessage(1, function (r) {
          _flgLeft = 1;
          if (r && _validate($("body"))) {
            saveData();
          }
        });
      } catch (e) {
        console.log("click btn-save: " + e.message);
      }
    });
    // click btn-delete
    $(document).on("click", "#btn-delete", function (e) {
      try {
        jMessage(3, function (r) {
          if (r) {
            deleteData();
          }
        });
      } catch (e) {
        console.log("click btn-delete: " + e.message);
      }
    });
    // click btn-back
    $(document).on("click", "#btn-back", function (e) {
      try {
        if (_validateDomain(window.location)) {
          window.location.href = "edashboard";
        } else {
          jError(
            "エラー",
            "このプロトコル又はホストドメインは拒否されました。"
          );
        }
      } catch (e) {
        console.log("click btn-back: " + e.message);
      }
    });
  } catch (e) {
    console.log(e.stack);
  }
}

/**
 * save
 *
 * @author      :   namnb - 2018/08/16 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
  try {
    var qualification_cd = $("#qualification_cd").val();
    var data = getData(_obj);
    data.data_sql.mode = $("#mode").val();
    data.data_sql.qualification_cd = qualification_cd;
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0010/save",
      dataType: "json",
      loading: true,
      data: JSON.stringify(data),
      success: function (res) {
        switch (res["status"]) {
          // success
          case OK:
            jMessage(2, function (r) {
              clearData(_obj);
              location.reload();
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
    alert("save" + e.message);
  }
}

/**
 * saviiiie
 *
 * @author      :   namnb - 2018/08/16 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
  try {
    var qualification_cd = $("#qualification_cd").val();
    var data = getData(_obj);
    data.data_sql.mode = $("#mode").val();
    data.data_sql.qualification_cd = qualification_cd;
    // send data to post
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0010/delete",
      dataType: "json",
      loading: true,
      data: JSON.stringify(data),
      success: function (res) {
        switch (res["status"]) {
          // success
          case OK:
            jMessage(4, function (r) {
              // $('#rightcontent').find('input,select,checkbox').val('');
              clearData(_obj);
              location.reload();
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
    alert("save" + e.message);
  }
}

/**
 * refer data menu left
 * @author      :   manhnd - 2024/03/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
  try {
    // send data to post
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0010/leftcontent",
      dataType: "html",
      loading: true,
      data: { current_page: page, search_key: search },
      success: function (res) {
        if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
          jMessage(164);
        } else {
          $("#leftcontent .inner").empty();
          $("#leftcontent .inner").html(res);
          // var qualification_cd = $('#qualification_cd').val();
          // $('.list-search-content div[id="'+qualification_cd+'"]').addClass('active');
          $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
          if (_flgLeft != 1) {
            $("#search_key").focus();
          } else {
            _flgLeft = 0;
          }
          _formatTooltip();
        }
      },
    });
  } catch (e) {
    alert("get left content: " + e.message);
  }
}

/**
 * refer data
 * @author      :   manhnd - 2024/03/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(qualification_cd) {
  try {
    // send data to post
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0010/rightcontent",
      dataType: "json",
      data: { qualification_cd: qualification_cd },
      success: function (res) {
        $("#qualification_cd").val(htmlEntities(res.qualification_cd));
        $("#qualification_nm").val(htmlEntities(res.qualification_nm));
        $(`#qualification_typ option[value="${res.qualification_typ}"]`).prop(
          "selected",
          true
        );
        $("#arrange_order").val(res["arrange_order"]);
        $("#qualification_nm").focus();
        $("#qualification_nm").removeClass("boder-error");
        $("#qualification_nm").next(".textbox-error").remove();
        // set mode
        $("#mode").val("1");
      },
    });
  } catch (e) {
    alert("get right content: " + e.message);
  }
}
