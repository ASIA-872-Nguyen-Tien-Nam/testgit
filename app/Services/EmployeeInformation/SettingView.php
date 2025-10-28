<?php

namespace App\Services\EmployeeInformation;

use Dao;

class SettingView
{

    /**
     * Get Tabs and Authorites
     *
     * @return void
     */
    function getTabsAndAuthorities($params)
    {
        return Dao::executeSql('SPC_eM0100_LST1', $params);
    }

    /**
     * Get Tabs and Authorites
     *
     * @return void
     */
    function saveTabAuthority($params)
    {
        return Dao::executeSql('SPC_eM0100_ACT1', $params);
    }
}
