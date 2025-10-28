/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	tannq – tannq@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {};
$(document).ready(function() {
	try {
		initEvents();
		chart();

		// var html = '<a href="javascript:;" class="btn btn-outline-primary"><i class="fa fa-check"></i>登録</a>';
		// 	html+= '<a href="javascript:;" class="btn btn-outline-success"><i class="fa fa-check"></i>登録</a>';
		// 	html+= '<a href="javascript:;" class="btn btn-outline-danger"><i class="fa fa-check"></i>登録</a>';
		// $.buttonGroupModal({
		// 	target:'.lst-content .list-group-item',
		// 	content:html,
		// 	autoshow:false,
		// });
	} catch (e) {
		alert('ready' + e.message);
	}
});

/*
 * INIT EVENTS
 * @author		:	tannq - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
		// $('.list-group-item').balloontip(html);
		$(document).on('mousemove','.list-group-item',function(event){
		    // alert(event.pageX + ", " + event.pageY);
		    $(this).find('.dropdown-menu').addClass('show');
		    var menuHeight = $(this).find('.dropdown-menu').outerHeight(true);
		    var winHeight = $(this).find('.dropdown-menu').outerHeight(true);
		    var obTop = $(this).offset().top;
		    var obLeft = $(this).offset().left;
		    var y =event.pageY - obTop;
		    var x =event.pageX - obLeft;
		    
		    if(event.pageY - obTop + menuHeight > $(window).outerHeight(true)) {
		    	y = $(window).outerHeight(true) - menuHeight;
		    }
		    $(this).find('.dropdown-menu').css({
		    	top:y - 10,
		    	left:x+30,
		    })
		});
 		$(document).on('mouseout','.list-group-item',function(event){
		    $(this).find('.dropdown-menu').removeClass('show');
		});
}

function chart() {
	// Create the chart
	Highcharts.chart('chart', {
	    chart: {
	        type: 'pie'
	    },
	    title: {
	        text: ''
	    },
	    subtitle: {
	        text: ''
	    },
	    plotOptions: {
	        series: {
	            dataLabels: {
	                enabled: false,
	                format: '{point.name}: {point.y:.1f}%'
	            }
	        }
	    },
	    plotShadow: true,
	    tooltip: {
	        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
	        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
	    },

	    "series": [
	        {
	            "name": "Browsers",
	            "colorByPoint": true,
	            "data": [
	                {
	                    "name": "Chrome",
	                    "y":11.111,
	                    "drilldown": "Chrome",
	                    color: "#42A5F6",
	                },
	                {
	                    "name": "Firefox",
	                    "y":11.111,
	                    "drilldown": "Firefox",
	                    color:"#25C6DA"
	                },
	                {
	                    "name": "Internet Explorer",
	                    "y":11.111,
	                    "drilldown": "Internet Explorer",
	                    color: "#25A79B",
	                },
	                {
	                    "name": "Safari",
	                    "y":11.111,
	                    "drilldown": "Safari",
	                    color: "#D4E259",
	                },
	                {
	                    "name": "Edge",
	                    "y":11.111,
	                    "drilldown": "Edge",
	                    color: "#FECA26",
	                },
	                {
	                    "name": "Opera",
	                    "y":11.111,
	                    "drilldown": "Opera",
	                    color: "#FFA827",
	                },
	                {
	                    "name": "Other",
	                    "y":11.111,
	                    "drilldown": null,
	                    color: "#FE6F45",
	                },
	                {
	                    "name": "Other2",
	                    "y":11.111,
	                    "drilldown": 'Other2',
	                    color: "#ED3F7A",
	                }
	            ]
	        }
	    ],
	    // "drilldown": {
	    //     "series": [
	    //         {
	    //             "name": "Chrome",
	    //             "id": "Chrome",
	    //             "data": [
	    //                 [
	    //                     "v65.0",
	    //                     0.1
	    //                 ],
	    //                 [
	    //                     "v64.0",
	    //                     1.3
	    //                 ],
	    //                 [
	    //                     "v63.0",
	    //                     53.02
	    //                 ],
	    //                 [
	    //                     "v62.0",
	    //                     1.4
	    //                 ],
	    //                 [
	    //                     "v61.0",
	    //                     0.88
	    //                 ],
	    //                 [
	    //                     "v60.0",
	    //                     0.56
	    //                 ],
	    //                 [
	    //                     "v59.0",
	    //                     0.45
	    //                 ],
	    //                 [
	    //                     "v58.0",
	    //                     0.49
	    //                 ],
	    //                 [
	    //                     "v57.0",
	    //                     0.32
	    //                 ],
	    //                 [
	    //                     "v56.0",
	    //                     0.29
	    //                 ],
	    //                 [
	    //                     "v55.0",
	    //                     0.79
	    //                 ],
	    //                 [
	    //                     "v54.0",
	    //                     0.18
	    //                 ],
	    //                 [
	    //                     "v51.0",
	    //                     0.13
	    //                 ],
	    //                 [
	    //                     "v49.0",
	    //                     2.16
	    //                 ],
	    //                 [
	    //                     "v48.0",
	    //                     0.13
	    //                 ],
	    //                 [
	    //                     "v47.0",
	    //                     0.11
	    //                 ],
	    //                 [
	    //                     "v43.0",
	    //                     0.17
	    //                 ],
	    //                 [
	    //                     "v29.0",
	    //                     0.26
	    //                 ]
	    //             ]
	    //         },
	    //         {
	    //             "name": "Firefox",
	    //             "id": "Firefox",
	    //             "data": [
	    //                 [
	    //                     "v58.0",
	    //                     1.02
	    //                 ],
	    //                 [
	    //                     "v57.0",
	    //                     7.36
	    //                 ],
	    //                 [
	    //                     "v56.0",
	    //                     0.35
	    //                 ],
	    //                 [
	    //                     "v55.0",
	    //                     0.11
	    //                 ],
	    //                 [
	    //                     "v54.0",
	    //                     0.1
	    //                 ],
	    //                 [
	    //                     "v52.0",
	    //                     0.95
	    //                 ],
	    //                 [
	    //                     "v51.0",
	    //                     0.15
	    //                 ],
	    //                 [
	    //                     "v50.0",
	    //                     0.1
	    //                 ],
	    //                 [
	    //                     "v48.0",
	    //                     0.31
	    //                 ],
	    //                 [
	    //                     "v47.0",
	    //                     0.12
	    //                 ]
	    //             ]
	    //         },
	    //         {
	    //             "name": "Internet Explorer",
	    //             "id": "Internet Explorer",
	    //             "data": [
	    //                 [
	    //                     "v11.0",
	    //                     6.2
	    //                 ],
	    //                 [
	    //                     "v10.0",
	    //                     0.29
	    //                 ],
	    //                 [
	    //                     "v9.0",
	    //                     0.27
	    //                 ],
	    //                 [
	    //                     "v8.0",
	    //                     0.47
	    //                 ]
	    //             ]
	    //         },
	    //         {
	    //             "name": "Safari",
	    //             "id": "Safari",
	    //             "data": [
	    //                 [
	    //                     "v11.0",
	    //                     3.39
	    //                 ],
	    //                 [
	    //                     "v10.1",
	    //                     0.96
	    //                 ],
	    //                 [
	    //                     "v10.0",
	    //                     0.36
	    //                 ],
	    //                 [
	    //                     "v9.1",
	    //                     0.54
	    //                 ],
	    //                 [
	    //                     "v9.0",
	    //                     0.13
	    //                 ],
	    //                 [
	    //                     "v5.1",
	    //                     0.2
	    //                 ]
	    //             ]
	    //         },
	    //         {
	    //             "name": "Edge",
	    //             "id": "Edge",
	    //             "data": [
	    //                 [
	    //                     "v16",
	    //                     2.6
	    //                 ],
	    //                 [
	    //                     "v15",
	    //                     0.92
	    //                 ],
	    //                 [
	    //                     "v14",
	    //                     0.4
	    //                 ],
	    //                 [
	    //                     "v13",
	    //                     0.1
	    //                 ]
	    //             ]
	    //         },
	    //         {
	    //             "name": "Opera",
	    //             "id": "Opera",
	    //             "data": [
	    //                 [
	    //                     "v50.0",
	    //                     0.96
	    //                 ],
	    //                 [
	    //                     "v49.0",
	    //                     0.82
	    //                 ],
	    //                 [
	    //                     "v12.1",
	    //                     0.14
	    //                 ]
	    //             ]
	    //         }
	    //     ]
	    // }
	});
}