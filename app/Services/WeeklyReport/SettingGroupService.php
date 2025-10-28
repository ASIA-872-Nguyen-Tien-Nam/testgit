<?php
namespace App\Services\WeeklyReport;

use Dao;

class SettingGroupService
{    
        
    /**
     * Using serice for（ rM0010 ）利用設定
     * 
     */
    public function __construct()
    {
        
    }
    /**
     * register a new record
     * @author namnt
     * @created at 2023-04-18
     * @return \Illuminate\Http\Response
     */
    public function register($params)
    {
        return Dao::executeSql('SPC_RM0300_ACT1',$params);
    }

    /**
     * get a record
     * @author namnt
     * @created at 2023-04-18
     * @return \Illuminate\Http\Response
     */
    public function get($params)
    {
        return Dao::executeSql('SPC_RM0300_INQ1',$params);
    }

    /**
     * find a record
     * @author namnt
     * @created at 2023-04-18
     * @return \Illuminate\Http\Response
     */
    public function find($params)
    {
        return Dao::executeSql('SPC_RM0300_LST1',$params);
    }
    public function delete($params)
    {
        return Dao::executeSql('SPC_RM0300_ACT2',$params);
    }

}