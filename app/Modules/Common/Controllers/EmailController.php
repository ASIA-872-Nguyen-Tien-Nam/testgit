<?php
namespace App\Modules\Common\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Routing\Controller;
use App\Helpers\PHPEmail;

class EmailController extends Controller
{
	/**
	* test demo
	*
	* @author      :   namnb 	- 2017/08/11 - create
	* @param       :   null
	* @return      :   view
	* @access      :   public
	* @see         :   null
	*/
	public function index()
	{
		$data['title'] = 'Sending Email';
		return view('Common::email.index',$data);
	}
	/**
	* send email
	*
	* @author      :   namnb 	- 2017/08/11 - create
	* @param       :   null
	* @return      :   json
	* @access      :   public
	* @see         :   null
	*/
	public function sendraw(Request $request)
	{
    	if($request->ajax())
    	{
			$input = $request->all();
			$response['status'] = OK;
			//
			try {
				\Mail::raw($input['body'], function ($message) use ($input)
				{
			        $to = explode(',', $input['to']);
					$message->to($to)->subject($input['subject']);
					//
					if ( ! empty($input['attachs']) )
					{
						$attachs = explode(',', $input['attachs']);
						// print_r($attachs);
						// $message->attach($attachs);
						// foreach ($attachs as $attach) {
						// 	$message->attach($attach);
						// }
						//$message->attach('D:\Projects\UniteMedical\02_Sourcecode\02_VN\UniteMedical\public\download\test.docx', array('as' => 'ありが.docx'));
					}
					//
					if ( ! empty($input['cc']) )
					{
						$cc = explode(',', $input['cc']);
						$message->cc($cc);
					}
					//
					if ( ! empty($input['bcc']) )
					{
						$bcc = explode(',', $input['bcc']);
						$message->bcc($bcc);
					}
				});
				//
				if( count(\Mail::failures()) > 0 )
				{
					$response['status'] = NG;
					$respon['error'] 	= 'Send Error';
				}
			} catch (Exception $e) {
				$response['status'] = NG;
				$respon['error'] 	= $e->getMessage();
			}
			return json_encode($response);
		}
	}
	/**
	* send html email
	*
	* @author      :   namnb 	- 2017/08/11 - create
	* @param       :   null
	* @return      :   json
	* @access      :   public
	* @see         :   null
	*/
	public function sendhtml(Request $request)
	{
    	if($request->ajax())
    	{
			$input = $request->all();
			$response['status'] = OK;
			$data = $input['data'] ?? array();
			//
			try {
				\Mail::send($input['body'], $data, function($message) use ($input)
				{
					$to = explode(',', $input['to']);
					$message->to($to)->subject($input['subject']);
					//
					if ( ! empty($input['attachs']) )
					{
						$attachs = explode(',', $input['attachs']);
						foreach ($attachs as $attach) {
							$message->attach($attach);
						}
					}
					//
					if ( ! empty($input['cc']) )
					{
						$cc = explode(',', $input['cc']);
						$message->cc($cc);
					}
					//
					if ( ! empty($input['bcc']) )
					{
						$bcc = explode(',', $input['bcc']);
						$message->bcc($bcc);
					}
				});
				//
				if( count(\Mail::failures()) > 0 )
				{
					$response['status'] = NG;
					$respon['error'] 	= 'Send Error';
				}
			} catch (Exception $e) {
				$response['status'] = NG;
				$respon['error'] 	= $e->getMessage();
			}
			return json_encode($response);
		}
	}
}