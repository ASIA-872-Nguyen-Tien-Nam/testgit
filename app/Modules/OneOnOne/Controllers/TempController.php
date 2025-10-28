<?php
namespace App\Modules\OneOnOne\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
class TempController extends Controller
{
	/**
     * Show the application index.
     * @author viettd@ans-asia.com 
     * @created at 2020-12-17 02:48:11
     * @return \Illuminate\Http\Response
     */
	public function index(Request $request)
	{
		$data['title'] = 'OneOnOne';
		return view('OneOnOne::temp.index',$data);
	}

	/**
     * Show the application index.
     * @author viettd@ans-asia.com 
     * @created at 2020-12-17 02:48:11
     * @return void
     */
    public function postSave(Request $request) 
    {
    	if($request->ajax()) 
    	{
    		//return request ajax
    	}
    	// return http request
    }
}