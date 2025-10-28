<?php

namespace App\Services;

use Dao;

class MiraiService
{
    /**
     * find fiscal year from company & date 
     *
     * @param  Int $company_cd
     * @param  Int $system      1.人事評価 | 2.1on1 | 3.Mulitireview | 4.BasicSetting | 5.WeeklyReport
     * @param  Date $year_mon_day
     * @return Int
     */
    public function findFiscalYearFromDate($company_cd = 0, $system = 1, $year_mon_day = '')
    {
        $params['company_cd'] = $company_cd;
        $params['system'] = $system;
        $params['year_mon_day'] = $year_mon_day;
        $result = Dao::executeSql('SPC_GET_FISCAL_YEAR', $params);
        return $result[0][0]['fiscal_year'] ?? 0;
    }

    /**
     * cacheReports
     *
     * @param  String $json
     * @return Array
     */
    public function cacheReports($json = '')
    {
        $params['sesion_key'] = session_data()->login_key ?? '';
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['user_id'] = session_data()->user_id ?? '';
        $params['json'] = $json;
        $reports =  Dao::executeSql('SPC_WEEKLYREPORT_CACHE_REPORTS_ACT1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports[0] ?? [];
    }
}
