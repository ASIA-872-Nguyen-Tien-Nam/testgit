<?php

namespace App\Services\EmployeeInformation;

use Dao;

class EmployeeInfor
{

    /**
     * Get Combobox conditions add
     *
     * @return void
     */
    function getCombobox($params)
    {
        return Dao::executeSql('SPC_eQ0100_INQ1', $params);
    }

    /**
     * get a EmployeeInfor
     * @param  Array $params
     * @return void
     */
    function getEmployeeInfors($params)
    {
        return Dao::executeSql('SPC_eQ0100_LST1', $params);
    }

    /**
     * searchEmployeeInformation
     *
     * @param  String $json
     * @return Array
     */
    function searchEmployeeInfor($json)
    {
        $params['json'] = $json;
        $params['mode'] = 0;
        $params['user_id'] = session_data()->user_id ?? '';
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['json_employee'] = '';
        return Dao::executeSql('SPC_eQ0100_FND1', $params);
    }
}
