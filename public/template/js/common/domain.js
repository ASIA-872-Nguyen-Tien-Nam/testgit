// ドメインを定義する
// 配列が空の場合は、任意のドメインを利用する可能性です。
var _DOMAIN_WHITELIST  =	[
	// 'mirai.com.vn',
];
//リダイレクトのURLをセットする
var _URL_WHITELIST = [
	'/master/i2010',
	// '/master/i2010?from=dashboard',
	// '/master/i2010?from=i2040',
	// '/master/i2010?from=q0071',
	// '/master/i2010?from=q2010',
	// '/master/i2010?from=i2050',
	// '/master/i2010?from=evaluator',
	// '/master/i2010?from=portal',
	// '/master/i2010?from=information',
	//
	'/master/i2020',
	// '/master/i2020?from=dashboard',
	// '/master/i2020?from=i2040',
	// '/master/i2020?from=q0071',
	// '/master/i2020?from=q2010',
	// '/master/i2020?from=i2050',
	// '/master/i2020?from=evaluator',
	// '/master/i2020?from=portal_i2020',
	// '/master/i2020?from=information',
	//
	'/master/i2030',
	// '/master/i2030?from=i2010',
	// '/master/i2030?from=i2020',
	//
	'/master/q0071',
	// '/master/q0071?from=q0070',
	// '/master/q0071?from=q2010',
	// '/master/q0071?from=i2040',
	// '/master/q0071?from=i2020',
	//
	'/master/i2040',
	'/master/i2050',
	'/master/i2040?from=q2010',
	//
	'/master/portal',
	'/master/portal/evaluator?from=dashboard',
	'/master/portal/evaluator',
	//
	'/dashboard',
	'/master/i1041',
	'/master/m0001',
	'/customer/master/m0001',
	'/master/i1010',
	'/master/q0070',
	// '/master/q0070?from=q0071',
	// '/master/q0071?from=q0070',
	'/master/q2030',
	'/master/q2010',
	// '/master/q0071?from=m0070',
	// '/master/i2010?from=m0070',
	// '/master/i2020?from=m0070',

// basic
	'/basicsetting/m0070',
	'/basicsetting/sq0070',
	'/basicsetting/a0003/api',
	'/basicsetting/a0003/requesttokens',
	'/basicsetting/a0003/kot-api',
	'/basicsetting/sdashboard',
// oneonone
	'/oneonone/oq2010',
	'/oneonone/oq2020',
	'/oneonone/oi2010',
	'/oneonone/oi3010',
	'/oneonone/oq2030',
	'/oneonone/oq2031',
	'/oneonone/oq2032',
	'/oneonone/oq2033',
//multiview
	'/multiview/mdashboardsupporter', 
	'/multiview/mi2000',
	'/multiview/mq2000', 
// weeklyreport
	'/weeklyreport/ri2010',
	'/weeklyreport/rq2020',
	// employeeinfo
	'/employeeinfo/eq0101',
];