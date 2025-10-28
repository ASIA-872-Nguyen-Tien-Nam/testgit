<?php

namespace App\Services\EmployeeInformation;

use Dao;

class Training
{


    /**
     * Find a training
     *
     * @return void
     */
    function findTraining($params = [])
    {
        return Dao::executeSql('SPC_EM0030_LST1',$params);
    }

    /**
     * Get trainings
     *
     * @return void
     */
    function getTrainings($params = [])
    {
        return Dao::executeSql('SPC_EM0030_INQ1',$params);
    }

    /**
     * Save a training
     *
     * @return void
     */
    function saveTraining($params = [])
    {
        return Dao::executeSql('SPC_EM0030_ACT1',$params);
    }
    /**
     * Delete a Qualification
     *
     * @return void
     */
    function deleteTraining($params = [])
    {
        return Dao::executeSql('SPC_EM0030_ACT2', $params);
    }
    /**
     * get training
     *
     * @return void
     */
    function getPopupTraining($params = [])
    {
        return Dao::executeSql('SPC_EM0030_INQ2', $params)[0] ?? [];
    }
    /**
     * Save a training
     *
     * @return void
     */
    function savePopupTraining($params = [])
    {
        return Dao::executeSql('SPC_EM0030_ACT3',$params);
    }

    /**
     * Save a training
     *
     * @return void
     */
    function deletePopupTraining($params = [])
    {
        return Dao::executeSql('SPC_EM0030_ACT4',$params);
    }
}
