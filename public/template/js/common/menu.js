/**
 * ****************************************************************************
 * ANS ASIA
 *
 * Created Date         : 2020/09/08
 * Created By           : datnt - datnt@ans-asia.com
 *
 * Updated Date         :
 * Updated By           :
 * Updated Content      :
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
$(document).ready(function () {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});
function initialize() {

}
/**
 * initialize
 *
 * @author		:	datnt - 2020/09/08 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try {
        $(document).on('click', '#evalution_screen', function (e) {
            window.open('/menu/rdashboard');
        });
        $(document).on('click', '#oneonone_screen_admin', function (e) {
            window.open('/oneonone/odashboardadmin');
        });
        $(document).on('click', '#oneonone_screen_coach', function (e) {
            window.open('/oneonone/odashboard');
        });
        $(document).on('click', '#oneonone_screen_member', function (e) {
            window.open('/oneonone/odashboardmember');
        });
        $(document).on('click', '#mdashboardsupporter_screen', function (e) {
            window.open('/multiview/mdashboardsupporter');
        });
        $(document).on('click', '#mdashboard_screen ', function (e) {
            window.open('/multiview/mdashboard');
        });
        $(document).on('click', '#sdashboard_screen', function (e) {
            window.open('/basicsetting/sdashboard');
        });
        $(document).on('click', '#weekly_report_admin', function (e) {
            window.open('/weeklyreport/rdashboard');
        });
        $(document).on('click', '#weekly_report_repoter', function (e) {
            window.open('/weeklyreport/rdashboardreporter');
        });
        $(document).on('click', '#weekly_report_aproval', function (e) {
            window.open('/weeklyreport/rdashboardapprover');
        });
        $(document).on('click', '#eq0200_screen', function (e) {
            window.open('/employeeinfo/eq0200');
        });
        $(document).on('click', '#eq0100_screen', function (e) {
            window.open('/employeeinfo/eq0100');
        });
        $(document).on('click', '#edashboard_screen', function (e) {
            window.open('/employeeinfo/edashboard');
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}
