/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日            :    2018/08/28
 * 作成者            :    SonDH – sondh@ans-asia.com
 *
 * @package        :    MODULE MASTER
 * @copyright        :    Copyright (c) ANS-ASIA
 * @version        :    1.0.0
 * ****************************************************************************
 */
var _obj = {
  tabs: {
    attr: "list",
    item: {
      authority_cd: { type: "text", attr: "class" },
      tab_id: { type: "text", attr: "class" },
      use_typ: { type: "checkbox", attr: "class" },
    },
  },
};
$(function () {
  try {
    initEvents();
    initialize();
  } catch (e) {
    alert("initialize: " + e.message);
  }
});
/**
 * initialize
 *
 * @author    : SonDH - 2018/08/27 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
  try {
  } catch (e) {
    alert("initialize: " + e.message);
  }
}
/*
 * INIT EVENTS
 * @author    : SonDH - 2018/08/27 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
  try {
    // click btn-back
    $(document).on("click", "#btn-back", function () {
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
    // change checkbox-setting
    $(document).on("change", "#table-em0100 .checkbox-setting", function () {
      try {
        var is_checked = $(this).is(":checked");
        var column = $(this).closest("th").attr("column");
        if (is_checked == true) {
          $(`#table-em0100 thead tr th[column="${column}"] .checkbox-all`).attr(
            "disabled",
            false
          );
          $(`#table-em0100 tbody tr td[column="${column}"] .checkbox`).attr(
            "disabled",
            false
          );
        } else {
          $(`#table-em0100 thead tr th[column="${column}"] .checkbox-all`).attr(
            "disabled",
            true
          );
          $(`#table-em0100 tbody tr td[column="${column}"] .checkbox`).attr(
            "disabled",
            true
          );
          // disable all checkbox
          $(
            `#table-em0100 thead tr th[column="${column}"] .checkbox-all, #table-em0100 tbody tr td[column="${column}"] .checkbox`
          ).prop("checked", false);
        }
      } catch (e) {
        console.log("change checkbox-all: " + e.message);
      }
    });
    // change checkbox-all
    $(document).on("change", "#table-em0100 .checkbox-all", function () {
      try {
        var is_checked = $(this).is(":checked");
        var column = $(this).closest("th").attr("column");
        if (is_checked == true) {
          $(`#table-em0100 tbody tr td[column="${column}"] .checkbox`)
            .prop("checked", true)
            .val("1");
        } else {
          $(`#table-em0100 tbody tr td[column="${column}"] .checkbox`)
            .prop("checked", false)
            .val("0");
        }
      } catch (e) {
        console.log("change checkbox-all: " + e.message);
      }
    });
    // change checkbox
    $(document).on("change", "#table-em0100 .checkbox", function () {
      try {
        // var column = $(this).closest("td").attr("class");
        var column = $(this).closest("td").attr("column");
        var total_chk = $("#table-em0100 tbody tr").length;
        var count_chked = $(
          `#table-em0100 tbody tr td[column="${column}"] .checkbox:checked`
        ).length;
        $(`#table-em0100 thead tr th[column="${column}"] .checkbox-all`).prop(
          "checked",
          false
        );
        if (total_chk == count_chked) {
          $(`#table-em0100 thead tr th[column="${column}"] .checkbox-all`).prop(
            "checked",
            true
          );
        }
        $(this).is(":checked") ? $(this).val("1") : $(this).val("0");
      } catch (e) {
        console.log("change checkbox: " + e.message);
      }
    });
    // click btn-save
    $(document).on("click", "#btn-save", function () {
      try {
        jMessage(1, function (r) {
          if (r) {
            saveData();
          }
        });
      } catch (e) {
        console.log("click btn-save: " + e.message);
      }
    });
  } catch (e) {
    console.log("initEvents: " + e.message);
  }
}

/**
 * save
 * @author      :   manhnd - 2024/03/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
  try {
    var data = getData(_obj);
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0100/save",
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
