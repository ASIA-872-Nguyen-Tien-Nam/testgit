<?php 
namespace App\Services;

use Dao;

class QuestionService {
    /**
     * findQuestions
     * search list authority master for leftcontent
     *  @param  array $params
     *  @param  array 
     *
     * @return array
    */
    public function findQuestions($params = [])
    {
        
        return Dao::executeSql('SPC_oM0110_LST1',$params);
        
    }
    /**
     * getQuestion
     * get data of Question master
     * @param  array $params
     * @param  array 
     *
     * @return array
    */
    public function getQuestion($params = [])
    {
        
        return Dao::executeSql('SPC_oM0110_INQ1',$params);
        
    }
    /**
     * saveQuestion
     * save data of Question master
     *  @param  array $params
     *  @param  array 
     *
     * @return array
    */
    public function saveQuestion($params = [])
    {
        
        return Dao::executeSql('SPC_oM0110_ACT1',$params);
        
    }
    /**
     * deleteQuestion
     * delete data of Question master
     *  @param  array $params
     *  @param  array 
     *
     * @return array
    */
    public function deleteQuestion($params = [])
    {
        
        return Dao::executeSql('SPC_oM0110_ACT2',$params);
        
    }
}


