<?php

namespace App\Services;

use Illuminate\Support\Collection;
use Dao;

class AnalysisService
{
    const IMPLEMENTATION_STATUS = 1;    // 1.実施状況
    const ADEQUACY = 2; //2.充実度
    const QUESTIONNAIRE_RESULT = 3; //3.アンケート結果

    public function __construct()
    {
    }

    /**
     * getImplementationStatus (oq2030)
     *
     * @param  int $company_cd
     * @param  string $json 
     * @param  string $user_id
     * @param  int $mode
     * @return array
     */
    public function getImplementationStatus($params)
    {
        //2022/08/23
        $language = session_data()->language;
        array_unshift($params, $language);
        return Dao::executeSql('SPC_oQ2030_FND1', $params);
    }

    /**
     * getFulfillmentResult (oq2031)
     *
     * @param  int $company_cd
     * @param  string $json
     * @param  string $user_id
     * @param  int $mode
     * @return array
     */
    public function getFulfillmentResult($params)
    {
        //2022/08/23
        $language = session_data()->language;
        array_unshift($params, $language);
        return Dao::executeSql('SPC_oQ2031_FND1', $params);
    }

    /**
     * getQuestionnaireResult (oq2032)
     *
     * @param  int $company_cd
     * @param  string $json
     * @param  string $user_id
     * @param  int $mode
     * @return array
     */
    public function getQuestionnaireResult($params)
    {
        //2022/08/23
        $language = session_data()->language;
        array_unshift($params, $language);
        return Dao::executeSql('SPC_oQ2032_FND1', $params);
    }

    /**
     * getCrossResult
     *
     * @param  json $params
     * @param  int $horizontal
     * @param  int $vertical
     * @return array
     */
    public function getCrossResult($params, $combination_vertical = 0, $combination_horizontal = 0)
    {
       
        // 1.実施状況 & 2.充実度
        if ($combination_vertical == self::IMPLEMENTATION_STATUS && $combination_horizontal == self::ADEQUACY) {
            return $this->getImplementationStatusFulfillmentResult($params, 'implementation_fulfillment');
        // 1.実施状況 & 3.アンケート結果
        } else if ($combination_vertical == self::IMPLEMENTATION_STATUS && $combination_horizontal == self::QUESTIONNAIRE_RESULT) {
            return $this->getImplementationStatusQuestionnaireResult($params,'implementation_questionnaire');
        // 2.充実度 & 1.実施状況
        } else if ($combination_vertical == self::ADEQUACY && $combination_horizontal == self::IMPLEMENTATION_STATUS) {
          
            return $this->getImplementationStatusFulfillmentResult($params, 'fulfillment_implementation');
        // 2.充実度 & 3.アンケート結果
        } else if ($combination_vertical == self::ADEQUACY && $combination_horizontal == self::QUESTIONNAIRE_RESULT) {
          
            return $this->getFulfillmentQuestionnaireResult($params, 'fulfillment_questionnaire');
        // 3.アンケート結果 & 1.実施状況
        } else if ($combination_vertical == self::QUESTIONNAIRE_RESULT && $combination_horizontal == self::IMPLEMENTATION_STATUS) {
          
            return $this->getImplementationStatusQuestionnaireResult($params,'questionnaire_implementation');
        // 3.アンケート結果 & 2.充実度
        } else if ($combination_vertical == self::QUESTIONNAIRE_RESULT && $combination_horizontal == self::ADEQUACY) {
           
            return $this->getFulfillmentQuestionnaireResult($params, 'questionnaire_fulfillment');
        }
        return [];
    }

    /**
     * getImplementationStatusFulfillmentResult
     *
     * @param  json $params
     * @param  string $relationship
     * @return void
     */
    private function getImplementationStatusFulfillmentResult($params, $relationship = '')
    {
        //2022/08/23
        $language = session_data()->language;
        array_unshift($params, $language);
        $fulfillments = Dao::executeSql('SPC_oQ2031_FND1', $params);
        $implementations = Dao::executeSql('SPC_oQ2030_FND1', $params);
        // 
        if (isset($implementations[0][0]['error_typ']) && $implementations[0][0]['error_typ'] == '999') {
            return $implementations;
        }
        // 
        if (isset($fulfillments[0][0]['error_typ']) && $fulfillments[0][0]['error_typ'] == '999') {
            return $fulfillments;
        }
        // compare data
        $fulfillments[0] = $this->compareData($fulfillments[0],$implementations[0]);
        // 
        $implementation_total = count($implementations[0]);
        $fulfillment_total = count($fulfillments[0]);
        // check not exist data
        if($implementation_total == 0 || $fulfillment_total  == 0){
            return [];
        }
        $total = $implementation_total;
        if ($fulfillment_total > $implementation_total) {
            $total = $fulfillment_total;
        }
        // check $total <= 0
        if($total <= 0){
            return [];
        }
        // get 1.実施状況 (implementation) +  2.充実度 (fulfillment)
        if ($relationship == 'implementation_fulfillment') {
            return $this->getImplementationStatusRelationshipData($implementations, $fulfillments, $total, $relationship);
        }
        // get 2.充実度 (fulfillment) + 1.実施状況 (implementation)
        if ($relationship == 'fulfillment_implementation') {
            return $this->getFulfillmentRelationshipData($fulfillments, $implementations, $total, $relationship);
        }
    }

    /**
     * getImplementationStatusQuestionnaireResult
     *
     * @param  json $params
     * @param  string $relationship
     * 
     * @return array
     */
    private function getImplementationStatusQuestionnaireResult($params,$relationship = '')
    {
        //2022/08/23
        $language = session_data()->language;
        array_unshift($params, $language);
        $questionnaires = Dao::executeSql('SPC_oQ2032_FND1', $params);
        $implementations = Dao::executeSql('SPC_oQ2030_FND1', $params);
        // 
        if (isset($implementations[0][0]['error_typ']) && $implementations[0][0]['error_typ'] == '999') {
            return $implementations;
        }
        // 
        if (isset($questionnaires[0][0]['error_typ']) && $questionnaires[0][0]['error_typ'] == '999') {
            return $questionnaires;
        }
        // compare data
        $questionnaires[0] = $this->compareData($questionnaires[0],$implementations[0]);
        $implementation_total = count($implementations[0]);
        $questionnaire_total = count($questionnaires[0]);
        // check not exist data
        if($implementation_total == 0 || $questionnaire_total  == 0){
            return [];
        }
        $total = $implementation_total;
        if ($questionnaire_total > $implementation_total) {
            $total = $questionnaire_total;
        }
        // check $total <= 0
        if($total <= 0){
            return [];
        }
        // get 実施状況 (implementation) +  3.アンケート結果 (Questionnaire)
        if($relationship == 'implementation_questionnaire'){
            return $this->getImplementationStatusRelationshipData($implementations, $questionnaires, $total, $relationship);
        }
        // get 3.アンケート結果 (Questionnaire) + 実施状況 (implementation) 
        if ($relationship == 'questionnaire_implementation'){
            return $this->getQuestionnaireRelationshipData($questionnaires, $implementations, $total, $relationship);
        }
    }
    
    /**
     * getFulfillmentQuestionnaireResult
     *
     * @param  array $params
     * @param  string $relationship
     * @return void
     */
    private function getFulfillmentQuestionnaireResult($params,$relationship = '')
    {
        //2022/08/23
        $language = session_data()->language;
        array_unshift($params, $language);
        $fulfillments = Dao::executeSql('SPC_oQ2031_FND1', $params);
        $questionnaires = Dao::executeSql('SPC_oQ2032_FND1', $params);
        // 
         if (isset($fulfillments[0][0]['error_typ']) && $fulfillments[0][0]['error_typ'] == '999') {
            return $fulfillments;
        }
        // 
        if (isset($questionnaires[0][0]['error_typ']) && $questionnaires[0][0]['error_typ'] == '999') {
            return $questionnaires;
        }
        // compare data
        $questionnaires[0] = $this->compareData($questionnaires[0],$fulfillments[0]);
        // 
        $fulfillment_total = count($fulfillments[0]);
        $questionnaire_total = count($questionnaires[0]);
        // check not exist data
        if($fulfillment_total == 0 || $questionnaire_total  == 0){
            return [];
        }
        $total = $fulfillment_total;
        if ($questionnaire_total > $fulfillment_total) {
            $total = $questionnaire_total;
        }
        // check $total <= 0
        if($total <= 0){
            return [];
        }
        // get 2.充実度 (fulfillment) +  3.アンケート結果 (Questionnaire)
        if($relationship == 'fulfillment_questionnaire'){
            return $this->getFulfillmentRelationshipData($fulfillments, $questionnaires, $total, $relationship);
        }
        // get 3.アンケート結果 (Questionnaire) + 2.充実度 (fulfillment)
        if($relationship == 'questionnaire_fulfillment'){
            return $this->getQuestionnaireRelationshipData($questionnaires,$fulfillments, $total, $relationship);
        }
    }
    
    /**
     * getQuestionnaireRelationshipData
     *
     * @param  array $questionnaires
     * @param  array $relationship_data
     * @param  int $total
     * @param  string $relationship
     * @return void
     */
    private function getQuestionnaireRelationshipData($questionnaires, $relationship_data, $total, $relationship = '')
    {
        for ($i=1; $i <= 10 ; $i++) { 
            $result['questionnaire_'.$i]['sub_total'] = 0;
            // if questionnaire_implementation
            if($relationship == 'questionnaire_implementation'){
                $result['questionnaire_'.$i]['0'] = 0;
                $result['questionnaire_'.$i]['10'] = 0;
                $result['questionnaire_'.$i]['20'] = 0;
                $result['questionnaire_'.$i]['30'] = 0;
                $result['questionnaire_'.$i]['40'] = 0;
                $result['questionnaire_'.$i]['50'] = 0;
                $result['questionnaire_'.$i]['60'] = 0;
                $result['questionnaire_'.$i]['70'] = 0;
                $result['questionnaire_'.$i]['80'] = 0;
                $result['questionnaire_'.$i]['90'] = 0;
                // percent
                $result['questionnaire_'.$i]['0_percent'] = 0;
                $result['questionnaire_'.$i]['10_percent'] = 0;
                $result['questionnaire_'.$i]['20_percent'] = 0;
                $result['questionnaire_'.$i]['30_percent'] = 0;
                $result['questionnaire_'.$i]['40_percent'] = 0;
                $result['questionnaire_'.$i]['50_percent'] = 0;
                $result['questionnaire_'.$i]['60_percent'] = 0;
                $result['questionnaire_'.$i]['70_percent'] = 0;
                $result['questionnaire_'.$i]['80_percent'] = 0;
                $result['questionnaire_'.$i]['90_percent'] = 0;
            }else if ($relationship == 'questionnaire_fulfillment'){
                if (empty($relationship_data[1]) || empty($relationship_data[2][0])) {
                    return $result;
                }
                // init fulfillment data
                $item_no_min =  $relationship_data[2][0]['item_no'];
                foreach ($relationship_data[1] as $mark) {
                    $result['questionnaire_'.$i]['item_no_'.$mark['item_no']] = 0;
                    // PERCENT
                    $result['questionnaire_'.$i]['item_no_percent'.$mark['item_no']] = 0;
                }
            }  
        }
        // check $relationship
        if ($relationship == '') {
            return $result;
        }
        // check exists $questionnaires
        if (empty($questionnaires[0])) {
            return $result;
        }
        // LOOP $questionnaires
        foreach($questionnaires[0] as $questionnaire){
            // count sub_total
            $result['questionnaire_'.$questionnaire['points_answer']]['sub_total'] += 1;
            $employee_data = $this->getEmployeeData($questionnaire['employee_cd'], $relationship_data[0]);
            // check questionnaire_implementation
            if($relationship == 'questionnaire_implementation'){
                if (isset($employee_data['finished_percent']) && !empty($employee_data['finished_percent'])) {
                    $finished_percent = (float)$employee_data['finished_percent'];
                    // check value of $finished_percent
                    if ($finished_percent < 10) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['0'] += 1;
                    } else if ($finished_percent >= 10 && $finished_percent < 20) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['10'] += 1;
                    } else if ($finished_percent >= 20 && $finished_percent < 30) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['20'] += 1;
                    } else if ($finished_percent >= 30 && $finished_percent < 40) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['30'] += 1;
                    } else if ($finished_percent >= 40 && $finished_percent < 50) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['40'] += 1;
                    } else if ($finished_percent >= 50 && $finished_percent < 60) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['50'] += 1;
                    } else if ($finished_percent >= 60 && $finished_percent < 70) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['60'] += 1;
                    } else if ($finished_percent >= 70 && $finished_percent < 80) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['70'] += 1;
                    } else if ($finished_percent >= 80 && $finished_percent < 90) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['80'] += 1;
                    } else if ($finished_percent >= 90) {
                        $result['questionnaire_'.$questionnaire['points_answer']]['90'] += 1;
                    }
                }else{
                    $result['questionnaire_'.$questionnaire['points_answer']]['0'] += 1;
                }
            }else if ($relationship == 'questionnaire_fulfillment'){
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['questionnaire_'.$questionnaire['points_answer']]['item_no_'.$employee_data['item_no']] += 1;
                }else{
                    $result['questionnaire_'.$questionnaire['points_answer']]['item_no_'.$item_no_min] += 1;
                }
            }
        }
        // sum percent
        if($relationship == 'questionnaire_implementation'){
            foreach ($result as $key => $value) {
                $result[$key]['0_percent'] = round((($value['0'] / $total) * 100), 1);
                $result[$key]['10_percent'] = round((($value['10'] / $total) * 100), 1);
                $result[$key]['20_percent'] = round((($value['20'] / $total) * 100), 1);
                $result[$key]['30_percent'] = round((($value['30'] / $total) * 100), 1);
                $result[$key]['40_percent'] = round((($value['40'] / $total) * 100), 1);
                $result[$key]['50_percent'] = round((($value['50'] / $total) * 100), 1);
                $result[$key]['60_percent'] = round((($value['60'] / $total) * 100), 1);
                $result[$key]['70_percent'] = round((($value['70'] / $total) * 100), 1);
                $result[$key]['80_percent'] = round((($value['80'] / $total) * 100), 1);
                $result[$key]['90_percent'] = round((($value['90'] / $total) * 100), 1);
            }
        }else if ($relationship == 'questionnaire_fulfillment'){
            foreach ($result as $key => $value) {
                $result[$key]['item_no_percent1'] = round((($value['item_no_1'] / $total) * 100), 1);
                $result[$key]['item_no_percent2'] = round((($value['item_no_2'] / $total) * 100), 1);
                $result[$key]['item_no_percent3'] = round((($value['item_no_3'] / $total) * 100), 1);
                $result[$key]['item_no_percent4'] = round((($value['item_no_4'] / $total) * 100), 1);
                $result[$key]['item_no_percent5'] = round((($value['item_no_5'] / $total) * 100), 1);
            }   
        }
        return $result;
    }

    /**
     * getFulfillmentRelationshipData
     *
     * @param  array $fulfillments
     * @param  array $relationship_data
     * @param  int $total
     * @param  string $relationship
     * @return void
     */
    private function getFulfillmentRelationshipData($fulfillments, $relationship_data, $total, $relationship = '')
    {
        $result = [];
        // check $relationship
        if ($relationship == '') {
            return $result;
        }
        // check exists $implementations
        if (empty($fulfillments[0]) || empty($fulfillments[1])) {
            return $result;
        }
        // loop $fulfillments for init sub_total
        foreach ($fulfillments[1] as $fulfillment) {
            $result['item_no_' . $fulfillment['item_no']]['sub_total'] = 0;
            // 
            if($relationship == 'fulfillment_implementation'){
                $result['item_no_' . $fulfillment['item_no']]['0'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['10'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['20'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['30'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['40'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['50'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['60'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['70'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['80'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['90'] = 0;
                // percent
                $result['item_no_' . $fulfillment['item_no']]['0_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['10_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['20_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['30_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['40_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['50_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['60_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['70_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['80_percent'] = 0;
                $result['item_no_' . $fulfillment['item_no']]['90_percent'] = 0;
            }else if($relationship == 'fulfillment_questionnaire'){
                // init Questionnaire data
                for ($i=1; $i <= 10; $i++) { 
                    $result['item_no_' . $fulfillment['item_no']]['questionnaire_'.$i] = 0;
                    $result['item_no_' . $fulfillment['item_no']]['questionnaire_percent_'.$i] = 0;
                }
            }
        }
        // LOOP $fulfillments  
        foreach ($fulfillments[0] as $fulfillment) {
            // count sub_total
            $result['item_no_' . $fulfillment['item_no']]['sub_total'] += 1;
            $employee_data = $this->getEmployeeData($fulfillment['employee_cd'], $relationship_data[0]);
            // check fulfillment_implementation or fulfillment_questionnaire
            if($relationship == 'fulfillment_implementation'){
                if (isset($employee_data['finished_percent']) && !empty($employee_data['finished_percent'])) {
                    $finished_percent = (float)$employee_data['finished_percent'];
                    // check value of $finished_percent
                    if ($finished_percent < 10) {
                        $result['item_no_' . $fulfillment['item_no']]['0'] += 1;
                    } else if ($finished_percent >= 10 && $finished_percent < 20) {
                        $result['item_no_' . $fulfillment['item_no']]['10'] += 1;
                    } else if ($finished_percent >= 20 && $finished_percent < 30) {
                        $result['item_no_' . $fulfillment['item_no']]['20'] += 1;
                    } else if ($finished_percent >= 30 && $finished_percent < 40) {
                        $result['item_no_' . $fulfillment['item_no']]['30'] += 1;
                    } else if ($finished_percent >= 40 && $finished_percent < 50) {
                        $result['item_no_' . $fulfillment['item_no']]['40'] += 1;
                    } else if ($finished_percent >= 50 && $finished_percent < 60) {
                        $result['item_no_' . $fulfillment['item_no']]['50'] += 1;
                    } else if ($finished_percent >= 60 && $finished_percent < 70) {
                        $result['item_no_' . $fulfillment['item_no']]['60'] += 1;
                    } else if ($finished_percent >= 70 && $finished_percent < 80) {
                        $result['item_no_' . $fulfillment['item_no']]['70'] += 1;
                    } else if ($finished_percent >= 80 && $finished_percent < 90) {
                        $result['item_no_' . $fulfillment['item_no']]['80'] += 1;
                    } else if ($finished_percent >= 90) {
                        $result['item_no_' . $fulfillment['item_no']]['90'] += 1;
                    }
                } else {
                    $result['item_no_' . $fulfillment['item_no']]['0'] += 1;
                }
            }else if($relationship == 'fulfillment_questionnaire'){
                if(isset($employee_data['points_answer']) && !empty($employee_data['points_answer'])){
                    $points_answer = (int)$employee_data['points_answer'];
                    $result['item_no_' . $fulfillment['item_no']]['questionnaire_'.$points_answer] += 1;
                }else{
                    $result['item_no_' . $fulfillment['item_no']]['questionnaire_1'] += 1;
                }
            }
        }
        // sum percent
        if ($relationship == 'fulfillment_implementation') {
            foreach ($result as $key => $value) {
                $result[$key]['0_percent'] = round((($value['0'] / $total) * 100), 1);
                $result[$key]['10_percent'] = round((($value['10'] / $total) * 100), 1);
                $result[$key]['20_percent'] = round((($value['20'] / $total) * 100), 1);
                $result[$key]['30_percent'] = round((($value['30'] / $total) * 100), 1);
                $result[$key]['40_percent'] = round((($value['40'] / $total) * 100), 1);
                $result[$key]['50_percent'] = round((($value['50'] / $total) * 100), 1);
                $result[$key]['60_percent'] = round((($value['60'] / $total) * 100), 1);
                $result[$key]['70_percent'] = round((($value['70'] / $total) * 100), 1);
                $result[$key]['80_percent'] = round((($value['80'] / $total) * 100), 1);
                $result[$key]['90_percent'] = round((($value['90'] / $total) * 100), 1);
            }
        }else if ($relationship == 'fulfillment_questionnaire'){
            foreach ($result as $key => $value) {
                $result[$key]['questionnaire_percent_1'] = round((($value['questionnaire_1'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_2'] = round((($value['questionnaire_2'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_3'] = round((($value['questionnaire_3'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_4'] = round((($value['questionnaire_4'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_5'] = round((($value['questionnaire_5'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_6'] = round((($value['questionnaire_6'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_7'] = round((($value['questionnaire_7'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_8'] = round((($value['questionnaire_8'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_9'] = round((($value['questionnaire_9'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_10'] = round((($value['questionnaire_10'] / $total) * 100), 1);
            }
        }
        return $result;
    }
    /**
     * getImplementationStatusRelationshipData
     *
     * @param  array $data
     * @return void
     */
    private function getImplementationStatusRelationshipData($implementations, $relationship_data, $total, $relationship = '')
    {
        $result['0']['sub_total'] = 0;
        $result['10']['sub_total'] = 0;
        $result['20']['sub_total'] = 0;
        $result['30']['sub_total'] = 0;
        $result['40']['sub_total'] = 0;
        $result['50']['sub_total'] = 0;
        $result['60']['sub_total'] = 0;
        $result['70']['sub_total'] = 0;
        $result['80']['sub_total'] = 0;
        $result['90']['sub_total'] = 0;
        // check exists $implementations
        if (empty($implementations[0])) {
            return $result;
        }
        // check $relationship
        if ($relationship == '') {
            return $result;
        }
        // if implementation_fulfillment 1.実施状況 (implementation) +  2.充実度 (fulfillment)
        if ($relationship == 'implementation_fulfillment') {
            if (empty($relationship_data[1]) || empty($relationship_data[2][0])) {
                return $result;
            }
            $item_no_min =  $relationship_data[2][0]['item_no'];
            // init fulfillment data
            foreach ($relationship_data[1] as $mark) {
                $result['0']["item_no_" . $mark['item_no']] = 0;
                $result['10']["item_no_" . $mark['item_no']] = 0;
                $result['20']["item_no_" . $mark['item_no']] = 0;
                $result['30']["item_no_" . $mark['item_no']] = 0;
                $result['40']["item_no_" . $mark['item_no']] = 0;
                $result['50']["item_no_" . $mark['item_no']] = 0;
                $result['60']["item_no_" . $mark['item_no']] = 0;
                $result['70']["item_no_" . $mark['item_no']] = 0;
                $result['80']["item_no_" . $mark['item_no']] = 0;
                $result['90']["item_no_" . $mark['item_no']] = 0;
                // PERCENT
                $result['0']["item_no_percent" . $mark['item_no']] = 0;
                $result['10']["item_no_percent" . $mark['item_no']] = 0;
                $result['20']["item_no_percent" . $mark['item_no']] = 0;
                $result['30']["item_no_percent" . $mark['item_no']] = 0;
                $result['40']["item_no_percent" . $mark['item_no']] = 0;
                $result['50']["item_no_percent" . $mark['item_no']] = 0;
                $result['60']["item_no_percent" . $mark['item_no']] = 0;
                $result['70']["item_no_percent" . $mark['item_no']] = 0;
                $result['80']["item_no_percent" . $mark['item_no']] = 0;
                $result['90']["item_no_percent" . $mark['item_no']] = 0;
            }
        }
        // if implementation_fulfillment 1.実施状況 (implementation) +  3.アンケート結果 (Questionnaire)
        if ($relationship == 'implementation_questionnaire') {
            if (empty($relationship_data[0])) {
                return $result;
            }
            // init Questionnaire data
            for ($i = 1; $i <= 10; $i++) {
                $result['0']['questionnaire_' . $i] = 0;
                $result['10']['questionnaire_' . $i] = 0;
                $result['20']['questionnaire_' . $i] = 0;
                $result['30']['questionnaire_' . $i] = 0;
                $result['40']['questionnaire_' . $i] = 0;
                $result['50']['questionnaire_' . $i] = 0;
                $result['60']['questionnaire_' . $i] = 0;
                $result['70']['questionnaire_' . $i] = 0;
                $result['80']['questionnaire_' . $i] = 0;
                $result['90']['questionnaire_' . $i] = 0;
                // PERCENT
                $result['0']['questionnaire_percent_' . $i] = 0;
                $result['10']['questionnaire_percent_' . $i] = 0;
                $result['20']['questionnaire_percent_' . $i] = 0;
                $result['30']['questionnaire_percent_' . $i] = 0;
                $result['40']['questionnaire_percent_' . $i] = 0;
                $result['50']['questionnaire_percent_' . $i] = 0;
                $result['60']['questionnaire_percent_' . $i] = 0;
                $result['70']['questionnaire_percent_' . $i] = 0;
                $result['80']['questionnaire_percent_' . $i] = 0;
                $result['90']['questionnaire_percent_' . $i] = 0;
            }
        }
        //  loop implementation 
        foreach ($implementations[0] as $implementation) {
            // get information from implementation
            if ($implementation['finished_percent'] < 10) {
                $result['0']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['0']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['0']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['0']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['0']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 10 && $implementation['finished_percent'] < 20) {
                $result['10']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['10']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['10']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['10']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['10']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 20 && $implementation['finished_percent'] < 30) {
                $result['20']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['20']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['20']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['20']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['20']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 30 && $implementation['finished_percent'] < 40) {
                $result['30']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['30']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['30']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['30']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['30']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 40 && $implementation['finished_percent'] < 50) {
                $result['40']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['40']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['40']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['40']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['40']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 50 && $implementation['finished_percent'] < 60) {
                $result['50']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['50']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['50']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['50']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['50']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 60 && $implementation['finished_percent'] < 70) {
                $result['60']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['60']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['60']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['60']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['60']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 70 && $implementation['finished_percent'] < 80) {
                $result['70']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['70']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['70']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['70']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['70']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 80 && $implementation['finished_percent'] < 90) {
                $result['80']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['80']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['80']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['80']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['80']['questionnaire_1'] += 1;
                    }
                }
            } else if ($implementation['finished_percent'] >= 90) {
                $result['90']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                // implementation_fulfillment
                if ($relationship == 'implementation_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $result['90']["item_no_" . $employee_data['item_no']] += 1;
                    } else {
                        $result['90']["item_no_" . $item_no_min] += 1;
                    }
                }
                // implementation_questionnaire
                else if ($relationship == 'implementation_questionnaire') {
                    if (isset($employee_data['points_answer'])) {
                        $result['90']['questionnaire_' . $employee_data['points_answer']] += 1;
                    } else {
                        $result['90']['questionnaire_1'] += 1;
                    }
                }
            }
        } 
        // sum item_no_percent
        if ($relationship == 'implementation_fulfillment') {
            foreach ($result as $key => $value) {
                $result[$key]['item_no_percent1'] = round((($value['item_no_1'] / $total) * 100), 1);
                $result[$key]['item_no_percent2'] = round((($value['item_no_2'] / $total) * 100), 1);
                $result[$key]['item_no_percent3'] = round((($value['item_no_3'] / $total) * 100), 1);
                $result[$key]['item_no_percent4'] = round((($value['item_no_4'] / $total) * 100), 1);
                $result[$key]['item_no_percent5'] = round((($value['item_no_5'] / $total) * 100), 1);
            }
        } else if ($relationship == 'implementation_questionnaire') {
            foreach ($result as $key => $value) {
                $result[$key]['questionnaire_percent_1'] = round((($value['questionnaire_1'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_2'] = round((($value['questionnaire_2'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_3'] = round((($value['questionnaire_3'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_4'] = round((($value['questionnaire_4'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_5'] = round((($value['questionnaire_5'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_6'] = round((($value['questionnaire_6'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_7'] = round((($value['questionnaire_7'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_8'] = round((($value['questionnaire_8'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_9'] = round((($value['questionnaire_9'] / $total) * 100), 1);
                $result[$key]['questionnaire_percent_10'] = round((($value['questionnaire_10'] / $total) * 100), 1);
            }
        }
        return $result;
    }
    /**
     * getEmployeeData
     *
     * @param  string $employee_cd
     * @param  array $relationship_data
     * @return void
     */
    private function getEmployeeData($employee_cd, $relationship_data)
    {
        if (empty($relationship_data)) {
            return [];
        }
        // 
        foreach ($relationship_data as $data) {
            if ($data['employee_cd'] == $employee_cd) {
                return $data;
            }
        }
    }    
    /**
     * compareData
     *
     * @param  array $input_array
     * @param  array $target_array
     * @return void
     */
    private function compareData($input_array = [], $target_array = [])
    {
        // if $input_array empty then return []
        if(empty($input_array)){
            return [];
        }
        // if $target_array empty then $input_array
        if(empty($target_array)){
            return $input_array;
        }
        // get list employee_cd
        $employees = [];
        foreach($target_array as $temp){
            $employees[] = $temp['employee_cd'];
        }
        // 

        // remove employee not exists in $target_array
        foreach($input_array as $key=>$value){
            if(!in_array($value['employee_cd'],$employees)){
                unset($input_array[$key]);
            }
        }
        //  return 
        return $input_array;
    }
}