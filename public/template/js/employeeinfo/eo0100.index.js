/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日               :    2024/04/11
 * 作成者               :    manhnd – manhnd@ans-asia.com
 *
 * @package             :    MODULE EMPLOYEEINFO
 * @copyright           :    Copyright (c) ANS-ASIA
 * @version             :    2.1.0
 * ****************************************************************************
 */
$(document).ready(function () {
  try {
    initialize();
    initEvents();
  } catch (e) {
    alert("ready" + e.message);
  }
});

/*
 * INITIALIZE
 * @author      :   manhnd
 * @created at  :   2024/04/11
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
  try {
  } catch (e) {
    alert("initialize: " + e.message);
  }
}
/*
 * INIT EVENTS
 * @author      :   manhnd
 * @created at  :   2024/04/11
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
  try {
    // click input fake-upload
    $(document).on("click", ".fake-input-upload", function () {
      try {
        $("#real-input").trigger("click");
      } catch (e) {
        console.log("click input fake-upload: " + e.message);
      }
    });
    // change real imput upload
    $(document).on("change", "#real-input", function (e) {
      try {
        var files = e.target.files;
        var text_no_file = $("#text_no_file").val();
        if (files.length > 0) {
          var filename = files[0].name;
          $(".ln-text-file").text(filename);
        } else {
          $(".ln-text-file").text(text_no_file);
        }
      } catch (e) {
        console.log("change real imput upload: " + e.message);
      }
    });

    // click btn-export
    $(document).on("click", "#btn-data-output", function (e) {
      try {
        exportCSV();
      } catch (e) {
        console.log("click btn-export: " + e.message);
      }
    });

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

    // click btn-import
    $(document).on("click", "#btn-data-input", function (e) {
      try {
        var import_file = $("#real-input")[0].files[0];
        if (import_file != undefined) {
          jMessage(6, function () {
            importCSV();
          });
        } else {
          jMessage(21, function (r) {});
        }
      } catch (e) {
        alert("btn-data-input: " + e.message);
      }
    });
  } catch (e) {
    alert("initEvents:" + e.message);
  }
}

/*
 * importCSV
 * @author      :   manhnd
 * @created at  :   2024/04/11
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
  try {
    var target_employee_field = $("#target_employee_field").val();
    var name_file = $('#real-input')[0].files[0].name;
    var formData = new FormData();
    formData.append("file", $("#real-input")[0].files[0]);
    formData.append("target_employee_field", target_employee_field);
    // call ajax
    $.ajax({
      type: "POST",
      data: formData,
      url: "/employeeinfo/eo0100/import",
      loading: true,
      processData: false,
      contentType: false,
      enctype: "multipart/form-data",
      success: function (res) {
        //
        switch (res["status"]) {
          // success
          case 200:
            jMessage(7, function (r) {
              location.reload();
            });
            break;
          // error
          case 201:
            jMessage(22);
            break;
          // check error file is not csv
          case 205:
            jMessage(27);
            break;
          // check nubmer item per row in file csv
          case 206:
            // jMessage(31);
            // break;
            jMessage(31, function (r) {
              $("#import_file").val("");
              $(".ln-text-file").text(text_no_file);
            });
            break;
          case 207:
            var filedownload = res["FileName"];
            if (filedownload != "") {
              downloadfileHTML(
                filedownload,
                name_file.split(".").slice(0, -1) + "_" + error + ".csv",
                function () {
                  //
                }
              );
            }
            break;
          // Exception
          case EX:
            //jError(res['Exception']);
            break;
          default:
            break;
        }
      },
    });
  } catch (e) {
    alert("importCSV: " + e.message);
  }
}

/*
 * exportCSV
 * @author      :   manhnd
 * @created at  :   2024/04/11
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV() {
  try {
    var data = {};
    var target_employee_field = $("#target_employee_field").val();
    data.target_employee_field = target_employee_field;
    //
    $.ajax({
      type: "POST",
      url: "/employeeinfo/eo0100/export",
      dataType: "json",
      loading: true,
      data: data,
      success: function (res) {
        // success
        switch (res["status"]) {
          case OK:
            var csv_name = "";
            if (target_employee_field == 1) {
              csv_name = qualification_master.replace(/\s/g, "") + ".csv";
            } else if (target_employee_field == 2) {
              csv_name = training_master.replace(/\s/g, "") + ".csv";
            } else {
              csv_name = "";
            }
            //
            var filedownload = res["FileName"];
            if (filedownload != "") {
              downloadfileHTML(
                "/download/" + filedownload,
                csv_name,
                function () {
                  //
                }
              );
            } else {
              jMessage(21);
            }
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
    alert("exportCSV: " + e.message);
  }
}
