<?php
namespace App\Services\WeeklyReport;

use Dao;

class QuestionService
{    
        
    /**
     * Using serice for（rM0100）質問マスタ
     * 
     */
    public function __construct()
    {
        
    }
    /**
     * findQuestions
     * search list authority master for leftcontent
     *  @param  array $params = [search_key,current_page,page_size,company_cd,language]
     *  @param  array 
     *
     * @return array
    */
    public function findQuestions($params = [])
    {
        return Dao::executeSql('SPC_rM0100_LST1',$params);    
    }
    /**
     * saveQuestion
     * save data of Question master
     *  @param  array $params =[json,cre_user,cre_ip,company_cd]
     *  @param  array 
     *
     * @return array
    */
    public function saveQuestion($params = [])
    {
        return Dao::executeSql('SPC_rM0100_ACT1',$params);    
    }

    /**
     * getQuestion
     * get data of Question master
     * @param  array $params = [company_cd,report_kind,question_no,language]
     * @param  array 
     *
     * @return array
    */
    public function getQuestion($params = [])
    {   
        return Dao::executeSql('SPC_rM0100_INQ1',$params);      
    }

    /**
     * deleteQuestion
     * delete data of Question master
     *  @param  array $params = [report_kind,question_no,company_cd_refer,cre_user,cre_ip,company_cd]
     *  @param  array 
     *
     * @return array
    */
    public function deleteQuestion($params = [])
    {       
        return Dao::executeSql('SPC_rM0100_ACT2',$params);   
    }
}