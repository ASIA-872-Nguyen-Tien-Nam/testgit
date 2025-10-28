<?php
namespace App\Services\WeeklyReport;

use Dao;

class SheetService
{    
        
    /**
     * Using serice for（ rM0200 ）シートマスタ
     * 
     */
    public function __construct()
    {
        
    }
    /**
     * register a new record
     *
     * @param  Array $params
     * @return Array
     */
    public function register($params)
    {
        $res = Dao::executeSql('SPC_rM0200_ACT1',$params);
        return $res;
    }

    /**
     * Get a record
     *
     * @param  Array $params
     * @return Array
     * @author namnt 
     * @created at 2023/04/10
     */
    public function getRightContent($params)
    {
        $res = Dao::executeSql('SPC_rM0200_FND1',$params);
        $data['refer'] = $res[0];
        $data['option_report_kind'] = $res[2];
        $data['question'] = $res[1];
        return $data;
    }
     /**
     * Get a record
     *
     * @param  Array $params
     * @return Array
     * @author namnt 
     * @created at 2023/04/10
     */
    public function getLeftContent($params)
    {
        $data['menu'] = Dao::executeSql('SPC_rM0200_INQ1',$params);
        $data['list'] = [
            ["name"=>__('rm0120.reaction')],
            ["name"=> __('rm0120.reply')],
            ];
        $data['paging'] = $data['menu'][3][0];
        $data['search_key'] = $data['menu'][3][0]['search_key'];
        return $data;
    }
     /**
     * delete a record
     *
     * @param  Array $params
     * @return Array
     * @author namnt 
     * @created at 2023/04/10
     */
    public function delete($params)
    {
        $result = Dao::executeSql('SPC_rM0200_ACT2',$params);
        return $result;
    }
}