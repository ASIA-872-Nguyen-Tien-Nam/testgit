/**
 * ****************************************************************************
 * ANS ASIA
 * 	ansplugin.js
 *
 * 処理概要		:	ans plugin for js
 * 作成日		:	2017/08/01
 * 作成者		:	viettd – viettd@ans-asia.com
 *
 * 更新日		:
 * 更新者		:
 * 更新内容		:
 *
 * @package		:	ansplugin.js
 * @copyright	:	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
(function(jQuery) {
	//////////////////////////////////////////////////////////////////////////
	// COMMON FUNCTION
	//////////////////////////////////////////////////////////////////////////
	// ----------+[ キャスト関連 ]+----------

	/**
	 * マルチバイト R trim (全半角スペース + 改行 + タブ)
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @return {string} trim 後文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var trimString = $.mbRTrim(string);
	 */
	jQuery.mbRTrim = function(target) {
		try {
			var tmpString = jQuery.castString(target);
			tmpString = jQuery.trim(tmpString);
			tmpString = tmpString.replace(/[\s\t\n\r　]+$/g, '');
			return (tmpString);
		} catch (e) {
			jQuery.showErrorDetail(e, 'mbRTrim');
			return ('');
		}
	};
	jQuery.initTabindex = function(target) {
		var max = -1;
        $("[tabindex]").attr('tabindex', function (a, b) {
            max = Math.max(max, +b);
        });
        if($('.pagination').length > 0){
            $('.pagination a:not(.pagging-disable,.no-focus,.disable,:hidden,[disabled])').each(function(e){
                max++;
                $(this).attr('tabindex',max);
            })
        }
        if($('#cb_page').length > 0){
            max++;
            $('#cb_page').attr('tabindex',max);
        }
        if($('.check_all').length > 0){
             max++;
            $('.check_all').attr('tabindex',max);
        }
        $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden,[disabled])').each(function(e){
            max++;
            $(this).attr('tabindex',max);
        })
	}
	/**
	 * 文字列へのキャスト
	 *
	 * @param {object}
	 *            target 対象
	 * @return {string} 文字列 (null / undefined の場合は空文字を返す)
	 * @public
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.castString(text);
	 */
	jQuery.castString = function(target) {
		try {
			if (target == null) {
				return ('');
			} else {
				return (target.toString());
			}
		} catch (e) {
			alert('castString' + e.message);
			return ('');
		}
	};
	/**
	 * 数字へのキャスト
	 *
	 * @param {object}
	 *            target 対象
	 * @param {bool}
	 *            type キャストタイプ true:小数 / false:整数 [デフォルト:true]
	 * @return {number} 数値 (null / undefined / 数値以外の場合は 0 を返す)
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var integer = $.castNumber(text, false);
	 */
	jQuery.castNumber = function(target, type) {
		try {
			target = jQuery.mbTrim(target);
			//
			var half = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8',
					'9', '.', ',', '+', '-');
			var full = new Array('０', '１', '２', '３', '４', '５', '６', '７', '８',
					'９', '．', '，', '＋', '－');
			var object = null;
			var i = 0;
			var len = half.length;
			for (i = 0; i < len; i++) {
				object = new RegExp(full[i], 'gm');
				target = target.replace(object, half[i]);
			}
			//
			// 数値形式にマッチするか判定
			var match = target.match(/^[-+]?\d+[\,0-9]*\.?\d*$/);
			var number = 0;
			if (match !== null) {
				match[0] = match[0].replace(/\,/g, '');
				if (type !== false) {
					// 小数
					number = match[0] - 0;
				} else {
					// 整数
					number = parseInt(match[0], 10);
				}
			}
			return (number);
		} catch (e) {
			alert('castNumber' + e.message);
			return (0);
		}
	};
		/**
	 * HTML文へのキャスト
	 *
	 * @param {string}
	 *            target 対象
	 * @return {string} 処理文字列 (null / undefined の場合は空文字を返す)
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.castHtml(text);
	 */
	jQuery.castHtml = function(target) {
		try {
			target = jQuery.castString(target);
			// HTML コードに変換
			target = target.replace(/\&/g, '\&amp;');
			target = target.replace(/\</g, '\&lt;').replace(/\>/g, '\&gt;')
					.replace(/\"/g, '\&quot;');
			return (target);
		} catch (e) {
			alert('castHtml' + e.message);
			return ('');
		}
	};
	// ----------+[ 文字列操作関連 ]+----------
	/**
	 * マルチバイトtrim (全半角スペース + 改行 + タブ)
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @return {string} trim 後文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var trimString = $.mbTrim(string);
	 */
	jQuery.mbTrim = function(target) {
		try {
			var tmpString = jQuery.castString(target);
			tmpString = jQuery.trim(tmpString);
			tmpString = tmpString.replace(/^[\s\t\n\r　]+|[\s\t\n\r　]+$/g, '');
			return (tmpString);
		} catch (e) {
			alert('mbTrim' + e.message);
			return ('');
		}
	};
	/**
	 * バイト換算の文字列長取得
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @return {integer} 文字列長のバイト数
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var length = $.byteLength('abc012あいうアイウｱｲｳ');
	 */
	jQuery.byteLength = function(target) {
		try {
			var i = 0;
			var length = 0;
			var count = 0;
			var character = '';
			//
			target = jQuery.castString(target);
			length = target.length;
			//
			for (i = 0; i < length; i++) {
				// 1 文字を切り出し Unicode に変換
				character = target.charCodeAt(i);
				//
				// Unicode の半角 : 0x0 - 0x80, 0xf8f0, 0xff61 - 0xff9f, 0xf8f1 -
				// 0xf8f3
				if ((character >= 0x0 && character < 0x81)
						|| (character == 0xf8f0)
						|| (character > 0xff60 && character < 0xffa0)
						|| (character > 0xf8f0 && character < 0xf8f4)) {
					// 1 バイト文字
					count += 1;
				} else {
					// 2 バイト文字
					count += 2;
				}
			}
			//
			return (count);
		} catch (e) {
			alert('byteLength' + e.message);
			return (0);
		}
	};
	/**
	 * Left 関数
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @param {integer}
	 *            number 切り取り数
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.left(number + '00000', 5);
	 */
	jQuery.left = function(target, number) {
		try {
			target = jQuery.castString(target);
			number = jQuery.castNumber(number, false);
			if (number > target.length - 1 || number < 1) {
				// 切り取り数が文字列より長い or マイナス -> そのまま返す
				return (target);
			}
			//
			return (target.slice(0, number));
		} catch (e) {
			alert('left' + e.message);
			return ('');
		}
	};

	/**
	 * Right 関数
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @param {integer}
	 *            number 切り取り数
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.right('00000' + number, 5);
	 */
	jQuery.right = function(target, number) {
		try {
			target = jQuery.castString(target);
			number = jQuery.castNumber(number, false);
			if (number > target.length - 1 || number < 1) {
				// 切り取り数が文字列より長い or マイナス -> そのまま返す
				return (target);
			}
			//
			return (target.slice(target.length - number));
		} catch (e) {
			alert('right' + e.message);
			return ('');
		}
	};

	/**
	 * Left 関数 (バイト長)
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @param {integer}
	 *            number 切り取り数
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.mbLeft(number + '00000', 5);
	 */
	jQuery.mbLeft = function(target, number) {
		try {
			var result = ''; // 結果
			var count = 0; // バイト数カウンター
			var i = 0; // ループ用
			var len = 0; // ループ最大用
			var byteCount = 0; // バイト長
			var character = ''; // 1 文字
			//
			target = jQuery.castString(target);
			number = jQuery.castNumber(number, false);
			byteCount = jQuery.byteLength(target) - 1;
			//
			if (number < -1 || number > byteCount) {
				// 切り取り数が文字列より長い or マイナス -> そのまま返す
				return (target);
			}
			//
			len = target.length;
			for (i = 0; i < len; i++) {
				character = target.charAt(i);
				byteCount = jQuery.byteLength(character);
				//
				if (count + byteCount > number) {
					// 最大文字数を越えたら終了
					break;
				} else {
					// 結果と結合
					result += character;
					// カウンターインクリメント
					count += byteCount;
				}
			}
			//
			if (jQuery.byteLength(result) !== number) {
				// バイト長と必要文字数が異なる -> 区切り部分がが全角
				result += ' ';
			}
			//
			return (result);
		} catch (e) {
			alert('mbLeft' + e.message);
			return ('');
		}
	};

	/**
	 * Right 関数 (バイト長)
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @param {integer}
	 *            number 切り取り数
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.mbLeft(number + '00000', 5);
	 */
	jQuery.mbRight = function(target, number) {
		try {
			var result = ''; // 結果
			var count = 0; // バイト数カウンター
			var i = 0; // ループ用
			var len = 0; // ループ最大用
			var byteCount = 0; // バイト長
			var character = ''; // 1 文字
			//
			target = jQuery.castString(target);
			number = jQuery.castNumber(number, false);
			byteCount = jQuery.byteLength(target) - 1;
			//
			if (number < -1 || number > byteCount) {
				// 切り取り数が文字列より長い or マイナス -> そのまま返す
				return (target);
			}
			//
			len = target.length;
			for (i = len - 1; i > -1; i--) {
				character = target.charAt(i);
				byteCount = jQuery.byteLength(character);
				//
				if (count + byteCount > number) {
					// 最大文字数を越えたら終了
					break;
				} else {
					// 結果と結合
					result = character + result;
					// カウンターインクリメント
					count += byteCount;
				}
			}
			//
			if (jQuery.byteLength(result) !== number) {
				// バイト長と必要文字数が異なる -> 区切り部分がが全角
				result = ' ' + result;
			}
			//
			return (result);
		} catch (e) {
			alert('mbRight' + e.message);
			return ('');
		}
	};

	/**
	 * バイト換算の文字列長取得
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @return {integer} 文字列長のバイト数
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var length = $.byteLength('abc012あいうアイウｱｲｳ');
	 */
	jQuery.byteLength = function(target) {
		try {
			var i = 0;
			var length = 0;
			var count = 0;
			var character = '';
			//
			target = jQuery.castString(target);
			length = target.length;
			//
			for (i = 0; i < length; i++) {
				// 1 文字を切り出し Unicode に変換
				character = target.charCodeAt(i);
				//
				// Unicode の半角 : 0x0 - 0x80, 0xf8f0, 0xff61 - 0xff9f, 0xf8f1 -
				// 0xf8f3
				if ((character >= 0x0 && character < 0x81)
						|| (character == 0xf8f0)
						|| (character > 0xff60 && character < 0xffa0)
						|| (character > 0xf8f0 && character < 0xf8f4)) {
					// 1 バイト文字
					count += 1;
				} else {
					// 2 バイト文字
					count += 2;
				}
			}
			//
			return (count);
		} catch (e) {
			alert('byteLength' + e.message);
			return (0);
		}
	};

	/**
	 * 指定バイト数まで文字列で埋める
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @param {integer}
	 *            maxLength バイト数
	 * @param {string}
	 *            fillString 詰め文字 [デフォルト:半角スペース]
	 * @param {bool}
	 *            fillFlag 詰め方 true:文字列の前に詰め文字挿入 / false:文字列の後ろに詰め文字挿入
	 *            [デフォルト:false]
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.byteLength
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.fillByByte('abcde', 10, '0', false);
	 */
	jQuery.fillByByte = function(target, maxLength, fillString, fillFlag) {
		try {
			var tmpString = ''; // 一時文字列
			var count = 0; // バイト数カウンター
			var fillLength = 0; // 詰め文字のバイト数
			var i = 0; // ループ用
			var length = 0; // ループ最大用
			var byteCount = 0; // バイト長
			var character = ''; // 1 文字
			//
			target = jQuery.castString(target);
			maxLength = jQuery.castNumber(maxLength, false);
			fillString = jQuery.castString(fillString);
			//
			if (fillString === '') {
				// 詰め文字の指定無し -> 半角スペース
				fillString = ' ';
				fillLength = 1;
			} else {
				fillLength = jQuery.byteLength(fillString);
			}
			//
			// 現在の文字が最大文字数を越えていないか確認
			length = target.length;
			for (i = 0; i < length; i++) {
				character = target.charAt(i);
				byteCount = jQuery.byteLength(character);
				//
				if (count + byteCount > maxLength) {
					// 最大文字数を越えたら終了
					break;
				} else {
					// 一時文字列に格納
					tmpString += character;
					// カウンターインクリメント
					count += byteCount;
				}
			}
			//
			// 最大文字数まで詰め文字で埋める
			for (i = count + 1; i < maxLength + 1; i += fillLength) {
				if (count + fillLength > maxLength) {
					break;
				} else {
					if (fillFlag === true) {
						// 前詰め
						tmpString = fillString + tmpString;
					} else {
						// 後ろ詰め
						tmpString += fillString;
					}
					count += fillLength;
				}
			}
			//
			// 残り分を半角スペースで埋める
			for (i = count + 1; i < maxLength + 1; i++) {
				if (fillFlag === true) {
					tmpString = ' ' + tmpString;
				} else {
					tmpString += ' ';
				}
			}
			//
			return (tmpString);
		} catch (e) {
			alert('fillByByte' + e.message);
			return ('');
		}
	};

	/**
	 * 指定文字数まで文字列で埋める
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @param {integer}
	 *            maxLength 文字数
	 * @param {string}
	 *            fillString 詰め文字 [デフォルト:半角スペース]
	 * @param {bool}
	 *            fillFlag 詰め方 true:文字列の前に詰め文字挿入 / false:文字列の後ろに詰め文字挿入
	 *            [デフォルト:false]
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.fillByLength(number, 10, '0', false);
	 */
	jQuery.fillByLength = function(target, maxLength, fillString, fillFlag) {
		try {
			// 内部変数
			var tmpString = ''; // 一時文字列
			var count = 0; // バイト数カウンター
			var fillLength = 0; // 詰め文字のバイト数
			var i = 0; // ループ用
			var length = 0; // ループ最大用
			//
			target = jQuery.castString(target);
			maxLength = jQuery.castNumber(maxLength, false);
			fillString = jQuery.castString(fillString);
			//
			if (fillString === '') {
				// 詰め文字の指定無し -> 半角スペース
				fillString = ' ';
				fillLength = 1;
			} else {
				// 詰め文字の長さ取得
				fillLength = fillString.length;
			}
			//
			// 現在の文字が最大文字数を越えていないか確認
			length = target.length;
			for (i = 0; i < length; i++) {
				if (count + 1 > maxLength) {
					// 最大文字数を越えたら終了
					break;
				} else {
					// 一時文字列に格納
					tmpString += target.charAt(i);
					// カウンターインクリメント
					count += 1;
				}
			}
			//
			// 最大文字数まで詰め文字で埋める
			for (i = count + 1; i < maxLength + 1; i += fillLength) {
				if (count + fillLength > maxLength) {
					break;
				} else {
					if (fillFlag === true) {
						// 前詰め
						tmpString = fillString + tmpString;
					} else {
						// 後ろ詰め
						tmpString += fillString;
					}
					count += fillLength;
				}
			}
			//
			// 残り分を半角スペースで埋める
			for (i = count + 1; i < maxLength + 1; i++) {
				if (fillFlag === true) {
					tmpString = ' ' + tmpString;
				} else {
					tmpString += ' ';
				}
			}
			//
			return (tmpString);
		} catch (e) {
			alert('fillByLength' + e.message);
			return ('');
		}
	};

	/**
	 * 区切り数ごとに区切り文字挿入
	 *
	 * @param {string}
	 *            target 対象文字列
	 * @param {integer}
	 *            number 区切り数
	 * @param {string}
	 *            delimiter 区切り文字
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.showErrorDetail
	 * @example var str = $.wordwrap('123456789', 3, '-');
	 */
	jQuery.wordwrap = function(target, number, delimiter) {
		try {
			var result = ''; // 結果
			var i = 0; // ループ用
			var len = 0; // ループ最大用
			//
			target = jQuery.castString(target);
			delimiter = jQuery.castString(delimiter);
			number = jQuery.castNumber(number, false);
			//
			if (number < 1) {
				return (target);
			}
			//
			len = target.length;
			for (i = 0; i < len; i += number) {
				result += target.slice(i, i + number) + delimiter;
			}
			//
			return (result);
		} catch (e) {
			alert('wordwrap' + e.message);
			return ('');
		}
	};

	/**
	 * 区切り数ごとに区切り文字挿入 (マルチバイト対応)
	 *
	 * @param {string}
	 *            target 入力文字列
	 * @param {integer}
	 *            number 文字列を分割するときの文字数
	 * @param {string}
	 *            delimiter 区切り文字
	 * @return {string} 処理文字列
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.castNumber
	 * @requires jQuery.showErrorDetail
	 * @example var str = $.wordwrap('あいうえお', 3, '-');
	 */
	jQuery.mbWordwrap = function(target, number, delimiter) {
		try {
			var result = ''; // 結果
			var count = 0; // バイト数カウンター
			var i = 0; // ループ用
			var len = 0; // ループ最大用
			var byteCount = 0; // バイト長
			var character = ''; // 1 文字
			//
			target = jQuery.castString(target);
			delimiter = jQuery.castString(delimiter);
			number = jQuery.castNumber(number, false);
			if (number < 1) {
				return (target);
			}
			//
			len = target.length;
			for (i = 0; i < len; i++) {
				character = target.charAt(i);
				byteCount = jQuery.byteLength(character);
				//
				if (count + byteCount > number) {
					// 最大文字数を越えたら区切り文字挿入
					result += delimiter + character;
					count = byteCount;
				} else {
					// 結果と結合
					result += character;
					count += byteCount;
				}
			}
			//
			return (result);
		} catch (e) {
			alert('mbWordwrap' + e.message);
			return ('');
		}
	};
	//////////////////////////////////////////////////////////////////////////
	// Plugin for dowload , preview , export, updatePDF file from service
	//////////////////////////////////////////////////////////////////////////
	// download file ajax
	jQuery.downloadFileAjax = function(process_url,data) {
		try {
			var error 		= 'エラー';
			var exception 	= '例外';
			var fail 		= '処理が失敗しました。';
			if ($('#language_jmessages').val() == 'en') {
				error 		= 'Error';
				exception 	= 'Exception';
				fail	  	= 'Processing failed.';
			}
			$.ajax({
				type		:	'POST',
	    		url			:	process_url,
	    		dataType	:	'json',
	    		loading 	: 	true,
	    		data		:	data,
				success: function(res) {
					switch (res['status']){
	                    // Success
						case 200:
							//location.href = target_url + '?filename='+res['filename'];
							var fileNameSave = res['fileNameSave'];
							var path_file = res['path_file'];
							var link = document.createElement('a');
					        if (link.download !== undefined) {
						        // Browsers that support HTML5 download attribute
						        link.setAttribute("href", path_file);
						        link.setAttribute("download", fileNameSave);
						        document.body.appendChild(link);
						        link.click();
						        document.body.removeChild(link);
						    }
	                        break;
	                    case 201: // error
	              			if(typeof res['message'] != 'undefined'){
	                    		jError(error,res['message']);
	                    	}else{
	                    		jError(exception,res['Exception']);
	                    	}
	                    	break;
	                    case 202: // Exception
	                    	if(typeof res['data'] != 'undefined'){
	                    		jError(exception,res['data']);
	                    	}else{
	                    		jError(exception,res['Exception']);
	                    	}
	                    	break;
	                    case 203: // Exception
	                    	if(typeof res['message'] != 'undefined'){
	                    		jError(error,res['message']);
	                    	}else{
	                    		jError(exception,res['Exception']);
	                    	}
	                    	break;
	                    default:
	                        jError(fail,error);
	                        break;
            		}
				},
				error: function(res) {
					if(res['status'] != 200){
						jError(fail,error);
					}
				}
			});
		} catch (e) {
			alert('downloadFileAjax: ' + e.message);
		}
	}
	// preview pdf
	jQuery.previewPDFAjax = function(process_url, target_url, data)
	{
		try {
			$.ajax({
				type		:	'POST',
	    		url			:	process_url,
	    		dataType	:	'json',
	    		loading 	: 	true,
	    		data		:	data,
				success: function(res) {
					switch (res['status']){
	                    // Success
	                    case 200:
							var params = '';
							$.each(res,function(index,val){
								params += index+'='+val+'&';
							});
							if(typeof res['filename'] != 'undefined'){
								window.open(target_url + '?' + params,'_blank');
							}
	                        break;
	                    case 201: // error
	              			if(typeof res['message'] != 'undefined'){
	                    		jError(res['message'],'エラー');
	                    	}else{
	                    		jError(res['Exception'],'例外');
	                    	}
	                    	break;
	                    case 202: // Exception
	                    	if(typeof res['data'] != 'undefined'){
	                    		jError(res['data'],'例外');
	                    	}else{
	                    		jError(res['Exception'],'例外');
	                    	}
	                    	break;
	                    case 203: // Exception
	                    	if(typeof res['message'] != 'undefined'){
	                    		jError(res['message'],'エラー');
	                    	}else{
	                    		jError(res['Exception'],'例外');
	                    	}
	                    	break;
	                    default:
	                        jError('処理が失敗しました。','エラー');
	                        break;
            		}
				},
				error: function(res) {
					if(res['status'] != 200){
						jError('処理が失敗しました。','エラー');
					}
				}
			});
		} catch (e) {
			alert('previewPDFAjax: ' + e.message);
		}
	}
	//////////////////////////////////////////////////////////////////////////
	// tooltip error
	//////////////////////////////////////////////////////////////////////////
	// ----------▽[ ツールチップ ]▽----------
	/**
	 * jQuery拡張 ツールチップ用
	 *
	 * @param {integer}
	 *            _xOffset マウスからの x 軸距離
	 * @private
	 */
	var _xOffset = 10;
	/**
	 * jQuery拡張 ツールチップ用
	 *
	 * @param {integer}
	 *            _yOffset マウスからの y 軸距離
	 * @private
	 */
	var _yOffset = 0;
	/**
	 * jQuery拡張 ツールチップ用
	 *
	 * @param {string}
	 *            _balloontipId balloontip 本体のID名 (変更時は component.css も変更する)
	 * @private
	 */
	var _balloontipId = 'has-balloontip-class';
	/**
	 * jQuery拡張 ツールチップ用
	 *
	 * @param {string}
	 *            _balloontipId balloontip 内容記憶属性
	 * @private
	 */
	var _toottipAttr = 'has-balloontip-message';
	/**
	 * jQuery拡張 ツールチップ用:マウスホバー
	 *
	 * @param {object}
	 *            event イベント
	 * @param {object}
	 *            object jQuery オブジェクト
	 * @private
	 * @requires jQuery.castString
	 * @requires _balloontipId
	 * @requires jQuery.showErrorDetail
	 * @example _balloontipMouseover(event, jQuery(this));
	 */
	function _balloontipMouseover(event, object, callback) {
		try {
			// 表示
			if (jQuery('#' + _balloontipId).length > 0) {
				// 他で表示した balloontip があれば削除
				jQuery('#' + _balloontipId).remove();
			}
			var balloontipMessage = jQuery
					.castString(object.attr(_toottipAttr));
			if (balloontipMessage !== '') {
				// css強制指定 iframe 内のコンポーネントに対しても対処
				var parent = object.parent();
				//parent.css({'position' : 'relative'});
				var position  = object.position();
				/*parent.append(
						'<p id="' + _balloontipId + '"><span class="arrow"></span>' + balloontipMessage
								+ '</p>');*/

                //nguyen van bien 2014/10/30
                jQuery('body').append(
						'<p id="' + _balloontipId + '"><span class="arrow"></span>' + balloontipMessage
								+ '</p>');

                var erroutHeight = jQuery('#' + _balloontipId).outerHeight();
                var errHeight = jQuery('#' + _balloontipId).height();
                var errlineHeight = jQuery('#' + _balloontipId).css('line-height');
                var errorgHeight = parseInt(errlineHeight)  + erroutHeight - errHeight;
                /*var css = {
                    'top' : (position.top - errorgHeight - 5) + 'px',
                };*/
                //nguyen van bien 2014/10/30
                var css = {
                    'top' : (object.offset().top-errorgHeight-5)+ 'px',
                    'left' : (parseInt(event['pageX'])-10)+ 'px',
                    'position': 'absolute'
                };
                jQuery('#' + _balloontipId).css(css);
                jQuery('#' + _balloontipId).addClass('fix-position');
				if(callback){
					callback(jQuery('#' + _balloontipId, parent));
				}
				jQuery('#' + _balloontipId, parent).fadeIn(300,null);
			}
		} catch (e) {
			alert('balloontipMouseover',e.message);
		}
	}
	/**
	 * jQuery拡張 ツールチップ用:マウスホバー
	 *
	 * @param {object}
	 *            event イベント
	 * @param {object}
	 *            object jQuery オブジェクト
	 * @private
	 * @requires _balloontipId
	 * @requires jQuery.showErrorDetail
	 * @example _balloontipMouseout(event, jQuery(this));
	 */
	function _balloontipMouseout(event, object) {
		try {
			// 非表示 iframe 内のコンポーネントに対しても対処
			//jQuery('#' + _balloontipId, object.parent()).remove();
            //nguyen van bien 2014/10/30
            jQuery('#' + _balloontipId).remove();
		} catch (e) {
			alert('balloontipMouseout',e.message);
		}
	}
	/**
	 * jQuery拡張 ツールチップ用:マウスホバー
	 *
	 * @param {object}
	 *            event jQuery Event オブジェクト
	 * @param {object}
	 *            object jQuery オブジェクト
	 * @private
	 * @requires _yOffset
	 * @requires _xOffset
	 * @requires jQuery.showErrorDetail
	 * @example _balloontipMousemove(event, jQuery(this));
	 */
	function _balloontipMousemove(event, object, callback) {
		try {
			var parent = object.parent();
			var balloontip = jQuery('#' + _balloontipId, parent);
			var width = balloontip.outerWidth(true);
			var height = balloontip.outerHeight(true);
			var x = parseInt(event['pageX'], 10) + _xOffset;
			var y = parseInt(event['pageY'], 10) + _yOffset;
			var windowWidth = jQuery(window).width();
			var windowHeight = jQuery(window).height();
			var windowLeft = jQuery(window).scrollLeft();
			var windowTop = jQuery(window).scrollTop();
			var xOffset = 0;
			var yOffset = 0;
			if (x + width > windowWidth + windowLeft) {
				x = parseInt(windowWidth + windowLeft - width - _xOffset, 10);
				yOffset = -1 * height - 10;
			}
			if (y + height > windowHeight + windowTop) {
				y = parseInt(windowHeight + windowTop - height - _yOffset, 10);
			}
			//parent.css({'position' : 'relative'});
			// マウスムーブ -> balloontip をマウスに追従
			var objectOffset = object.offset();
			var position  = object.position();
			var css = {
				'left' : (x - objectOffset.left - 25 + position.left) + 'px',
			};
			// iframe 内のコンポーネントに対しても対処
			//jQuery('#' + _balloontipId, parent).css(css);
            //nguyen van bien 2014/10/30
            var erroutHeight = jQuery('#' + _balloontipId).outerHeight();
            var errHeight = jQuery('#' + _balloontipId).height();
            var errlineHeight = jQuery('#' + _balloontipId).css('line-height');
            var errorgHeight = parseInt(errlineHeight)  + erroutHeight - errHeight;
            var css = {
                'top' : (object.offset().top-errorgHeight-5)+ 'px',
                'left' : (parseInt(event['pageX'])-10)+ 'px',
                'position': 'absolute'
            };
            jQuery('#' + _balloontipId).css(css);
            jQuery('#' + _balloontipId).addClass('fix-position');
			if(callback){
				callback(jQuery('#' + _balloontipId, parent));
			}
		} catch (e) {
			alert('balloontipMousemove',e.message);
		}
	}
	/**
	 * jQuery拡張 ツールチップ
	 *
	 * @param {string}
	 *            message メッセージ ※null の場合ツールチップ削除
	 * @return {object} 自身の jQuery オブジェクト
	 * @public
	 * @requires jQuery.castString
	 * @requires _toottipAttr
	 * @requires _balloontipMouseover
	 * @requires _balloontipMouseout
	 * @requires _balloontipMousemove
	 * @requires jQuery.showErrorDetail
	 * @example $('#sample').balloontip('ポップアップ表示');
	 */
	jQuery.fn.balloontip = function(message, callback) {
		try {
			if(!callback){
				callback = '';
			}
			message = jQuery.castHtml(message);
			message = message.replace(/\r\n/g, '<br />').replace(/\r/g,
					'<br />').replace(/\n/g, '<br />');
			//
			return (this.each(function(index, dom) {
				try {
					jQuery(this).attr(_toottipAttr, message).mouseover(
							function(event) {
								_balloontipMouseover(event, jQuery(this), callback);
							}).mouseout(function(event) {
						_balloontipMouseout(event, jQuery(this));
					}).mousemove(function(event) {
						_balloontipMousemove(event, jQuery(this));
					});
				} catch (e) {
					alert('balloontip each',e.message);
					return (false);
				}
			}));
		} catch (e) {
			alert('balloontip',e.message);
			return (this.each(function(index, dom) {
			}));
		}
	};
	/**
	 * jQuery拡張 ツールチップ削除
	 *
	 * @return {object} 自身の jQuery オブジェクト
	 * @public
	 * @requires _toottipAttr
	 * @requires _balloontipMouseover
	 * @requires _balloontipMouseout
	 * @requires _balloontipMousemove
	 * @requires _balloontipId
	 * @requires jQuery.showErrorDetail
	 * @example $('#sample').removeBalloontip();
	 */
	jQuery.fn.removeBalloontip = function() {
		try {
			return (this.each(function(index, dom) {
				try {
					jQuery(this).removeAttr(_toottipAttr).unbind('mouseover',
							_balloontipMouseover).unbind('mouseout',
							_balloontipMouseout).unbind('mousemove',
							_balloontipMousemove);
					jQuery('#' + _balloontipId).remove();
				} catch (e) {
					alert('removeBalloontip each',e.message);
					return (false);
				}
			}));
		} catch (e) {
			alert('removeBalloontip',e.message);
			return (this.each(function(index, dom) {
			}));
		}
	};
	//////////////////////////////////////////////////////////////////////////
	// Process error item
	//////////////////////////////////////////////////////////////////////////
	jQuery.fn.errorStyle = function(message, style,callback) {
		try {
			if(style == 1){
				return (this.each(function(index, dom) {
					try {
						message = jQuery.castString(message);
						if (message !== '') {
							if($(this).find('button').length > 0){
								$(this).find('button').addClass('boder-error');
							}else{
								$(this).addClass('boder-error');
							}
							if($(this).closest('div').hasClass('login-inline-box')){
								$(this).closest('div').after('<div class="textbox-error">'+message+'</span>');
							}else{
								$(this).after('<div class="textbox-error">'+message+'</span>');
							}
							if($(this).closest('tr').length > 0 ){
								$(this).closest('tr').find('td .num-length').addClass('td-error');
								$(this).closest('tr').find('td').css('vertical-align','top');
								$(this).closest('tr').find('td .btn-remove-row').closest('td').css('vertical-align','middle');
							}
						}
					} catch (e) {
						alert('errorStyle each',e.message);
						return (false);
					}
				}));
			}else if(style == 2){
				return (this.each(function(index, dom) {
					try {
						message = jQuery.castString(message);
						if (message !== '') {
							$(this).addClass('boder-error');
							$(this).after('<div class="textbox-error">'+message+'</span>');
							if($(this).closest('tr').length > 0 ){
								$(this).closest('tr').find('td .num-length').addClass('td-error');
								$(this).closest('tr').find('td').css('vertical-align','top');
								$(this).closest('tr').find('td .btn-remove-row').closest('td').css('vertical-align','middle');
							}

						}
					} catch (e) {
						alert('errorStyle each',e.message);
						return (false);
					}
				}));
			}else{
				return (this.each(function(index, dom) {
				try {
					message = jQuery.castString(message);
					if (message !== '') {
						style = jQuery.castString(style);
						if (style === '') {
							style = 'textbox-error';
						}
						if (!jQuery(this).hasClass(style)) {
							// エラースタイルを持っていない場合
							jQuery(this).addClass(style);
							if(callback){
								jQuery(this).balloontip(message, callback);
							}else{
								jQuery(this).balloontip(message);
							}
						}
					}
				} catch (e) {
					alert('errorStyle each',e.message);
					return (false);
				}
			}));
			}
			// return (this.each(function(index, dom) {
			// 	try {
			// 		message = jQuery.castString(message);
			// 		if (message !== '') {
			// 			style = jQuery.castString(style);
			// 			if (style === '') {
			// 				style = 'textbox-error';
			// 			}
			// 			if (!jQuery(this).hasClass(style)) {
			// 				// エラースタイルを持っていない場合
			// 				jQuery(this).addClass(style);
			// 				if(callback){
			// 					jQuery(this).balloontip(message, callback);
			// 				}else{
			// 					jQuery(this).balloontip(message);
			// 				}
			// 			}
			// 		}
			// 	} catch (e) {
			// 		alert('errorStyle each',e.message);
			// 		return (false);
			// 	}
			// }));
		} catch (e) {
			alert('errorStyle',e.message);
			return (this.each(function(index, dom) {
			}));
		}
	};

	/**
	 * jQuery拡張 エラースタイル削除
	 *
	 * @param {string}
	 *            style スタイル名 [デフォルト:textbox-error]
	 * @return {object} 自身の jQuery オブジェクト
	 * @public
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example $('input').removeErrorStyle('textbox-error');
	 */
	jQuery.fn.removeErrorStyle = function(style) {
		try {
			if(style == 1){
					return (this.each(function(index, dom) {
					try {
						$('.textbox-error').remove();
						$('input,select,textarea').removeClass('boder-error');
					} catch (e) {
						jQuery.showErrorDetail(e, 'removeErrorStyle each');
						return (false);
					}
				}));
			}else{
				return (this.each(function(index, dom) {
				try {
					style = jQuery.castString(style);
					if (style === '') {
						style = 'textbox-error';
					}
					//
					jQuery(this).removeClass(style).removeBalloontip();
				} catch (e) {
					jQuery.showErrorDetail(e, 'removeErrorStyle each');
					return (false);
				}
			}));
			}
		} catch (e) {
			jQuery.showErrorDetail(e, 'removeErrorStyle');
			return (this.each(function(index, dom) {
			}));
		}
	};

	//////////////////////////////////////////////////////////////////////////
	// COMMON
	//////////////////////////////////////////////////////////////////////////
		/**
	 * jQuery拡張 フォーマット
	 *
	 * @param {string}
	 *            format フォーマット ※変換表参照
	 * @return {object} jQuery オブジェクト
	 * @public
	 * @requires _textFormatBlur
	 * @requires jQuery.showErrorDetail
	 * @example $('#sample').textFormat('aA9');
	 */
	jQuery.fn.textFormat = function(format) {
		try {
			// 入力系タグ抽出
			var input = this.find('input[type=text]').add(
					this.filter('input[type=text]')).add(this.find('textarea'))
					.add(this.filter('textarea'));
			//
			input.each(function(index, dom) {
				try {
					jQuery(this).unbind('blur', _textFormatBlur).bind('blur', {
						normalFormat : format
					}, _textFormatBlur);
				} catch (e) {
					alert('textFormat each',e.message);
				}
			});
			//
			return (this.each(function(index, dom) {
			}));
		} catch (e) {
			alert('textFormat',e.message);
			return (this.each(function(index, dom) {
			}));
		}
	};
	/**
	 * フォーマット用イベント (unbind 特定用)
	 *
	 * @param {object}
	 *            event イベント
	 * @private
	 * @requires jQuery.textFormat
	 * @requires jQuery.showErrorDetail
	 * @example jQuery(this).unbind('blur', _textFormatBlur)
	 */
	function _textFormatBlur(event) {
		try {
			var object = jQuery(event['target']);
			var string = jQuery.textFormat(object.val(),
					event['data']['normalFormat']);
			object.val(string);
		} catch (e) {
			alert('textFormatBlur',e.message);
		}
	}
	/**
	 * フォーマット
	 *
	 * @param {string}
	 *            target フォーマット対象文字列
	 * @param {string}
	 *            format フォーマット ※変換表参照
	 * @return {string} フォーマット後文字列
	 * @public
	 * @requires jQuery.textFormat
	 * @requires jQuery.showErrorDetail
	 * @example var string = $.textFormat('abcABC012ａｂｃＡＢＣ０１２', 'aA9');
	 */
	jQuery.textFormat = function(target, format) {
		try {
			target = jQuery.castString(target);
			format = jQuery.castString(format);
			//
			if (target === '') {
				return (target);
			}
			//
			var flag = false;
			if (format.indexOf('-', 0) !== -1) {
				// "-"あり -> 指定以外削除
				flag = true;
			}
			// 全対象置換
			format = format.replace(/H/g, 'aA9@SK').replace(/Ｚ/g, 'ａＡ９＃＠ＳＫ');
			// 不要項目削除
			format = format.replace(/[^aａAＡ9９#＃@＠SＳKＫCＣWＷ]/g, '');
			//
			// 解析
			var memory = new Array();
			var stack = new Array();
			var H = new Array('a', 'A', '9', '#', '@', 'S', 'K', 'C', 'W');
			var Z = new Array('ａ', 'Ａ', '９', '＃', '＠', 'Ｓ', 'Ｋ', 'Ｃ', 'Ｗ');
			var indexH = -1;
			var indexZ = -1;
			var i = 0;
			var len = H.length;
			for (i = 0; i < len; i++) {
				// パターンを後ろから検索
				indexH = format.lastIndexOf(H[i]);
				indexZ = format.lastIndexOf(Z[i]);
				//
				if (indexH !== indexZ) {
					// インデックスが大きい方が最終的な変換対象
					if (indexH > indexZ) {
						memory[indexH] = H[i];
					} else {
						memory[indexZ] = Z[i];
					}
				}
			}
			//
			// 抜け番を詰める
			len = memory.length;
			for (i = 0; i < len; i++) {
				if (typeof (memory[i]) !== 'undefined') {
					stack[stack.length] = memory[i];
				}
			}
			//
			// 削除対象初期化
			_deleteStack = '';
			//
			len = stack.length;
			if (len === 0) {
				// フォーマット対象なし -> そのまま返却
				return (target);
			}
			//
			// 各フォーマット実行
			for (i = 0; i < len; i++) {
				switch (stack[i]) {
				case 'a':
					target = _formatConvertAlphabetLower(target, 'h');
					break;
				case 'ａ':
					target = _formatConvertAlphabetLower(target, 'f');
					break;
				case 'A':
					target = _formatConvertAlphabetUpper(target, 'h');
					break;
				case 'Ａ':
					target = _formatConvertAlphabetUpper(target, 'f');
					break;
				case '9':
					target = _formatConvertNumberOnly(target, 'h');
					break;
				case '９':
					target = _formatConvertNumberOnly(target, 'f');
					break;
				case '#':
					target = _formatConvertNumber(target, 'h');
					break;
				case '＃':
					target = _formatConvertNumber(target, 'f');
					break;
				case '@':
					target = _formatConvertSymbol(target, 'h');
					break;
				case '＠':
					target = _formatConvertSymbol(target, 'f');
					break;
				case 'S':
					target = _formatConvertSpace(target, 'h');
					break;
				case 'Ｓ':
					target = _formatConvertSpace(target, 'f');
					break;
				case 'K':
					target = _formatConvertKatakana(target, 'h');
					break;
				case 'Ｋ':
					target = _formatConvertKatakana(target, 'f');
					break;
				case 'C':
					target = _formatConvertAlphabetCase(target, 'h');
					break;
				case 'Ｃ':
					target = _formatConvertAlphabetCase(target, 'f');
					break;
				case 'W':
					target = _formatConvertKana(target, 'h');
					break;
				case 'Ｗ':
					target = _formatConvertKana(target, 'f');
					break;
				default:
					break;
				}
			}
			//
			// 不要文字列削除
			if (flag) {
				var object = '[^' + _deleteStack + ']';
				var regularExpression = new RegExp(object, 'gm');
				target = target.replace(regularExpression, '');
			}
			//
			return (target);
		} catch (e) {
			alert('textFormat',e.message);
			return ('');
		}
	};
	/**
	 * フォーマット:英字小文字の全角半角変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:半角 / f:全角
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertAlphabetLower('string', 'h');
	 */
	function _formatConvertAlphabetLower(target, type) {
		try {
			var half = new Array('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
					'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
					'v', 'w', 'x', 'y', 'z');
			var full = new Array('ａ', 'ｂ', 'ｃ', 'ｄ', 'ｅ', 'ｆ', 'ｇ', 'ｈ', 'ｉ',
					'ｊ', 'ｋ', 'ｌ', 'ｍ', 'ｎ', 'ｏ', 'ｐ', 'ｑ', 'ｒ', 'ｓ', 'ｔ', 'ｕ',
					'ｖ', 'ｗ', 'ｘ', 'ｙ', 'ｚ');
			//
			if (type === 'h') {
				target = _formatConvert(target, full, half);
				_deleteStack += half.join('');
			} else if (type === 'f') {
				target = _formatConvert(target, half, full);
				_deleteStack += full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertAlphabetLower',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:英字大文字の全角半角変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:半角 / f:全角
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertAlphabetUpper('string', 'h');
	 */
	function _formatConvertAlphabetUpper(target, type) {
		try {
			var half = new Array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
					'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
					'V', 'W', 'X', 'Y', 'Z');
			var full = new Array('Ａ', 'Ｂ', 'Ｃ', 'Ｄ', 'Ｅ', 'Ｆ', 'Ｇ', 'Ｈ', 'Ｉ',
					'Ｊ', 'Ｋ', 'Ｌ', 'Ｍ', 'Ｎ', 'Ｏ', 'Ｐ', 'Ｑ', 'Ｒ', 'Ｓ', 'Ｔ', 'Ｕ',
					'Ｖ', 'Ｗ', 'Ｘ', 'Ｙ', 'Ｚ');
			//
			if (type === 'h') {
				target = _formatConvert(target, full, half);
				_deleteStack += half.join('');
			} else if (type === 'f') {
				target = _formatConvert(target, half, full);
				_deleteStack += full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertAlphabetUpper',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:数字のみの全角半角変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:半角 / f:全角
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertNumberOnly('string', 'h');
	 */
	function _formatConvertNumberOnly(target, type) {
		try {
			var half = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8',
					'9');
			var full = new Array('０', '１', '２', '３', '４', '５', '６', '７', '８',
					'９');
			//
			if (type === 'h') {
				target = _formatConvert(target, full, half);
				_deleteStack += half.join('');
			} else if (type === 'f') {
				target = _formatConvert(target, half, full, true);
				_deleteStack += full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertNumberOnly',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:数字の全角半角変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:半角 / f:全角
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertNumber('string', 'h');
	 */
	function _formatConvertNumber(target, type) {
		try {
			var half = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8',
					'9', '%', '.', ',', '+', '-');
			var full = new Array('０', '１', '２', '３', '４', '５', '６', '７', '８',
					'９', '％', '．', '，', '＋', '－');
			//
			if (type === 'h') {
				target = _formatConvert(target, full, half);
				_deleteStack += '0123456789\%\\\.\,\\\+\\\-';
			} else if (type === 'f') {
				target = _formatConvert(target, half, full, true);
				_deleteStack += full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertNumber',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:記号の全角半角変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:半角 / f:全角
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertSymbol('string', 'h');
	 */
	function _formatConvertSymbol(target, type) {
		try {
			var half = new Array('!'
					, '"', '#'
					, '$', '%'
					, '\'', '&'
					, '(', ')'
					,'-', '='
					, '^', '~'
					, '\\', '|'
					, '@', '`'
					, '[', '{'
					, ';','+'
					, ':', '*'
					, ']', '}'
					, ',', '<'
					, '.', '>'
					, '/', '?'
					, '_','-'
					, '-', '-'
					, ',', '.'
					, '/');
			var full = new Array('！'
					, '”', '＃'
					, '＄', '％'
					, '’', '＆'
					, '（', '）',
					'－', '＝'
					, '＾', '～'
					, '￥', '｜'
					, '＠', '‘'
					, '［', '｛'
					, '；', '＋'
					,'：', '＊'
					, '］', '｝'
					, '，', '＜'
					, '．', '＞'
					, '／', '？'
					, '＿', 'ー'
					,'―', '‐'
					, '、', '。'
					, '・');
			//
			if (type === 'h') {
				target = _formatConvert(target, full, half);
				_deleteStack += '\\' + half.join('\\');
			} else if (type === 'f') {
				target = _formatConvert(target, half, full, true);
				_deleteStack += full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertSymbol',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:スペースの全角半角変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:半角 / f:全角
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertSpace('string', 'h');
	 */
	function _formatConvertSpace(target, type) {
		try {
			var half = new Array(' ');
			var full = new Array('　');
			//
			if (type === 'h') {
				target = _formatConvert(target, full, half);
				_deleteStack += half.join('');
			} else if (type === 'f') {
				target = _formatConvert(target, half, full);
				_deleteStack += full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertSpace',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:カタカナの全角半角変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:半角 / f:全角
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertKatakana('string', 'h');
	 */
	function _formatConvertKatakana(target, type) {
		try {
			// ※濁点・半濁点から先に置換する
			var half = new Array('ｶﾞ', 'ｷﾞ', 'ｸﾞ', 'ｹﾞ', 'ｺﾞ', 'ｻﾞ', 'ｼﾞ',
					'ｽﾞ', 'ｾﾞ', 'ｿﾞ', 'ﾀﾞ', 'ﾁﾞ', 'ﾂﾞ', 'ﾃﾞ', 'ﾄﾞ', 'ﾊﾞ', 'ﾋﾞ',
					'ﾌﾞ', 'ﾍﾞ', 'ﾎﾞ', 'ﾊﾟ', 'ﾋﾟ', 'ﾌﾟ', 'ﾍﾟ', 'ﾎﾟ', 'ｧ', 'ｨ',
					'ｩ', 'ｪ', 'ｫ', 'ｬ', 'ｭ', 'ｮ', 'ｯ', 'ｳﾞ', 'ｱ', 'ｲ', 'ｳ',
					'ｴ', 'ｵ', 'ｶ', 'ｷ', 'ｸ', 'ｹ', 'ｺ', 'ｻ', 'ｼ', 'ｽ', 'ｾ', 'ｿ',
					'ﾀ', 'ﾁ', 'ﾂ', 'ﾃ', 'ﾄ', 'ﾅ', 'ﾆ', 'ﾇ', 'ﾈ', 'ﾉ', 'ﾊ', 'ﾋ',
					'ﾌ', 'ﾍ', 'ﾎ', 'ﾏ', 'ﾐ', 'ﾑ', 'ﾒ', 'ﾓ', 'ﾔ', 'ﾕ', 'ﾖ', 'ﾗ',
					'ﾘ', 'ﾙ', 'ﾚ', 'ﾛ', 'ﾜ', 'ｦ', 'ﾝ', 'ｰ');
			var full = new Array('ガ', 'ギ', 'グ', 'ゲ', 'ゴ', 'ザ', 'ジ', 'ズ', 'ゼ',
					'ゾ', 'ダ', 'ヂ', 'ヅ', 'デ', 'ド', 'バ', 'ビ', 'ブ', 'ベ', 'ボ', 'パ',
					'ピ', 'プ', 'ペ', 'ポ', 'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', 'ャ', 'ュ', 'ョ',
					'ッ', 'ヴ', 'ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ',
					'サ', 'シ', 'ス', 'セ', 'ソ', 'タ', 'チ', 'ツ', 'テ', 'ト', 'ナ', 'ニ',
					'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ', 'マ', 'ミ', 'ム', 'メ',
					'モ', 'ヤ', 'ユ', 'ヨ', 'ラ', 'リ', 'ル', 'レ', 'ロ', 'ワ', 'ヲ', 'ン',
					'ー');
			//
			if (type === 'h') {
				target = _formatConvert(target, full, half);
				_deleteStack += half.join('');
			} else if (type === 'f') {
				target = _formatConvert(target, half, full);
				_deleteStack += full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertKatakana',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:英字の大文字小文字変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:小文字 / f:大文字
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertAlphabetCase('string', 'h');
	 */
	function _formatConvertAlphabetCase(target, type) {
		try {
			var half = new Array('ａ', 'ｂ', 'ｃ', 'ｄ', 'ｅ', 'ｆ', 'ｇ', 'ｈ', 'ｉ',
					'ｊ', 'ｋ', 'ｌ', 'ｍ', 'ｎ', 'ｏ', 'ｐ', 'ｑ', 'ｒ', 'ｓ', 'ｔ', 'ｕ',
					'ｖ', 'ｗ', 'ｘ', 'ｙ', 'ｚ');
			var full = new Array('Ａ', 'Ｂ', 'Ｃ', 'Ｄ', 'Ｅ', 'Ｆ', 'Ｇ', 'Ｈ', 'Ｉ',
					'Ｊ', 'Ｋ', 'Ｌ', 'Ｍ', 'Ｎ', 'Ｏ', 'Ｐ', 'Ｑ', 'Ｒ', 'Ｓ', 'Ｔ', 'Ｕ',
					'Ｖ', 'Ｗ', 'Ｘ', 'Ｙ', 'Ｚ');
			//
			if (type === 'h') {
				target = target.toLowerCase();
				target = _formatConvert(target, full, half);
				_deleteStack += 'abcdefghijklmnopqrstuvwxyz' + half.join('');
			} else if (type === 'f') {
				target = target.toUpperCase();
				target = _formatConvert(target, half, full);
				_deleteStack += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + full.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertAlphabetCase',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:ひらがな <-> カタカナ
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {string}
	 *            type 変換タイプ h:カタカナ / f:ひらがな
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires _deleteStack
	 * @requires _formatConvert
	 * @requires jQuery.castString
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertKana('string', 'h');
	 */
	function _formatConvertKana(target, type) {
		try {
			var katakana = new Array('ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク',
					'ケ', 'コ', 'サ', 'シ', 'ス', 'セ', 'ソ', 'タ', 'チ', 'ツ', 'テ', 'ト',
					'ナ', 'ニ', 'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ', 'マ', 'ミ',
					'ム', 'メ', 'モ', 'ヤ', 'ヰ', 'ユ', 'ヱ', 'ヨ', 'ラ', 'リ', 'ル', 'レ',
					'ロ', 'ワ', 'ヲ', 'ン', 'ガ', 'ギ', 'グ', 'ゲ', 'ゴ', 'ザ', 'ジ', 'ズ',
					'ゼ', 'ゾ', 'ダ', 'ヂ', 'ヅ', 'デ', 'ド', 'バ', 'ビ', 'ブ', 'ベ', 'ボ',
					'パ', 'ピ', 'プ', 'ペ', 'ポ', 'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', 'ャ', 'ュ',
					'ョ', 'ッ', 'ヮ', 'ー');
			var hiragana = new Array('あ', 'い', 'う', 'え', 'お', 'か', 'き', 'く',
					'け', 'こ', 'さ', 'し', 'す', 'せ', 'そ', 'た', 'ち', 'つ', 'て', 'と',
					'な', 'に', 'ぬ', 'ね', 'の', 'は', 'ひ', 'ふ', 'へ', 'ほ', 'ま', 'み',
					'む', 'め', 'も', 'や', 'ゐ', 'ゆ', 'ゑ', 'よ', 'ら', 'り', 'る', 'れ',
					'ろ', 'わ', 'を', 'ん', 'が', 'ぎ', 'ぐ', 'げ', 'ご', 'ざ', 'じ', 'ず',
					'ぜ', 'ぞ', 'だ', 'ぢ', 'づ', 'で', 'ど', 'ば', 'び', 'ぶ', 'べ', 'ぼ',
					'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ', 'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'ゃ', 'ゅ',
					'ょ', 'っ', 'ゎ', 'ー');
			//
			if (type === 'h') {
				target = _formatConvert(target, hiragana, katakana);
				_deleteStack += katakana.join('');
			} else if (type === 'f') {
				target = _formatConvert(target, katakana, hiragana);
				_deleteStack += hiragana.join('');
			}
			return (target);
		} catch (e) {
			alert('formatConvertKana',e.message);
			return ('');
		}
	}

	/**
	 * フォーマット:変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {array}
	 *            original 変換元
	 * @param {array}
	 *            format 変換先
	 * @param {bool}
	 *            escape true:エスケープ処理実行 / false:エスケープ処理不実行 [デフォルト:false]
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvert('string', full, half, true);
	 */
	function _formatConvert(target, original, format, escape) {
		try {
			var object = null;
			var i = 0;
			var len = original.length;
			//
			if (escape === true) {
				for (i = 0; i < len; i++) {
					object = new RegExp(_formatConvertEscapeCheck(original[i]),
							'gm');
					target = target.replace(object, format[i]);
				}
			} else {
				for (i = 0; i < len; i++) {
					object = new RegExp(original[i], 'gm');
					target = target.replace(object, format[i]);
				}
			}
			delete (object);
			return (target);
		} catch (e) {
			alert('formatConvert',e.message);
			return ('');
		}
	}

	/**
	 * 半角記号でエスケープ処理が必要なもの判定
	 *
	 * @param {string}
	 *            character 文字
	 * @return {srting} エスケープ処理文字
	 * @private
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvertEscapeCheck(character);
	 */
	function _formatConvertEscapeCheck(character) {
		try {
			var escape = '\\/^$*+-?{|}[].()';
			var i = 0;
			var len = escape.length;
			for (i = 0; i < len; i++) {
				if (character.indexOf(escape[i], 0) !== -1) {
					return ('\\' + character);
				}
			}
			return (character);
		} catch (e) {
			alert('formatConvertEscapeCheck',e.message);
			return ('');
		}
	}
	/**
	 * フォーマット:変換
	 *
	 * @param {string}
	 *            target フォーマット対象の文字列
	 * @param {array}
	 *            original 変換元
	 * @param {array}
	 *            format 変換先
	 * @param {bool}
	 *            escape true:エスケープ処理実行 / false:エスケープ処理不実行 [デフォルト:false]
	 * @return {string} フォーマット後の文字列
	 * @private
	 * @requires jQuery.showErrorDetail
	 * @example var string = _formatConvert('string', full, half, true);
	 */
	function _formatConvert(target, original, format, escape) {
		try {
			var object = null;
			var i = 0;
			var len = original.length;
			//
			if (escape === true) {
				for (i = 0; i < len; i++) {
					object = new RegExp(_formatConvertEscapeCheck(original[i]),
							'gm');
					target = target.replace(object, format[i]);
				}
			} else {
				for (i = 0; i < len; i++) {
					object = new RegExp(original[i], 'gm');
					target = target.replace(object, format[i]);
				}
			}
			delete (object);
			return (target);
		} catch (e) {
			alert('formatConvertEscapeCheck',e.message);
			return ('');
		}
	}
	/**
	 * send email
	 *
	 * @param {array}
	 *
	 * @return {number}
	 * @private
	 * @requires
	 * @example sendEmail(data, function() {});
	 */
	jQuery.sendEmail = function(data, callback) {
		try {
			var url = '';
			if ( data.mail_type == 'html' ) {
				url = '/common/email/sendhtml';
			}
			else {
				url = '/common/email/sendraw';
			}
			$.ajax({
				type		:	'POST',
	    		url			:	url,
	    		dataType	:	'json',
	    		loading		:	true,
	    		data		:	data,
				success: function(res) {
					if ( typeof callback != 'undefined' ) {
						callback(res);
					}
				},
				complete: function() {
					$('.div_loading').css('display', 'none');
				}
			});
		} catch (e) {
			alert('sendEmail: ', e.message);
		}
	}
	/**
	 * buttonGroupModal
	 *
	 * @param {array}
	 *
	 * @return {number}
	 * @private
	 * @requires
	 * @example buttonGroupModal(options, function() {});
	 */
	jQuery.buttonGroupModal = function(options) {
		var html = '<div id="btn-group-modal">';
			html+=		'<div class="card">';
			html+=			'<div class="text-center mh">';
			html+=				'<a href="jvascript:;"><i class="fa caret"></i></a>';
			html+=			'</div>';
			html+=			'<a href="jvascript:;" class="m-remove">';
			html+=				'<span class="rm-x"></span>';
			html+=				'<span class="rm-y"></span>';
			html+=			'</a>';
			html+=			'<div class="card-body">';
			html+=				'<div class="full-width text-center">';
			html+=					'{content}';
			html+=				'</div>';
			html+=			'</div>';
			html+=		'</div>';
			html+=	'</div>';
		var _plugins = {
			content:'',
			target:'',
			autoshow:false,
			},
			body     = $('body'),
			container = '';
		$.extend(_plugins,options);
		_plugins.groupActionShow = function() {
			body.find('#btn-group-modal').remove();
			html = html.replace('{content}',_plugins.content);
			body.append(html);
		}
		_plugins.groupActionRemove = function() {
			if(body.find('#btn-group-modal').length > 0)
				body.find('#btn-group-modal').remove();
		}
		_plugins.groupActionHide = function() {
			if(body.find('#btn-group-modal').length > 0) {
				container = body.find('#btn-group-modal');
				container.toggleClass('out');
			}
		}
		if(_plugins.target) {
			$(document).on('click',_plugins.target,function(e){
				e.preventDefault();
				_plugins.groupActionShow();
			});
		}
		$(document).on('click','#btn-group-modal .mh',function(e){
			e.preventDefault();
			_plugins.groupActionHide();
		});
		$(document).on('click','#btn-group-modal .m-remove',function(e){
			e.preventDefault();
			_plugins.groupActionRemove();
		});

		if(_plugins.autoshow) {
			_plugins.groupActionShow();
		}
	}
	/*=============================================================================*/
	/*Format input*/
	/*=============================================================================*/
	/**
	 * buttonGroupModal
	 *
	 * @param {array}
	 *
	 * @return {number}
	 * @private
	 * @requires
	 * @example buttonGroupModal(options, function() {});
	 */
	jQuery.formatInput = function(options) {
		if( options == undefined){
			options = 'body';
		}
		// keydown event
		// console.log(options);
		$(options).find('input.numeric:enabled').keydown(function(e){
			if (!((e.keyCode > 47 && e.keyCode < 58)
				|| (e.keyCode > 95 && e.keyCode < 106)
				// ////////// PERIOD SIGN
				|| ((e.keyCode == 190 || e.keyCode == 110) && $(this).val().indexOf('.') === -1)
				|| e.keyCode == 173
				|| e.keyCode == 109
				|| e.keyCode == 189
				|| e.keyCode == 116
				|| e.keyCode == 46
				|| e.keyCode == 37
				|| e.keyCode == 39
				|| e.keyCode == 8
				|| e.keyCode == 9
				|| e.keyCode == 229 // ten-key processing
				||
				($.inArray(e.keyCode,[ 65, 67, 86, 88, 116 ]) !== -1 && e.ctrlKey === true)
				||
				// Allow: Ctrl+A, C, X, V
				($.inArray(e.keyCode,[9]) !== -1 && e.shiftKey === true)
				||
				// Allow: home, end, left, right
				(e.keyCode >= 35 && e.keyCode <= 39)
			)) {
				e.preventDefault();
				return false;
			}
			// check numeric is negative ?
			var negativeEnabled = $(this).attr('negative');
			if (e.keyCode != 116
					&& e.keyCode != 46
					&& e.keyCode != 37
					&& e.keyCode != 39
					&& e.keyCode != 8
					&& e.keyCode != 9
					&& e.keyCode != 173
					&& e.keyCode != 189
					&& e.keyCode != 109
					&& ($(this).get(0).selectionEnd - $(this).get(0).selectionStart) < $(this).val().length
				) {
				// DEFAULT PARAMS (NUMERIC (10, 0))
				var ml = 10;
				var dc = 0;
			
				if (parseInt($(this).attr('maxlength')) * 1 > 2) {
					//ml = 1 * $(this).attr('maxlength') - 1;
					ml = 1 * $(this).attr('maxlength') ;
				}
				if (parseInt($(this).attr('decimal')) > 0) {
					dc = 1 * $(this).attr('decimal');
					if (dc >= ml - 1) {
						dc = 0;
					}
				}
				var it = (ml - (dc > 0 ? (dc + 1) : 0));
				// CURRENT STATES
				var val 			= $(this).val();
				var negative 		= val.indexOf('-') > -1;
				var selectionStart 	= $(this).get(0).selectionStart;
				var selectionEnd 	= $(this).get(0).selectionEnd;
				if (negative) {
					val = val.substring(1);
					//datnt reduce maxlenght = 1 cause line above remove '-' from value input
					ml --;
					//end datnt
					selectionStart--;
					selectionEnd--;
				}
				// OUTPUT STATES
				var destSelectionStart 		= undefined;
				var destSelectionEnd 		= undefined;
				var destVal 				= undefined;
				// SKIP PERIOD KEY WHEN DECIMAL = 0
				if (dc == 0 && (e.keyCode == 190 || e.keyCode == 110)) {
					e.preventDefault();
				}
				// EXCEED THE ACCEPTED NUMBER OF INTEGERS
				if (val.match(new RegExp('[0-9]{' + it + '}')) && selectionStart <= it) {
					// PERIOD DOES NOT EXIST
					if (val.indexOf('.') === -1) {
						// PERIOD KEY NOT RECEIVED (USER FORGETS TO TYPE PERIOD) DECIMAL > 0
						if (e.keyCode != 190 && e.keyCode != 110 && dc > 0) {
							e.preventDefault();
//							var output = val.substring(0,selectionStart) + String.fromCharCode((96 <= e.keyCode && e.keyCode <= 105) ? e.keyCode - 48 : e.keyCode) + val.substring(selectionStart);
							var output = '';
							if(e.keyCode >= 96 && e.keyCode <= 105){
								output = val.substring(0,selectionStart) + String.fromCharCode(e.keyCode - 48) + val.substring(selectionStart);
								destVal = output.substring(0, ml - (dc + 1)) + '.'+ output.substring(ml - (dc + 1));
							}else if (e.keyCode == 229){
								if ($.inArray(e.key,[ '0','1','2','3','4','5','6','7','8','9']) !== -1){
									output = val.substring(0,selectionStart) + e.key +val.substring(selectionStart);
								}
								if(output.substring(ml - (dc + 1)) != ''){
									destVal = output.substring(0, ml - (dc + 1)) + '.'+ output.substring(ml - (dc + 1));
								}else{
									destVal = output.substring(0, ml - (dc + 1));
								}
							}else{
								output = val.substring(0,selectionStart) + String.fromCharCode(e.keyCode) + val.substring(selectionStart);
								destVal = output.substring(0, ml - (dc + 1)) + '.'+ output.substring(ml - (dc + 1));
							}
							// INSERT PERIOD


						}
						// PERIOD EXISTS
						// CARET STARTS NEXT TO THE PERIOD
					} else if (selectionStart == val.indexOf('.')) {
						// EXCEED THE ACCEPTED NUMBER OF
						// DECIMALS
						if (val.match(new RegExp('\\.[0-9]{'+ dc + '}$'))) {
							e.preventDefault();
						} else {
							// JUMP TO THE NEXT POSITION THEN
							// INSERT THE DIGIT
							destSelectionStart = selectionStart + 1;
						}
						// CARET STARTS BEFORE THE PERIOD AND
						// NOTHING HIGHLIGHTED
					} else if (selectionStart < val.indexOf('.') && selectionStart == selectionEnd) {
						e.preventDefault();
						// CARET STARTS BEFORE THE PERIOD AND
						// ENDS AFTER THE PERIOD (HIGHLIGHTS
						// OVER THE PERIOD)
					} else if (selectionEnd > val.indexOf('.') && selectionStart < val.indexOf('.')) {
						e.preventDefault();
						var output = '';
						if(e.keyCode >= 96 && e.keyCode <= 105){
							output 	= val.substring(0,selectionStart)+ String.fromCharCode(e.keyCode - 48) + val.substring(selectionEnd);
							destVal = output.substring(0, ml - (dc + 1)) + '.' + output.substring(ml - (dc + 1));
						}else if(e.keyCode == 229){
							//output = val.substring(0,selectionStart)+ val.substring(selectionEnd);
							if ($.inArray(e.key,[ '0','1','2','3','4','5','6','7','8','9']) !== -1){
								output = val.substring(0,selectionStart) + e.key +val.substring(selectionStart);
							}
							if(output.substring(ml - (dc + 1)) != ''){
								destVal = output.substring(0, ml - (dc + 1)) + '.' + output.substring(ml - (dc + 1));
							}else{
								destVal = output.substring(0, ml - (dc + 1));
							}
						}else{
							output 	= val.substring(0,selectionStart)+ String.fromCharCode(e.keyCode) + val.substring(selectionEnd);
							destVal = output.substring(0, ml - (dc + 1)) + '.' + output.substring(ml - (dc + 1));
						}
						//
						destSelectionStart 	= selectionStart + 1;
						destSelectionEnd 	= selectionStart + 1;
					}
					// INTEGERS CAN BE ADDED BUT...
					// EXCEED THE ACCEPTED NUMBER OF DECIMALS
				} else if (val.match(new RegExp('\\.[0-9]{'+ dc + '}$'))) {
					// PERIOD EXISTS
					// CARET STARTS AFTER THE PERIOD
					if (val.indexOf('.') != -1 && selectionStart > val.indexOf('.')) {
						e.preventDefault();
					}
				}
				// CARET RESULT
				if(typeof destVal != undefined){
					if (destVal && negative) {
						destVal = '-' + destVal;
					}
					if (destVal) {
						$(this).val(destVal);
					}
				}
				//
				if (negative && destSelectionStart) {
					destSelectionStart++;
				}
				if (destSelectionStart) {
					$(this).get(0).selectionStart = destSelectionStart;
				}
				if (negative && destSelectionEnd) {
					destSelectionEnd++;
				}
				if (destSelectionEnd) {
					$(this).get(0).selectionEnd = destSelectionEnd;
				}
			// when click [-]
			} else if (e.keyCode == 173 || e.keyCode == 109 || e.keyCode == 189) {
				e.preventDefault();
				if (negativeEnabled) {
					var maxlength 		=	$(this).attr('maxlength')*1;
					var val = $(this).val();
					var negative = val.indexOf('-') > -1;
					if (negative) {
						$(this).val(val.substring(1));
						$(this).attr('maxlength',maxlength-1);
					} else {
						$(this).val('-' + val);
						$(this).attr('maxlength',maxlength+1);
					}
				}
			}
			// fix maxlenght
			var val = $(this).val();
			if ($(this).attr('fixed') != undefined && val.indexOf('-') > -1) {
				var f_maxlenght = (parseInt($(this).attr('maxlengthfixed')) + 1) + '';
				if (val.length <= f_maxlenght) {
					$(this).attr('maxlength', f_maxlenght);
				} else {
					$(this).attr('maxlength', f_maxlenght);
				}
			} else if ($(this).attr('maxlength') > $(this).attr('maxlengthfixed')) {
				$(this).attr('maxlength',$(this).attr('maxlengthfixed'));
			}
		});
		////////////////////////////////////////////////////////////////////
		//  add new datetimepicker
		////////////////////////////////////////////////////////////////////
		if($.fn.datetimepicker)
		{
			//add vietdt 2022/08/08
			var language = 'ja'
			if ($('#language_jmessages').val() == 'en') {
				language         = 'en'
			}
			jQuery.datetimepicker.setLocale(language);
			$('input.date:not([disabled]):not([readonly])').datetimepicker({
				format : 'Y/m/d',
				timepicker:false,
			});
			// click button date
			$('input.date:not([disabled]):not([readonly])').closest('.input-group').find('.btn').click(function(){
				var date_item = $(this).closest('.input-group').find('.date:not([disabled]):not([readonly])');
				date_item.trigger('focus');
			});
		}
		//
		$(".employee_customer_nm").autocomplete({
			source: function (request, response){
				$.ajax({
					type: 'GET',
					url: '/common/employeecustomerautocomplete',
					dataType: 'json',
				// loading:true,
				global: false,
				data: {
					key: request.term
				},
				success: function (res){
					// console.log(res);
					for(var i = 0;i<res.length;i++){
						res[i].label 	=	htmlEntities(res[i].label);
						res[i].value 	=	htmlEntities(res[i].value);
					}
					response(res);
				},
			});
			},
			minLength: 1,
			open: function (event, ui) {
				var $input = $(event.target);
				var $results = $input.autocomplete("widget");
				var scrollTop = $(window).scrollTop();
				var top = $results.position().top;
				var height = $results.outerHeight();
				if (top + height > $(window).innerHeight() + scrollTop) {
					newTop = top - height - $input.outerHeight();
					if (newTop > scrollTop)
						$results.css("top", newTop + "px");
				}
			},
			select: function (event, ui){
				$(this).closest('span').find('.incharge_cd').val(ui.item.id);
				$(this).attr('old_employee_nm',htmlEntities(ui.item.value));
			}
		});
		// employee_nm item
		$(".employee_nm").autocomplete({
			source: function (request, response){
				$.ajax({
					type: 'GET',
					url: '/common/employeeautocomplete',
					dataType: 'json',
				// loading:true,
				global: false,
				data: {
					key: request.term,
					fiscal_year :	$('#fiscal_year').val(), //add vietdt 2022/04/01
				},
				success: function (res){
					// console.log(res);
					for(var i = 0;i<res.length;i++){
						res[i].label 	=	htmlEntities(res[i].label);
						res[i].value 	=	htmlEntities(res[i].value);
					}
					response(res);
				},
			});
			},
			minLength: 1,
			open: function (event, ui) {
				var $input = $(event.target);
				var $results = $input.autocomplete("widget");
				var scrollTop = $(window).scrollTop();
				var top = $results.position().top;
				var height = $results.outerHeight();
				if (top + height > $(window).innerHeight() + scrollTop) {
					newTop = top - height - $input.outerHeight();
					if (newTop > scrollTop)
						$results.css("top", newTop + "px");
				}
			},
			select: function (event, ui){
				$(this).closest('span').find('.employee_cd_hidden').val(ui.item.id);
				$(this).attr('old_employee_nm',htmlEntities(ui.item.value));
				$(this).closest('.div_parent_employee_nm').prev('.div_parent_employee_cd').find('.employee_cd').val(ui.item.id);
			}
		});
		// employee_nm_1on1 item
		$(".employee_nm_1on1").autocomplete({
			source: function (request, response){
				$.ajax({
					type: 'GET',
					url: '/common/employeeautocomplete1on1',
					dataType: 'json',
				// loading:true,
				global: false,
				data: {
					key: 			request.term,
					fiscal_year :	$('#fiscal_year').val(),
				},
				success: function (res){
					// console.log(res);
					for(var i = 0;i<res.length;i++){
						res[i].label 	=	htmlEntities(res[i].label);
						res[i].value 	=	htmlEntities(res[i].value);
					}
					response(res);
				},
			});
			},
			minLength: 1,
			open: function (event, ui) {
				var $input = $(event.target);
				var $results = $input.autocomplete("widget");
				var scrollTop = $(window).scrollTop();
				var top = $results.position().top;
				var height = $results.outerHeight();
				if (top + height > $(window).innerHeight() + scrollTop) {
					newTop = top - height - $input.outerHeight();
					if (newTop > scrollTop)
						$results.css("top", newTop + "px");
				}
			},
			select: function (event, ui){
				$(this).closest('span').find('.employee_cd_hidden').val(ui.item.id);
				$(this).attr('old_employee_nm',htmlEntities(ui.item.value));
				$(this).closest('.div_parent_employee_nm').prev('.div_parent_employee_cd').find('.employee_cd').val(ui.item.id);
			}
		});
		// employee_nm_mulitireview item
		$(".employee_nm_mulitireview").autocomplete({
			source: function (request, response){
				$.ajax({
					type: 'GET',
					url: '/common/employeeautocompletemulitireview',
					dataType: 'json',
				// loading:true,
				global: false,
				data: {
					key: 			request.term,
					fiscal_year :	$('#fiscal_year').val(),
				},
				success: function (res){
					for(var i = 0;i<res.length;i++){
						res[i].label 	=	htmlEntities(res[i].label);
						res[i].value 	=	htmlEntities(res[i].value);
					}
					response(res);
				},
			});
			},
			minLength: 1,
			open: function (event, ui) {
				var $input = $(event.target);
				var $results = $input.autocomplete("widget");
				var scrollTop = $(window).scrollTop();
				var top = $results.position().top;
				var height = $results.outerHeight();
				if (top + height > $(window).innerHeight() + scrollTop) {
					newTop = top - height - $input.outerHeight();
					if (newTop > scrollTop)
						$results.css("top", newTop + "px");
				}
			},
			select: function (event, ui){
				$(this).closest('span').find('.employee_cd_hidden').val(ui.item.id);
				$(this).attr('old_employee_nm',htmlEntities(ui.item.value));
				$(this).closest('.div_parent_employee_nm').prev('.div_parent_employee_cd').find('.employee_cd').val(ui.item.id);
			}
		});
		// employee_nm_mulitiselect item
		$(".employee_nm_mulitiselect").focus(function(){
			var mulitiselect_mode = $(this).attr('mulitiselect_mode');
			$('#mulitiselect_mode').val(mulitiselect_mode);
		});
		$(".employee_nm_mulitiselect").autocomplete({
			source: function (request, response){
				$.ajax({
					type: 'GET',
					url: '/common/employeeautocompletemulitiselect',
					dataType: 'json',
				// loading:true,
				global: false,
				data: {
					key: 			request.term,
					fiscal_year :	$('#fiscal_year').val(),
					mulitiselect_mode :	$('#mulitiselect_mode').val(),
				},
				success: function (res){
					for(var i = 0;i<res.length;i++){
						res[i].label 	=	htmlEntities(res[i].label);
						res[i].value 	=	htmlEntities(res[i].value);
					}
					response(res);
				},
			});
			},
			minLength: 1,
			open: function (event, ui) {
				var $input = $(event.target);
				var $results = $input.autocomplete("widget");
				var scrollTop = $(window).scrollTop();
				var top = $results.position().top;
				var height = $results.outerHeight();
				if (top + height > $(window).innerHeight() + scrollTop) {
					newTop = top - height - $input.outerHeight();
					if (newTop > scrollTop)
						$results.css("top", newTop + "px");
				}
			},
			select: function (event, ui){
				$(this).closest('span').find('.employee_cd_hidden').val(ui.item.id);
				$(this).attr('old_employee_nm',htmlEntities(ui.item.value));
				$(this).closest('.div_parent_employee_nm').prev('.div_parent_employee_cd').find('.employee_cd').val(ui.item.id);
			}
		});
		// employee_nm_weeklyreport item
		$(".employee_nm_weeklyreport").autocomplete({
			source: function (request, response){
				$.ajax({
					type: 'GET',
					url: '/common/employeeautocompleteweeklyreport',
					dataType: 'json',
				// loading:true,
				global: false,
				data: {
					key: 			request.term,
					fiscal_year :	$('#fiscal_year').val(),
				},
				success: function (res){
					// console.log(res);
					for(var i = 0;i<res.length;i++){
						res[i].label 	=	htmlEntities(res[i].label);
						res[i].value 	=	htmlEntities(res[i].value);
					}
					response(res);
				},
			});
			},
			minLength: 1,
			open: function (event, ui) {
				var $input = $(event.target);
				var $results = $input.autocomplete("widget");
				var scrollTop = $(window).scrollTop();
				var top = $results.position().top;
				var height = $results.outerHeight();
				if (top + height > $(window).innerHeight() + scrollTop) {
					newTop = top - height - $input.outerHeight();
					if (newTop > scrollTop)
						$results.css("top", newTop + "px");
				}
			},
			select: function (event, ui){
				$(this).closest('span').find('.employee_cd_hidden').val(ui.item.id);
				$(this).attr('old_employee_nm',htmlEntities(ui.item.value));
				$(this).closest('.div_parent_employee_nm').prev('.div_parent_employee_cd').find('.employee_cd').val(ui.item.id);
			}
		});
		/**
		 * Get end day of year
		 *
		 * @author : tannq
		 * @return : null
		 * @access : public
		 * @see :
		 */
		function getDaysInMonth(m, y) {
		    return m===2 ? y & 3 || !(y%25) && y & 15 ? 28 : 29 : 30 + (m+(m>>3)&1);
		}

		//
		function renderYearMonthDay(elm)
		{
			var d = (elm.parent('.input-group').find('.jday').val());
			var m = (elm.parent('.input-group').find('.jmonth').val());
			var y = (elm.parent('.input-group').find('.jyear').val());
			if(elm.hasClass('jyear')) {
				regex = /\d{4}/;
				if(!regex.test(y)) {
					elm.val('');
				}
			} else if(elm.hasClass('jmonth')) {
				regex = /^01|02|03|04|05|06|07|08|09|10|11|12$/;
				if(/^1|2|3|4|5|6|7|8|9$/.test(m) && parseInt(m) < 10)
				{
					elm.val('0'+parseInt(m));
					return;
				} else if(!regex.test(m)) {
					elm.val('');
				}
			} else if(elm.hasClass('jday')) {
				regex = /\d{2}/;
				if(regex.test(d) && parseInt(d) < 10)
				{
					elm.val('0'+parseInt(d));
					return;
				} else if(regex.test(d) && parseInt(d) > 31) {
					elm.val(31);
				} else if(!regex.test(d)) {
					elm.val('');
				}
			}
			if(y!='' && m!='' && parseInt(d) > getDaysInMonth(parseInt(m), parseInt(y)))
			{
				elm.parent('.input-group').find('.jday').val(getDaysInMonth(parseInt(m), parseInt(y)));
				return;
			}
		}
		// focus event
		$(this).find('input.date:enabled').focus(function(){
			if ( !$(this).hasClass('date--time') ) {
				if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
					$(this).select();
				}else{
					var string = $(this).val();
						string = formatConvertHalfsize(string);
					// if(string.indexOf('/') != -1){
					// 	var temp = string.replace(/\//g,'');
					// 	$(this).val(temp);
					// }
					$(this).select();
				}
			}
		});
		// blur event
		$(this).find('input.date:enabled').blur(function(){
			if ( !$(this).hasClass('date--time') ) {
				var string = $(this).val();
					string = formatConvertHalfsize(string);
				var reg1 = /^[0-9]{8}$/;
				var reg2 = /^[0-9]{4}[\/.][0-9]{2}[\/.][0-9]{2}$/;
				// add by viettd 2017/12/15
				if(parseInt(string)  > 0 &&  parseInt(string)  < 32){
					var d  = new Date();
					var yyyy = d.getFullYear();
					var mm = d.getMonth() + 1;
					string = yyyy + '/' + $.fillByLength(mm, 2, '0', true) + '/' +  $.fillByLength(string, 2, '0', true)
				}
				//
				if (string.match(reg1)) {
					$(this).val(string.substring(0, 4) + '/' + string.substring(4, 6) + '/' + string.substring(6));
				} else if (string.match(reg2)) {
					$(this).val(string);
				} else {
					$(this).val('');
				}
				if (!_validateYyyyMmDd($(this).val())) {
					$(this).val('');
				}
			}
			// callback
			if(typeof date_callback == 'function'){
			    date_callback(this);
			}
		});
		//  event
		$(this).find('input.date:enabled').change(function(){
			if ( !$(this).hasClass('date--time') ) {
				var string = $(this).val();
					string = formatConvertHalfsize(string);
				var reg1 = /^[0-9]{8}$/;
				var reg2 = /^[0-9]{4}[\/.][0-9]{2}[\/.][0-9]{2}$/;
				// add by viettd 2017/12/15
				if(parseInt(string)  > 0 &&  parseInt(string)  < 32){
					var d  = new Date();
					var yyyy = d.getFullYear();
					var mm = d.getMonth() + 1;
					string = yyyy + '/' + $.fillByLength(mm, 2, '0', true) + '/' +  $.fillByLength(string, 2, '0', true)
				}
				//
				if (string.match(reg1)) {
					$(this).val(string.substring(0, 4) + '/' + string.substring(4, 6) + '/' + string.substring(6));
				} else if (string.match(reg2)) {
					$(this).val(string);
				} else {
					$(this).val('');
				}
				if (!_validateYyyyMmDd($(this).val())) {
					$(this).val('');
				}
			}
			// callback
			if(typeof date_callback == 'function'){
			    date_callback(this);
			}
		});
		//
		$(this).find('input.month:enabled').blur(function(){
			try {
				var string = $(this).val();
				var reg1 = /^[0-9]{6}$/;
				var reg2 = /^[0-9]{4}[\/.][0-9]{2}$/;
				// add by viettd 2017/12/15
				if(parseInt(string)  > 0 &&  parseInt(string)  < 13){
					var d  = new Date();
					var yyyy = d.getFullYear();
					// var mm = d.getMonth() + 1;
					// var dd = d.getDay();
					//
					string = yyyy + '/' + $.fillByLength(string, 2, '0', true);
				}
				//
				if (string.match(reg1)) {
						$(this).val(
								string.substring(0, 4) + '/'
										+ string.substring(4, 6));
						$(this).val(set_limit_date_month($(this).val()));
					} else if (string.match(reg2)) {
						$(this).val(string);
						$(this).val(set_limit_date_month($(this).val()));
					} else {
						$(this).val('');
					}
					if (string.replace(/\D/g, '') != $(this).attr('old')) {
						$(this).next('.hasYmpicker').trigger('change');
					}
					if (!_validateYyyyMm($(this).val())) {
						$(this).val('');
					}
			} catch (e) {
				alert(e.message);
			}
		});
		// focus month
		$(this).find('input.month:enabled').focus(function(){
			try {
				var string = $(this).val();
				var reg = /^[0-9]{4}[\/.][0-9]{2}$/;
				if (string.match(reg)) {
					$(this).val(string.replace(/\D/g, ''));
					$(this).attr('old', string.replace(/\D/g, ''));
				}
				$(this).select();
			} catch (e) {
				alert(e.message);
			}
		});
		//-----------ONLY-NUMBER-------------
		// blur event
		$(this).find('input.only-number:enabled').blur(function(){
			var _this 	= 	$(this)
			var val 	=	_this.val();
				val 	= 	formatConvertHalfsize(val);
			if (_this.attr('negative')) {
				if (!_validateNumber(val)) {
					_this.val('');
				}
			}else{
				if (!_isNormalInteger(val)) {
					_this.val('');
				}
			}
		});

		// keydoun event
		$(this).find('input.only-number:enabled,input.money:enabled').keydown(function(event){
			try {
				var negativeEnabled = false;
				if ($(this).attr('negative')) {
					negativeEnabled = $(this).attr('negative');
				}
				if (event.keyCode == 53){
					return true;
				}
				if (!((event.keyCode > 47 && event.keyCode < 58)
						|| (event.keyCode > 95 && event.keyCode < 106)
						|| event.keyCode == 116
						|| event.keyCode == 46
						|| event.keyCode == 37
						|| event.keyCode == 39
						|| event.keyCode == 8
						|| event.keyCode == 9
						|| event.ctrlKey // 20160404 - sangtk - allow all ctrl combination //
						|| event.keyCode == 229 // ten-key processing
						)
						// || event.shiftKey
						|| (negativeEnabled == false
								&& event.keyCode == 189 || event.keyCode == 109)) {
					event.preventDefault();
				}
				if (negativeEnabled && (event.keyCode == 189 || event.keyCode == 109)) {
					var _this 			=	$(this);
					var val 			= 	_this.val();
					var character 		=	val.substring(0,1);
					var negative 		=	'';
					var maxlength 		=	_this.attr('maxlength')*1;
					if(character=='-'){
						_this.attr('maxlength',maxlength-1);
						negative 	= val.replace(/-/g, '');
					}else{
						_this.attr('maxlength',maxlength+1);
						negative 	= '-' + val.replace(/-/g, '');
					}
					// var negative 	= '-' + val.replace(/-/g, '');
					$(this).val(negative);
				}
			} catch (e) {
				alert(e.message);
			}
		});
		// focus event
		$(this).find('input.only-number:enabled').focus(function(){
			setTimeout(() => {
			    $(this).select();
            }, 1);
		});
		//-----------NUMERIC-------------
		// blur event
		$(this).find('input.numeric:enabled').not('.number_item').blur(function(){
			try {
				var negativeEnabled 	= $(this).attr('negative');
				var val 				= $(this).val();
					val 				= formatConvertHalfsize(val);
				//
				if (typeof val != undefined && val != ''){
					var negative 			= val.indexOf('-') > -1;
					if (negative) {
						val = val.substring(1);
					}
					var old = val;
					val = val.replace('.', '');
					val = old;
					//
					var dc = 1 * $(this).attr('decimal');
					var result = parseFloat(val.replace(/,/g, ""));
					if (result || result === 0) {
						result = result.toFixed(dc);
						if (result.indexOf('.') > -1) {
							var integer = result.substring(0,result.indexOf('.')).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
							var decimal = result.substring(result.indexOf('.'));
							var ml = typeof $(this).attr('maxlength') != 'undefined' ? parseInt($(this).attr('maxlength')) : 0;
							if(ml > 2 && integer.length > (ml-2)){
								var num = ml-dc-1;
								var tmp = $(this).val().replace('.', "");
								integer = parseFloat(tmp.substring(0,num));
								decimal = parseFloat('0.'+tmp.substring(num,num+dc));
							}
							val = integer + decimal;
						} else {
							val = result.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
					} else {
						val = '';
					}
					if(!negativeEnabled && val < 0){
						val = '';
					}
					//
					var max 	= $(this).attr('max');
					if(typeof max != undefined && val*1 > max*1){
						val = max;
					}
					console.log(val);
					$(this).val((val != '' && val != '0' && negativeEnabled && negative) ? ('-' + val) : val);
				}
			} catch (e) {
				alert('Error input.numeric blur event: ' + e.message);
			}
		});
		//focus event
		$(this).find('input.numeric:enabled').not('.number_item').focus(function(){
			var val = $(this).val();
			var negative = val.indexOf('-') > -1;
			if (negative) {
				val = val.substring(1);
			}
			val = val.replace(/,/g, "");
			$(this).val(negative ? ('-' + val) : val);
			$(this).select();
		});


	
		//-----------PHONE with not minus-------------
		//blur event
		$(this).find('input.tel:enabled').blur(function(){
			try {
				var string 	=	$(this).val();
					string = formatConvertHalfsize(string);
				var reg2 	=	/^[0-9+]+$/; // add by viettd 2016/06/10
				if(!string.match(reg2)){
					$(this).val('');
				} else {
					$(this).val(string);
				}
			} catch (e) {
				alert(e.message);
			}
		});
		//-----------PHONE with minus-------------
		//blur event
		$(this).find('input.tel-haifun:enabled').blur(function(){
			try {
				var string 	=	$(this).val();
					string = formatConvertHalfsize(string);
				var reg2 	=	/^[0-9-+]+$/;
				if(!string.match(reg2)){
					$(this).val('');
				} else {
					$(this).val(string);
				}
			} catch (e) {
				alert(e.message);
			}
		});

		//-----------ZIPCODE-------------
		// blur
		$(this).find('input.zip_cd:enabled').blur(function(){
			var string = $(this).val();

			if (!_validateZipCd($(this).val())) {
				$(this).val('');
			}
		});
		// focus
		$(this).find('input.zip_cd:enabled').focus(function(){
			var zip_cd = $(this).val();
			$(this).val(zip_cd.replace(/[-]/gi,''));
			$(this).select();
		});
		//-----------KATAKANA-------------
		// blur katakana
		$(this).find('input.katakana:enabled').blur(function(){
			var string = $(this).val();
			if (_validateFullSize(string)) {
				$(this).val('');
			}
		});
		// blur fullsize
		$(this).find('input.fullsize:enabled').blur(function(){
			var string = $(this).val();
			if (!_validateFullSize(string)) {
				$(this).val('');
			}
		});
		// blur alphabetkatakana
		$(this).find('input.alphabetkatakana:enabled').blur(function(){
			var string = $(this).val();
			if (!_validateHalfSizeAlphabet(string)) {
				$(this).val('');
			}
		});
		$(document).on('blur', 'input.halfsize-numberic:enabled', function(){
			if(!_validateHalfSizeAlphanumeric($(this).val())){
				$(this).val('');
			}
		});
		//-----------TIME-------------
		$(this).find('input.time:enabled').blur(function(){
			var string = padZeroLeft($(this).val(), 4);
			var reg1 = /^(([0-1][0-9])|(2[0-3])):[0-5][0-9]|[2][4]:[0][0]$/;
			var reg2 = /^(([0-1][0-9])|(2[0-3]))[0-5][0-9]|[2][4][0][0]$/;
			var reg3 = /^[2][4][0][0]$/;
			if (string.match(reg1)) {
				$(this).val(string);
			}else if (string.length > 4) { // add by vietdt 2022/02/09
				$(this).val('');
			}else if (string.match(reg2)) {
				$(this).val(
						string.substring(0, 2) + ':'
								+ string.substring(2));
			} else {
				$(this).val('');
			}
			if (!_validateTime($(this).val())) {
				$(this).val('');
			}
		});
		//-----------TIME25-------------
		// input blur time25
		$(this).find('input.time25:enabled').blur(function(){
			var string 		= $(this).val();
			var maxlength 	= 4;
			if(typeof $(this).attr('maxLength') !== typeof undefined){
				maxlength = $(this).attr('maxLength');
			}
			// check number
			if(string.indexOf(':') > -1){
				string = string.replace(/:/g,'');
			}
			// check number
			if(!_validateNumber(string)){
				$(this).val('');
			}
			string = padZeroLeft(string, maxlength);
			var len = string.length;
			// check time25
			var reg = /^([0-9]{0,})[0-5][0-9]$/;
			if (string.match(reg)) {
				$(this).val(parseInt(string.substring(0, maxlength - 2)) + ':'+ string.slice(-2,maxlength));
			}else{
				$(this).val('');
			}
			// if (string.match(reg1)) {
			if (!_validateTime25($(this).val())) {
				$(this).val('');
			}
		});
		$(this).find('input.time:enabled,input.time25:enabled').focus(function(){
			// $(this).val($(this).val().replace(/:/g, '')); // delete by vietdt 2022/02/09
			$(this).select();
		});
		//-----------EMAIL-------------
		$(this).find('input.email:enabled').blur(function(){
			if (!_validateEmail($(this).val())) {
				$(this).val('');
			}
		});
		//-----------MMDD-------------
		$(this).find('input.mmdd:enabled').blur(function(){
			var str = $(this).val();
			str = formatConvertHalfsize(str);
			$(this).val(_validateMMDD(str));
			var mmdd  = $(this).val();
			if(mmdd){
				var yyyymmdd	 = 	'1990/'+mmdd;
				if (!_validateYyyyMmDd(yyyymmdd)) {
					$(this).val('');
					$(this).closest('.input-group').find('input.yyyymmdd').val('');
				}else{
					$(this).closest('.input-group').find('input.yyyymmdd').val(yyyymmdd);
				}
			}else{
				$(this).closest('.input-group').find('input.yyyymmdd').val('');
			}
		});
		// input method for blur datepicker
		$(this).find('input.mmdd:enabled').focus(function(){
			var string = $(this).val();
			var reg = /^[0-9]{2}[\/.][0-9]{2}$/;
			if (string.match(reg)) {
				$(this).val(string.replace(/\D/g, ''));
				$(this).attr('old', string.replace(/\D/g, ''));
			}
			$(this).select();
		});
		$(this).find('input.Convert-Halfsize:enabled').blur(function(){
			var _this 	=	$(this);
			var str 	= 	_this.val();
			str = formatConvertHalfsize(str);
			_this.val(str);
		});
		return this;
	}
	//
	Number.prototype.formatN = function(n, x) {
		var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
		return this.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&,');
	};
	/**
	 * _isNormalInteger
	 *
	 * @author : longvv - 2018/11/19 - create
	 * @param :
	 *            string
	 * @returns : {Boolean}
	 */
	function _isNormalInteger(string) {
		var regexp = /^\+?(0|[1-9]\d*)$/;
    	if (regexp.test(string) || string == '') {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * _validateNumber
	 *
	 * @author : biennv - 2015/04/17 - create
	 * @param :
	 *            string
	 * @returns : {Boolean}
	 */
	function _validateNumber(string) {
		try {
			var regexp = /^-*[0-9]+$/;
			if (regexp.test(string) || string == '') {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			alert(e.message);
		}
	}
	/**
	 * validate zip code
	 *
	 * @param string
	 * @returns {boolean}
	 */
	function _validateZipCd(zip_cd) {
		try {
			zip_cd = _formatString(zip_cd);
			var reg1 = /^[0-9]{3}-[0-9]{4}$/;
			var reg2 = /^[0-9]{3}[0-9]{4}$/;
			//
			if (zip_cd.match(reg1) || zip_cd.match(reg2) || zip_cd == '') {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			alert('_validateZipCd: ' + e);
		}
	}
	/**
	 * check full size
	 *
	 * @param string
	 * @returns {boolean}
	 */
	function _validateFullSize(string) {
		try {
			// string = $.rtrim(string);
			string = $.mbRTrim(string);
			if ($.byteLength(string) != string.length) {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			alert('_validateFullSize: ' + e);
		}
	}
	/**
	 * Check halfsize alphabet
	 *
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateHalfSizeAlphabet(string) {
		// string = _formatString(string);
		var regexp = /^[a-zA-Z]+$/;
		if (regexp.test(string) || string == '') {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Check halfsize alphanumeric
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateHalfSizeAlphanumeric(string){
	//	string = _formatString(string);
		var regexp = /^[a-zA-Z0-9]+$/;
		if(regexp.test(string)||string == ''){
			return true;
		}else{
			return false;
		}
	}
	/**
	 * Check Time
	 *
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateTime(string) {
		string = _formatString(string);
		var reg = /^(([0-1][0-9])|(2[0-3])):[0-5][0-9]|[2][4]:[0][0]$/;
		if (string.match(reg) || string == '') {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Check Time
	 *
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateTime25(string) {
		var string = _formatString(string);
		var reg = /^([0-9]{0,}):[0-5][0-9]$/;
		if (string.match(reg) || string == '') {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Check Date
	 *
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateYyyyMmDd(string) {
		if (string == '') {
			return true;
		}
		// alert(string);
		if (string.length == 8) {
			string = string.substring(0, 4) + '/' + string.substring(4, 6) + '/'
					+ string.substring(6);
		}
		string = _formatString(string);

		var reg = /^((19|[2-9][0-9])[0-9]{2})[\/.](0[13578]|1[02])[\/.]31|((19|[2-9][0-9])[0-9]{2}[\/.](01|0[3-9]|1[0-2])[\/.](29|30))|((19|[2-9][0-9])[0-9]{2}[\/.](0[1-9]|1[0-2])[\/.](0[1-9]|1[0-9]|2[0-8]))|((((19|[2-9][0-9])(04|08|[2468][048]|[13579][26]))|2000)[\/.](02)[\/.]29)$/;

		if (string.match(reg)) {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Check Date
	 *
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateYyyyMm(string) {
		if (string == '') {
			return true;
		}
		if (string.length == 6) {
			string = string.substring(0, 4) + '/' + string.substring(4);
		}
		string = _formatString(string);
		var reg = /^((1[0-9]|[2-9][0-9])[0-9]{2})[\/.](0[1-9]|1[0-2])$/;
		if (string.match(reg)) {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Convert Full-width to Half-width Characters
	 *
	 * @param string
	 * @returns string
	 */
	function _formatString(string) {
		try {
			if(typeof $.textFormat ==='function')
			{
				string = $.textFormat(string, '9');
				string = $.textFormat(string, '@');
				string = $.textFormat(string, 'a');
				string = $.textFormat(string, 'A');
				return string;
			} else {
				return string;
			}

		} catch (e) {
			alert('_formatString: ' + e);
		}
	}
	/**
	 * Check Email Address
	 *
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateEmail(string) {
		// string = _formatString(string);
		var regexp = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
		if (regexp.test(string) || string == '') {
			return true;
		} else {
			return false;
		}
	}
	/**
	 * check date is fomart MMDD
	 *
	 * @param string
	 * @returns {Boolean}
	 */
	function _validateMMDD(string) {
		var reg1 = /^[0-9]{4}$/;
		var reg2 = /^[0-9]{2}[\/.][0-9]{2}$/;
		if (string.match(reg1)) {
			var mm = parseInt(string.substring(0, 2));
			var dd = parseInt(string.substring(2));
			if((mm == 2 && dd > 29) || (dd < 1) || (mm < 1) || (mm > 12) || (dd > 31) || ((mm==4 || mm==6 || mm==9 || mm==11) && dd >=31)) {
				return null;
			}
			return string.substring(0, 2) + '/' + string.substring(2);
		} else if (string.match(reg2)) {
			var mm = parseInt(string.substring(0, 2));
			var dd = parseInt(string.substring(3));
			if((mm == 2 && dd > 29) || (dd < 1) || (mm < 1) || (mm > 12)) {
				return null;
			}
			return string;
		} else {
			return null;
		}
	}
	/**
		 * set_limit_date_month
		 *
		 * @author : viettd - 2015/10/02 - create
		 * @author :
		 * @param :
		 *            date
		 * @return : date
		 * @access : public
		 * @see : set limit date ( 1900/01/01 -> 9999/12/31 )
		 */
		function set_limit_date_month(date) {
			try {
				if (date == '') {
					return '';
				}
				var date_value = parseInt((date + "/01").replace('/', '').replace('/',
						''));
				if (date_value < 19000101 || date_value > 99991231) {
					return '';
				}
				return date;
			} catch (e) {
				alert('set_limit_date_month' + e.message);
			}
		}
		/**
		 * set_limit_date
		 *
		 * @author : viettd - 2015/10/02 - create
		 * @author :
		 * @return : null
		 * @access : public
		 * @see : set limit date ( 1900/01/01 -> 9999/12/31 )
		 */
		function set_limit_date(date) {
			try {
				if (date == '') {
					return '';
				}
				var date_value = parseInt((date).replace('/', '').replace('/', ''));
				if (date_value < 19000101 || date_value > 99991231) {
					return '';
				}
				return date;
			} catch (e) {
				alert('set_limit_date' + e.message);
			}
		}
	/**
	 * formatMoney
	 *
	 * @author : longvv - 2018/07/17 - create
	 * @author :
	 * @params : element
	 * @returns {Boolean}
	 * @access : public
	 */
	function formatMoney(event){
		var regexp = /^([0-9])+$/;
		var value = event.val().replace(/,/g, '');
		if (regexp.test(value) || value == '') {
			var maxlength = event.attr('maxlength');
			var result = '';
			var valueArray = value.split('');
			var resultArray = [];
			var counter = 0;
			var temp = '';
			for (var i = valueArray.length - 1; i >= 0; i--) {
				temp += valueArray[i];
				counter++
				if(counter == 3){
					resultArray.push(temp);
					counter = 0;
					temp = '';
				}
			};
			if(counter > 0){
				resultArray.push(temp);
			}
			for (var i = resultArray.length - 1; i >= 0; i--) {
				var resTemp = resultArray[i].split('');
				for (var j = resTemp.length - 1; j >= 0; j--) {
					result += resTemp[j];
				};
				if(i > 0){
					result += ','
				}
			};
			if(result.length > maxlength){
				result = result.substring(0, maxlength);
			}
			result = result.replace(/-,/g,'-');
			event.val(result);
		} else {
			var maxlength = event.attr('maxlength');
			if(value.length > (maxlength-2-(maxlength%3))){
				var result = value.substring(0, (maxlength-2-(maxlength%3)));
				event.val(result);
			}
		}
	}
	/**
	 * htmlEntities
	 *
	 * @author : viettd - 2015/10/02 - create
	 * @author :
	 * @params : null
	 * @return : null
	 * @access : public
	 * @see :
	 */
	function htmlEntities(str) {
		try {
			if (str == undefined) {
				str = '';
			}
			return str.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(
					/&gt;/g, '>').replace(/&quot;/g, '"');
		} catch (e) {
			alert('htmlEntities' + e.message);
		}
	}
	/**
	 * getParameterByName
	 *
	 * @author : viettd - 2015/11/13 - create
	 * @author :
	 * @params : null
	 * @return : null
	 * @access : public
	 * @see :
	 */
	function getParameterByName(name, url) {
		try {
			name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
			var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex
					.exec(url);
			return results === null ? "" : decodeURIComponent(results[1].replace(
					/\+/g, " "));
		} catch (e) {
			alert('getParameterByName' + e.message);
		}
	}
	/**
	 * priceFormat of function
	 *
	 * @author : KienNT - 2015/05/27 - create
	 * @param  : 999999
	 * @return : 999,999
	 */
	function priceFormat(val) {
		try {
			var rgx = /(\d+)(\d{3})/;
			str = val + '';
			while (rgx.test(str)) {
				str = str.replace(rgx, '$1' + ',' + '$2');
			}
			return (str);
		} catch (e) {
			alert('priceFormat: ' + e.message);
		}
	}
	/**
	 * unPriceFormat
	 *
	 * @author		:	viettd - 2016/02/17 - create
	 * @author		:
	 * @params		:	999,999
	 * @return		:	999999
	 * @access		:	public
	 * @see			:
	 */
	function unPriceFormat(val) {
		try {
			var res = 0;
			if(val != ''){
				res = val.replace(/,/g , '');
			}
			return (res);
		} catch (e) {
			alert('unPriceFormat: ' + e.message);
		}
	}
	/**
	 * padZeroLeft
	 *
	 * @author : viettd - 2015/10/02 - create
	 * @author :
	 * @param :
	 *            $data
	 * @param :
	 *            $max
	 * @return : null
	 * @access : public
	 * @see :
	 */
	function padZeroLeft($data, $max) {
		try {
			var length = $max - $data.length; // alert(length);
			var zero = '';
			if (length == $max) {
				return '';
			}
			for (var i = 0; i < length; i++) {
				zero = zero + '0';
			}
			return zero + $data;
		} catch (e) {
			alert('padZeroLeft' + e.message);
		}
	}
	/**
	 * getTimeHHMM
	 *
	 * @author		:	viettd - 2016/06/01 - create
	 * @author		:
	 * @params		:	time: HH:MM or HHMM ,mode: m,h
	 * @return		:	null
	 * @access		:	public
	 * @see			:
	 */
	function _getTimeHHMM(time,mode) {
		try {
			var timeTemp 	= '';
			var hh			= '';
			var mm			= '';
			// check time
			if(typeof (time) == 'undefined' || time == '' || time == 0){
				return 0;
			}
			// check mode
			if(mode != 'hh' && mode != 'mm'){
				return 0;
			}
			if(time.indexOf(':') != -1){
				timeTemp	= time.replace(':', '');
			}
			// get hh,mm
			hh 			= timeTemp.substr(0,2);
			mm 			= timeTemp.substr(2,2);
			if(mode == 'hh'){
				return parseInt(hh);
			}else if(mode == 'mm'){
				return parseInt(mm);
			}else{
				return 0;
			}
		} catch (e) {
			alert('_getTimeHHMM' + e.message);
		}
	}
	/**
	 * _sumTimeHHMM
	 *
	 * @author		:	viettd - 2016/06/07 - create
	 * @author		:
	 * @params		:	time1,time2,mode
	 * @return		:	null
	 * @access		:	public
	 * @see			:	mode = 0 HHMM , mode = 1 =>HH:MM
	 */
	function _sumTimeHHMM(time1, time2 , mode) {
		try {
			var time1_temp 		=  	0;
			var time2_temp 		=  	0;
			var h1				=	0;
			var h2				=	0;
			var h_total			=	0;
			var h_minute		=	0;
			var result 			=	'';
			if(time1.indexOf(':') != -1){
				time1	= time1.replace(':', '');
			}
			if(time2.indexOf(':') != -1){
				time2	= time2.replace(':', '');
			}
			//jQuery.fillByLength(target , maxLength , fillString , fillFlag)
			time1_temp = $.fillByLength(time1 , 4 , '0' , true) * 1;
			time2_temp = $.fillByLength(time2 , 4 , '0' , true) * 1;
			h1 = Math.floor(time1_temp/100) * 60 + time1_temp % 100;
			h2 = Math.floor(time2_temp/100) * 60 + time2_temp % 100;
			h_total 	= Math.floor((h1 + h2) / 60);
			h_minute 	= (h1 + h2) % 60;
			// check mode
			if(mode == 0){
				result =  $.fillByLength(h_total , 2 , '0' , true) +  $.fillByLength(h_minute , 2 , '0' , true);
			}else if(mode == 1){
				result =  $.fillByLength(h_total , 2 , '0' , true) +':' + $.fillByLength(h_minute , 2 , '0' , true);
			}else{
				result = '';
			}
			return result;
		} catch (e) {
			alert('_sumTimeHHMM' + e.message);
		}
	}

	/**
	 * Convert Full-width to Half-width Characters
	 *
	 * @param string
	 * @returns string
	 */
	function formatConvertHalfsize(string) {
	    try {
	        string = $.textFormat(string, '9');
	        string = $.textFormat(string, '@');
	        string = $.textFormat(string, 'a');
	        string = $.textFormat(string, 'A');
	        return string;
	    } catch (e) {
	        alert('_formatString: ' + e);
	    }
	}
		//
		//-----------MONEY-------------
		// keyup event
		$(document).on('compositionend', 'input.money', function (e) {
			try {
				window.getSelection().removeAllRanges();	
			} catch (e) {
				alert('.d-numeric:compositionstart ' + e.toString());
			}
		});
		var is_fullsize = false;
		$(document).on('compositionupdate', 'input.money', function (e) {
			try {
				is_fullsize = true;
			} catch (e) {
				alert('.d-numeric:compositionstart ' + e.toString());
			}
		});
		$(document).on('compositionstart', 'input.money', function (e) {
				$(this).val($(this).val().replace(/[，,]/g, ''))

		});
		$(document).on('compositionend', ' .numeric', function (e) {
			try {
				window.getSelection().removeAllRanges();	
			} catch (e) {
				alert('.d-numeric:compositionstart ' + e.toString());
			}
		});
		$(document).on('keyup','input.money:enabled', function (e) {
			try {
				if(is_fullsize == false) {
					formatMoney($(this))
				}
				
			} catch (e) {
				alert(e.message);
			}
		});
		// focus
		$(document).on('focus','input.money:enabled', function (e) {
			try {
				$(this).select();
				
			} catch (e) {
				alert(e.message);
			}
		});
		//blur event
		$(document).on('blur','input.money', function (e) {
			if(is_fullsize == true) {
				var val 	=	$(this).val();
				var maxlength = $(this).attr('maxlength');
				var regexp = /^[0-9\uFF10-\uFF19]+$/;
				if (regexp.test(val) || val == '') {
					$(this).val(val);
					var	string = formatConvertHalfsize(val);
					if(string.length > (maxlength-2-(maxlength%3))){
						var result = string.substring(0, (maxlength-2-(maxlength%3)));
						$(this).val(result.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					} else {
						$(this).val(string.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					}	
				} else {
					$(this).val('');
				}
			} 
			is_fullsize = false;
		});
})(jQuery);