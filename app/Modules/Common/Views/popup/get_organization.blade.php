@extends('popup')

@section('content')
<?php
if (empty($data)) {
	for ($i=1; $i<=5; $i++) {
		array_push($data, ['use_typ' => 0, 'organization_group_nm' => '']);
	}
}
?>
	<div class="wrp">
		@foreach ($data as $k => $tmp)
		<?php
		$index = 0;
		switch ($k) {
			case 0:
				$index = '１';
				break;
			case 1:
				$index = '２';
				break;
			case 2:
				$index = '３';
				break;
			case 3:
				$index = '４';
				break;
			case 4:
				$index = '５';
				break;
			
			default:
				break;
		}
		?>
		<div class="row-x" style="position: relative;">
			<div class="col-sm-6">
				<input type="checkbox" id="use_typ{{$k+1}}" class="ck-value" value="1" style="display: none;" <?php echo ($k===0 || 1*$tmp['use_typ']===1)?'checked="checked"':'' ?> {{$k===0?'disabled':''}}>
				<label class="btn btn-outline-brand-x btn-block text-left" for="use_typ{{$k+1}}">
					<i class="fa fa-check"></i>
					{{ __('messages.use_org', ['index' => $index]) }}
				</label>
			</div>
			<div class="col-sm-6">
				<span class="num-length">
					<input type="text"
						id="organization_group_nm{{$k+1}}"
						class="form-control input-sm ck-nm <?php echo 1*$tmp['use_typ']===1?'required':'XXX' ?>"
						maxlength="20"
						value="<?php echo $tmp['organization_group_nm']; ?>"
						tabindex="3">
				</span>
			</div>
		</div>
		@endforeach
		<div class="row-x">
			<div class="col-sm-6">&nbsp;</div>
			<div class="col-sm-6" style="text-align: right;">
				<a href="javascript:;" id="btn-save-x" class="btn btn-horizontal btn-outline-primary">
					<i class="fa fa-pencil-square-o "></i>
					<div>{{ __('messages.register') }}</div>
				</a>
			</div>
		</div>
	</div>
@stop

@section('asset_footer')
<script type="text/javascript" src="/template/js/form/m0020.org.js"></script>
@stop

@section('asset_header')
<style type="text/css">
	.p-head {
		position: relative !important;
	}
	.p-content {
		margin-top: 0 !important;
		max-height: 1000px;
	}
	.wrp {
		padding: 30px 10px 0;
	}
	.wrp > div:not(:first-child) {
		margin-top: 20px;
	}
	.row-x {
		display: grid;
		grid-template-columns: 220px auto;
	}
	.ck-value + label {
		text-align: center !important;
	}
	.ck-value:checked + label {
		border: 1px solid #2b71b9 !important;
	    background: #2b71b9;
	    color: #fff !important;
	}
	.ck-value:checked + label > i {
		display: inline-block;
	}
	.textbox-error {
		position: absolute;
	    width: 200%;
	    margin-bottom: 20px;
	}
	.modal .m-success {
		margin: 0 auto;
	}
</style>
@stop