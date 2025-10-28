@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/q2020.index.css')!!}
@stop
@section('asset_footer')
	{!!public_url('template/js/form/q2020.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
    Helper::buttonRender(['printButton','saveButton','confirmButton2','decisionCancelButton','evaluationSynthesisButton','backButton'])
!!}
@endpush
@section('content')
<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="card">
			<div class="card-body box-input-search">

				<div class="row">
					<div class="col-sm-6 col-md-2 col-lg-1">

						<div class="form-group">
							<label class="control-label lb-required">年度</label>
							<span class="num-length">
								<input type="tel" class="form-control required only-number text-center" tabindex="1" maxlength="4"  />
							</span>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">

						<div class="form-group">
							<label class="control-label lb-required">処遇用途&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="技術職利用設定で登録した評価用途が表示される。"></i>
							</label>
							<select name="" id="" tabindex="2" class="form-control required">
								<option value="">給与</option>
								<option value="">夏期賞与</option>
								<option value="">冬季賞与</option>
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">ステータス&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="ステータス設定でステータス管理を実施するに設定したものが表示される。"></i>
							</label>
							<select name="" id="" tabindex="3" class="form-control">
								<option value=""></option>
								<option value="">目標管理-目標シート提出</option>
								<option value="">目標管理-期首面談</option>
								<option value="">目標管理-目標シート承認</option>
								<option value="">目標管理-自己評価</option>
								<option value="">目標管理-評価面談</option>
								<option value="">目標管理-一次評価</option>
								<option value="">目標管理-二次評価</option>
								<option value="">目標管理-三次評価</option>
								<option value="">目標管理-四次評価</option>
								<option value="">目標管理-評価確定</option>
								<option value="">目標管理-フィードバック面談</option>
								<option value="">プロセス評価-自己評価</option>
								<option value="">プロセス評価-一次評価</option>
								<option value="">プロセス評価-二次評価</option>
								<option value="">プロセス評価-三次評価</option>
								<option value="">プロセス評価-四次評価</option>
								<option value="">プロセス評価-評価確定</option>								
							</select>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">評価シート&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="目標管理シートマスタ、プロセス評価シートマスタで登録したシートの名称が表示される。"></i>
							</label>
							<select name="" id="" tabindex="4" class="form-control">
								<option value=""></option>
								<option value=''>目標管理 技術職用</option>
								<option value=''>目標管理 企画職用</option>
								<option value=''>目標管理 管理職用</option>
								<option value=''>目標管理 事務職用</option>
								<option value=''>目標管理 専門職用</option>
								<option value=''>目標管理 営業職用</option>
								<option value=''>目標管理 新人用</option>
								<option value=''>目標管理 中途採用者用</option>
								<option value=''>行動評価 技術職用</option>
								<option value=''>行動評価 企画職用</option>
								<option value=''>行動評価 管理職用</option>
								<option value=''>行動評価 事務職用</option>
								<option value=''>行動評価 専門職用</option>
								<option value=''>行動評価 営業職用</option>
								<option value=''>行動評価 新人用</option>
								<option value=''>行動評価 中途採用者用</option>
							</select>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">カテゴリ&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="技術職仕様設定で「利用する」にチェックを入れた機能がカテゴリとして表示される。"></i>
							</label>
							<select name="" id="" tabindex="5" class="form-control">
								<option value=""></option>
								<option value="">目標管理</option>
								<option value="">人事評価</option>
								<option value="">総合評価</option>
							</select>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">評価者</label>
							<div class="input-group-btn">
								<input type="text" class="form-control" tabindex="6"  >
								<div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button">
										<i class="fa fa-search"></i>
									</button>
								</div>
							</div>
						</div><!--/.form-group -->
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6 col-md-2 col-lg-1">
						<div class="form-group">
							<label class="control-label">評語&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="評語マスタで登録された評語がすべて表示される。"></i>
							</label>
							</label>
							<select name="" id="" tabindex="7" class="form-control">
								<option value=""></option>
								<option value="">S</option>
								<option value="">A</option>
								<option value="">B</option>
								<option value="">C</option>
								<option value="">D</option>
							</select>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">グループ&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="評価グループマスタで登録したグループ名称が表示される。"></i>
							</label>
							<select name="" id="" tabindex="8" class="form-control">
								<option value=""></option>
								<option value="">技術職職グループ</option>
								<option value="">営業職グループ</option>
								<option value="">新卒社員グループ</option>
							</select>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">職種&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="職種マスタで登録した職種名が表示される。"></i>							
							</label>
							<select name="" id="" tabindex="9" class="form-control">
								<option value=""></option>
                                <option value="">技術職</option>
                                <option value="">企画職</option>
                                <option value="">管理職</option>
                                <option value="">事務職</option>
                                <option value="">専門職</option>
                                <option value="">営業職</option>
							</select>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">役職&nbsp;
								<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="役職マスタで登録した役職名が表示される。"></i>	
							</label>
							<select name="" id="" tabindex="10" class="form-control">
								<option value=""></option>
								<option value="">部長</option>
								<option value="">課長</option>
								<option value="">係長</option>
								<option value="">主任</option>
								<option value="">一般社員</option>
							</select>
						</div><!--/.form-group -->
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">等級</label>
							<select name="" id="" tabindex="11" class="form-control">
								<option value=""></option>
								<option value="">1-1</option>
                                <option value="">1-2</option>
                                <option value="">1-3</option>
                                <option value="">1-4</option>
                                <option value="">1-5</option>
                                <option value="">2-1</option>
                                <option value="">2-2</option>
                                <option value="">2-3</option>
							</select>
						</div><!--/.form-group -->
					</div>
				</div>
				<div class="col-md-12">					
					<div class="form-group text-right">						
						<div class="full-width">
							<a href="javascript:;" class="btn btn-outline-primary" tabindex="14" >
								<i class="fa fa-search"></i>
								 検索
							</a>
						</div><!-- end .full-width -->
					</div>
				</div>
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		<div class="card">
			<div class="card-body">
				<nav class="pager-wrap">
					<ul class="pagination outline circle">
						<li class="page-item page-first">
							<a class="page-link" href="javascript:;" tabindex="-1"><i class="fa fa-angle-double-left"></i></a>
						</li>
						<li class="page-item page-prev">
							<a class="page-link" href="javascript:;" tabindex="-1"><i class="fa fa-angle-left"></i></a>
						</li>
						<li class="page-item">
							<a class="page-link" href="javascript:;">1</a>
						</li>
						<li class="page-item active">
							<a class="page-link" href="javascript:;">2</a>
						</li>
						<li class="page-item">
							<a class="page-link" href="javascript:;">3</a>
						</li>
						<li class="page-item page-next">
							<a class="page-link" href="javascript:;"><i class="fa fa-angle-right"></i></a>
						</li>
						<li class="page-item page-last">
							<a class="page-link" href="javascript:;"><i class="fa fa-angle-double-right"></i></a>
						</li>
					</ul>
					<div class="pager-info">
						<div class="input-group">
							<select class="form-control pager-size" data-width="70px" data-selected="10" tabindex="-98">
								<option value="">ページ</option>
								<option value="50">50</option>
								<option value="100">100</option>
							</select>
							<div class="input-group-append">
								<span class="input-group-text" id="basic-addon2">検索結果（全72件中　1～50件を表示）</span>
							</div>
						</div><!-- end .input-group -->
					</div>
				</nav>
				<div class="table-responsive">
				    <table class="table table-bordered table-hover table-striped">
				        <thead>
				            <tr>
								<th class="text-center" style="width: 40px">
									<div class="md-checkbox-v2 inline-block lb">
										<input name="ckball" class="checkAll" item="1" num="6" id="ckball"  checked="" type="checkbox">
										<label for="ckball"></label>
									</div>
								</th>
				                <th class="min-w150">従業員名</th>
				                <th class="min-w150">社員区分</th>
				                <th class="min-w150">職種</th>
				                <th class="min-w150">役職</th>
				                <th style="min-width: 100px;">等級</th>
				                <th class="min-w150">評価シート</th>
				                <th class="min-w150">ステータス</th>
								<th class="min-w70">自己評価</th>
								<th class="min-w70">一次評価</th>
								<th style="min-width: 80px;">二次評価</th>
								<th style="min-width: 80px;">三次評価</th>
								<th style="min-width: 80px;">四次評価</th>

				            </tr>
				        </thead>
				        <tbody>
				            <tr>
								<td class="text-center">
									<div class="md-checkbox-v2 inline-block lb">
										<input name="ckb1" id="ckb2" checked="" type="checkbox">
										<label for="ckb2"></label>
									</div>
								</td>
				                <td>菅原 未来</td>
								<td>正社員</td>
								<td>技術職</td>
								<td>主任</td>
								<td>2-1</td>
								<td><a href="/master/i2020?screen=11" data-toggle="q2020">行動評価 技術職用</a></td>
								<td>プロセス評価-評価確定</td>
								<td class="text-right">7</td>
								<td class="text-right">8</td>
								<td>
									<span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span>
								</td>
								<td>
									<span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span>
								</td>
								<td>
									<span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span>
								</td>

				            </tr>
							<tr>
								<td class="text-center">
									<div class="md-checkbox-v2 inline-block lb">
										<input name="ckb1" id="ckb3" checked="" type="checkbox">
										<label for="ckb3"></label>
									</div>
								</td>
								<td>菅原 未来</td>
								<td>正社員</td>
								<td>技術職</td>
								<td>主任</td>
								<td>2-1</td>
								<td><a href="/master/i2010?stt=18">目標管理 技術職用</a></td>
								<td>目標管理-評価確定</td>
								<td class="text-right">7</td>
								<td class="text-right">8</td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="8" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>

							</tr>
							<tr>
								<td class="text-center">
									<div class="md-checkbox-v2 inline-block lb">
										<input name="ckb1" id="ckb4" checked="" type="checkbox">
										<label for="ckb4"></label>
									</div>
								</td>
								<td>谷川 薫</td>
								<td>正社員</td>
								<td>技術職</td>
								<td>一般社員</td>
								<td>1-1</td>
								<td><a href="/master/i2020?screen=11">行動評価 技術職用</a></td>
								<td>プロセス評価-評価確定</td>
								<td class="text-right">9</td>
								<td class="text-right">9</td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span></td>

							</tr>
							<tr>
								<td class="text-center">
									<div class="md-checkbox-v2 inline-block lb">
										<input name="ckb1" id="ckb5" checked="" type="checkbox">
										<label for="ckb5"></label>
									</div>
								</td>
								<td>谷川 薫</td>
								<td>正社員</td>
								<td>技術職</td>
								<td>一般社員</td>
								<td>1-1</td>
								<td><a href="/master/i2010?stt=18">目標管理 技術職用</a></td>
								<td>目標管理-評価確定</td>
								<td class="text-right">8</td>
								<td class="text-right">9</td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="6" decimal="2" negative="true"  tabindex="12">
									</span></td>

							</tr>
							<tr>
								<td class="text-center">
									<div class="md-checkbox-v2 inline-block lb">
										<input name="ckb1" id="ckb6" checked="" type="checkbox">
										<label for="ckb6"></label>
									</div>
								</td>
								<td>野崎 功補</td>
								<td>正社員</td>
								<td>営業職</td>
								<td>係長</td>
								<td>5-2</td>
								<td><a href="/master/i2020?screen=5">行動評価 営業職用</a></td>
								<td>プロセス評価-自己評価</td>
								<td class="text-right"></td>
								<td class="text-right"></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>

							</tr>
							<tr>
								<td class="text-center">
									<div class="md-checkbox-v2 inline-block lb">
										<input name="ckb1" id="ckb7" checked="" type="checkbox">
										<label for="ckb7"></label>
									</div>
								</td>
								<td>野崎 功補</td>
								<td>正社員</td>
								<td>営業職</td>
								<td>係長</td>
								<td>5-2</td>
								<td><a href="/master/i2010?stt=6">目標管理 営業職用</a></td>
								<td>目標管理-期首面談</td>
								<td class="text-right"></td>
								<td class="text-right"></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>
								<td><span class="num-length">
										<input type="tel" class="form-control numeric text-right" maxlength="10" value="" decimal="2" negative="true"  tabindex="12">
									</span></td>

							</tr>	    
				        </tbody>
				    </table>
				</div><!-- end .table-responsive -->
			</div><!-- end .card-body -->
		</div><!-- end .card -->
	</div><!-- end .container-fluid -->
@stop