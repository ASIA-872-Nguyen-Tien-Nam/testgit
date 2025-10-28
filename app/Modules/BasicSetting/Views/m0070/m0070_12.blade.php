<div class="tab-pane fade" id="tab17">
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-2 input_money" style="min-width:190px !important">
        <div class="form-group">
					<label class="control-label">{{ __('messages.emp_salary') }}</label>
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" class="form-control money" id="base_salary" style="width: 100%" maxlength="13" tabindex="16" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif value="{{$tab_12['data_tab_12']['base_salary']??''}}" {{ $disabled }} {{$tab_12['disabled_tab12']}}>
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-yen"></i></button>
							</div>
						</div>
					</span>
				</div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-2 input_money"  style="min-width:190px !important">
        <div class="form-group">
					<label class="control-label">{{ __('messages.basic_annual_income') }}</label>
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" class="form-control money" id="basic_annual_income" maxlength="13" tabindex="16" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif value="{{$tab_12['data_tab_12']['basic_annual_income']??''}}" {{ $disabled }} {{$tab_12['disabled_tab12']}} >
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-yen"></i></button>
							</div>
						</div>
					</span>
				</div>
            <!--/.form-group -->
        </div>
    </div>
</div>
