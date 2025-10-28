<?php

namespace App\Services\EmployeeInformation;

use Dao;

class BusinessHistory
{

    /**
     * Find a BusinessHistory
     *
     * @return void
     */
    function findBusinessHistory($params)
    {
        return Dao::executeSql('SPC_EM0020_LST1', $params);
    }

    /**
     * Get BusinessHistorys
     *
     * @return void
     */
    function getBusinessHistorys($params)
    {
        return Dao::executeSql('SPC_EM0020_INQ1', $params);
    }

    /**
     * Save a BusinessHistory
     * @param  Array $params
     * @return void
     */
    function saveBusinessHistory($params)
    {
        return Dao::executeSql('SPC_EM0020_ACT1', $params);
    }

    /**
     * Delete a BusinessHistory
     *
     * @return void
     */
    function deleteBusinessHistory($params)
    {
        return Dao::executeSql('SPC_EM0020_ACT2', $params);
    }
    /**
     * get Selection
     *
     * @return void
     */
    function getPopupSelection($params = [])
    {
        return Dao::executeSql('SPC_EM0020_INQ2', $params);
    }
    /**
     * Save a Selection
     *
     * @return void
     */
    function savePopupSelection($params = [])
    {
        return Dao::executeSql('SPC_EM0020_ACT3',$params);
    }

    /**
     * Del a Selection
     *
     * @return void
     */
    function deletePopupSelection($params = [])
    {
        return Dao::executeSql('SPC_EM0020_ACT4',$params);
    }
}
