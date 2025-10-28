<?php

namespace App\Services\WeeklyReport;

use Dao;

class WeeklyReportService
{

    /**
     * get list report kinds of company
     *
     * @param  Int $company_cd
     * @param  String $order_by
     * @return Array
     */
    public function getReportKinds($company_cd = 0, $order_by = 'asc')
    {
        $params['company_cd']   =   $company_cd;
        $params['language']     =   session_data()->language;
        $params['order_by']     =   $order_by;
        $report_kinds = Dao::executeSql('SPC_WEEKLYREPORT_GET_REPORT_KIND', $params);
        if (isset($report_kinds[0][0]['error_typ']) && $report_kinds[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data =  $report_kinds ?? [];
        return $data;
    }
    /**
     * Get a record
     *
     * @param  Array $params
     * @return Array
     */
    public function getSchedule($company_cd = 0, $report_group_list = [])
    {
        $params['company_cd']           =   $company_cd;
        $params['report_group_list']    =   $report_group_list;
        return Dao::executeSql('SPC_WEEKLYREPORT_SCHEDULE_FND1', $params);
    }

    /**
     * Get all reports for approvers
     *
     * @param  String $employee_cd
     * @param  Int $fiscal_year
     * @param  Int $report_kind
     * @param  Int $year
     * @param  Int $month
     * @param  Int $times
     * @param  Int $unapproved_only
     * @param  Int $approved_show
     * @return Array
     */
    public function getReportsForApprover(
        $employee_cd = '',
        $fiscal_year = 0,
        $report_kind = 0,
        $year = -1,
        $month = -1,
        $times = -1,
        $mygroup_cd = -1,
        $belong_cd1 = '-1',
        $belong_cd2 = '-1',
        $belong_cd3 = '-1',
        $unapproved_only = 0,
        $approved_show = 0
    ) {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['employee_cd'] = $employee_cd;
        $params['fiscal_year'] = $fiscal_year;
        $params['report_kind'] = $report_kind;
        $params['year'] = $year;
        $params['month'] = $month;
        $params['times'] = $times;
        $params['mygroup_cd'] = $mygroup_cd;
        $params['belong_cd1'] = $belong_cd1;
        $params['belong_cd2'] = $belong_cd2;
        $params['belong_cd3'] = $belong_cd3;
        $params['unapproved_only'] = $unapproved_only;
        $params['approved_show'] = $approved_show;
        $reports =  Dao::executeSql('SPC_rDashboard_LST3', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports[0] ?? [];
    }

    /**
     * Get all reports for viewers
     *
     * @param  String $employee_cd
     * @param  Int $fiscal_year
     * @param  Int $json
     * @return Array
     */
    public function getReportsForViewers(
        $employee_cd = '',
        $fiscal_year = 0,
        $year = -1,
        $month = -1,
        $times = -1,
        $report_kind = -1,
        $mygroup_cd = -1,
        $shared_report = 0,
        $approved_show = 0,
        $belong_cd1 = '-1',
        $belong_cd2 = '-1',
        $belong_cd3 = '-1',
        $belong_cd4 = '-1',
        $belong_cd5 = '-1'
    ) {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['employee_cd'] = $employee_cd;
        $params['fiscal_year'] = $fiscal_year;
        $params['year'] = $year;
        $params['month'] = $month;
        $params['times'] = $times;
        $params['report_kind'] = $report_kind;
        $params['mygroup_cd'] = $mygroup_cd;
        $params['shared_report'] = $shared_report;
        $params['approved_show'] = $approved_show;
        $params['belong_cd1'] = $belong_cd1;
        $params['belong_cd2'] = $belong_cd2;
        $params['belong_cd3'] = $belong_cd3;
        $params['belong_cd4'] = $belong_cd4;
        $params['belong_cd5'] = $belong_cd5;
        $reports =  Dao::executeSql('SPC_rDashboard_LST4', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports[0] ?? [];
    }

    /**
     * Get all reports for reporters
     *
     * @param  String $employee_cd
     * @param  Int $year
     * @param  Int $month
     * @return Array
     */
    public function getReportsForReporter($employee_cd = '', $year = -1, $month = -1)
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['employee_cd'] = $employee_cd;
        $params['year'] = $year;
        $params['month'] = $month;
        $reports =  Dao::executeSql('SPC_rDashboard_LST1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports[0] ?? [];
    }

    /**
     * Get schedule setting
     *
     * @param  Int $company_cd
     * @param  Int $mode        0.GET REPORT KINDS | 1.GET FISCAL_YEAR	| 2. GET MONTH | 3.GET TIMES | 4. GET GROUP 
     * @param  Int $fiscal_year
     * @param  Int $report_kind
     * @param  Int $month
     * @param  Int $year
     * @return Array
     */
    public function getScheduleSetting($company_cd = 0, $mode = 0, $fiscal_year = 0, $report_kind = 0, $month = 0, $group = 0, $detail_no = 0, $year = 0)
    {
        $params['company_cd'] = $company_cd;
        $params['mode'] = $mode;
        $params['fiscal_year'] = $fiscal_year;
        $params['report_kind'] = $report_kind;
        $params['month'] = $month;
        $params['lang'] = session_data()->language;
        $params['detail_no'] = $detail_no ?? 0;
        $params['group'] = $group ?? 0;
        $params['year'] = $year ?? 0;
        $schedules = Dao::executeSql('SPC_WEEKLYREPORT_SCHEDULE_SETTING', $params);
        if (isset($schedules[0][0]['error_typ']) && $schedules[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $schedules[0] ?? [];
    }

    /**
     * Get informations
     *
     * @param  Int $infomation_typ  1:通知 2:アラート 3:リアクション 4.共有
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @return Array
     */
    public function getInfomations($infomation_typ = 0, $fiscal_year = 0, $employee_cd = '')
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['employee_cd'] = $employee_cd;
        $params['fiscal_year'] = $fiscal_year;
        $params['infomation_typ'] = $infomation_typ;
        $informations =  Dao::executeSql('SPC_rDashboard_LST2', $params);
        if (isset($informations[0][0]['error_typ']) && $informations[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $informations[0] ?? [];
    }

    /**
     * find report by report_no
     *
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $report_kind
     * @param  Int $report_no
     * @param  String $session_key
     * @return Array
     */
    public function findReportByCd($fiscal_year = 0, $employee_cd = '', $report_kind = 0, $report_no = 0, $session_key = '')
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['fiscal_year'] = $fiscal_year;
        $params['employee_cd'] = $employee_cd;
        $params['report_kind'] = $report_kind;
        $params['report_no'] = $report_no;
        $params['session_key'] = $session_key;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $report =  Dao::executeSql('SPC_rI2010_INQ1', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report ?? [];
    }

    /**
     * find report detail by report_no
     *
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $report_kind
     * @param  Int $report_no
     * @param  Int $reaction_typ
     * @return Array
     */
    public function findReportDetailByCd($fiscal_year = 0, $employee_cd = '', $report_kind = 0, $report_no = 0, $reaction_typ = 0)
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['fiscal_year'] = $fiscal_year;
        $params['employee_cd'] = $employee_cd;
        $params['report_kind'] = $report_kind;
        $params['report_no'] = $report_no;
        $params['reaction_typ'] = $reaction_typ;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $report =  Dao::executeSql('SPC_rI2010_LST1', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report ?? [];
    }

    /**
     * findPermissonReportForUser
     *
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $report_kind
     * @param  Int $report_no
     * @param  Int $login_user_type
     * @return Array
     */
    public function findPermissonReportForUser($fiscal_year = 0, $employee_cd = '', $report_kind = 0, $report_no = 0, $login_user_type = 0)
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['fiscal_year'] = $fiscal_year;
        $params['employee_cd'] = $employee_cd;
        $params['report_kind'] = $report_kind;
        $params['report_no'] = $report_no;
        $params['login_user_type'] = $login_user_type;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $report =  Dao::executeSql('SPC_rI2010_INQ2', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report[0][0] ?? [];
    }

    /**
     * save a report
     *
     * @param  Array $report
     * @param  Int $login_user_type
     * @return Array
     */
    public function saveReport($report = [], $login_user_type = 0)
    {
        if (empty($report)) {
            return [];
        }
        $params['json'] = json_encode($report);
        $params['login_user_type'] = $login_user_type;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $report =  Dao::executeSql('SPC_rI2010_ACT1', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report ?? [];
    }

    /**
     * get reaction comments for report
     *
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $report_kind
     * @param  Int $report_no
     * @param  Int $mode
     * @return Array
     */
    public function getReactionCommentsForReport($fiscal_year = 0, $employee_cd = '', $report_kind = 0, $report_no = 0, $mode = 0)
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['fiscal_year'] = $fiscal_year;
        $params['employee_cd'] = $employee_cd;
        $params['report_kind'] = $report_kind;
        $params['report_no'] = $report_no;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['mode'] = $mode;
        $reaction_comment =  Dao::executeSql('SPC_rI2010_LST2', $params);
        if (isset($reaction_comment[0][0]['error_typ']) && $reaction_comment[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reaction_comment[0] ?? [];
    }

    /**
     * reply reaction
     *
     * @param  Array $params
     * @return Array
     */
    public function replyReaction($params = [])
    {
        if (empty($params)) {
            return [];
        }
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $report =  Dao::executeSql('SPC_rI2010_ACT2', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report??[];
    }

    /**
     * save comment temporary
     *
     * @param  Array $params
     * @return Array
     */
    public function saveComment($params = [])
    {
        if (empty($params)) {
            return [];
        }
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $report =  Dao::executeSql('SPC_rI2010_ACT3', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report[0][0] ?? [];
    }
    /**
     * postTranslate temporary
     *
     * @param  Array $params
     * @return Array
     */
    public function saveTranslate($report = [],$trans_user ='')
    {
        if (empty($report)) {
            return [];
        }
        $params['json'] = json_encode($report);
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['trans_user'] = $trans_user ?? '';
        $report =  Dao::executeSql('SPC_rI2010_ACT9', $params);
        // if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
        //     return response()->view('errors.query', [], 501);
        // }
        return $report[0][0] ?? [];
    }
            /**
     * save a target with findTr
     *
     * @return Array
     */
    public function findTranslate($fiscal_year = 0, $report_kind = 0, $report_no = 0,$employee_cd='')
    {
        $params['company_cd'] = session_data()->company_cd;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['fiscal_year'] = $fiscal_year;
        $params['report_kind'] = $report_kind;
        $params['report_no'] = $report_no;
        $params['employee_cd'] = $employee_cd;
        return Dao::executeSql('SPC_rI2010_INQ4', $params);
    }

    /**
     * confirm a report
     *
     * @param  Array $params
     * @return Array
     */
    public function confimReport($params = [])
    {
        if (empty($params)) {
            return [];
        }
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $report =  Dao::executeSql('SPC_rI2010_ACT4', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report[0][0] ?? [];
    }

    /**
     * get viewers for report
     *
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $report_kind
     * @param  Int $report_no
     * @param  Int $page
     * @param  Int $page_size
     * @return Array
     */
    public function getViewersForReport($fiscal_year = 0, $employee_cd = '', $report_kind = 0, $report_no = 0, $page = 1, $page_size = 50)
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['fiscal_year'] = $fiscal_year;
        $params['employee_cd'] = $employee_cd;
        $params['report_kind'] = $report_kind;
        $params['report_no'] = $report_no;
        $params['page'] = $page;
        $params['page_size'] = $page_size;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $viewers =  Dao::executeSql('SPC_rI2010_LST3', $params);
        if (isset($viewers[0][0]['error_typ']) && $viewers[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $viewers ?? [];
    }

    /**
     * get sharing employees for report
     *
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $report_kind
     * @param  Int $report_no
     * @param  Int $page
     * @param  Int $page_size
     * @return Array
     */
    public function getSharingEmployeesForReport($params = [])
    {
        $params_data['fiscal_year'] = $params['fiscal_year'] ?? 0;
        $params_data['employee_cd'] = $params['employee_cd'] ?? '';
        $params_data['report_kind'] = $params['report_kind'] ?? 0;
        $params_data['report_no'] = $params['report_no'] ?? 0;
        $params_data['page'] = $params['page'] ?? '';
        $params_data['page_size'] = $params['page_size'] ?? 0;
        $params_data['employee_cd_key'] = $params['employee_cd_key'] ?? '';
        $params_data['employee_nm_key'] = $params['employee_nm_key'] ?? '';
        $params_data['employee_typ'] = $params['employee_typ'] ?? -1;
      
        $params_data['belong_cd1'] = $params['belong_cd1'] ?? '-1';
        $params_data['belong_cd2'] = $params['belong_cd2'] ?? '-1';
        $params_data['belong_cd3'] = $params['belong_cd3'] ?? '-1';
        $params_data['belong_cd4'] = $params['belong_cd4'] ?? '-1';
        $params_data['belong_cd5'] = $params['belong_cd5'] ?? '-1';
        $params_data['job_cd'] = $params['job_cd'] ?? -1;
        $params_data['position_cd'] = $params['position_cd'] ?? -1;
        $params_data['group_cd'] = $params['group_cd'] ?? -1;
        $params_data['mygroup_cd'] = $params['mygroup_cd'] ?? -1;
        $params_data['company_cd'] = session_data()->company_cd ?? 0;
        $params_data['login_employee_cd'] = session_data()->employee_cd ?? '';

        $shares =  Dao::executeSql('SPC_rI2010_LST4', $params_data);
        if (isset($shares[0][0]['error_typ']) && $shares[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $shares ?? [];
    }

    /**
     * share report for employees
     *
     * @param  Array $report
     * @return Array
     */
    public function shareReport($report = [])
    {
        if (empty($report)) {
            return [];
        }
        $params['json'] = json_encode($report);
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $report =  Dao::executeSql('SPC_rI2010_ACT6', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report[0][0] ?? [];
    }

    /**
     * read notifications
     *
     * @param  Array $report
     * @return Array
     */
    public function readNotification($params = [])
    {
        if (empty($params)) {
            return [];
        }
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $report =  Dao::executeSql('SPC_rDashboard_ACT1', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report[0][0] ?? [];
    }

    /**
     * get reports for search page (rQ2010)
     *
     * @param  Array $params
     * @return Array
     */
    public function getReportsForPage($params = [],$option = false)
    {
        if (empty($params)) {
            return [];
        }
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['number_org'] = sizeof(getCombobox('M0022', 1, 5));
        // 
        $reports =  Dao::executeSql('SPC_rQ2010_FND1', $params,$option);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }
    /**
     * getSubmissionRateAnalysis (rQ3010)
     *
     * @param  String $json
     * @param  Int $mode 0:SEARCH/1:OUTPUT EXCEL/2.CROSS
     * @return Array
     */
    public function getSubmissionRateAnalysis($json = '', $mode = 0)
    {
        $params['language'] = session_data()->language;
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['mode'] = $mode;
        // 
        $reports =  Dao::executeSql('SPC_rQ3010_FND1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }

    /**
     * getAdequacyAnalysis (rQ3020)
     *
     * @param  String $json
     * @param  Int $mode 0:SEARCH/1:OUTPUT EXCEL/2.CROSS
     * @return Array
     */
    public function getAdequacyAnalysis($json = '', $mode = 0)
    {
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['mode'] = $mode;
        // 
        $reports =  Dao::executeSql('SPC_rQ3020_FND1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }

    /**
     * getReactionAnalysis (rQ3030)
     *
     * @param  String $json
     * @param  Int $mode 0:SEARCH/1:OUTPUT EXCEL/2.CROSS
     * @return Array
     */
    public function getReactionAnalysis($json = '', $mode = 0)
    {
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['mode'] = $mode;
        // 
        $reports =  Dao::executeSql('SPC_rQ3030_FND1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }

    /**
     * getCrossAnalysis (rQ3040)
     *
     * @param  String $json
     * @return Array
     */
    public function getCrossAnalysis($json = '')
    {
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $params['cre_user'] = session_data()->user_id ?? '';
        // 
        $reports =  Dao::executeSql('SPC_rQ3040_FND1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }

    /**
     * findLoginUserType
     *
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $report_kind
     * @param  Int $report_no
     * @return Int
     */
    public function findLoginUserType($fiscal_year = 0, $employee_cd = '', $report_kind = 0, $report_no = 0)
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['fiscal_year'] = $fiscal_year;
        $params['employee_cd'] = $employee_cd;
        $params['report_kind'] = $report_kind;
        $params['report_no'] = $report_no;
        $params['login_employee_cd'] = session_data()->employee_cd ?? '';
        $report =  Dao::executeSql('SPC_rI2010_INQ3', $params);
        if (isset($report[0][0]['error_typ']) && $report[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $report[0][0]['login_use_typ'] ?? 0;
    }
        /**
     * Get Group For Sheet
     * @param  Int $report_kind
     * @return Array
     */
    public function getGroupForSheet($report_kind = 0)
    {
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['report_kind'] = $report_kind;
        $reports = Dao::executeSql('SPC_rI1010_INQ2', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports[0] ?? [];
    }
}
