<?php 
namespace App\Modules\Common\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
use App\Helpers\ANSFile;
class PHPExcelController extends Controller
{
    protected $respon;
    //
    public function __construct(){
        $respon['status'] = OK;
    }
	// /**
    //  * Show the application index.
    //  * @author trandaiviet 
    //  * @created at 2017-08-09 05:01:16
    //  * @return \Illuminate\Http\Response
    //  */
	// public function getIndex(Request $request)
	// {
	// 	$data['title'] = 'PHPExcel';
    //     return view('Common::phpexcel.index',$data);
	// }
    // /**
    //  * Show the application index.
    //  * @author trandaiviet 
    //  * @created at 2017-08-09 05:01:16
    //  * @return void
    //  */
    // public function export(Request $request) 
    // {
    //     if($request->ajax()) 
    //     {            
    //         //return request ajax
    //         $params = $request->all();
    //         $template_file  =   public_path().'\\'.'excel_template'.'\\'.$params['file_template'];
    //         $file_name      =   public_path().'\\'.'download'.'\\'.$params['file_name'];
    //         //
    //         if(!is_file($template_file)){
    //             $respon['status']   =   EPT;
    //         }else{
    //             \Excel::load($template_file,function($excel){
    //                 // sheet chay tu 0->n
    //                 $excel->sheet(0,function($sheet){
    //                     //
    //                     var_dump($sheet->getRowIndex(7));
    //                     //
    //                     $row_start  =   7;
    //                     $col_start  =   1;
    //                     $soure_style    = 'A7:AC';
    //                 });
    //             })->setFileName('test')->store('xlsx',storage_path('excel/exports'));
    //         }
    //     }
    //     // return http request
    // }
    // /**
    //  * Show the application index.
    //  * @author trandaiviet 
    //  * @created at 2017-08-09 05:01:16
    //  * @return void
    //  */
    // public function getDataForExcel($setCell,$bookData){
    //     $bookData = [];
    //     for($i = 0;$i < 100; $i++){
    //         $bookData[] = array('employee'=>$i,'employee_nm'=>"viettd{$i}");
    //     }
    //     //
    // }
    // /**
    //  * num2char
    //  *
    //  * @author      :   biennv  - 2016/06/20 - create
    //  * @param       :   null
    //  * @return      :   array
    //  * @access      :   protect
    //  * @see         :   remark
    //  */
    // public function num2char($num) {
    //     $numeric = $num % 26;
    //     $letter = chr(65 + $numeric);
    //     $num2 = intval($num / 26);
    //     if ($num2 > 0) {
    //         return $this->num2char($num2 - 1) . $letter;
    //     } else {
    //         return $letter;
    //     }
    // }
    // /**
    //  * [inportCSV import file csv]
    //  * @return [type] [description]
    //  */
    // public function importCSV(Request $request){
    //     if($request->ajax()){
    //         $params = $request->all();
    //         $path_file = public_path().'\\'.'temp'.'\\'.$params['file_name'];
    //         // import file 
    //         $import = new ANSFile();
    //         $result = $import->importFile($path_file);
    //         // validate herder
    //         $error = array(
    //             array('message_no'=>1, 'item'=>'#123', 'order_by'=>0, 'error_typ'=>0, 'value1'=>1, 'value2'=>0, 'remark'=>'')
    //         ,   array('message_no'=>2, 'item'=>'#456', 'order_by'=>0, 'error_typ'=>0, 'value1'=>2, 'value2'=>0, 'remark'=>'')   
    //         );
    //         $error_array = array();
    //         foreach ($error as $key => $value) {
    //             array_push($error_array,array($value['value1'],$value['item'],'lội dung nỗi lấy từ message_no'));
    //         }
    //         // check error?
    //         if(isset($error_array) && !empty($error_array)){    
    //             $import->showError($error_array);
    //         }else{
    //             // thực hiện call đến store để lưu giá trị hay xử lý gì thì viết ở đây.          
    //         }
    //     }
    // }
    // /**
    //  * [inportCSV import file csv]
    //  * @return [type] [description]
    //  */
    // public function importExcel(Request $request){
    //     if($request->ajax()){
    //         $params = $request->all();
    //         $path_file = public_path().'\\'.'temp'.'\\'.$params['file_name'];
    //         // validate herder
    //         $import = new ANSFile();
    //         $result = $import->importFile($path_file);
    //         dd($result);
    //     }
    // }
    // /**
    //  * [exportCSV]
    //  * @param  Request $request [nhận requets từ client]
    //  * @return [type]           [description]
    //  */
    // public function exportCSV(Request $request){
    //     if($request->ajax()){
    //         $data = array(
    //             array('employee_no' => '社員番号', 'employee_nm' => '社員名', 'price' => '単価')
    //         ,   array('employee_no' => 721, 'employee_nm' => '美江戸', 'price' => 1000)
    //         ,   array('employee_no' => 721, 'employee_nm' => 'ヴィエット', 'price' => 1000)
    //         ,   array('employee_no' => 721, 'employee_nm' => '山下', 'price' => 2016000)
    //         ,   array('employee_no' => 721, 'employee_nm' => '宮川', 'price' => 15400)
    //         ,   array('employee_no' => 721, 'employee_nm' => '山崎', 'price' => 16600)     
    //         );
    //         // xuất csv
    //         $export = new ANSFile();
    //         $option = array('file_type' => 'csv');
    //         $this->respon = $export->exportFile($data,$option);
    //         return response()->json($this->respon);
    //     }
    // }
    // /**
    //  * [exportExcel]
    //  * @param  Request $request [nhận requets từ client]
    //  * @return [type]           [description]
    //  */
    // public function exportExcel(Request $request){
    //     if($request->ajax()){
    //         $data = array(
    //             array('employee_no' => '社員番号', 'employee_nm' => '社員名', 'price' => '単価')
    //         ,   array('employee_no' => 721, 'employee_nm' => '美江戸', 'price' => 1000)
    //         ,   array('employee_no' => 721, 'employee_nm' => 'ヴィエット', 'price' => 1000)
    //         ,   array('employee_no' => 721, 'employee_nm' => '山下', 'price' => 2016000)
    //         ,   array('employee_no' => 721, 'employee_nm' => '宮川', 'price' => 15400)
    //         ,   array('employee_no' => 721, 'employee_nm' => '山崎', 'price' => 16600)     
    //         );
    //         // xuất csv
    //         $export = new ANSFile();
    //         $option = array('file_type' => 'xlsx');
    //         $this->respon = $export->exportFile($data,$option);
    //         return response()->json($this->respon);
    //     }
    // }    
}