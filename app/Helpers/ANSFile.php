<?php
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * Import file
 *
 * 処理概要/process overview		:	UNITE_MEDICAL Import file
 * 作成日/create date			:	2017/08/11
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
use Illuminate\Support\Collection;
/**
* 
*/
class ANSFile
{
	protected $repon;
	protected $delimiter 	= ",";
	protected $enclosure	= "\"";
	protected $line_ending	= "\n";
	/**
	 * [__construct]
	 * @param [array] $config [mảng khởi tạo cho các giá trị muốn overide cấu hình file csv]
	 */
	public function __construct($config = null){
		$this->repon['status'] 	= OK;
		$this->repon['result']	= NULL;
		if(!is_null($config)){
			$this->delimiter 	= $config['delimiter'];
			$this->enclosure 	= $config['enclosure'];
			$this->line_ending 	= $config['line_ending'];
		}
	}
	/**
	 * [import]
	 * @param  [String] $path_file [đường đãn đến file cần imoport]
	 * @return [array]            [result data of file to array]
	 * @author viettd <2017/08/14>
	 */
	public function importFile($path_file,$option = array()){
		try {
			// check file exists 
			if(!is_file($path_file)){
				$this->repon['status'] = EPT;
				goto complete;
			}
			// read file csv
			$extension = \File::extension($path_file);
			// check type of file
			if($extension == 'csv'){
				$this->importCSV($path_file);
			}else if($extension == 'xls' || $extension == 'xlsx'){
				$this->importExcel($path_file,$option);
			}
		} catch (\Exception $e) {
			$this->repon['status'] = EX;
		}
		// functuon return result 
		complete:
		return $this->repon;
	}
	/**
	 * [importCSV]
	 * @param  [String] $path_file [đường dẫn đến file]
	 * @return [Array]            [kết quả trả về dạng mảng repon]
	 */
	public function importCSV($path_file){
		try {
			$arrData	=	array();
			$i			=	0;
			// check file exists 
			$content	=	file_get_contents($path_file);
			if(mb_detect_encoding($content, 'SJIS',true)==true)
			{
				$content = mb_convert_encoding($content,'UTF-8','SJIS');
			}
			$rows = str_getcsv($content,"\n"); //parse the rows
			foreach($rows as $row){
				$tmp 			=	str_getcsv($row,$this->delimiter); //parse the items in rows
				$arrData[$i]	=	$this->changeKey($tmp);
				$i++;
			}
			$this->repon['result'] = json_encode($arrData);
		} catch (\Exception $e) {
			$this->repon['status'] = EX;
			$this->repon['message'] = $e->getMessage();
		}
		// functuon return result 
		complete:
		return $this->repon;
	}
	/**
	 * [importExcel description]
	 * @param  [String] $path_file [đường đãn file excel đầu vào]
	 * @param  [Array] $option [array('sheet'=>index_of_sheet)]
	 * @return [type]            [description]
	 */
	public function importExcel($path_file,$option){
		try {
			$sheet_active 		= 0;
			$arrData			= array();
			// check option
			if(isset($option['sheet'])){
				$sheet_active 	=	$option['sheet'];
			}
			// load file to read
			\Excel::selectSheetsByIndex($sheet_active)->load($path_file,function($sheet){
				$rows = $sheet->get()->toArray();
				for ($i=0; $i < count($rows); $i++) { 
					$arrData[$i] = $this->changeKey($rows[$i]);
				}
				$this->repon['result'] = json_encode($arrData);
			});
		} catch (\Exception $e) {
			$this->repon['status']	= EX;
			$this->repon['message'] = $e->getMessage();	
		}
		// functuon return result 
		complete:
		return $this->repon;
	}
	/**
	 * [changeKey description]
	 * @param  [array] $array [mảng đầu vào]
	 * @return [type]        [description]
	 */
	public function changeKey($array = null){
		$result = array(); 
		if(is_null($array)){
			return null;
		}else{
			foreach ($array as $key => $value) {
				$result['col'.$key] = $value;
			}
			return $result;
		}
		//
	}
	/**
	 * [showError hiển thị lỗi khi import file]
	 * @param  [Array] $error [Mảng chứa lỗi]
	 * @return [type]        [description]
	 */
	public function showError($error,$option = array()){
		if(isset($error) && !empty($error)){
			$error_file_name 	= 'error_file_'.time();
			$file_type 			= 'xlsx';
			// check options is exists
			if(!empty($option)){
				$file_type = $option['file_type'];
			}
			// create file
			if($file_type == 'xlsx'){
				\Excel::create($error_file_name,function($excel) use($error){
					$excel->sheet('error',function($sheet) use($error){
						$sheet->fromArray($error, null, 'A1', true);
					});
				})->store('xlsx');
			}else if($file_type == 'xls'){
				\Excel::create($error_file_name,function($excel) use($error){
					$excel->sheet('error',function($sheet) use($error){
						$sheet->fromArray($error, null, 'A1', true);
					});
				})->store('xls');
			}else if($file_type == 'csv'){
				\Excel::create($error_file_name,function($excel) use($error){
					$excel->sheet('error',function($sheet) use($error){
						$sheet->fromArray($error);
					});
				})->store('csv');
			}
			// save error
			$this->repon['status']		= NG;
			$this->repon['error_file']	= $error_file_name.'.'.$fi;
		}
	}
	/**
	 * funtion exportFile 
	 * @param  [array] $data   [mảng dữ liệu đầu vào]
	 * @param  [array] $option [mảng chứa các thuộc tính]
	 * @return [File]         [trả ra đường dẫn file đã được tạo ra]
	 */
	public function exportFile($data,$option = array()){
		if(isset($data) && !empty($data)){
			$file_type = 'csv';
			if(!empty($option)){
				$file_type = $option['file_type'];
			}
			//
			$export_file_name = 'export_file_name_'.time();
			if(isset($option['export_file_name'])){
				$export_file_name = $option['export_file_name'].'_'.time();
			}
			if($file_type == 'xlsx'){
				\Excel::create($export_file_name,function($excel) use($data){
					$excel->sheet('data',function($sheet) use($data){
						$sheet->fromArray($data, null, 'A1', true,false);
					});
				})->store('xlsx');
			}else if($file_type == 'xls'){
				\Excel::create($export_file_name,function($excel) use($data){
					$excel->sheet('data',function($sheet) use($data){
						$sheet->fromArray($data, null, 'A1', true,false);
					});
				})->store('xls');
			}else if($file_type == 'csv'){
				\Excel::create($export_file_name,function($excel) use($data){
					$excel->sheet('data',function($sheet) use($data){
						$sheet->fromArray($data, null, 'A1', false, false);
					});
				})->store('csv');
			}
			//
			$this->repon['export_file']	= $export_file_name.'.'.$file_type;
		}else{
			$this->repon['status'] 	= EPT;
			goto complete;
		}
		// result
		complete:
		return $this->repon;
	}
}
