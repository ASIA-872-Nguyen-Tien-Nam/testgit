<?php

namespace App\Services\WeeklyReport;

use Illuminate\Support\Collection;
use Dao;

class AnalysisService
{
    const IMPLEMENTATION_STATUS = 1;    // 1.実施状況
    const ADEQUACY = 2; //2.充実度
    const REACTIONS = 3; //3.リアクション

    /**
     * getSubmissionRateAnalysis (rQ3010)
     *
     * @param  String $json
     * @param  Int $mode 0:SEARCH/1:OUTPUT EXCEL/2.CROSS
     * @return Array
     */
    public function getSubmissionRateAnalysis($json = '', $mode = 0)
    {
        $params['language'] = session_data()->language;
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['mode'] = $mode;
        // 
        $reports =  Dao::executeSql('SPC_rQ3010_FND1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }

    /**
     * getAdequacyAnalysis (rQ3020)
     *
     * @param  String $json
     * @param  Int $mode 0:SEARCH/1:OUTPUT EXCEL/2.CROSS
     * @return Array
     */
    public function getAdequacyAnalysis($json = '', $mode = 0)
    {
        $params['language'] = session_data()->language;
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['mode'] = $mode;
        // 
        $reports =  Dao::executeSql('SPC_rQ3020_FND1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }

    /**
     * getReactionAnalysis (rQ3030)
     *
     * @param  String $json
     * @param  Int $mode 0:SEARCH/1:OUTPUT EXCEL/2.CROSS
     * @return Array
     */
    public function getReactionAnalysis($json = '', $mode = 0)
    {
        $params['language'] = session_data()->language;
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['mode'] = $mode;
        // 
        $reports =  Dao::executeSql('SPC_rQ3030_FND1', $params);
        if (isset($reports[0][0]['error_typ']) && $reports[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $reports ?? [];
    }

    /**
     * getCrossAnalysis (rQ3040)
     *
     * @param  String $json
     * @param  Int $combination_vertical
     * @param  Int $combination_horizontal
     * @return Array
     */
    public function getCrossAnalysis($json = '', $combination_vertical = 0, $combination_horizontal = 0)
    {
        $params['language'] = session_data()->language;
        $params['json'] = $json;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['mode']               =  2; // 0.search 1.csv 2.cross
        // 1.実施状況 & 2.充実度
        if ($combination_vertical == self::IMPLEMENTATION_STATUS && $combination_horizontal == self::ADEQUACY) {
            return $this->getImplementationStatusFulfillmentResult($params, 'implementation_fulfillment');
            // 1.実施状況 & 3.リアクション
        } else if ($combination_vertical == self::IMPLEMENTATION_STATUS && $combination_horizontal == self::REACTIONS) {
            return $this->getImplementationStatusReactionsResult($params, 'implementation_reactions');
            // 2.充実度 & 1.実施状況
        } else if ($combination_vertical == self::ADEQUACY && $combination_horizontal == self::IMPLEMENTATION_STATUS) {
            return $this->getImplementationStatusFulfillmentResult($params, 'fulfillment_implementation');
            // 2.充実度 & 3.リアクション
        } else if ($combination_vertical == self::ADEQUACY && $combination_horizontal == self::REACTIONS) {
            return $this->getFulfillmentReactionsResult($params, 'fulfillment_reactions');
            // 3.リアクション & 1.実施状況
        } else if ($combination_vertical == self::REACTIONS && $combination_horizontal == self::IMPLEMENTATION_STATUS) {
            return $this->getImplementationStatusReactionsResult($params, 'reactions_implementation');
            // 3.リアクション & 2.充実度
        } else if ($combination_vertical == self::REACTIONS && $combination_horizontal == self::ADEQUACY) {
            return $this->getFulfillmentReactionsResult($params, 'reactions_fulfillment');
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
        $fulfillments = Dao::executeSql('SPC_rQ3020_FND1', $params);
        $implementations = Dao::executeSql('SPC_rQ3010_FND1', $params);
        // 
        if (isset($implementations[0][0]['error_typ']) && $implementations[0][0]['error_typ'] == '999') {
            return $implementations;
        }
        // 
        if (isset($fulfillments[0][0]['error_typ']) && $fulfillments[0][0]['error_typ'] == '999') {
            return $fulfillments;
        }
        // compare data
        $fulfillments[0] = $this->compareData($fulfillments[0], $implementations[0]);
        // 
        $implementation_total = count($implementations[0]);
        $fulfillment_total = count($fulfillments[0]);
        // check not exist data
        if ($implementation_total == 0 || $fulfillment_total  == 0) {
            return [];
        }
        $total = $implementation_total;
        if ($fulfillment_total > $implementation_total) {
            $total = $fulfillment_total;
        }
        // check $total <= 0
        if ($total <= 0) {
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
     * getImplementationStatusReactionsResult
     *
     * @param  json $params
     * @param  string $relationship
     * 
     * @return array
     */
    private function getImplementationStatusReactionsResult($params, $relationship = '')
    {
        $reactions = Dao::executeSql('SPC_rQ3030_FND1', $params);
        $implementations = Dao::executeSql('SPC_rQ3010_FND1', $params);
        // 
        if (isset($implementations[0][0]['error_typ']) && $implementations[0][0]['error_typ'] == '999') {
            return $implementations;
        }
        // 
        if (isset($reactions[0][0]['error_typ']) && $reactions[0][0]['error_typ'] == '999') {
            return $reactions;
        }
        // compare data
        $reactions[0] = $this->compareData($reactions[0], $implementations[0]);
        $implementation_total = count($implementations[0]);
        $reactions_total = count($reactions[0]);
        // check not exist data
        if ($implementation_total == 0 || $reactions_total  == 0) {
            return [];
        }
        $total = $implementation_total;
        if ($reactions_total > $implementation_total) {
            $total = $reactions_total;
        }
        // check $total <= 0
        if ($total <= 0) {
            return [];
        }
        // get 実施状況 (implementation) +  3.リアクション (reactions)
        if ($relationship == 'implementation_reactions') {
            return $this->getImplementationStatusRelationshipData($implementations, $reactions, $total, $relationship);
        }
        // get 3.リアクション (reactions) + 実施状況 (implementation) 
        if ($relationship == 'reactions_implementation') {
            return $this->getReactionsRelationshipData($reactions, $implementations, $total, $relationship);
        }
    }

    /**
     * getFulfillmentReactionsResult
     *
     * @param  array $params
     * @param  string $relationship
     * @return void
     */
    private function getFulfillmentReactionsResult($params, $relationship = '')
    {
        $fulfillments = Dao::executeSql('SPC_rQ3020_FND1', $params);
        $reactions = Dao::executeSql('SPC_rQ3030_FND1', $params);
        // 
        if (isset($fulfillments[0][0]['error_typ']) && $fulfillments[0][0]['error_typ'] == '999') {
            return $fulfillments;
        }
        // 
        if (isset($reactions[0][0]['error_typ']) && $reactions[0][0]['error_typ'] == '999') {
            return $reactions;
        }
        // compare data
        $reactions[0] = $this->compareData($reactions[0], $fulfillments[0]);
        // 
        $fulfillment_total = count($fulfillments[0]);
        $reaction_total = count($reactions[0]);
        // check not exist data
        if ($fulfillment_total == 0 || $reaction_total  == 0) {
            return [];
        }
        $total = $fulfillment_total;
        if ($reaction_total > $fulfillment_total) {
            $total = $reaction_total;
        }
        // check $total <= 0
        if ($total <= 0) {
            return [];
        }
        // get 2.充実度 (fulfillment) +  3.リアクション (Reactions)
        if ($relationship == 'fulfillment_reactions') {
            return $this->getFulfillmentRelationshipData($fulfillments, $reactions, $total, $relationship);
        }
        // get 3.リアクション (Reactions) + 2.充実度 (fulfillment)
        if ($relationship == 'reactions_fulfillment') {
            return $this->getReactionsRelationshipData($reactions, $fulfillments, $total, $relationship);
        }
    }

    /**
     * getReactionsRelationshipData
     *
     * @param  array $questionnaires
     * @param  array $relationship_data
     * @param  int $total
     * @param  string $relationship
     * @return void
     */
    private function getReactionsRelationshipData($reactions, $relationship_data, $total, $relationship = '')
    {
        // dd($reactions, $relationship_data, $total, $relationship);
        $result = [];
        // check $relationship
        if ($relationship == '') {
            return $result;
        }
        // check exists $implementations
        if (empty($reactions[0]) || empty($reactions[1])) {
            return $result;
        }
        // loop $reactions for init sub_total
        foreach ($reactions[1] as $reaction) {
            if ($reaction['item_no'] > 0) {
                $result['item_no_' . $reaction['item_no']]['sub_total'] = 0;
                if ($relationship == 'reactions_implementation') {
                    $result['item_no_' . $reaction['item_no']]['0'] = 0;
                    $result['item_no_' . $reaction['item_no']]['10'] = 0;
                    $result['item_no_' . $reaction['item_no']]['20'] = 0;
                    $result['item_no_' . $reaction['item_no']]['30'] = 0;
                    $result['item_no_' . $reaction['item_no']]['40'] = 0;
                    $result['item_no_' . $reaction['item_no']]['50'] = 0;
                    $result['item_no_' . $reaction['item_no']]['60'] = 0;
                    $result['item_no_' . $reaction['item_no']]['70'] = 0;
                    $result['item_no_' . $reaction['item_no']]['80'] = 0;
                    $result['item_no_' . $reaction['item_no']]['90'] = 0;
                    // percent
                    $result['item_no_' . $reaction['item_no']]['0_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['10_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['20_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['30_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['40_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['50_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['60_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['70_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['80_percent'] = 0;
                    $result['item_no_' . $reaction['item_no']]['90_percent'] = 0;
                } else if ($relationship == 'reactions_fulfillment') {
                    // init Reactions data
                    $item_no_min =  $relationship_data[2][0]['item_no'];
                    // init reactions data
                    foreach ($relationship_data[1] as $mark) {
                        $result['item_no_' . $reaction['item_no']]['reactions_' . $mark['item_no']] = 0;
                    }
                }
            }
        }
        // LOOP $reactions  
        foreach ($reactions[0] as $reaction) {
            if ($reaction['item_no'] > 0) {
                // count sub_total
                $result['item_no_' . $reaction['item_no']]['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($reaction['employee_cd'], $relationship_data[0]);
                // 
                if ($relationship == 'reactions_implementation') {
                    if (isset($employee_data['finished_percent']) && !empty($employee_data['finished_percent'])) {
                        $finished_percent = (float)$employee_data['finished_percent'];
                        // check value of $finished_percent
                        if ($finished_percent < 10) {
                            $result['item_no_' . $reaction['item_no']]['0'] += 1;
                        } else if ($finished_percent >= 10 && $finished_percent < 20) {
                            $result['item_no_' . $reaction['item_no']]['10'] += 1;
                        } else if ($finished_percent >= 20 && $finished_percent < 30) {
                            $result['item_no_' . $reaction['item_no']]['20'] += 1;
                        } else if ($finished_percent >= 30 && $finished_percent < 40) {
                            $result['item_no_' . $reaction['item_no']]['30'] += 1;
                        } else if ($finished_percent >= 40 && $finished_percent < 50) {
                            $result['item_no_' . $reaction['item_no']]['40'] += 1;
                        } else if ($finished_percent >= 50 && $finished_percent < 60) {
                            $result['item_no_' . $reaction['item_no']]['50'] += 1;
                        } else if ($finished_percent >= 60 && $finished_percent < 70) {
                            $result['item_no_' . $reaction['item_no']]['60'] += 1;
                        } else if ($finished_percent >= 70 && $finished_percent < 80) {
                            $result['item_no_' . $reaction['item_no']]['70'] += 1;
                        } else if ($finished_percent >= 80 && $finished_percent < 90) {
                            $result['item_no_' . $reaction['item_no']]['80'] += 1;
                        } else if ($finished_percent >= 90) {
                            $result['item_no_' . $reaction['item_no']]['90'] += 1;
                        }
                    } else {
                        $result['item_no_' . $reaction['item_no']]['0'] += 1;
                    }
                } else if ($relationship == 'reactions_fulfillment') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $item_no =  (int)$employee_data['item_no'];
                        $result['item_no_' . $reaction['item_no']]["reactions_" . $item_no] += 1;
                    } else {
                        $result['item_no_' . $reaction['item_no']]["reactions_" . $item_no_min] += 1;
                    }
                }
            }
        }
        // sum percent
        if ($relationship == 'reactions_implementation') {
            foreach ($result as $key => $value) {
                $result[$key]['0_percent'] = 0;
                $result[$key]['10_percent'] = 0;
                $result[$key]['20_percent'] = 0;
                $result[$key]['30_percent'] = 0;
                $result[$key]['40_percent'] = 0;
                $result[$key]['50_percent'] = 0;
                $result[$key]['60_percent'] = 0;
                $result[$key]['70_percent'] = 0;
                $result[$key]['80_percent'] = 0;
                $result[$key]['90_percent'] = 0;
                if (isset($value['0'])) {
                    $result[$key]['0_percent'] = round((($value['0'] / $total) * 100), 1);
                }
                if (isset($value['10'])) {
                    $result[$key]['10_percent'] = round((($value['10'] / $total) * 100), 1);
                }
                if (isset($value['20'])) {
                    $result[$key]['20_percent'] = round((($value['20'] / $total) * 100), 1);
                }
                if (isset($value['30'])) {
                    $result[$key]['30_percent'] = round((($value['30'] / $total) * 100), 1);
                }
                if (isset($value['40'])) {
                    $result[$key]['40_percent'] = round((($value['40'] / $total) * 100), 1);
                }
                if (isset($value['50'])) {
                    $result[$key]['50_percent'] = round((($value['50'] / $total) * 100), 1);
                }
                if (isset($value['60'])) {
                    $result[$key]['60_percent'] = round((($value['60'] / $total) * 100), 1);
                }
                if (isset($value['70'])) {
                    $result[$key]['70_percent'] = round((($value['70'] / $total) * 100), 1);
                }
                if (isset($value['80'])) {
                    $result[$key]['80_percent'] = round((($value['80'] / $total) * 100), 1);
                }
                if (isset($value['90'])) {
                    $result[$key]['90_percent'] = round((($value['90'] / $total) * 100), 1);
                }
            }
        } else if ($relationship == 'reactions_fulfillment') {
            foreach ($result as $key => $value) {
                $result[$key]['reactions_percent_1'] = 0;
                $result[$key]['reactions_percent_2'] = 0;
                $result[$key]['reactions_percent_3'] = 0;
                $result[$key]['reactions_percent_4'] = 0;
                if (isset($value['reactions_1'])) {
                    $result[$key]['reactions_percent_1'] = round((($value['reactions_1'] / $total) * 100), 1);
                }
                if (isset($value['reactions_2'])) {
                    $result[$key]['reactions_percent_2'] = round((($value['reactions_2'] / $total) * 100), 1);
                }
                if (isset($value['reactions_3'])) {
                    $result[$key]['reactions_percent_3'] = round((($value['reactions_3'] / $total) * 100), 1);
                }
                if (isset($value['reactions_4'])) {
                    $result[$key]['reactions_percent_4'] = round((($value['reactions_4'] / $total) * 100), 1);
                }
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
        // check exists $v
        if (empty($fulfillments[0]) || empty($fulfillments[1])) {
            return $result;
        }
        // loop $fulfillments for init sub_total
        foreach ($fulfillments[1] as $fulfillment) {
            if ($fulfillment['item_no'] > 0) {
                $result['item_no_' . $fulfillment['item_no']]['sub_total'] = 0;
                // 
                if ($relationship == 'fulfillment_implementation') {
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
                } else if ($relationship == 'fulfillment_reactions') {
                    // init Reactions data
                    $item_no_min =  $relationship_data[2][0]['item_no'];
                    // init reactions data
                    foreach ($relationship_data[1] as $mark) {
                        $result['item_no_' . $fulfillment['item_no']]['reactions_' . $mark['item_no']] = 0;
                    }
                }
            }
        }

        // LOOP $fulfillments  
        foreach ($fulfillments[0] as $fulfillment) {
            if ($fulfillment['item_no'] > 0) {
                // count sub_total
                $result['item_no_' . $fulfillment['item_no']]['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($fulfillment['employee_cd'], $relationship_data[0]);
                // check fulfillment_implementation or fulfillment_reactions
                if ($relationship == 'fulfillment_implementation') {
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
                } else if ($relationship == 'fulfillment_reactions') {
                    if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                        $item_no = (int)$employee_data['item_no'];
                        $result['item_no_' . $fulfillment['item_no']]["reactions_" . $item_no] += 1;
                    } else {
                        $result['item_no_' . $mark['item_no']]["reactions_" . $item_no_min] += 1;
                    }
                }
            }
        }
        // sum percent
        if ($relationship == 'fulfillment_implementation') {
            foreach ($result as $key => $value) {
                $result[$key]['0_percent'] = 0;
                $result[$key]['10_percent'] = 0;
                $result[$key]['20_percent'] = 0;
                $result[$key]['30_percent'] = 0;
                $result[$key]['40_percent'] = 0;
                $result[$key]['50_percent'] = 0;
                $result[$key]['60_percent'] = 0;
                $result[$key]['70_percent'] = 0;
                $result[$key]['80_percent'] = 0;
                $result[$key]['90_percent'] = 0;
                if (isset($value['0'])) {
                    $result[$key]['0_percent'] = round((($value['0'] / $total) * 100), 1);
                }
                if (isset($value['10'])) {
                    $result[$key]['10_percent'] = round((($value['10'] / $total) * 100), 1);
                }
                if (isset($value['20'])) {
                    $result[$key]['20_percent'] = round((($value['20'] / $total) * 100), 1);
                }
                if (isset($value['30'])) {
                    $result[$key]['30_percent'] = round((($value['30'] / $total) * 100), 1);
                }
                if (isset($value['40'])) {
                    $result[$key]['40_percent'] = round((($value['40'] / $total) * 100), 1);
                }
                if (isset($value['50'])) {
                    $result[$key]['50_percent'] = round((($value['50'] / $total) * 100), 1);
                }
                if (isset($value['60'])) {
                    $result[$key]['60_percent'] = round((($value['60'] / $total) * 100), 1);
                }
                if (isset($value['70'])) {
                    $result[$key]['70_percent'] = round((($value['70'] / $total) * 100), 1);
                }
                if (isset($value['80'])) {
                    $result[$key]['80_percent'] = round((($value['80'] / $total) * 100), 1);
                }
                if (isset($value['90'])) {
                    $result[$key]['90_percent'] = round((($value['90'] / $total) * 100), 1);
                }
            }
        } else if ($relationship == 'fulfillment_reactions') {
            foreach ($result as $key => $value) {
                $result[$key]['reactions_percent_1'] = 0;
                $result[$key]['reactions_percent_2'] = 0;
                $result[$key]['reactions_percent_3'] = 0;
                $result[$key]['reactions_percent_4'] = 0;
                if (isset($value['reactions_1'])) {
                    $result[$key]['reactions_percent_1'] = round((($value['reactions_1'] / $total) * 100), 1);
                }
                if (isset($value['reactions_2'])) {
                    $result[$key]['reactions_percent_2'] = round((($value['reactions_2'] / $total) * 100), 1);
                }
                if (isset($value['reactions_3'])) {
                    $result[$key]['reactions_percent_3'] = round((($value['reactions_3'] / $total) * 100), 1);
                }
                if (isset($value['reactions_4'])) {
                    $result[$key]['reactions_percent_4'] = round((($value['reactions_4'] / $total) * 100), 1);
                }
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
        if (empty($relationship_data[1]) || empty($relationship_data[2][0])) {
            return $result;
        }
        $item_no_min =  $relationship_data[2][0]['item_no'];
        // init fulfillment data
        foreach ($relationship_data[1] as $mark) {
            if ($mark['item_no'] > 0) {
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
        //  loop implementation 
        foreach ($implementations[0] as $implementation) {
            // get information from implementation
            if ($implementation['finished_percent'] < 10) {
                $result['0']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['0']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['0']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 10 && $implementation['finished_percent'] < 20) {
                $result['10']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['10']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['10']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 20 && $implementation['finished_percent'] < 30) {
                $result['20']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['20']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['20']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 30 && $implementation['finished_percent'] < 40) {
                $result['30']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['30']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['30']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 40 && $implementation['finished_percent'] < 50) {
                $result['40']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['40']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['40']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 50 && $implementation['finished_percent'] < 60) {
                $result['50']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['50']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['50']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 60 && $implementation['finished_percent'] < 70) {
                $result['60']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['60']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['60']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 70 && $implementation['finished_percent'] < 80) {
                $result['70']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['70']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['70']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 80 && $implementation['finished_percent'] < 90) {
                $result['80']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['80']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['80']["item_no_" . $item_no_min] += 1;
                }
            } else if ($implementation['finished_percent'] >= 90) {
                $result['90']['sub_total'] += 1;
                $employee_data = $this->getEmployeeData($implementation['employee_cd'], $relationship_data[0]);
                if (isset($employee_data['item_no']) && $employee_data['item_no'] > 0) {
                    $result['90']["item_no_" . $employee_data['item_no']] += 1;
                } else {
                    $result['90']["item_no_" . $item_no_min] += 1;
                }
            }
        }
        // sum item_no_percent
        foreach ($result as $key => $value) {
            $result[$key]['item_no_percent1'] = 0;
            $result[$key]['item_no_percent2'] = 0;
            $result[$key]['item_no_percent3'] = 0;
            $result[$key]['item_no_percent4'] = 0;
            if (isset($value['item_no_1'])) {
                $result[$key]['item_no_percent1'] = round((($value['item_no_1'] / $total) * 100), 1);
            }
            if (isset($value['item_no_2'])) {
                $result[$key]['item_no_percent2'] = round((($value['item_no_2'] / $total) * 100), 1);
            }
            if (isset($value['item_no_3'])) {
                $result[$key]['item_no_percent3'] = round((($value['item_no_3'] / $total) * 100), 1);
            }
            if (isset($value['item_no_4'])) {
                $result[$key]['item_no_percent4'] = round((($value['item_no_4'] / $total) * 100), 1);
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
        if (empty($input_array)) {
            return [];
        }
        // if $target_array empty then $input_array
        if (empty($target_array)) {
            return $input_array;
        }
        // get list employee_cd
        $employees = [];
        foreach ($target_array as $temp) {
            $employees[] = $temp['employee_cd'];
        }
        // 

        // remove employee not exists in $target_array
        foreach ($input_array as $key => $value) {
            if (!in_array($value['employee_cd'], $employees)) {
                unset($input_array[$key]);
            }
        }
        //  return 
        return $input_array;
    }
}
