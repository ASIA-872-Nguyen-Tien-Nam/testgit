<?php
	/**
	*-------------------------------------------------------------------------*
	* Souei
	* Helpers pagging
	*
	* 処理概要/process overview  :
	* 作成日/create date         :   2016/11/15
	* 作成者/creater             :   vuongvt – vuongvt@ans-asia.com
	*
	* @package                  :   MASTER
	* @copyright                :   Copyright (c) ANS-ASIA
	* @version                  :   1.0.0
	*-------------------------------------------------------------------------*
	* DESCRIPTION
	*
	*
	*
	*
	*/
namespace App\Helpers;
use Form;
class Paging {

	/**
	* show pagging for list
	* -----------------------------------------------
	* @author      :   vuongvt     - 2016/11/16 - create
	* @param       :   null
	* @return      :   null
	* @access      :   public
	* @see         :   remark
	*/
	public static function show($page = [], $showLabel = 1, $return=false) {
		$strpage = '';
		if (isset($page) && !empty($page) && $page['totalRecord'] > 0) {
			$pageSize    = $page['pagesize'] ?? 10;
			$totalRecord = $page['totalRecord'] ?? 0;
			$currentPage = $page['page'] ?? 0;
			$totalPage   = $page['pageMax'] ?? 0;
			//
			$start	= min(($page['page']-1)*$page['pagesize']+1, $page['totalRecord']);
			$end	= min(($page['page']-1)*$page['pagesize']+$pageSize, $page['totalRecord']);
			$label = $showLabel == 1 ? self::_displayCount($start,$end, $page['totalRecord']) : '';
			$strpage  = '';//'<label class="panel-title inline-block title-paging">'.$label.'</label>';
			$strpage .=  self::_showPage($page);
		}
		
		if ($return) {return $strpage;}
		echo $strpage;
	}

	/**
	* show pagging for list
	* -----------------------------------------------
	* @author      :   vuongvt     - 2016/11/16 - create
	* @author      :   DuyTP       - 2017/02/16 - fix [prev-next] btn to [first-last]
	* @param       :   null
	* @return      :   null
	* @access      :   public
	* @see         :   remark
	*/
	private static function _showPage($array){
		$page = $array['page'] ?? 0;
		$pageMax = $array['pageMax'] ?? 0;
		$totalRecord = $array['totalRecord'] ?? 0;
		$offset = $array['offset'] ?? 0;
		$pagesize = $array['pagesize'] ?? 0;
		$totalRecordPage = ($page==$pageMax) ?$totalRecord:($page*$pagesize);
		if( $totalRecord == 0 ){
			return '';
		}
		//add new
		$anti_tab_1 = ($page <= 1 ) ?'tabindex = -1':'';
		$anti_tab_2 = ($page >= $pageMax ) ? 'tabindex = -1':'';
		$disabledfirst = ($page <= 1 ) ? 'pagging-disable' : '';
		$_disabledfirst = ($page <= 1 ) ? 'disabled' : '';
		$pagePrevious2  = ($page <= 2)? '': $page - 2;
		$pagePrevious  	= ($page <= 1)? '': $page - 1;
		$pagenext  		= ($pageMax <= $page)? '': $page + 1;
		$pagenext2  	= ($pageMax <= $page + 1)? '': $page + 2;
		$disabledlast	= ($page >= $pageMax ) ? 'pagging-disable' : '';
		$_disabledlast	= ($page >= $pageMax ) ? 'disabled' : '';
		$paging  = '<ul class="pagination pagination-fix outline circle">';
		$paging .= '    <li class="page-item page-prev ' . $disabledfirst . '" ' . $_disabledfirst . ' page="1"><a class="page-link ' . $disabledfirst . '" page="1" href="javascript:;" '.$anti_tab_1.'><i class="fa fa-angle-double-left" '.$anti_tab_1.'></i></a></li>'; // DuyTP 2017/02/16
		if($page > 1){
			$paging .= '     <li class="page-item page-prev" page="' . ($page-1) . '"><a class="page-link" page="' . ($page-1) . '" href="javascript:;"><i class="fa fa-angle-left"></i></a></li>';
		}
		if ( ($page == $pageMax) && ($pagePrevious2 !='')) {
			$paging .= '    <li class="page-item page-prev" page="' . $pagePrevious2 . '"><a class="page-link" page="' . $pagePrevious2 . '" href="javascript:;">' . $pagePrevious2 . '</a></li>';
		}
		if ($pagePrevious!= '') {
			$paging .= '    <li class="page-item page-prev" page="' . $pagePrevious . '"><a class="page-link" page="' . $pagePrevious . '" href="javascript:;">' . $pagePrevious . '</a></li>';
		}

		$paging .= '    <li class="page-item page-prev active" page="'.$page.'"><a class="page-link" page="'.$page.'" href="javascript:;">'.$page.'</a></li>';
		if ($pagenext != '') {
			$paging .= '    <li class="page-item page-prev" page="' . $pagenext . '"><a class="page-link" page="' . $pagenext . '" href="javascript:;">' . $pagenext . '</a></li>';
		}
		if (($pagePrevious == '') && ($pagenext2 != '')) {
			$paging .= '    <li class="page-item page-prev" page="' . $pagenext2 . '"><a class="page-link" page="' . $pagenext2 . '" href="javascript:;">' . $pagenext2 . '</a></li>';
		}
		if($page < $pageMax){
			$paging .= '     <li class="page-item page-prev " page="' . ($page+1) . '"><a class="page-link" page="' . ($page+1) . '" href="javascript:;"><i class="fa fa-angle-right"></i></a></li>';
		}
		$paging .= '    <li class="page-item page-prev ' . $disabledlast . '" page="' . $pageMax . '" ' . $_disabledlast . '><a page="' . $pageMax . '" class="page-link ' . $disabledlast . '" href="javascript:;" '.$anti_tab_2.'><i class="fa fa-angle-double-right"></i></a></li>'; // DuyTP 2017/02/16
		$paging .= '</ul>';

		if($offset > 0) {
			$paging .= '<div class="pager-info">';
			$paging .= 	'<div class="input-group">';
			$paging .= 		'<select id="cb_page" class="form-control pager-size" data-width="70px" data-selected="10" >';
			$paging .= 			'<option '.($pagesize == 20 ? 'selected' : '').' value="20">20</option>';
			$paging .= 			'<option '.($pagesize == 50 ? 'selected' : '').' value="50">50</option>';
			$paging .= 			'<option '.($pagesize == 100 ? 'selected' : '').' value="100">100</option>';
			$paging .= 		'</select>';
			$paging .= 		'<div class="input-group-append">';
			$paging .= 			'<span class="input-group-text" id="basic-addon2">'. trans('messages.paging', ['totalRecord' => $totalRecord, 'offset' => $offset, 'totalRecordPage' => $totalRecordPage]).'</span>';
			$paging .= 		'</div>';
			$paging .= 	'</div>';
			$paging .= '</div>';
		}
		return $paging;
	}
	
	/**
	* show pagging for list
	* -----------------------------------------------
	* @author      :   vuongvt     - 2016/11/16 - create
	* @param       :   null
	* @return      :   null
	* @access      :   public
	* @see         :   remark
	*/
	private static function _displayCount($start, $end, $totalRecord ) {
		$displaycount = '';
		if ( $start != 0 && $totalRecord>0) {
			$displaycount = number_format($totalRecord) . "件中 " .  number_format($start) . "-" . number_format($end) . "件";
		} else {
			$displaycount =  number_format($totalRecord). "件 ";
		}

		return $displaycount;
	}
}