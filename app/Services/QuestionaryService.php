<?php
namespace App\Services;

use Dao;

class QuestionaryService
{
    public function __construct()
    {
    	//
    }
    /**
     *  search item for left content
     *  @param  integer $company_cd
     *  @param  string  $key_search
     *  @param  integer $page
     *  @param  integer $page_size
     *  @param  integer $submit
     *
     *  @return array
    */
    public function findQuestionarys($company_cd = 0,$key_search = '',$page = 1,$page_size = 20,$submit=0,$mode)
    {
        $params = [
            'search_key'    => $key_search,
            'current_page'  => $page,
            'page_size'     => $page_size,
            'company_cd'    => $company_cd, 
            'submit'        => $submit,
            'mode'          => $mode 
        ];
        return Dao::executeSql('SPC_OM0400_LST1',$params);
    }

    /**
     *  refer item for rightcontent
     *  @param  integer $company_cd
     *  @param  integer $questionnaire_cd
     *
     *  @return array
    */
    public function getQuestionary($company_cd = 0,$questionnaire_cd = 0)
    {
        $params = [
            'questionnaire_cd'          => $questionnaire_cd,
            'company_cd'    	        => $company_cd,
            'employee_cd'               => session_data()->employee_cd,
        ];
        return Dao::executeSql('SPC_OM0400_INQ1',$params);
    }

    /**
     *  save item
     *  @param  integer $company_cd
     *  @param  json    $params
     *
     *  @return array
    */
    public function saveQuestionary($company_cd = 0,$params = '')
    {
        return Dao::executeSql('SPC_OM0400_ACT1',$params);
    }

    /**
     *  delete item
     *  @param  integer $company_cd
     *  @param  integer $item_cd
     *
     *  @return array
    */
    public function deleteQuestionary($company_cd = 0,$params = '')
    {
        return Dao::executeSql('SPC_OM0400_ACT2',$params);
    }
}