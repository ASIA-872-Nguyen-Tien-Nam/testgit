<?php
namespace App\Modules\Multiview\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
class MQ2010Controller extends Controller
{
	/**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-09-04 08:43:12
     * @return \Illuminate\Http\Response
     */
	public function index(Request $request)
	{
		$data['title'] = 'Multiview';
		return view('Multiview::mq2010.index',$data);
	}

	/**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-09-04 08:43:12
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