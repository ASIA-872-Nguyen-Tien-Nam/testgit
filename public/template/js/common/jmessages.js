/*
|--------------------------------------------------------------------------
| Plugin messages  -  tannq@ans-asia.com - 2018
|--------------------------------------------------------------------------
|
| Show message action
|
*/
(function ($) {
    "use strict";
    var pluginName = "_jMessage";
    var pluginDataName = "plugin_" + pluginName;
    //CR 2022/08/10 viettd
    var cancelText                 = 'いいえ'
    var okText                     = 'はい'
    var notify_by_email            = 'メールで通知する'
    var popup_message              = 'メッセージ'
    var email_sent_successfully    = 'メールの送信が成功しました。'
    var cannot_send_mail           = 'メールアドレスが登録されていないため送信できません'
    var title_report               = '報告'
    var title_error                = 'エラー'
    if ($('#language_jmessages').val() == 'en') {
        cancelText         = 'No'
        okText             = 'Yes'
        notify_by_email    = 'Notify By Email'
        popup_message      = 'Message'
        email_sent_successfully  = 'Email sent successfully'
        cannot_send_mail         = 'Cannot send because the email address is not registered'
        title_report          = 'Report'
        title_error           = 'Error'
    }
    function _jMessage(element, options) {

        this._attachedEvents = [];
        this.element = element;
        this.$element = $(element);
        this.params = {
            target: false,
            title: '',
            content: '',
            employee_cd : '',
            mail_type: 0,
            target_employee_cd: '',
            code: null,
            array: (typeof _text !== 'undefined' && typeof _text !== null && typeof _text === 'object') ? _text : [],
            type: 'success',
            class: '',
            id: '',
            cancelText: cancelText,
            okText: okText,
            btnOk: true,
            btnCancel: true,
            trigger: true,
            okEvent: function () { },
            cancelEvent: function () { },
            notifyClosed: function () { },
            animated: 'fadeInRight', // fadeInRight ,fadeInLeft ,fadeInUp,fadeInDown
            place: 'right top',
            lifetime: -1,
            timeout: 1000,
            filterKeyCode: [119, 120, 113, 118, 115],
        };

        this.params = $.fn.extend(this.params, options);
        this.name = "jmessage_" + this.setName();

        this.$element.attr("data-jmessage", this.name);

        this.init();
    }

    $.fn[pluginName] = function (options, p) {
        var _this = this;
        _this.each(function () {
            if (!$.data(this, pluginDataName)) {
                $.data(this, pluginDataName, new _jMessage(this, options));
            } else {
                if (typeof ($.data(this, pluginDataName)[options]) === 'function') {
                    $.data(this, pluginDataName)[options](p);
                }
                if (options === 'destroy') {
                    delete $.data(this, pluginDataName);
                }
                if (typeof ($.data(this, pluginDataName)[options]) !== 'function' || options !== 'destroy') {
                    $.data(this, pluginDataName, new _jMessage(this, options));
                }
            }
        });
        return this;
    };

    _jMessage.prototype = {
        init: function () {
            var _this = this;
            _this.initTemplate();
            if (!_this.params.target) {
                _this.showJMessage()
            } else {
                _this._attachEvent($(_this.params.target), 'click', _this.showJMessage.bind(_this));
            }
            _this._attachEvent(_this.$jElement.find('.btn-ok'), 'click', _this.okClick.bind(_this));
            _this._attachEvent(_this.$jElement.find('.btn-cancel'), 'click', _this.cancelClick.bind(_this));
            _this._attachEvent($(document), 'keyup', _this.keyBoardUp.bind(_this));
            //  when type = mail
            _this._attachEvent(_this.$jElement.find('#popup_mail_checked'), 'click', _this.mailChecked.bind(_this));
        },
        initCode: function () {
            if (typeof this.params.array !== 'undefined' && typeof this.params.array !== null && typeof this.params.array === 'object' && this.params.code !== null) {
                var code = this.params.code;
                var message_typ = 1;

                if (typeof this.params.array[this.params.code] !== 'undefined' && typeof this.params.array[this.params.code].message_nm !== 'undefined' && typeof this.params.array[this.params.code].message_nm !== null) {
                    this.params.title = this.params.array[this.params.code].message_nm;
                } else {
                    $.error('Code: [' + this.params.code + '] does not exist on $this.params.array variable');
                }
                if (typeof this.params.array[this.params.code] !== 'undefined' && typeof this.params.array[this.params.code].message !== 'undefined' && typeof this.params.array[this.params.code].message !== null) {
                    // this.params.content = this.params.array[this.params.code].message;
                    this.params.content = this.params.array[this.params.code].message.replace("。", "。 <br>"); //longvv add 2018/08/22
                } else {
                    $.error('Code: [' + this.params.code + '] does not exist on $_text variable');
                }

                if (typeof this.params.array[this.params.code] !== 'undefined' && typeof this.params.array[this.params.code].message_typ !== 'undefined' && typeof this.params.array[this.params.code].message_typ !== null) {
                    message_typ = this.params.array[this.params.code].message_typ;
                    switch (message_typ) {
                        case '1':
                            this.params.type = 'confirm'

                            break;
                        case '2':
                            this.params.type = 'success'
                            this.params.btnCancel = false
                            break;
                        case '4':
                            this.params.type = 'danger'
                            this.params.btnCancel = false
                            break;
                        default:
                            this.params.type = 'warning'
                            break;
                    }
                } else {
                    $.error('Code: [' + this.params.code + '] does not exist on $this.params.array variable');
                }
            }
        },
        initButton: function () {
            var btnOk = this.params.btnOk ? '<button type="button" class="btn btn-secondary btn-ok" data-dismiss="modal">' + this.params.okText + '</button>' : '';
            var btnCancel = this.params.btnCancel ? '<button type="button" class="btn btn-except btn-cancel">' + this.params.cancelText + '</button>' : '';
            return btnOk + btnCancel;
        },
        initNotify: function () {
            this.template = '<div class="alert alert-dismissible in ' + this.params.animated + ' animated ' + this.params.place + ' ' + this.params.class + ' " id="' + this.name + '">';
            this.template += '<button type="button" class="close btn-cancel">';
            this.template += '<span aria-hidden="true">×</span>';
            this.template += '</button>';
            this.template += '<strong>' + this.params.title + '</strong> ' + this.params.content + '';
            this.template += '</div>';
        },
        initAlert: function () {
            // this.initCode();
            var mConfirm = '<div class="m-icon m-confirm" style="display: block;">?</div>';
            var mSuccess = '<div class="m-icon m-success" style="display: block;"><span class="m-success-line-tip m-animate-success-line-tip"></span><span class="m-success-line-long m-animate-success-line-long"></span></div>';
            var mWarning = '<div class="m-icon m-warning" style="display: block;">!</div>';
            var mDanger = '<div class="m-icon m-danger" style="display: block;"><span class="m-x-mark-line-left"></span><span class="m-x-mark-line-right"></span></div>';
            var mMail = '<div class="m-icon m-success" style="display: block;"><span class="m-success-line-tip m-animate-success-line-tip"></span><span class="m-success-line-long m-animate-success-line-long"></span></div>';
            var ic = mConfirm;
            var mailContent = '';
            mailContent += '<div class="modal-mail">';
            mailContent += '    <div class="form-group">';
            mailContent += '        <div class="checkbox">';
            mailContent += '            <div class="md-checkbox-v2 inline-block">';
            mailContent += '                <input name="popup_mail_checked" id="popup_mail_checked" type="checkbox" value="0">';
            mailContent += '                <label for="popup_mail_checked">'+notify_by_email+'</label>';
            mailContent += '            </div>';
            mailContent += '        </div>';
            mailContent += '    </div>';
            mailContent += '    <div class="form-group">';
            mailContent += '        <label class="control-label">'+popup_message+'</label>';
            mailContent += '        <span class="num-length">';
            mailContent += '            <textarea class="form-control" cols="30" rows="4" maxlength="500" disabled id="popup_mail_body"></textarea>';
            mailContent += '        </span>';
            mailContent += '    </div>';
            mailContent += '</div>';
            var option = '';
            switch (this.params.type) {
                case 'danger':
                    ic = mDanger;
                    break;
                case 'warning':
                    ic = mWarning;
                    break;
                case 'confirm':
                    ic = mConfirm;
                    break;
                case 'mail':
                    ic = mMail;
                    option = mailContent;
                    break;
                default:
                    ic = mSuccess;
                    break;
            }
            this.template = '<div class="modal m-wrap in show" tabindex="-1" id="' + this.name + '">';
            this.template += '<div class="modal-dialog m-show ' + this.params.class + '">';
            this.template += '<div class="modal-content">';
            this.template += '<div class="modal-header">';
            this.template += ic;
            this.template += '</div>';
            this.template += '<div class="modal-body">';
            this.template += '<h4 id="confirm_popup_title">' + this.params.title + '</h4>';
            this.template += '<p id="confirm_popup_body">' + this.params.content + '</p>';
            this.template += '</div>';
            this.template += option;
            this.template += '<div class="modal-footer justify-content-md-center">';
            this.template += this.initButton()
            this.template += '</div>';
            this.template += '</div>';
            this.template += '</div>';
            this.template += '</div>';
        },
        initTemplate: function () {
            this.initCode();
            $('body').find('.m-wrap').remove();
            $('[data-jmessage=' + this.name + ']').removeAttr('data-jmessage');
            switch (this.params.type) {
                case 'danger':
                case 'warning':
                case 'confirm':
                case 'success':
                case 'mail':
                    this.params.class = 'm-' + this.params.type;
                    this.initAlert();
                    break;
                case 'notify':
                    this.params.class = 'japp-alert';
                    this.initNotify();
                    break;
                case 'paceloader':
                    this.params.class = 'japp-alert';
                    this.initPaceloader();
                default:
                    this.params.class = 'm-success';
                    break;
            }

            if ($('body').find("#" + this.name).length <= 0) {
                $('body').append(this.template);

                if (this)
                    this.jElement = $('body').find("#" + this.name);
                this.$jElement = $("#" + this.name);
                $('.textbox-error').remove();
                $('.form-control.boder-error').removeClass('boder-error');
            }
        },
        autoHideNotify: function () {
            var _this = this;
            if (_this.params.type === 'notify' && _this.params.lifetime != -1) {
                setTimeout(function () {
                    _this.hideJMessage();
                    _this.params.notifyClosed(_this);
                }, _this.params.lifetime);
            }
        },
        showJMessage: function () {
            var _this = this;
            $.when(_this.$jElement.show()).then(function () {
                $('body').addClass('has-jmessage');
                _this.autoHideNotify();
                var code = _this.params.code;
                if (_this.$jElement.find('.btn').length > 0) {
                    if (code == 3) _this.$jElement.find('.btn:last').focus(); // cancel button
                    else _this.$jElement.find('.btn:first').focus();
                }
            });
        },
        hideJMessage: function () {
            var _this = this;
            $.when($('body').removeClass('has-jmessage')).then(function () {
                if (_this.params.type === 'notify') {
                    _this.$jElement.hide("slide", { direction: "right" }, 300);
                } else {
                    _this.$jElement.hide();
                }
            });
        },
        mailChecked: function(){
            // checked
            if (this.$jElement.find('#popup_mail_checked').prop('checked')) {
                this.$jElement.find('#popup_mail_body').attr('disabled',false);
            }else{
            // unchecked
                this.$jElement.find('#popup_mail_body').attr('disabled',true);
            }
        },
        okClick: function () {
            // when type = mail when send mail
            var _this = this;
            var chk = this.$jElement.find('#popup_mail_checked').prop('checked');
            var mail_message = this.$jElement.find('#popup_mail_body').val();
            if (_this.params.type == 'mail' && chk) {
                var employee_cd = _this.params.employee_cd;
                var mail_type = _this.params.mail_type;
                var target_employee_cd = _this.params.target_employee_cd;
                $.ajax({
                    type        :   'post',
                    url         :   '/common/sendmailpopup',
                    dataType    :   'json',
                    loading     :   true,
                    data 		: 	{
                        employee_cd : employee_cd
                    ,   mail_message : mail_message
                    ,   mail_type : mail_type
                    ,   target_employee_cd : target_employee_cd
                    },
                    success: function(res){
                        switch (res['status']) {
                            case OK:
                                _this.hideJMessage();
                                jSuccess(title_report,email_sent_successfully,function (r) {
                                    if (r) {
                                        _this.params.okEvent(_this);                                        
                                    }
                                });
                                break;
                            case NG: 
                                _this.hideJMessage();
                                jError(title_error,cannot_send_mail,function(r){
                                    parent.location.reload();
                                    $('#btn-close-popup').trigger('click');
                                });
                                break;
                            case EX:
                                _this.hideJMessage();
                                // jError(res['Exception']);
                                jMessage(81,function(r){
                                    parent.location.reload();
                                    $('#btn-close-popup').trigger('click');
                                });	
                                break;
                            default:
                                break;
                        }
                    }
                });            
            }else{
                _this.params.okEvent(_this);
                _this.hideJMessage();    
            }
        },
        cancelClick: function () {
            this.params.cancelEvent(this);
            this.hideJMessage();
        },
        destroy: function () {
            this._detachEvents();
            this.$jElement.remove();
        },
        hasJMessage: function () {
            return $('[data-jmessage=' + this.name + ']').hasClass('has-jmessage');
        },
        keyBoardUp: function (e) {
            if (typeof e !== 'undefined' && typeof e.keyCode !== 'undefined') {
                if (e.keyCode == 27) {
                    this.hideJMessage();
                }
                if (this.params.filterKeyCode.indexOf(e.keyCode) != -1 && this.hasJMessage()) {
                    e.preventDefault()
                }
            }
        },
        _attachEvent: function (el, ev, fn) {
            if ($(el).length > 0) {
                el.on(ev, null, null, fn);
                this._attachedEvents.push([el, ev, fn]);
            }
        },
        _detachEvents: function () {
            for (var i = this._attachedEvents.length - 1; i >= 0; i--) {
                this._attachedEvents[i][0].off(this._attachedEvents[i][1], this._attachedEvents[i][2]);
                this._attachedEvents.splice(i, 1);
            }
        },
        setName: function () {
            var text = "";
            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            for (var i = 0; i < 5; i++) {
                text += possible.charAt(Math.floor(Math.random() * possible.length));
            }
            return text;
        }
    };
})($);

if (typeof jMessage === 'undefined') {
    function jMessage(code, callback, options) {
        var configs = {
            okEvent: callback,
            code: code,
            // type:'success',
            // btnCancel:false,
            // array:_text,
        };
        $.extend(configs, options);
        $('body')._jMessage(configs);
    }
}

if (typeof jError === 'undefined') {
    function jError(title, content, callback) {
        var configs = {
            okEvent: callback,
            title: title,
            content: content,
            // btnOk:false, fix is common 20180913
            btnCancel: false,
            type: 'danger',
            el: 'body',
        };
        $('body')._jMessage(configs);
    }
}

if (typeof jConfirm === 'undefined') {
    function jConfirm(title, content, callback) {
        var configs = {
            okEvent: callback,
            title: title,
            content: content,
            type: 'confirm',
            el: 'body',
        };
        $('body')._jMessage(configs);
    }
}

if (typeof jWarning === 'undefined') {
    function jWarning(title, content, callback) {
        var configs = {
            okEvent: callback,
            title: title,
            content: content,
            type: 'warning',
        };
        $('body')._jMessage(configs);
    }
}

if (typeof jSuccess === 'undefined') {
    function jSuccess(title, content, callback) {
        var configs = {
            // target:".btn-outline-primary",
            okEvent: callback,
            title: title,
            content: content,
            type: 'success',
            btnCancel: false,
        };
        $('body')._jMessage(configs);
    }
}

if (typeof jTooltip === 'undefined') {
    function jTooltip(title, content, callback) {
        var configs = {
            // target:".btn-outline-primary",
            notifyClosed: callback,
            title: title,
            content: content,
            type: 'notify',
            btnCancel: false,
            lifetime: 1000,
        };
        $('body')._jMessage(configs);
    }
}

// add by viettd 2021/11/30
if (typeof jMail === 'undefined') {
    function jMail(title, content,employee_cd,mail_type = 0, target_employee_cd = '',callback) {
        var configs = {
            okEvent: callback,
            title: title,
            content: content,
            employee_cd: employee_cd,
            mail_type: mail_type,
            target_employee_cd: target_employee_cd,
            type: 'mail',
            btnCancel: false,
        };
        $('body')._jMessage(configs);
    }
}