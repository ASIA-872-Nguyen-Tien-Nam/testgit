@extends('layout')

@push('header')
	{!!public_url('template/css/form/dashboardcustomer.css')!!}
@endpush

@section('asset_footer')
	
	{!!public_url('template/js/common/highcharts.min.js')!!}
	{!!public_url('template/js/form/dashboardcustomer.js')!!}

@stop

@section('content')
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<div class="card pe-w">
					<div class="card-body">
						<div class="row">
							<div class="col-md-7">
								<div class="p-title">
									<h4><i class="fa fa-bar-chart" aria-hidden="true"></i> ステータス別評価シート進捗状況 </h4>
									<select name="" id="" class="form-control">
										<option value=''>2018年度 目標管理 技術職用</option>
										<option value=''>2018年度 目標管理 企画職用</option>
										<option value=''>2018年度 目標管理 管理職用</option>
										<option value=''>2018年度 目標管理 事務職用</option>
										<option value=''>2018年度 目標管理 専門職用</option>
										<option value=''>2018年度 目標管理 営業職用</option>
										<option value=''>2018年度 目標管理 新人用</option>
										<option value=''>2018年度 目標管理 中途採用者用</option>
										<option value=''>2018年度 行動評価 技術職用</option>
										<option value=''>2018年度 行動評価 企画職用</option>
										<option value=''>2018年度 行動評価 管理職用</option>
										<option value=''>2018年度 行動評価 事務職用</option>
										<option value=''>2018年度 行動評価 専門職用</option>
										<option value=''>2018年度 行動評価 営業職用</option>
										<option value=''>2018年度 行動評価 新人用</option>
										<option value=''>2018年度 行動評価 中途採用者用</option>
									</select>
								</div><!-- end .p-title -->
								<div class="row">
									<div class="col-md-6">
										<div id="chart"></div>										
									</div><!-- end .col-md-6 -->
									<div class="col-md-6">
										<ul class="list-group pe dropright">
											<?php
												$data = array(
													array('1', '目標未設定', '62')
												,	array('2', '目標設定中', '33')
												,	array('3', '目標提出済', '56')
												,	array('4', '面談実施済','0')
												,	array('5', '目標設定完了','0')
												,	array('6', '自己評価中','0')
												,	array('7', '自己評価済','0')
												,	array('8', '次評価','0')
												,	array('9', '評価確定','0')
												,	array('10', '評価者フィードバック','0')
												,	array('11', '被評価者フィードバック','0')
												,	array('12', '評価終了','0')
												);

											?>
											@foreach($data as $row)
										    <li class=" list-group-item {{$row[0]==1 ? 'active' :''}}">
										    	<span class="clw step{{$row[0]}}"></span>{{$row[1]}}  ({{$row[0]}}人)
										    	<div class="dropdown-menu">
										    		<span class="caret"></span>
										    		<table class="table table-hover table-striped">
										    			<tbody>
										    				<tr>
										    					<td style="width: 30px"><span class="clw step{{$row[0]}}"></span></td>
										    					<td colspan="2" class="text-left">{{$row[1]}}　の社員一覧（6人）</td>
										    					<td></td>
										    				</tr>
										    				<tr>
										    					<td style="width: 30px"><span class="fa fa-user"></span></td>
										    					<td>社員A</td>
										    					<td>OO営蔵郎第ーチーム</td>
										    					<td><i class="fa fa-angle-right"></i> </td>
										    				</tr>
										    				<tr>
										    					<td style="width: 30px"><span class="fa fa-user"></span></td>
										    					<td>社員A</td>
										    					<td>OO営蔵郎第ーチーム</td>
										    					<td><i class="fa fa-angle-right"></i> </td>
										    				</tr>
										    				<tr>
										    					<td style="width: 30px"><span class="fa fa-user"></span></td>
										    					<td>社員A</td>
										    					<td>OO営蔵郎第ーチーム</td>
										    					<td><i class="fa fa-angle-right"></i> </td>
										    				</tr>
										    			</tbody>
										    		</table><!-- end .table-striped table-hover -->
										    	</div><!-- end .table-responsive -->
										    </li>
										    @endforeach
										</ul>
									</div><!-- end .col-md-6 -->
								</div><!-- end .row -->
							</div><!-- end .col-md-7 -->
							<div class="col-md-5">
								<ul class="p-title-btn">
									<li>
										<a href="javascript:;" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-refresh"></i>
												<div>年度更新</div>
											</div>
										</a>
									</li>
									<li>
										<a href="javascript:;" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-users"></i>
												<div>社員マスタ</div>
											</div>
										</a>
									</li>
									<li>
										<a href="javascript:;" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-file-text-o"></i>
												<div>総合評価</div>
											</div>
										</a>
									</li>
									<li>
										<a href="javascript:;" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-cog"></i>
												<div>ユーザー管理</div>
											</div>
										</a>
									</li>
								</ul><!-- end .btn-group -->
								<div class="clearfix"></div><!-- end .clearfix -->
								<div class="p-title mb-0">
									<h4 class="block"><i class="fa fa-file-text-o fa-flip-vertical"></i> インフォメーション</h4>
								</div><!-- end .p-title -->
								<ul class="list-group lst-content">
									<?php
										$data = array(
											array('期首面談' , '谷川 薫さんの期首面談')
										,	array('期首面談' , '北条 りえさんの期首面談')
										,	array('期首面談' , '堀 将也さんの期首面談')
										,	array('期首面談' , '矢口 光さんと面談')
										);
									?>
									@foreach($data as $row)
									<li class=" list-group-item">
										<a>
											<span>2018/06/22</span>
											
											<p>{{$row[1]}}</p>
										</a>
									</li>
									@endforeach									
								</ul>
								
							</div><!-- end .col-md-5 -->
						</div><!-- end .row -->
					</div><!-- end .card-body -->
				</div><!-- end .card -->
			</div><!-- end .col-md-6 -->
		</div><!-- end .row -->
	</div><!-- end .container-fluid -->
@stop
