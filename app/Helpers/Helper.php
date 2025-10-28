<?php

/**
 ****************************************************************************
 * MIRAI
 * Helper
 *
 * 処理概要/process overview	:	HELPER
 * 作成日/create date			:	2017/08/07
 * 作成者/creater				:	viettd – viettd@ans-asia.com
 *
 * 更新日/update date 			:
 * 更新者/updater				:
 * 更新内容	/update content		:
 *
 * @package    	 				: 	Helper
 * @copyright   				: 	Copyright (c) ANS-ASIA
 * @version						: 	1.0.0
 * **************************************************************************
 */

namespace App\Helpers;

use Exception;

class Helper
{
	/**
	 * show
	 *
	 * @author      :   viettd 	- 2017/08/07 - create
	 * @param       :   type_of_param  - description
	 * @return      :   type_of_result - description
	 * @access      :   public
	 * @see         :   show button function
	 */
	public static function buttonRender($buttonRight = array(), $attrs = array(), $param = array())
	{
		$buttonRightString 	= (sizeof($buttonRight) == 0) ? '' : Helper::genButtonRight($buttonRight, $attrs, $param);
		return $buttonRightString;
	}
	/**
	 * genButtonRight
	 *
	 * @author      :   viettd 	- 2017/08/07 - create
	 * @updated at  :   tannq 	- fix exception
	 * @param       :   type_of_param  - description
	 * @return      :   type_of_result - description
	 * @access      :   public
	 * @see         :   show button function
	 */
	public static function genButtonRight($items = array(), $attrs = array(), $param = array())
	{
		$result = '';
		try {
			$disabled = '';
			$screen_tabindex = '';
			$auth = session_data();
			$authority_typ = $auth->authority_typ;
			if ($authority_typ == 3) {
				$disabled = 'disabled';
			}
			$authority		= 0;
			$permission		= 0;
			$excepts = $auth->excepts;
			$currentScreenPrefix = $auth->currentScreenPrefix;
			if (property_exists($excepts, $currentScreenPrefix)) {
				$s0021 = $excepts->$currentScreenPrefix;
				$authority = $s0021->authority;
				if ($authority != 2) {

					$permission		= 1;	// 0. can use 1.disabled
				}
			}

			$listOutputButton           = array('id' => 'btn-List-Output', 'icon' => 'fa fa-print', 'label' => trans('messages.output_list'), 'class' => 'btn-outline-primary');
			$evaluationOutputButton     = array('id' => 'btn-Evaluation-Output', 'icon' => 'fa fa-print', 'label' => trans('messages.output_evaluation'), 'class' => 'btn-outline-primary');
			$saveButton                 = array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o ', 'label' => trans('messages.register'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$i2040SaveButton            = array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o ', 'label' => trans('messages.temp_save'), 'class' => 'btn-outline-primary');
			$backButton                 = array('id' => 'btn-back', 'icon' => 'fa fa-mail-reply', 'label' => trans('messages.back'), 'class' => 'btn-outline-primary');
			$deleteButton               = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$delButton                  = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$clearButton                = array('id' => 'btn-clear', 'icon' => 'fa fa-times', 'label' => trans('messages.clear'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$addNewButton               = array('id' => 'btn-add-new', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.add_new'), 'class' => 'btn-outline-primary', 'permission' => $authority_typ == 2 ? 1 : $permission);
			$searchButton               = array('id' => 'btn-search', 'icon' => 'fa fa-search', 'label' => trans('messages.search'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$referenceButton            = array('id' => 'btn-reference', 'icon' => 'fa fa-folder-open-o', 'label' => trans('messages.refer'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$correctionButton           = array('id' => 'btn-correction', 'icon' => 'fa fa-file', 'label' => trans('messages.modify'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$outputButton               = array('id' => 'btn-print', 'icon' => 'fa fa-upload', 'label' => trans('messages.output'), 'class' => 'btn-outline-primary');
			$confirmButton              = array('id' => 'btn-confirm', 'icon' => 'fa fa-check', 'label' => trans('messages.settle'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$changeButton               = array('id' => 'btn-change', 'icon' => 'fa fa-exchange', 'label' => trans('messages.change'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$updateButton               = array('id' => 'btn-update', 'icon' => 'fa fa-floppy-o', 'label' => trans('messages.update'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$settingButton              = array('id' => 'btn-setting', 'icon' => 'fa fa-cog', 'label' => trans('messages.set'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$uploadButton               = array('id' => 'btn-upload', 'icon' => 'fa fa-upload', 'label' => trans('messages.upload'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$importButton               = array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.capture'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$i2040ImportButton          = array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.capture'), 'class' => 'btn-outline-primary');
			$printButton                = array('id' => 'btn-print', 'icon' => 'fa fa-print', 'label' => trans('messages.output'), 'class' => 'btn-outline-primary');
			$closeButton                = array('id' => 'btn-close', 'icon' => 'fa fa-window-close', 'label' => trans('messages.close'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$copyButton                 = array('id' => 'btn-copy', 'icon' => 'fa fa-files-o', 'label' => trans('messages.copy'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$executionButton            = array('id' => 'btn-execution', 'icon' => 'fa fa-check', 'label' => trans('messages.execution'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$applyButton                = array('id' => 'btn-apply', 'icon' => 'fa fa-check', 'label' => trans('messages.apply'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$confirmButton2             = array('id' => 'btn-confirm', 'icon' => 'fa fa-check', 'label' => trans('messages.settle'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$i2040ConfirmButton2        = array('id' => 'btn-confirm', 'icon' => 'fa fa-check', 'label' => trans('messages.settle'), 'class' => 'btn-outline-primary');
			$itemSettingButton          = array('id' => 'btn-item-setting', 'icon' => 'fa fa-th-large', 'label' => trans('messages.item_setting'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$decisionCancelButton       = array('id' => 'btn-decision-cancel', 'icon' => 'fa fa-unlock-alt', 'label' => trans('messages.unsettle'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$I2040DecisionCancelButton  = array('id' => 'btn-decision-cancel', 'icon' => 'fa fa-unlock-alt', 'label' => trans('messages.unsettle'), 'class' => 'btn-outline-danger');
			$evaluationSynthesisButton  = array('id' => 'btn-evaluation-synthesis', 'icon' => 'fa fa-pie-chart', 'label' => trans('messages.go_to_overall_eval'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			// namnb add 2018-06-25
			$memoryButton               = array('id' => 'btn-memory', 'icon' => 'fa fa-floppy-o', 'label' => trans('messages.temp_save'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$sendButton                 = array('id' => 'btn-send', 'icon' => 'fa fa-check', 'label' => trans('messages.register'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$takeBackButton             = array('id' => 'btn-take-back', 'icon' => 'fa fa-reply', 'label' => trans('messages.take_back'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$recordButton               = array('id' => 'btn-record', 'icon' => 'fa fa-file-o', 'label' => trans('messages.interview_record'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$csvButton                  = array('id' => 'btn-csv', 'icon' => 'fa fa-arrow-down', 'label' => trans('messages.import_CSV'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$CreateDepartmentButton     = array('id' => 'btn-Create-Department', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_parent_org'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$CreateDivisionButton       = array('id' => 'btn-Create-Division', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_sub_org'), 'class' => 'btn-Create-Division btn-outline-primary', 'permission' => $permission);
			$deleteDivisionButton       = array('id' => 'btn-delete-Division', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete_sub_org'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$approveButton              = array('id' => 'btn-approve', 'icon' => 'fa fa-check-square', 'label' => trans('messages.approval'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$sendBackButton             = array('id' => 'btn-send-back', 'icon' => 'fa fa-hand-paper-o', 'label' => trans('messages.return'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$interviewButton            = array('id' => 'btn-interview', 'icon' => 'fa fa-clipboard', 'label' => trans('messages.interview_record'), 'class' => 'btn-outline-primary', 'permission' => 0);

			$releasedPass               = array('id' => 'btn-released-pass', 'icon' => 'fa fa-paper-plane-o', 'label' => trans('messages.issue_batch_pass'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$mailButton                 = array('id' => 'btn-mail', 'icon' => 'fa fa-adjust', 'label' => trans('messages.notify_pass'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$staffHistryOutputButton    = array('id' => 'btn-print-history', 'icon' => 'fa fa-upload', 'label' => trans('messages.output_eval_history'), 'class' => 'btn-outline-primary');
			$staffOutputButton          = array('id' => 'btn-print-employee', 'icon' => 'fa fa-upload', 'label' => trans('messages.output_employee_list'), 'class' => 'btn-outline-primary');
			$feedbackButton             = array('id' => 'btn-feedback', 'icon' => 'fa fa-comments', 'label' => trans('messages.feedback'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$feedbackEvaluatorButton    = array('id' => 'btn-feedback-evaluator', 'icon' => 'fa fa-comments', 'label' => trans('messages.rated_fb'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$i2040FeedbackEvaluatorButton	= array('id' => 'btn-feedback-evaluator', 'icon' => 'fa fa-comments', 'label' => trans('messages.rated_fb'), 'class' => 'btn-outline-primary');
			$feedbackRaterButton       	= array('id' => 'btn-feedback-rater', 'icon' => 'fa fa-comments', 'label' => trans('messages.1st_rater_fb'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$i2040FeedbackRaterButton   = array('id' => 'btn-feedback-rater', 'icon' => 'fa fa-comments', 'label' => trans('messages.1st_rater_fb'), 'class' => 'btn-outline-primary');
			$idOutputButton             = array('id' => 'btn-id-output', 'icon' => 'fa fa-check', 'label' => trans('messages.issue_id'), 'class' => 'btn-outline-primary');
			$ItemEvaluationInputButton  = array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download ', 'label' => trans('messages.download_eval_item'), 'class' => 'btn-outline-primary', 'permission' => $permission); //評価項目取り込み
			$ItemEvaluationOutputButton = array('id' => 'btn-item-evaluation-output', 'icon' => 'fa fa-print', 'label' => trans('messages.print_eval_item'), 'class' => 'btn-outline-primary'); //評価項目出力
			$dataInputButton            = array('id' => 'btn-data-input', 'icon' => 'fa fa-download ', 'label' => trans('messages.import_data'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$dataOutoutButton           = array('id' => 'btn-data-output', 'icon' => 'fa fa-print ', 'label' => trans('messages.output_data'), 'class' => 'btn-outline-primary');
			$preEvaluationCopyButton    = array('id' => 'btn-pre-evaluation-copy', 'icon' => 'fa fa-files-o', 'label' => trans('messages.copy_pre_rater'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			// sondh add 2018/08/22
			$deleteParentButton         = array('id' => 'btn-delete-parent', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete_parent_org'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$addNewSignupButton         = array('id' => 'btn-new-signup', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.sign_up'), 'class' => 'btn-outline-primary', 'permission' => $permission);

			// M0020
			$changeNameOrg      		= array('id' => 'btn-change-org-name', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.change_org_name'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$createNewOrg       		= array('id' => 'btn-create-org', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_new'), 'class' => 'btn-outline-primary', 'permission' => $permission);

			//ver1.7
			$excel         				= array('id' => 'btn-excel', 'icon' => 'fa fa-file-excel-o', 'label' => trans('messages.output_excel'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$finishasign        		= array('id' => 'btn-finishasign', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_after_1on1'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$beginasign        			= array('id' => 'btn-beginasign', 'icon' => 'fa fa-caret-square-o-right', 'label' => trans('messages.register_after_1on1'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$startasign         		= array('id' => 'btn-startasign', 'icon' => 'fa fa-caret-square-o-left', 'label' => trans('messages.register_before_1on1'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$endasign         			= array('id' => 'btn-endasign', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_before_1on1'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$v17ImportButton    		= array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.import'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$downloadButton  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.download'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$downloadButton2  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.down_personal_detail'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$downloadButton3 			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.down_average_point_list'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$exportButton  				= array('id' => 'btn-export', 'icon' => 'fa fa-print ', 'label' => trans('messages.export'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$sentquestion  				= array('id' => 'btn-sentquestion', 'icon' => 'fa fa-paper-plane-o', 'label' => trans('messages.deliver'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$backStatus  				= array('id' => 'btn-back-status', 'icon' => 'fa fa-backward', 'label' => trans('messages.return_status'), 'class' => 'btn-outline-danger', 'permission' => $permission);
			$q2010excel3  				= array('id' => 'btn-q2010-excel', 'icon' => 'fa fa-print', 'label' => trans('messages.output_target_list'), 'class' => 'btn-outline-primary');
			$supportPopup  				= array('id' => 'btn-view-supporter', 'icon' => 'fa fa-male', 'label' => trans('messages.supporter_viewing_settings'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$v17printButton             = array('id' => 'btn-print', 'icon' => 'fa fa-print', 'label' => trans('messages.output_list'), 'class' => 'btn-outline-primary');

			//ver2.1
			$createCategory        		= array('id' => 'btn-create-category', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_category'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$createCourse        		= array('id' => 'btn-create-course', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_course'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$createSelect        		= array('id' => 'btn-create-select', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.creating_selection'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$preview        			= array('id' => 'btn-preview', 'icon' => 'fa fa-eye', 'label' => trans('messages.preview'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			$employeeInformationOutput  = array('id' => 'btn-employee-info-output', 'icon' => 'fa fa-print', 'label' => trans('messages.employee_information_output'), 'class' => 'btn-outline-primary', 'permission' => $permission);
			//↓↓↓ permission check
			$m = '';
			if (isset($items) && !empty($items)) {
				$item_btn_arr = [];
				foreach ($items as $item) {
					if (isset($$item)) {
						$item_btn_arr[$item] = $$item;
					}
				}			
				$btnMobie = self::generateBtn($item_btn_arr,$param,'genButtonRight');
				// for mobile
				$result .= '<div class="col-2 col-xl-6 col-lg-6 header-right-function  nav-menubar-mobile" style="text-align:right">';
				if ($btnMobie['countItem'] == 1) {
					$result .=$btnMobie['result'];
				}else{
					$result .= '<div class="dropdown dropleft">';
					$result .= '<img style="float:right;cursor:pointer;margin-top:7px" src="/template/image/icon/1on1/icon_1.png" id="dropdownMenuLink" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" >';
					$result .= '<div class="dropdown-menu dropdown-menu-1on1" aria-labelledby="dropdownMenuLink">';
					// loop
					foreach ($items as $item) {
						$item_arr 	= isset($$item) ? $$item : null;
						// // check if button exists in $param
						// if (isset($param[$item]) && $param[$item] == '1') {
						// 	$result .= '<a class="dropdown-item ' . array_get($item_arr, 'class') . '" href="#" id="' . array_get($item_arr, 'id') . '"><span><i class="' . array_get($item_arr, 'icon') . '" style="margin-right: 5px"></i></span> ' . array_get($item_arr, 'label') . '</a>';
						// 	continue;
						// }
						// // check if button not exists in $param
						// if (!isset($param[$item]) && isset($item_arr) && array_get($item_arr, 'permission') != '1') {
						// 	$result .= '<a class="dropdown-item ' . array_get($item_arr, 'class') . '" href="#" id="' . array_get($item_arr, 'id') . '"><span><i class="' . array_get($item_arr, 'icon') . '" style="margin-right: 5px"></i></span> ' . array_get($item_arr, 'label') . '</a>';
						// }						
						if (isset($item_arr) && ((isset($param[$item]) && ($param[$item] != '1'))||($disabled == 'disabled' && array_get($item_arr, 'permission','0') == '1'))) {
							continue;
						}
						$result .= '<a class="dropdown-item ' . array_get($item_arr, 'class') . '" href="#" id="' . array_get($item_arr, 'id') . '"><span><i class="' . array_get($item_arr, 'icon') . '" style="margin-right: 5px"></i></span> ' . array_get($item_arr, 'label') . '</a>';	
					}
					// append after loop
					$result .= '</div>';
					$result .= '</div>';
				}
				$result .= '</div>';
				// for PC
				$result .= '<div class="col-2 col-xl-6 col-lg-6 header-right-function  nav-menubar-pc" style="text-align:right">';
				$result .= '<ul class="navbar-nav ml-auto" style="display:-webkit-inline-box">';
				foreach ($items as $item) {
					$item_arr 	= isset($$item) ? $$item : null;
					//
					$screen_disabled = '';
					$dis_tab = '';
					if (isset($item_arr)) {
						if (isset($param[$item]) && ($param[$item] != '1')) {
							$screen_disabled = 'disabled';
							$dis_tab = 'tabindex = -1';
						}
						if (array_get($item_arr, 'permission') == '1') {
							// if($disabled){
							$result .= '<li class="nav-item">';
							$result .= '	<a href="#" id="' . array_get($item_arr, 'id') . '" class="btn btn-horizontal ' . array_get($item_arr, 'class') . ' ' . $disabled . ' ' . $screen_disabled . '"  ' . $screen_tabindex . ' ' . $dis_tab . '>';
							$result .= '		<i class="' . array_get($item_arr, 'icon') . '"></i>';
							$result .= '		<div>' . array_get($item_arr, 'label') . '</div>';
							$result .= '	</a>';
							$result .= '</li>';
							// }else{
							// 	continue;
							// }
						} else {
							$result .= '<li class="nav-item">';
							$result .= '	<a href="#" id="' . array_get($item_arr, 'id') . '" class="btn btn-horizontal ' . array_get($item_arr, 'class') . ' ' . $screen_disabled . '" ' . $screen_tabindex . ' ' . $dis_tab . '>';
							$result .= '		<i class="' . array_get($item_arr, 'icon') . '"></i>';
							$result .= '		<div>' . array_get($item_arr, 'label') . '</div>';
							$result .= '	</a>';
							$result .= '</li>';
						}
					} else {
						$m .= "Undefined variable: {$item}";
					}
					// append after loop
				}
				$result .= '</ul>';
				$result .= '</div>';
			}
			if ($m) throw new Exception($m, 1);
		} catch (Exception $e) {
			echo $e->getMessage();
		}
		return $result;
	}

	/**
	 * dropdownRenderEmployeeInformation
	 *
	 * @param  Array $items
	 * @param  Array $param
	 * @return Html
	 */
	public static function dropdownRenderEmployeeInformation($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		//ver2.1
		$saveButton                 = array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o ', 'label' => trans('messages.register'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$backButton                 = array('id' => 'btn-back', 'icon' => 'fa fa-mail-reply', 'label' => trans('messages.back'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$deleteButton               = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'btn-outline-danger', 'permission' => $permission);
		$addNewButton               = array('id' => 'btn-add-new', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.add_new'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$dataInputButton            = array('id' => 'btn-data-input', 'icon' => 'fa fa-download ', 'label' => trans('messages.import_data'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$dataOutoutButton           = array('id' => 'btn-data-output', 'icon' => 'fa fa-print ', 'label' => trans('messages.output_data'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$staffOutputButton          = array('id' => 'btn-print-employee', 'icon' => 'fa fa-upload', 'label' => trans('messages.output_employee_list'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$createCategory        		= array('id' => 'btn-create-category', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_category'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$createCourse        		= array('id' => 'btn-create-course', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_course'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$createSelect        		= array('id' => 'btn-create-select', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.creating_selection'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$preview        			= array('id' => 'btn-preview', 'icon' => 'fa fa-eye', 'label' => trans('messages.preview'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$employeeInformationOutput  = array('id' => 'btn-employee-info-output', 'icon' => 'fa fa-print', 'label' => trans('messages.employee_information_output'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$addNewSignupButton         = array('id' => 'btn-new-signup', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.sign_up'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		
		// render
		if (isset($items) && !empty($items)) {
			$item_btn_arr = [];
			foreach ($items as $item) {
				if (isset($$item)) {
					$item_btn_arr[$item] = $$item;
				}
			}
			$btnMobie = self::generateBtn($item_btn_arr);
			// for mobile
			$result .= '<div class="col-2 col-xl-6 col-lg-6 header-right-function  nav-menubar-mobile" style="text-align:right">';
			if ($btnMobie['countItem'] == 1) {
				$result .=$btnMobie['result'];
			}else{
				$result .= '<div class="dropdown dropleft">';
				$result .= '<img style="float:right;cursor:pointer;margin-top:7px" src="/template/image/icon/1on1/icon_1.png" id="dropdownMenuLink" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" >';
				$result .= '<div class="dropdown-menu dropdown-menu-1on1" aria-labelledby="dropdownMenuLink">';
				// loop
				foreach ($items as $item) {
					$item_arr 	= isset($$item) ? $$item : null;
					//
					if (isset($item_arr)) {
						// if permission is view & update
						if (array_get($item_arr, 'permission') == '1') {
							$result .= '<a class="dropdown-item ' . array_get($item_arr, 'class') . '" href="#" id="' . array_get($item_arr, 'id') . '"><span><i class="' . array_get($item_arr, 'icon') . '" style="margin-right: 5px"></i></span> ' . array_get($item_arr, 'label') . '</a>';
						}
					}
				}
				// append after loop
				$result .= '</div>';
				$result .= '</div>';
			}
			$result .= '</div>';
			// for PC
			$result .= '<div class="col-2 col-xl-6 col-lg-6 header-right-function  nav-menubar-pc" style="text-align:right">';
			$result .= '<ul class="navbar-nav ml-auto" style="display:-webkit-inline-box">';

			foreach ($items as $item) {
				$item_arr 	= isset($$item) ? $$item : null;
				//
				if (isset($item_arr)) {
					// if permission is view & update
					if (array_get($item_arr, 'permission') == '1') {
						$result .= '<li class="nav-item">';
						$result .= '	<a href="#" id="' . array_get($item_arr, 'id') . '" class="btn btn-horizontal ' . array_get($item_arr, 'class') . '">';
						$result .= '		<i class="' . array_get($item_arr, 'icon') . '"></i>';
						$result .= '		<div>' . array_get($item_arr, 'label') . '</div>';
						$result .= '	</a>';
						$result .= '</li>';
					}
				}
			}
			// append after loop
			$result .= '</ul>';
			$result .= '</div>';
		}
		return $result;
	}

	/**
	 * dropdownRender1on1
	 *
	 * @param  array $buttonRight
	 * @param  array $attrs
	 * @param  array $param ['importButton'=>'0'] || ['importButton'=>'1']
	 * @return string
	 */
	public static function dropdownRender1on1($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		//1on1
		$importButton       		= array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.import'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$deleteButton       		= array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'dropdown-item dropdown-item-delete', 'permission' => $permission);
		$addNewButton       		= array('id' => 'btn-add-new', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.add_new'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		//2021/05/13 add by vietdt
		$memoryButton               = array('id' => 'btn-memory', 'icon' => 'fa fa-floppy-o', 'label' => trans('messages.temp_save'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$submitButton       		= array('id' => 'btn-submit', 'icon' => 'fa fa-check', 'label' => trans('messages.submit'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$approveButton              = array('id' => 'btn-approve', 'icon' => 'fa fa-check-square', 'label' => trans('messages.approval'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$sendBackButton             = array('id' => 'btn-send-back', 'icon' => 'fa fa-hand-paper-o', 'label' => trans('messages.return'), 'class' => 'dropdown-item btn-outline-danger', 'permission' => $permission);

		$saveButton       			= array('id' => 'btn-save-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'dropdown-item btn-outline-primary btn-save', 'permission' => $permission);
		$finishasign        		= array('id' => 'btn-finishasign-data', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_after_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-finishasign', 'permission' => $permission);
		$beginasign        			= array('id' => 'btn-beginasign-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.register_after_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-beginasign', 'permission' => $permission);
		$startasign         		= array('id' => 'btn-startasign-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.register_before_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-startasign', 'permission' => $permission);
		$saveButton_oi3010       	= array('id' => 'btn-save-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.send'), 'class' => 'dropdown-item btn-outline-primary btn-save', 'permission' => $permission);
		//2021/12/03 add by vietdt
		$temporarySave        		= array('id' => 'btn-temporary-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.temp_save'), 'class' => 'dropdown-item btn-outline-primary btn-temporary', 'permission' => $permission);
		$previousDeregistration     = array('id' => 'btn-previous-deregistration-data', 'icon' => 'fa fa-trash', 'label' => trans('messages.unregister_before_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-previous-deregistration', 'permission' => $permission);

		$excel         				= array('id' => 'btn-excel', 'icon' => 'fa fa-file-excel-o', 'label' => trans('messages.output_excel'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$v17ImportButton    		= array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.import'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$downloadButton  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.download'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$downloadButton2  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.down_personal_detail'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$downloadButton3 			= array('id' => 'btn-item-evaluation-input-3', 'icon' => 'fa fa-download', 'label' => trans('messages.down_average_point_list'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$exportButton  				= array('id' => 'btn-export', 'icon' => 'fa fa-print ', 'label' => trans('messages.export'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$sentquestion  				= array('id' => 'btn-sentquestion', 'icon' => 'fa fa-paper-plane-o', 'label' => trans('messages.deliver'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$backStatus  				= array('id' => 'btn-back-status', 'icon' => 'fa fa-backward', 'label' => trans('messages.return_status'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$q2010excel3  				= array('id' => 'btn-q2010-excel', 'icon' => 'fa fa-print', 'label' => trans('messages.output_target_list'), 'class' => 'dropdown-item');
		$supportPopup  				= array('id' => 'btn-view-supporter', 'icon' => 'fa fa-male', 'label' => trans('messages.supporter_viewing_settings'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$v17printButton             = array('id' => 'btn-print', 'icon' => 'fa fa-print', 'label' => trans('messages.output_list'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$copyButton                 = array('id' => 'btn-copy', 'icon' => 'fa fa-files-o', 'label' => trans('messages.copy'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$backButton                 = array('id' => 'btn-back', 'icon' => 'fa fa-mail-reply', 'label' => trans('messages.back'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$addNewSignupButton         = array('id' => 'btn-new-signup', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.sign_up'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$delButton                  = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel'), 'class' => 'dropdown-item dropdown-item-delete', 'permission' => $permission);
		$uploadButton               = array('id' => 'btn-upload', 'icon' => 'fa fa-upload', 'label' => trans('messages.upload'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$dataInputButton            = array('id' => 'btn-data-input', 'icon' => 'fa fa-download ', 'label' => trans('messages.import_data'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$dataOutoutButton           = array('id' => 'btn-data-output', 'icon' => 'fa fa-print ', 'label' => trans('messages.output_data'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$sendButton                 = array('id' => 'btn-send', 'icon' => 'fa fa-check', 'label' => trans('messages.register'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$newGroup 					= array('id' => 'btn-new-group', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_my_group'), 'class' => 'dropdown-item btn-outline-primary', 'permission'  => $permission);
		// render
		if (isset($items) && !empty($items)) {
			$item_btn_arr = [];
			foreach ($items as $item) {
				if (isset($$item)) {
					$item_btn_arr[$item] = $$item;
				}
			}			
			$btnMobie = self::generateBtn($item_btn_arr,$param);
			// for mobile
			$result .= '<div class="col-2 col-sm-7 col-md-9 col-xl-6 col-lg-6 header-right-function  nav-menubar-mobile" style="text-align:right">';
			if ($btnMobie['countItem'] == 1) {
				$result .=$btnMobie['result'];
			}else{
				$result .= '<div class="dropdown dropleft">';
				$result .= '<img style="float:right;cursor:pointer;margin-top:7px" src="/template/image/icon/1on1/icon_1.png" id="dropdownMenuLink" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" >';
				$result .= '<div class="dropdown-menu dropdown-menu-1on1" aria-labelledby="dropdownMenuLink">';
				// loop
				foreach ($items as $item) {
					$item_arr 	= isset($$item) ? $$item : null;
					//
					if (isset($item_arr)) {
						// if permission is view & update
						if (array_get($item_arr, 'permission') == '1') {
							$result .= '<a class="' . array_get($item_arr, 'class') . '" href="#" id="' . array_get($item_arr, 'id') . '"><span><i class="' . array_get($item_arr, 'icon') . '" style="margin-right: 5px"></i></span> ' . array_get($item_arr, 'label') . '</a>';
						}
					}
				}
				// append after loop
				$result .= '</div>';
				$result .= '</div>';				
			}
			$result .= '</div>';
			// for PC
			$result .= '<div class="col-10 col-sm-7 col-md-9 col-lg-8 col-xl-6 header-right-function  nav-menubar-pc" style="text-align:right">';
			$result .= '<ul class="navbar-nav ml-auto mt-2" style="display:-webkit-inline-box">';
			foreach ($items as $item) {
				$item_arr 	= isset($$item) ? $$item : null;
				//
				if (isset($item_arr)) {
					// if permission is view & update
					if (array_get($item_arr, 'permission') == '1') {
						$result .= '<li class="nav-item">';
						$result .= '	<a href="#" id="' . array_get($item_arr, 'id') . '" class="btn btn-horizontal ' . array_get($item_arr, 'class') . '">';
						$result .= '		<i class="' . array_get($item_arr, 'icon') . '"></i>';
						$result .= '		<div>' . array_get($item_arr, 'label') . '</div>';
						$result .= '	</a>';
						$result .= '</li>';
					}
				}
			}
			// append after loop
			$result .= '</ul>';
			$result .= '</div>';
		}
		return $result;
	}

	/**
	 * dropdownRenderWeeklyReport
	 *
	 * @param  array $items
	 * @param  array $param ['importButton'=>'0'] || ['importButton'=>'1']
	 * @return string
	 */
	public static function dropdownRenderWeeklyReport($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		//1on1
		$importButton       		= array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.import'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$deleteButton       		= array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'dropdown-item dropdown-item-delete', 'permission' => $permission);
		$addNewButton       		= array('id' => 'btn-add-new', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.add_new'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		//2021/05/13 add by vietdt
		$memoryButton               = array('id' => 'btn-memory', 'icon' => 'fa fa-floppy-o', 'label' => trans('messages.temp_save'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$submitButton       		= array('id' => 'btn-submit', 'icon' => 'fa fa-check', 'label' => trans('messages.submit'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$approveButton              = array('id' => 'btn-approve', 'icon' => 'fa fa-check-square', 'label' => trans('messages.approval'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$sendBackButton             = array('id' => 'btn-send-back', 'icon' => 'fa fa-hand-paper-o', 'label' => trans('messages.return'), 'class' => 'dropdown-item btn-outline-danger', 'permission' => $permission);

		$saveButton       			= array('id' => 'btn-save-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'dropdown-item btn-outline-primary btn-save', 'permission' => $permission);
		$finishasign        		= array('id' => 'btn-finishasign-data', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_after_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-finishasign', 'permission' => $permission);
		$beginasign        			= array('id' => 'btn-beginasign-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.register_after_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-beginasign', 'permission' => $permission);
		$startasign         		= array('id' => 'btn-startasign-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.register_before_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-startasign', 'permission' => $permission);
		$saveButton_oi3010       	= array('id' => 'btn-save-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.send'), 'class' => 'dropdown-item btn-outline-primary btn-save', 'permission' => $permission);
		//2021/12/03 add by vietdt
		$temporarySave        		= array('id' => 'btn-temporary-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.temp_save'), 'class' => 'dropdown-item btn-outline-primary btn-temporary', 'permission' => $permission);
		$previousDeregistration     = array('id' => 'btn-previous-deregistration-data', 'icon' => 'fa fa-trash', 'label' => trans('messages.unregister_before_1on1'), 'class' => 'dropdown-item btn-outline-primary btn-previous-deregistration', 'permission' => $permission);

		$excel         				= array('id' => 'btn-excel', 'icon' => 'fa fa-file-excel-o', 'label' => trans('messages.output_excel'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$v17ImportButton    		= array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.import'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$downloadButton  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.download'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$downloadButton2  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.down_personal_detail'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$downloadButton3 			= array('id' => 'btn-item-evaluation-input-3', 'icon' => 'fa fa-download', 'label' => trans('messages.down_average_point_list'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$exportButton  				= array('id' => 'btn-export', 'icon' => 'fa fa-print ', 'label' => trans('messages.export'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$sentquestion  				= array('id' => 'btn-sentquestion', 'icon' => 'fa fa-paper-plane-o', 'label' => trans('messages.deliver'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$backStatus  				= array('id' => 'btn-back-status', 'icon' => 'fa fa-backward', 'label' => trans('messages.return_status'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$q2010excel3  				= array('id' => 'btn-q2010-excel', 'icon' => 'fa fa-print', 'label' => trans('messages.output_target_list'), 'class' => 'dropdown-item');
		$supportPopup  				= array('id' => 'btn-view-supporter', 'icon' => 'fa fa-male', 'label' => trans('messages.supporter_viewing_settings'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$v17printButton             = array('id' => 'btn-print', 'icon' => 'fa fa-print', 'label' => trans('messages.output_list'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$copyButton                 = array('id' => 'btn-copy', 'icon' => 'fa fa-files-o', 'label' => trans('messages.copy'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$backButton                 = array('id' => 'btn-back', 'icon' => 'fa fa-mail-reply', 'label' => trans('messages.back'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$addNewSignupButton         = array('id' => 'btn-new-signup', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.sign_up'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$delButton                  = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel'), 'class' => 'dropdown-item dropdown-item-delete', 'permission' => $permission);
		$uploadButton               = array('id' => 'btn-upload', 'icon' => 'fa fa-upload', 'label' => trans('messages.upload'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$dataInputButton            = array('id' => 'btn-data-input', 'icon' => 'fa fa-download ', 'label' => trans('messages.import_data'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$dataOutoutButton           = array('id' => 'btn-data-output', 'icon' => 'fa fa-print ', 'label' => trans('messages.output_data'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$sendButton                 = array('id' => 'btn-send', 'icon' => 'fa fa-check', 'label' => trans('messages.register'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$newGroup 					= array('id' => 'btn-new-group', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_my_group'), 'class' => 'dropdown-item btn-outline-primary', 'permission'  => $permission);
		// render
		if (isset($items) && !empty($items)) {
			$item_btn_arr = [];
			foreach ($items as $item) {
				if (isset($$item)) {
					$item_btn_arr[$item] = $$item;
				}
			}			
			$btnMobie = self::generateBtn($item_btn_arr,$param);
			// for mobile
			$result .= '<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6 header-right-function  nav-menubar-mobile" style="text-align:right">';
			if ($btnMobie['countItem'] == 1) {
				$result .=$btnMobie['result'];
			}else{
				$result .= '<div class="dropdown dropleft">';
				$result .= '<img style="float:right;cursor:pointer;margin-top:7px" src="/template/image/icon/1on1/icon_1.png" id="dropdownMenuLink" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" >';
				$result .= '<div class="dropdown-menu dropdown-menu-1on1" aria-labelledby="dropdownMenuLink">';
				// loop
				foreach ($items as $item) {
					$item_arr 	= isset($$item) ? $$item : null;
					//
					if (isset($item_arr)) {
						// if permission is view & update
						if (array_get($item_arr, 'permission') == '1') {
							$result .= '<a class="' . array_get($item_arr, 'class') . '" href="#" id="' . array_get($item_arr, 'id') . '"><span><i class="' . array_get($item_arr, 'icon') . '" style="margin-right: 5px"></i></span> ' . array_get($item_arr, 'label') . '</a>';
						}
					}
				}
				// append after loop
				$result .= '</div>';
				$result .= '</div>';
			}
			$result .= '</div>';
			// for PC
			$result .= '<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6 header-right-function  nav-menubar-pc" style="text-align:right">';
			$result .= '<ul class="navbar-nav ml-auto mt-2" style="display:-webkit-inline-box">';
			foreach ($items as $item) {
				$item_arr 	= isset($$item) ? $$item : null;
				//
				if (isset($item_arr)) {
					// if permission is view & update
					if (array_get($item_arr, 'permission') == '1') {
						$result .= '<li class="nav-item">';
						$result .= '	<a href="#" id="' . array_get($item_arr, 'id') . '" class="btn btn-horizontal ' . array_get($item_arr, 'class') . '">';
						$result .= '		<i class="' . array_get($item_arr, 'icon') . '"></i>';
						$result .= '		<div>' . array_get($item_arr, 'label') . '</div>';
						$result .= '	</a>';
						$result .= '</li>';
					}
				}
			}
			// append after loop
			$result .= '</ul>';
			$result .= '</div>';
		}
		return $result;
	}

	/**
	 * buttonRender1on1
	 *
	 * @param  array $items
	 * @param  array $param ['importButton'=>'0'] || ['importButton'=>'1']
	 * @return string
	 */
	public static function buttonRender1on1($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		// 1on1
		$saveButton       			= array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'btn button-1on1 btn-block btn-save', 'permission' => $permission);
		$saveButton_oi3010       	= array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.send'), 'class' => 'btn button-1on1 btn-block btn-save', 'permission' => $permission);
		$saveButtonSetup       		= array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'btn button-1on1 btn-block', 'permission' => 1);
		$finishasign        		= array('id' => 'btn-finishasign', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_after_1on1'), 'class' => 'btn button-1on1 btn-block btn-finishasign', 'permission' => $permission);
		$beginasign        			= array('id' => 'btn-beginasign', 'icon' => 'fa fa-caret-square-o-right', 'label' => trans('messages.register_after_1on1'), 'class' => 'btn button-1on1 btn-block btn-beginasign', 'permission' => $permission);
		$startasign         		= array('id' => 'btn-startasign', 'icon' => 'fa fa-caret-square-o-left', 'label' => trans('messages.register_before_1on1'), 'class' => 'btn button-1on1 btn-block btn-startasign', 'permission' => $permission);
		$endasign         			= array('id' => 'btn-endasign', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_before_1on1'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$deleteButton               = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'btn button-1on1 btn-block btn-1on1-danger', 'permission' => $permission);

		$memoryButton               = array('id' => 'btn-memory', 'icon' => 'fa fa-floppy-o', 'label' => trans('messages.temp_save'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$submitButton       		= array('id' => 'btn-submit', 'icon' => 'fa fa-check', 'label' => trans('messages.submit'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$approveButton              = array('id' => 'btn-approve', 'icon' => 'fa fa-check-square', 'label' => trans('messages.approval'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$sendBackButton             = array('id' => 'btn-send-back', 'icon' => 'fa fa-hand-paper-o', 'label' => trans('messages.return'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$commentButton              = array('id' => 'btn-send-back', 'icon' => 'fa fa-hand-paper-o', 'label' => trans('ri2010.comment_action'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$sendButton                 = array('id' => 'btn-send', 'icon' => 'fa fa-check', 'label' => trans('messages.register'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		// $sticktButton                 = array('id' => 'btn-sticky', 'icon' => 'fa fa-check', 'label' => trans('messages.stick_aticky'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);

		// render
		foreach ($items as $item) {
			$item_arr 	= isset($$item) ? $$item : null;
			//
			if (isset($item_arr)) {
				// if permission is view & update
				if (array_get($item_arr, 'permission') == '1') {
					$result .= '<div class="col-md-5 col-lg-5 col-sm-5 col-xl-3 col-12 mt-3">';
					$result .= '<button tabindex="9999" id="' . array_get($item_arr, 'id') . '" type="button" class="' . array_get($item_arr, 'class') . '">' . array_get($item_arr, 'label') . '</button>';
					$result .= '</div>';
				}
			}
		}
		return $result;
	}

	/**
	 * buttonRenderWeeklyReport
	 *
	 * @param  array $items
	 * @param  array $param ['importButton'=>'0'] || ['importButton'=>'1']
	 * @return string
	 */
	public static function buttonRenderWeeklyReport($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		// 1on1
		$saveButton       			= array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'btn button-1on1 btn-block btn-save', 'permission' => $permission);
		$saveButton_oi3010       	= array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.send'), 'class' => 'btn button-1on1 btn-block btn-save', 'permission' => $permission);
		$saveButtonSetup       		= array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'btn button-1on1 btn-block', 'permission' => 1);
		$finishasign        		= array('id' => 'btn-finishasign', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_after_1on1'), 'class' => 'btn button-1on1 btn-block btn-finishasign', 'permission' => $permission);
		$beginasign        			= array('id' => 'btn-beginasign', 'icon' => 'fa fa-caret-square-o-right', 'label' => trans('messages.register_after_1on1'), 'class' => 'btn button-1on1 btn-block btn-beginasign', 'permission' => $permission);
		$startasign         		= array('id' => 'btn-startasign', 'icon' => 'fa fa-caret-square-o-left', 'label' => trans('messages.register_before_1on1'), 'class' => 'btn button-1on1 btn-block btn-startasign', 'permission' => $permission);
		$endasign         			= array('id' => 'btn-endasign', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel_before_1on1'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$deleteButton               = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'btn button-1on1 btn-block btn-1on1-danger', 'permission' => $permission);

		$memoryButton               = array('id' => 'btn-memory', 'icon' => 'fa fa-floppy-o', 'label' => trans('messages.temp_save'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$submitButton       		= array('id' => 'btn-submit', 'icon' => 'fa fa-check', 'label' => trans('messages.submit'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$approveButton              = array('id' => 'btn-approve', 'icon' => 'fa fa-check-square', 'label' => trans('messages.approval'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$sendBackButton             = array('id' => 'btn-send-back', 'icon' => 'fa fa-hand-paper-o', 'label' => trans('messages.return'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$commentButton              = array('id' => 'btn-send-back', 'icon' => 'fa fa-hand-paper-o', 'label' => trans('ri2010.comment_action'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$sendButton                 = array('id' => 'btn-send', 'icon' => 'fa fa-check', 'label' => trans('messages.register'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);
		$stickyButton               = array('id' => 'btn-sticky', 'icon' => 'fa fa-check', 'label' => trans('messages.stick_aticky'), 'class' => 'btn button-1on1 btn-block', 'permission' => $permission);

		// render
		foreach ($items as $item) {
			$item_arr 	= isset($$item) ? $$item : null;
			//
			if (isset($item_arr)) {
				// if permission is view & update
				if (array_get($item_arr, 'permission') == '1') {
					$result .= '<div class="col-md-5 col-lg-5 col-sm-5 col-xl-3 col-12 mt-3">';
					$result .= '<button tabindex="9999" id="' . array_get($item_arr, 'id') . '" type="button" class="' . array_get($item_arr, 'class') . '">' . array_get($item_arr, 'label') . '</button>';
					$result .= '</div>';
				}
			}
		}
		return $result;
	}
	
	/**
	 * dropdownRenderEmployeeInformation
	 *
	 * @param  Array $items
	 * @param  Array $param
	 * @return Html
	 */
	public static function buttonRenderEmployeeInformation($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		$permission_mi0200 = self::getPermission($auth,'eI0200');
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		//ver2.1
		$saveButton                 = array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o ', 'label' => trans('messages.register'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$saveButton_ei0200          = array('id' => 'btn-save-ei0200', 'icon' => 'fa fa-pencil-square-o ', 'label' => trans('messages.register'), 'class' => 'btn-outline-primary', 'permission' => $permission_mi0200);
		$backButton                 = array('id' => 'btn-back', 'icon' => 'fa fa-mail-reply', 'label' => trans('messages.back'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$deleteButton               = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'btn-outline-danger', 'permission' => $permission);
		$addNewButton               = array('id' => 'btn-add-new', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.add_new'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$dataInputButton            = array('id' => 'btn-data-input', 'icon' => 'fa fa-download ', 'label' => trans('messages.import_data'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$dataOutoutButton           = array('id' => 'btn-data-output', 'icon' => 'fa fa-print ', 'label' => trans('messages.output_data'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$staffOutputButton          = array('id' => 'btn-print-employee', 'icon' => 'fa fa-upload', 'label' => trans('messages.output_employee_list'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$createCategory        		= array('id' => 'btn-create-category', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_category'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$createCourse        		= array('id' => 'btn-create-course', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_course'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$createSelect        		= array('id' => 'btn-create-select', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.creating_selection'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$preview        			= array('id' => 'btn-preview', 'icon' => 'fa fa-eye', 'label' => trans('messages.preview'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		$employeeInformationOutput  = array('id' => 'btn-employee-info-output', 'icon' => 'fa fa-print', 'label' => trans('messages.employee_information_output'), 'class' => 'btn-outline-primary', 'permission' => 1);
		$addNewSignupButton         = array('id' => 'btn-new-signup', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.sign_up'), 'class' => 'btn-outline-primary', 'permission' => $permission);
		
		$personalSettingButton      = array('id' => 'personal_setting_btn', 'icon' => 'fa fa-cog', 'label' => trans('messages.sign_up'), 'class' => 'personal_setting', 'permission' => $permission);
		
		foreach ($items as $item) {
			$item_arr 	= isset($$item) ? $$item : null;
			//
			if (isset($item_arr)) {
				// if permission is view & update
	
				if (array_get($item_arr, 'permission') == '1') {

						$result .= '<div class="form-group">';
						$result .= '<div class="input-group-btn input-group">';
						$result .= '<div class="form-group text-right">';
						$result .= '<div class="full-width">';
						$result .= '<a href="javascript:;" id="' . array_get($item_arr, 'id') . '" class="btn ' . array_get($item_arr, 'class') . '" tabindex="1"  >';
						$result .= '<i class="' . array_get($item_arr, 'icon') . '"></i>';
						$result .= array_get($item_arr, 'label');
						$result .= '</a>';
						$result .= '</div>';
						$result .= '</div>';
						$result .= '</div>';
						$result .= '</div>';

				}
			}
		}
		return $result;
	}
	

	/**
	 * dropdownRenderMulitireview
	 *
	 * @param  array $buttonRight
	 * @param  array $attrs
	 * @param  array $param ['importButton'=>'0'] || ['importButton'=>'1']
	 * @return string
	 */
	public static function dropdownRenderMulitireview($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		$deleteButton       = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'dropdown-item dropdown-item-delete', 'permission' => $permission);
		$v17ImportButton    		= array('id' => 'btn-import', 'icon' => 'fa fa-download', 'label' => trans('messages.import'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$downloadButton  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.download'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$downloadButton2  			= array('id' => 'btn-item-evaluation-input', 'icon' => 'fa fa-download', 'label' => trans('messages.down_personal_detail'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$downloadButton3 			= array('id' => 'btn-item-evaluation-input-3', 'icon' => 'fa fa-download', 'label' => trans('messages.down_average_point_list'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$exportButton  				= array('id' => 'btn-export', 'icon' => 'fa fa-print ', 'label' => trans('messages.export'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$supportPopup  				= array('id' => 'btn-view-supporter', 'icon' => 'fa fa-male', 'label' => trans('messages.supporter_viewing_settings'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		$v17printButton             = array('id' => 'btn-print', 'icon' => 'fa fa-print', 'label' => trans('messages.output_list'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$backButton                 = array('id' => 'btn-back', 'icon' => 'fa fa-mail-reply', 'label' => trans('messages.back'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$addNewSignupButton         = array('id' => 'btn-new-signup', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.sign_up'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => $permission);
		//2021/05/13 add by vietdt
		$saveButton       			= array('id' => 'btn-save-data', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'dropdown-item btn-outline-primary btn-save', 'permission' => $permission);
		$delButton                  = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.cancel'), 'class' => 'dropdown-item dropdown-item-delete', 'permission' => $permission);
		$downloadButton4            = array('id' => 'btn-print', 'icon' => 'fa fa-print', 'label' => trans('messages.label_038'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		$newGroup 					= array('id' => 'btn-new-group', 'icon' => 'fa fa-plus-circle', 'label' => trans('messages.create_my_group'), 'class' => 'dropdown-item btn-outline-primary', 'permission' => 1);
		// render
		if (isset($items) && !empty($items)) {
			$item_btn_arr = [];
			foreach ($items as $item) {
				if (isset($$item)) {
					$item_btn_arr[$item] = $$item;
				}
			}			
			$btnMobie = self::generateBtn($item_btn_arr,$param);
			// for mobile
			$result .= '<div class="col-2 col-xl-6 col-lg-6 header-right-function  nav-menubar-mobile" style="text-align:right">';
			if ($btnMobie['countItem'] == 1) {
				$result .=$btnMobie['result'];
			}else{
				$result .= '<div class="dropdown dropleft">';
				$result .= '<img style="float:right;cursor:pointer;margin-top:7px" src="/template/image/icon/1on1/icon_1.png" id="dropdownMenuLink" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" >';
				$result .= '<div class="dropdown-menu dropdown-menu-1on1" aria-labelledby="dropdownMenuLink">';
				// loop
				foreach ($items as $item) {
					$item_arr 	= isset($$item) ? $$item : null;
					//
					if (isset($item_arr)) {
						// if permission is view & update
						if (array_get($item_arr, 'permission') == '1') {
							$result .= '<a class="' . array_get($item_arr, 'class') . '" href="#" id="' . array_get($item_arr, 'id') . '"><span><i class="' . array_get($item_arr, 'icon') . '" style="margin-right: 5px"></i></span> ' . array_get($item_arr, 'label') . '</a>';
						}
					}
				}
				// append after loop
				$result .= '</div>';
				$result .= '</div>';
			}
			$result .= '</div>';
			// for PC
			$result .= '<div class="col-10 col-sm-8 col-md-9 col-lg-8 col-xl-6 header-right-function  nav-menubar-pc" style="text-align:right">';
			$result .= '<ul class="navbar-nav ml-auto mt-2" style="display:-webkit-inline-box">';
			foreach ($items as $item) {
				$item_arr 	= isset($$item) ? $$item : null;
				//
				if (isset($item_arr)) {
					// if permission is view & update
					if (array_get($item_arr, 'permission') == '1') {
						$result .= '<li class="nav-item">';
						$result .= '	<a href="#" id="' . array_get($item_arr, 'id') . '" class="btn btn-horizontal ' . array_get($item_arr, 'class') . '">';
						$result .= '		<i class="' . array_get($item_arr, 'icon') . '"></i>';
						$result .= '		<div>' . array_get($item_arr, 'label') . '</div>';
						$result .= '	</a>';
						$result .= '</li>';
					}
				}
			}
			// append after loop
			$result .= '</ul>';
			$result .= '</div>';
		}
		return $result;
	}
	/**
	 * buttonRenderMulitireview
	 *
	 * @param  array $items
	 * @param  array $param ['importButton'=>'0'] || ['importButton'=>'1']
	 * @return string
	 */
	public static function buttonRenderMulitireview($items = array(), $param = array())
	{
		$result = '';
		$auth = session_data();
		$permission		=  self::getPermission($auth);
		//
		if (isset($param) && !empty($param)) {
			$permission = array_get($param, 'permission');
		}
		$saveButton       = array('id' => 'btn-save', 'icon' => 'fa fa-pencil-square-o', 'label' => trans('messages.save'), 'class' => 'btn button-1on1 btn-block btn-save', 'permission' => $permission);
		$deleteButton               = array('id' => 'btn-delete', 'icon' => 'fa fa-trash', 'label' => trans('messages.delete'), 'class' => 'btn button-1on1 btn-block btn-1on1-danger', 'permission' => $permission);
		// render
		foreach ($items as $item) {
			$item_arr 	= isset($$item) ? $$item : null;
			//
			if (isset($item_arr)) {
				// if permission is view & update
				if (array_get($item_arr, 'permission') == '1') {
					$result .= '<div class="col-md-5 col-lg-5 col-sm-5 col-xl-3 col-12 mt-3">';
					$result .= '<button tabindex="9999" id="' . array_get($item_arr, 'id') . '" type="button" class="' . array_get($item_arr, 'class') . '">' . array_get($item_arr, 'label') . '</button>';
					$result .= '</div>';
				}
			}
		}
		return $result;
	}
	/**
	 * get permission for the button
	 *
	 * @param  object $auth
	 * @return int
	 */
	public static function getPermission($auth,$type = '')
	{
		$permission		= 1; // 0.not view 1. view & update
		$excepts = $auth->excepts;
		//screen
		$current_screen_prefix = $auth->currentScreenPrefix;
		
		//screen
		if($type == 'eI0200') {
			$current_screen_prefix = 'screen_employeeinfo_ei0200';
		}
		//screen click event
		$current_screen_prefix_event = substr($current_screen_prefix,  0, strlen($current_screen_prefix) - strpos(strrev($current_screen_prefix), '_') - 1);
		//screen
		if (property_exists($excepts, $current_screen_prefix)) {
			$button = $excepts->$current_screen_prefix;
			// authority = 0.not view 1.view 2.update
			
			if ($button->authority != 2) {
				$permission		= 0;
			}
		}
		//screen click event
		if (property_exists($excepts, $current_screen_prefix_event)) {
			$button = $excepts->$current_screen_prefix_event;
			// authority = 0.not view 1.view 2.update
			if ($button->authority != 2) {

				$permission		= 0;
			}
		}
		return $permission;
	}
	/**
	 * generateBtn for the button
	 *
	 * @param  object $auth
	 * @return array
	 */
	protected static function generateBtn($item_btn_arr=[],$param=[],$mode='') {
		$countItem = 0;
		$selectedItem = null;
		$result = '';
		$disabled = '';
		$auth = session_data();
		$authority_typ = $auth->authority_typ;
		if ($authority_typ == 3) {
			$disabled = 'disabled';
		}
		foreach ($item_btn_arr as $key => $item) {
			if ($mode !='genButtonRight' &&isset($item) && array_get($item, 'permission') == '1') {
				$countItem++;		
			}
			if ($mode =='genButtonRight' &&(!(isset($item) && ((isset($param[$key]) && ($param[$key] != '1')) || ($disabled == 'disabled' && array_get($item, 'permission','0') == '1'))))) {
				$countItem++;
			}
			if ($countItem==1 && $selectedItem === null) {
				$selectedItem = $item;
			}
		}
		if ($countItem == 1 && $selectedItem) {
			$result .= '<div class="navbar-nav ml-auto mt-2" style="display:-webkit-inline-box">';
			$result .= '    <a href="#" id="' . array_get($selectedItem, 'id') . '" class="btn btn-horizontal ' . array_get($selectedItem, 'class') . '" style="padding: 1px 5px;">';
			$result .= '        <i class="' . array_get($selectedItem, 'icon') . '"></i>';
			$result .= '        <div>' . array_get($selectedItem, 'label') . '</div>';
			$result .= '    </a>';
			$result .= '</div>';
		}
		return ['countItem' => $countItem, 'result' => $result];
	}
}