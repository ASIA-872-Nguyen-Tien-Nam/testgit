<?php

namespace App\Services;

use Dao;

class EmployeeTabAuthorityService
{
    public function __construct()
    {
    }

    /**
     * getListTab
     *
     * @param  Int $company_cd
     * @return void
     */
    public function getListTab($company_cd = 0, $lang)
    {
        // dd($lang);
        $params = [
            'company_cd'    => $company_cd,
            'lang'          => $lang,
        ];
        return Dao::executeSql('SPC_EMPLOYEE_TAB_AUTHORITY', $params);
    }

    /**
     * findEmployeeInformationByTab
     *
     * @param  Int $company_cd
     * @param  String $employee_cd
     * @param  String $user_id
     * @param  Int $tab
     * @return Array
     */
    function findEmployeeInformationByTab($company_cd = 0, $employee_cd = '', $user_id = '', $tab = 0)
    {
        $params = [
            'employee_cd' => $employee_cd,
            'company_cd' => $company_cd,
            'user_id' => $user_id,
        ];
        // Tab 1.その他社員情報
        if ($tab == 1) {
            return Dao::executeSql('SPC_M0070_01_INQ1', $params);
        }
        // Tab 2.資格
        if ($tab == 2) {
            return Dao::executeSql('SPC_M0070_02_INQ1', $params);
        }
        // Tab 3.研修受講履歴
        if ($tab == 3) {
            return Dao::executeSql('SPC_M0070_03_INQ1', $params);
        }
        // Tab 4.業務経歴
        if ($tab == 4) {
            return Dao::executeSql('SPC_M0070_04_INQ1', $params);
        }
        // Tab 5.学歴
        if ($tab == 5) {
            return Dao::executeSql('SPC_M0070_05_INQ1', $params);
        }
        // Tab 6.連絡先
        if ($tab == 6) {
            return Dao::executeSql('SPC_M0070_06_INQ1', $params);
        }
        // Tab 7.通勤
        if ($tab == 7) {
            return Dao::executeSql('SPC_M0070_07_INQ1', $params);
        }
        // Tab 8.家族
        if ($tab == 8) {
            return Dao::executeSql('SPC_M0070_08_INQ1', $params);
        }
        // Tab 9.休職
        if ($tab == 9) {
            return Dao::executeSql('SPC_M0070_09_INQ1', $params);
        }
        // Tab 10.有期雇用契約
        if ($tab == 10) {
            return Dao::executeSql('SPC_M0070_10_INQ1', $params);
        }
        // Tab 11.社会保険
        if ($tab == 11) {
            return Dao::executeSql('SPC_M0070_11_INQ1', $params);
        }
        // Tab 12.給与
        if ($tab == 12) {
            return Dao::executeSql('SPC_M0070_12_INQ1', $params);
        }
        // Tab 13.賞罰
        if ($tab == 13) {
            return Dao::executeSql('SPC_M0070_13_INQ1', $params);
        }
        // Tab 14.人事評価
        if ($tab == 14) {
            return Dao::executeSql('SPC_M0070_14_INQ1', $params);
        }
        if ($tab == 0) {
            return Dao::executeSql('SPC_M0070_HEADER_INQ1', $params);
        }
        if ($tab == 18) {
            return Dao::executeSql('SPC_EQ0101_INQ2', $params);
        }
    }

    /**
     * saveEmployeeInformationByTab
     *
     * @param  Array $company_cd
     * @param  Int $tab
     * @return Array
     */
    function saveEmployeeInformationByTab($params = [], $tab = 0)
    {
        // Tab 1.その他社員情報
        if ($tab == 1) {
            return Dao::executeSql('SPC_M0070_01_ACT1', $params);
        }
        // Tab 2.資格
        if ($tab == 2) {
            return Dao::executeSql('SPC_M0070_02_ACT1', $params);
        }
        // Tab 3.研修受講履歴
        if ($tab == 3) {
            return Dao::executeSql('SPC_M0070_03_ACT1', $params);
        }
        // Tab 4.業務経歴
        if ($tab == 4) {
            return Dao::executeSql('SPC_M0070_04_ACT1', $params);
        }
        // Tab 5.学歴
        if ($tab == 5) {
            return Dao::executeSql('SPC_M0070_05_ACT1', $params);
        }
        // Tab 6.連絡先
        if ($tab == 6) {
            return Dao::executeSql('SPC_M0070_06_ACT1', $params);
        }
        // Tab 7.通勤
        if ($tab == 7) {
            return Dao::executeSql('SPC_M0070_07_ACT1', $params);
        }
        // Tab 8.家族
        if ($tab == 8) {
            return Dao::executeSql('SPC_M0070_08_ACT1', $params);
        }
        // Tab 9.休職
        if ($tab == 9) {
            return Dao::executeSql('SPC_M0070_09_ACT1', $params);
        }
        // Tab 10.有期雇用契約
        if ($tab == 10) {
            return Dao::executeSql('SPC_M0070_10_ACT1', $params);
        }
        // Tab 11.社会保険
        if ($tab == 11) {
            return Dao::executeSql('SPC_M0070_11_ACT1', $params);
        }
        // Tab 12.給与
        if ($tab == 12) {
            return Dao::executeSql('SPC_M0070_12_ACT1', $params);
        }
        // Tab 13.賞罰
        if ($tab == 13) {
            return Dao::executeSql('SPC_M0070_13_ACT1', $params);
        }
    }
}
