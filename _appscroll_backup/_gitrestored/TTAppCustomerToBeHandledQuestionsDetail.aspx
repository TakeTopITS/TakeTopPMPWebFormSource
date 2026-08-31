<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppCustomerToBeHandledQuestionsDetail.aspx.cs" Inherits="TTAppCustomerToBeHandledQuestionsDetail_aspx" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />
<meta name="format-detection" content="telephone=yes">

<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>

    <script src="js/exif.js" type="text/javascript"></script>
    <style type="text/css">
        /* 锟睫革拷锟斤拷锟斤拷选锟斤拷锟斤拷锟斤拷式 */
        .ajax__calendar_container {
            z-index: 10000 !important;
            position: fixed !important;
        }

        /* 确锟斤拷锟斤拷锟斤拷锟节碉拷锟斤拷锟斤拷锟斤拷确锟斤拷示 */
        #popDetailWindow .ajax__calendar_container {
            position: absolute !important;
        }

        /* 锟斤拷锟斤拷锟斤拷锟斤拷锟节碉拷锟斤拷锟斤拷虿季锟?*/
        .popup-input-group {
            position: relative;
            width: 100%;
        }

            .popup-input-group input[type="text"] {
                width: 100%;
                box-sizing: border-box;
            }

        /* 锟斤拷锟斤拷锟斤拷钮锟斤拷式 */
        .calendar-button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: url('ImagesSkin/calendar.png') no-repeat center;
            background-size: 16px 16px;
            width: 20px;
            height: 20px;
            border: none;
            cursor: pointer;
            z-index: 2;
        }
    </style>
    <script type="text/javascript" language="javascript">

        //页锟斤拷锟斤拷锟斤拷锟斤拷,ajax锟截凤拷锟斤拷锟斤拷锟斤拷珊锟街达拷械牟锟斤拷锟斤拷锟斤拷锟斤拷锟揭伙拷锟絝untion
        //$load锟斤拷锟斤拷示锟斤拷
        //$load(function () {
        //    //锟斤拷要页锟斤拷锟斤拷锟斤拷锟斤拷执锟叫的达拷锟斤拷
        //});
        var $load = function (loadFunc) {
            $(function () {
                initSwipeBack();// 锟斤拷始锟斤拷锟斤拷锟斤拷锟斤拷锟截癸拷锟斤拷
                if (typeof (Sys) != 'undefined') {
                    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(loadFunc);
                }
                else {
                    loadFunc();
                }
            });
        };

        $load(function () {
            /*  if (top.location != self.location) { } else { CloseWebPage(); }*/

            //选锟斤拷图片锟斤拷压锟斤拷图片
            $("#AttachFile").change(function () {

                //console.log(this.files[0]);
                var _ua = window.navigator.userAgent;
                var _simpleFile = this.files[0];
                //锟叫讹拷锟角凤拷为图片
                if (!/\/(?:jpeg|png|gif|png|bmp)/i.test(_simpleFile.type)) return;

                //锟斤拷锟絜xif.js锟斤拷取ios图片锟侥凤拷锟斤拷锟斤拷息
                var _orientation;
                //if (_ua.indexOf('iphone') > 0) {
                EXIF.getData(_simpleFile, function () {
                    _orientation = EXIF.getTag(this, 'Orientation');
                });
                //}



                //1.锟斤拷取锟侥硷拷锟斤拷通锟斤拷FileReader锟斤拷锟斤拷图片锟侥硷拷转锟斤拷为DataURL锟斤拷锟斤拷data:img/png;base64锟斤拷锟斤拷头锟斤拷url锟斤拷锟斤拷锟斤拷直锟接凤拷锟斤拷image.src锟斤拷;
                var _reader = new FileReader(),
                    _img = new Image(),
                    _url;

                _reader.onload = function () {
                    _img.onload = function () {
                        var data = compress(_img);
                        $("#imgData").val(compress(_img, _orientation));
                    };
                    _url = this.result;
                    _img.src = _url;
                };
                _reader.readAsDataURL(_simpleFile);
            });

            // 锟睫革拷锟斤拷锟斤拷锟截硷拷锟斤拷锟斤拷示
            fixCalendarPosition();

            // 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷示锟铰硷拷
            $(document).on('click', '[onclientclick*="popShow"]', function () {
                setTimeout(fixCalendarPosition, 100);
            });

        });

        // 锟睫革拷锟斤拷锟斤拷锟截硷拷位锟斤拷
        function fixCalendarPosition() {
            // 锟揭碉拷锟斤拷锟斤拷锟叫碉拷锟斤拷锟斤拷锟斤拷锟斤拷锟?
            var dateInput = $('#popDetailWindow').find('input[id*="DLC_NextServiceTime"]');
            if (dateInput.length > 0) {
                // 锟揭碉拷锟斤拷锟斤拷锟斤拷锟斤拷
                var calendarContainer = $('.ajax__calendar_container');
                if (calendarContainer.length > 0) {
                    // 确锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷诘锟斤拷锟斤拷锟轿?
                    calendarContainer.css({
                        'position': 'absolute',
                        'z-index': '10001'
                    });

                    // 锟斤拷锟铰讹拷位锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷蚋浇锟?
                    var inputOffset = dateInput.offset();
                    var inputWidth = dateInput.outerWidth();

                    calendarContainer.css({
                        'left': inputOffset.left + 'px',
                        'top': (inputOffset.top + dateInput.outerHeight()) + 'px'
                    });
                }
            }
        }



        /**
         * 锟斤拷锟斤拷图片锟侥尺寸，锟斤拷锟捷尺达拷压锟斤拷
         * 1. iphone锟街伙拷html5锟较达拷图片锟斤拷锟斤拷锟斤拷锟解，锟斤拷锟斤拷exif.js
         * 2. 锟斤拷卓UC锟斤拷锟斤拷锟斤拷锟街э拷锟?new Blob()锟斤拷使锟斤拷BlobBuilder
         * @param {Object} _img     图片
         * @param {Number} _orientation 锟斤拷片锟斤拷息
         * @return {String}       压锟斤拷锟斤拷base64锟斤拷式锟斤拷图片
         */
        function compress(_img, _orientation) {
            //2.锟斤拷锟斤拷锟斤拷锟侥匡拷锟竭达拷锟斤拷锟街碉拷锟斤拷锟斤拷洗锟酵计拷目锟斤拷叨锟斤拷锟斤拷锟侥匡拷锟酵硷拷锟斤拷锟侥匡拷锟酵硷拷缺锟窖癸拷锟斤拷锟斤拷锟斤拷锟斤拷一锟斤拷小锟节ｏ拷锟斤拷锟较达拷图片锟饺比放达拷
            var _goalWidth = 640,         //目锟斤拷锟斤拷锟?
                _goalHeight = 480,         //目锟斤拷叨锟?
                _imgWidth = _img.naturalWidth,   //图片锟斤拷锟斤拷
                _imgHeight = _img.naturalHeight,  //图片锟竭讹拷
                _tempWidth = _imgWidth,      //锟脚达拷锟斤拷锟叫★拷锟斤拷锟斤拷时锟斤拷锟斤拷
                _tempHeight = _imgHeight,     //锟脚达拷锟斤拷锟叫★拷锟斤拷锟斤拷时锟斤拷锟斤拷
                _r = 0;              //压锟斤拷锟斤拷

            if (_imgWidth > _goalWidth || _imgHeight > _goalHeight) {//锟斤拷锟斤拷叽锟斤拷锟侥匡拷锟酵硷拷锟斤拷锟饺憋拷压锟斤拷
                _r = _imgWidth / _goalWidth;
                if (_imgHeight / _goalHeight < _r) {
                    _r = _imgHeight / _goalHeight;
                }
                _tempWidth = Math.ceil(_imgWidth / _r);
                _tempHeight = Math.ceil(_imgHeight / _r);
            }

            //3.锟斤拷锟斤拷canvas锟斤拷图片锟斤拷锟叫裁硷拷锟斤拷锟饺比放达拷锟斤拷锟叫★拷锟斤拷锟叫撅拷锟叫裁硷拷
            var _canvas = $("#myCanvas")[0];

            var _context = _canvas.getContext('2d');
            _canvas.width = _tempWidth;
            _canvas.height = _tempHeight;
            var _degree;

            //ios bug锟斤拷iphone锟街伙拷锟较匡拷锟杰伙拷锟斤拷锟斤拷图片锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟?
            switch (_orientation) {
                //iphone锟斤拷锟斤拷锟斤拷锟姐，锟斤拷时home锟斤拷锟斤拷锟斤拷锟?
                case 3:
                    _degree = 180;
                    _tempWidth = -_imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone锟斤拷锟斤拷锟斤拷锟姐，锟斤拷时home锟斤拷锟斤拷锟铰凤拷(锟斤拷锟斤拷锟斤拷锟街伙拷锟侥凤拷锟斤拷)
                case 6:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 90;
                    _tempWidth = _imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone锟斤拷锟斤拷锟斤拷锟姐，锟斤拷时home锟斤拷锟斤拷锟较凤拷
                case 8:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 270;
                    _tempWidth = -_imgWidth;
                    _tempHeight = _imgHeight;
                    break;
            }
            //if (window.navigator.userAgent.indexOf('iphone') > 0 && !!_degree) {
            if (!!_degree) {
                _context.rotate(_degree * Math.PI / 180);
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            } else {
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            }
            //toDataURL锟斤拷锟斤拷锟斤拷锟斤拷锟皆伙拷取锟斤拷式为"data:image/png;base64,***"锟斤拷base64图片锟斤拷息锟斤拷
            var _data = _canvas.toDataURL('image/jpeg');
            return _data;
        }

        function upload() {

            $.ajax({
                //锟结交锟斤拷锟捷碉拷锟斤拷锟斤拷 POST GET
                type: "POST",
                //锟结交锟斤拷锟斤拷址
                url: "Handler/UploadPhotoToServerSite.ashx",
                //锟结交锟斤拷锟斤拷锟斤拷
                data: { FileData: $("#imgData").val(), FileName: $("#AttachFile").val() },
                //锟斤拷锟斤拷锟斤拷锟捷的革拷式
                //锟斤拷锟斤拷锟斤拷之前锟斤拷锟矫的猴拷锟斤拷
                beforeSend: function () {
                    $("#IMG_Waiting").show();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                },
                //锟缴癸拷锟斤拷锟斤拷之锟斤拷锟斤拷玫暮锟斤拷锟?            
                success: function (data) {

                    if (data.indexOf("img") > 0) {

                        $(document.getElementsByTagName("iframe")[1]).contents().find("body").append(data);
                    }
                    else {
                        alert(data);
                    }
                },
                //锟斤拷锟斤拷执锟叫猴拷锟斤拷玫暮锟斤拷锟?
                complete: function (XMLHttpRequest, textStatus) {
                    $("#IMG_Waiting").hide();
                }
            });
        }

        // 锟斤拷锟斤拷锟斤拷锟狡猴拷锟斤拷
        function popShow() {
            var popWindow = document.getElementById('popDetailWindow');
            var popShade = document.getElementById('popwindow_shade');
            if (popWindow && popShade) {
                popWindow.style.display = 'block';
                popShade.style.display = 'block';
                // 锟斤拷锟斤拷锟斤拷示
                var windowHeight = window.innerHeight || document.documentElement.clientHeight;
                var popHeight = popWindow.offsetHeight;
                var top = (windowHeight - popHeight) / 2;
                if (top < 0) top = 0;
                popWindow.style.top = top + 'px';

                // 锟斤拷锟矫斤拷锟姐到锟斤拷一锟斤拷锟斤拷锟斤拷锟?
                setTimeout(function () {
                    var firstInput = popWindow.querySelector('input, select, textarea');
                    if (firstInput) {
                        firstInput.focus();
                    }
                }, 100);
            }
        }

        function popClose() {
            var popWindow = document.getElementById('popDetailWindow');
            var popShade = document.getElementById('popwindow_shade');
            if (popWindow && popShade) {
                popWindow.style.display = 'none';
                popShade.style.display = 'none';
            }
            return false;
        }

        // 锟斤拷锟斤拷页锟斤拷锟斤拷锟铰硷拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷獠匡拷乇锟?
        document.addEventListener('click', function (e) {
            var popWindow = document.getElementById('popDetailWindow');
            var popShade = document.getElementById('popwindow_shade');

            if (popWindow && popWindow.style.display === 'block' &&
                popShade && e.target === popShade) {
                popClose();
            }
        });

        // 锟斤拷锟接硷拷锟斤拷锟铰硷拷锟斤拷锟斤拷ESC锟斤拷锟截闭碉拷锟斤拷
        document.addEventListener('keydown', function (e) {
            if (e.keyCode === 27) { // ESC锟斤拷
                popClose();
            }
        });
    </script>
</head>
<body class="napbac" data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    <!-- 锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷 -->
    <canvas id="myCanvas" style="display: none;"></canvas>

    <div class="mobile-container">
        <form id="form1" runat="server" class="napf">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                <div id="appScroll" class="app-scroll">

                    <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                        <tr>
                            <td colspan="2" height="31" class="page_topbj">
                                <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <img src="ImagesSkin/return.png" alt="" />
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                            <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5"></td>
                                                    </tr>
                                                </table>
                                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="锟斤拷锟皆候，达拷锟斤拷锟斤拷..." style="display: none;" />
                                            </a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <div class="napbac">
                        <!-- 锟斤拷锟斤拷锟斤拷锟斤拷锟较?-->
                        <div class="napbox">

                            <div class="npbxs">
                                <div class="mline">
                                    <div style="display: flex; margin-bottom: 5px;">
                                        <div style="width: 120px;">
                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XuQiuMingCheng%>"></asp:Label>:
                                        </div>
                                        <div>
                                            <asp:Label ID="LB_ServiceID" runat="server"></asp:Label>
                                            &nbsp;
                                            <asp:Label ID="LB_ServiceName" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <div class="mline">
                                    <div style="display: flex; margin-bottom: 5px;">
                                        <div style="width: 120px;">
                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,KeHuMingCheng%>"></asp:Label>:
                                        </div>
                                        <div>
                                            <asp:Label ID="LB_CompanyName" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <div class="mline">
                                    <div style="display: flex; margin-bottom: 5px;">
                                        <div style="width: 120px;">
                                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>:
                                        </div>
                                        <div>
                                            <asp:Label ID="LB_Type" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <div class="mline">
                                    <div style="display: flex; margin-bottom: 5px;">
                                        <div style="width: 120px;">
                                            <asp:Label ID="Label42" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>:
                                        </div>
                                        <div>
                                            <asp:Label ID="LB_ContactPerson" runat="server"></asp:Label>
                                            &nbsp;
                                            <asp:HyperLink ID="HL_PhoneNumber" runat="server" Text=""></asp:HyperLink>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 锟斤拷锟斤拷锟斤拷钮 -->
                            <div class="npbxs">
                                <div class="equal-buttons">
                                    <asp:Button ID="BT_Accept" runat="server" CssClass="inpu" OnClick="BT_Accept_Click"
                                        Text="<%$ Resources:lang,ShouLi%>" />

                                    <asp:Button ID="BT_Exit" runat="server" CssClass="inpu" OnClick="BT_Exit_Click"
                                        Text="<%$ Resources:lang,TuiChuShouLi%>" />

                                    <asp:Button ID="BT_Finish" runat="server" CssClass="inpu" OnClick="BT_Finish_Click" Text="<%$ Resources:lang,WanCheng%>" />

                                    <asp:Button ID="BT_DeleteQuestion" runat="server" CssClass="inpu" Visible="false" Text="<%$ Resources:lang,ShanChu%>" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" OnClick="BT_DeleteQuestion_Click" />
                                </div>

                                <div class="mline" style="margin-top: 15px;">
                                    <asp:DropDownList ID="DL_IsImportant" runat="server" CssClass="mobile-dropdown" AutoPostBack="true" OnSelectedIndexChanged="DL_IsImportant_SelectedIndexChanged">
                                        <asp:ListItem Value="NO" Text="<%$ Resources:lang,PuTong%>" />
                                        <asp:ListItem Value="YES" Text="<%$ Resources:lang,ShangJi%>" />
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <!-- 直锟接筹拷员锟斤拷指锟斤拷锟斤拷锟斤拷锟斤拷 -->
                            <div class="npbxs">
                                <div class="mline">
                                    <div style="display: flex; margin-bottom: 5px;">
                                        <div style="width: 100%;">
                                            <table width="100%">
                                                <tr>
                                                    <td style="vertical-align: middle;">
                                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ZhiJieChengYuan%>"></asp:Label>:
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="DL_Operator" DataTextField="UserName" Width="100%" DataValueField="UserCode" runat="server" CssClass="mobile-dropdown">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <div class="equal-buttons">
                                    <asp:Button ID="BT_TransferOperator" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ZhiDingWeiShouLiRen%>" OnClick="BT_TransferOperator_Click" />
                                </div>
                            </div>

                            <!-- 锟铰斤拷锟斤拷钮 -->
                            <div class="npbxs">
                                <div class="equal-buttons">
                                    <asp:Button ID="BT_Create" runat="server" Text="<%$ Resources:lang,New%>" CssClass="inpu" OnClick="BT_Create_Click" OnClientClick="popShow(); return false;" />
                                </div>
                            </div>

                            <!-- 锟酵凤拷锟斤拷录 -->
                            <div class="napbox">
                                <div class="npbx">
                                    <div class="npb">
                                        <div class="cline"></div>
                                        <h3>
                                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,KeFuJiLu%>"></asp:Label></h3>
                                    </div>
                                    <div class="npbxs">
                                        <asp:DataList ID="DataList3" runat="server" CellPadding="0" ForeColor="#333333" OnItemCommand="DataList3_ItemCommand"
                                            Height="1px" Width="100%">
                                            <ItemTemplate>
                                                <div style="margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                                                    <!-- 锟斤拷一锟叫ｏ拷ID锟斤拷钮 -->
                                                    <div style="margin-bottom: 8px;">
                                                        <asp:Button ID="BT_ID" runat="server" Text=' <%#DataBinder .Eval (Container .DataItem ,"ID") %> ' CssClass="inpu" CommandName="Update" OnClientClick="popShow(); return false;" />
                                                    </div>

                                                    <!-- 锟节讹拷锟叫匡拷始锟斤拷锟斤拷细锟斤拷息 -->
                                                    <div style="display: flex; flex-wrap: wrap; gap: 5px 0;">
                                                        <!-- 锟斤拷系锟斤拷 -->
                                                        <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                            <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>:
                                                            </div>
                                                            <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                                <%#DataBinder.Eval(Container.DataItem, "CustomerAcceptor")%>
                                                            </div>
                                                        </div>

                                                        <!-- 锟斤拷锟斤拷锟斤拷 -->
                                                        <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                            <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ShouLiRen%>"></asp:Label>:
                                                            </div>
                                                            <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                                <%#DataBinder .Eval (Container .DataItem ,"OperatorName") %>
                                                            </div>
                                                        </div>

                                                        <!-- 锟酵凤拷锟斤拷锟?-->
                                                        <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                            <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,KeFangYiJian%>"></asp:Label>:
                                                            </div>
                                                            <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                                <%#DataBinder.Eval(Container.DataItem, "CustomerComment")%>
                                                            </div>
                                                        </div>

                                                        <!-- 锟斤拷系锟斤拷式 -->
                                                        <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                            <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                                <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>:
                                                            </div>
                                                            <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                                <%#DataBinder.Eval(Container.DataItem, "CustomerAcceptor")%> &nbsp;
                        <a href='tel:<%#DataBinder.Eval(Container.DataItem, "AcceptorContactWay")%>' target="_blank"><%#DataBinder .Eval (Container .DataItem,"AcceptorContactWay") %></a>
                                                            </div>
                                                        </div>

                                                        <!-- 锟斤拷锟斤拷锟斤拷锟斤拷 -->
                                                        <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                            <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>"></asp:Label>:
                                                            </div>
                                                            <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                                <%#DataBinder.Eval(Container.DataItem, "HandleDetail")%>
                                                            </div>
                                                        </div>

                                                        <!-- 锟铰次凤拷锟斤拷时锟斤拷 -->
                                                        <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                            <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,XiaCiFuWuShiJian%>"></asp:Label>:
                                                            </div>
                                                            <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                                <%#DataBinder.Eval(Container.DataItem, "NextServiceTime")%>
                                                            </div>
                                                        </div>

                                                        <!-- 锟斤拷前通知锟斤拷锟斤拷 -->
                                                        <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                            <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,TiQianTongZhiTianShu%>"></asp:Label>:
                                                            </div>
                                                            <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                                <%#DataBinder.Eval(Container.DataItem, "PreDays")%>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </div>
                                </div>
                            </div>

                            <!-- 锟斤拷锟截诧拷锟斤拷 -->
                            <div style="display: none;">
                                <asp:DataList ID="DataList2" runat="server" CellPadding="0" ForeColor="#333333" Height="1px"
                                    Width="100%" Style="display: none;">
                                </asp:DataList>

                                <div class="equal-buttons">
                                    <asp:HyperLink ID="HL_RelatedDoc" runat="server" NavigateUrl="TTCollaborationRelatedDoc.aspx"
                                        CssClass="inpu">
                                        <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,XiangGuanWenJian%>"></asp:Label>
                                    </asp:HyperLink>

                                    &nbsp;

                                    <asp:HyperLink ID="HL_Expense" runat="server" NavigateUrl="TTProExpense.aspx" CssClass="inpu">
                                        <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,FeiYongMingXiYuBaoXiao%>"></asp:Label>
                                    </asp:HyperLink>

                                    &nbsp;

                                    <asp:HyperLink ID="HL_ResoveResultReview" runat="server" NavigateUrl="TTCustomerQuestionResultReviewWF.aspx" CssClass="inpu">
                                        <asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,TiJiaoPingShen%>"></asp:Label>
                                    </asp:HyperLink>

                                    &nbsp;
                                    <asp:HyperLink ID="HL_QuestionToCustomer" runat="server" CssClass="inpu">
                                        <asp:Label ID="Label40" runat="server" Text="<%$ Resources:lang,ZhuanChengKeHuHuoGuanLianKeHu%>"></asp:Label>
                                    </asp:HyperLink>
                                </div>
                            </div>
                        </div>

                        <!-- 锟斤拷锟斤拷锟斤拷锟斤拷 - 锟斤拷锟斤拷锟斤拷form锟节碉拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷 -->
                        <div class="layui-layer-shade" id="popwindow_shade" style="z-index: 9998; background-color: #000; opacity: 0.3; filter: alpha(opacity=30); display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;"></div>

                        <div class="layui-layer layui-layer-iframe" id="popDetailWindow" name="fixedDiv"
                            style="z-index: 9999; width: 96%; max-width: 500px; height: auto; max-height: 80vh; position: fixed; overflow: hidden; display: none; border-radius: 10px; left: 50%; transform: translateX(-50%); background: white; box-shadow: 0 5px 15px rgba(0,0,0,0.3);">
                            <div class="layui-layer-title" style="background: #e7e7e8; padding: 10px 15px; border-bottom: 1px solid #ddd;" id="popwindow_title">
                                <asp:Label ID="Label5" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                                <span class="layui-layer-setwin" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%);">
                                    <a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;" style="display: block; width: 30px; height: 30px; line-height: 30px; text-align: center;">锟斤拷</a>
                                </span>
                            </div>
                            <div id="popwindow_content" class="layui-layer-content" style="overflow: auto; padding: 15px; max-height: calc(80vh - 100px);">

                                <div style="margin: 0;">
                                    <div>
                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,KeHuYiJian%>"></asp:Label>
                                            </div>
                                            <div>
                                                <CKEditor:CKEditorControl ID="HE_CustomerComment" runat="server" Toolbar="" Width="100%" Height="150px" Visible="false" />
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ChuLiFangShi%>"></asp:Label>
                                            </div>
                                            <div style="display: flex; flex-wrap: wrap; gap: 10px; align-items: center;">
                                                <asp:TextBox ID="TB_HandleWay" runat="server" Width="120px"></asp:TextBox>
                                                <asp:DropDownList ID="DL_HandleWay" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DL_ContactWay_SelectedIndexChanged">
                                                    <asp:ListItem Value="" Text="<%$ Resources:lang,QingXuanZe%>" />
                                                    <asp:ListItem Value="Telephone" Text="<%$ Resources:lang,DianHua%>" />
                                                    <asp:ListItem Value="InstantMessaging" Text="<%$ Resources:lang,IM%>" />
                                                    <asp:ListItem Value="RemoteControl" Text="<%$ Resources:lang,YuanChengKongZhi%>" />
                                                    <asp:ListItem Value="EMail" Text="<%$ Resources:lang,EMail%>" />
                                                    <asp:ListItem Value="DoorToDoorVisit" Text="<%$ Resources:lang,ShangMenBaiFang%>" />
                                                    <asp:ListItem Value="OtherMethods" Text="<%$ Resources:lang,QiTaFangShi%>" />
                                                </asp:DropDownList>
                                                <asp:Label ID="LB_ID" runat="server" Visible="false"></asp:Label>
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                            </div>
                                            <div>
                                                <asp:DropDownList ID="DL_HandleStatus" runat="server" Width="100%">
                                                    <asp:ListItem Value="InProgress" Text="<%$ Resources:lang,ChuLiZhong%>" />
                                                    <asp:ListItem Value="Reviewing" Text="<%$ Resources:lang,PingShenZhong%>" />
                                                    <asp:ListItem Value="Suspended" Text="<%$ Resources:lang,GuaQi%>" />
                                                    <asp:ListItem Value="Completed" Text="<%$ Resources:lang,WanCheng%>" />
                                                    <asp:ListItem Value="Cancel" Text="<%$ Resources:lang,QuXiao%>" />
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,YongShi%>"></asp:Label>
                                            </div>
                                            <div style="display: flex; gap: 10px; align-items: center;">
                                                <NickLee:NumberBox ID="NB_UsedTime" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Width="100px" Amount="1">1.00</NickLee:NumberBox>
                                                <asp:DropDownList ID="DL_TimeUnit" runat="server" Width="100px">
                                                    <asp:ListItem Value="Minutes" Text="<%$ Resources:lang,FenZhong%>" />
                                                    <asp:ListItem Value="Hours" Text="<%$ Resources:lang,XiaoShi%>" />
                                                    <asp:ListItem Value="Days" Text="<%$ Resources:lang,Tian%>" />
                                                </asp:DropDownList>
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,LianLuoRen%>"></asp:Label>
                                            </div>
                                            <div style="display: flex; gap: 10px; align-items: center;">
                                                <asp:TextBox ID="TB_CustomerAcceptor" runat="server" Width="200px"></asp:TextBox>
                                                <asp:HyperLink ID="HL_AcceptorContactWay" runat="server"></asp:HyperLink>
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,LianXiFangFa%>"></asp:Label>
                                            </div>
                                            <div>
                                                <asp:TextBox ID="TB_AcceptorContactWay" runat="server" Width="100%"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,ChuLi%>"></asp:Label>
                                            </div>
                                            <div>
                                                <CKEditor:CKEditorControl ID="HE_HandleDetail" Toolbar="" runat="server" Width="100%" Height="100px" Visible="False" />
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <div style="display: flex; gap: 10px; align-items: center;">
                                                        <div>
                                                            <Upload:InputFile ID="AttachFile" runat="server" name="photo" Accept="image/*;capture=camera" Width="160px" />
                                                            <input type="hidden" val="" id="imgData" runat="server" />
                                                        </div>
                                                        <div class="upload-button">
                                                            <asp:Button ID="BtnUP" runat="server" OnClick="BtnUP_Click" OnClientClick="javascript:document.getElementById('IMG_Uploading').style.display = 'block';" Text="<%$ Resources:lang,ShiYong%>" CssClass="mobile-button" />
                                                            <img id="IMG_Uploading" src="Images/Processing.gif" alt="锟斤拷锟皆候，达拷锟斤拷锟斤拷..." style="display: none;" />
                                                        </div>
                                                    </div>
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:PostBackTrigger ControlID="BtnUP" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                        </div>

                                        <div style="margin-bottom: 15px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,XiaCi%>"></asp:Label>
                                            </div>
                                            <!-- 锟睫革拷锟斤拷锟斤拷选锟斤拷锟斤拷位锟斤拷 -->
                                            <div class="popup-input-group">
                                                <asp:TextBox ID="DLC_NextServiceTime" ReadOnly="false" runat="server" Width="100%" Style="padding-right: 30px;"></asp:TextBox>
                                                <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender1" runat="server" TargetControlID="DLC_NextServiceTime"
                                                    PopupPosition="BottomLeft">
                                                </ajaxToolkit:CalendarExtender>
                                                <button type="button" class="calendar-button" onclick="document.getElementById('<%= DLC_NextServiceTime.ClientID %>').focus(); return false;"></button>
                                            </div>
                                        </div>

                                        <div style="margin-bottom: 20px;">
                                            <div style="font-weight: bold; margin-bottom: 5px;">
                                                <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,TiQian%>"></asp:Label>
                                            </div>
                                            <div style="display: flex; gap: 10px; align-items: center;">
                                                <NickLee:NumberBox ID="NB_PreDays" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Precision="0" Width="100px">0</NickLee:NumberBox>
                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,Tian%>"></asp:Label>
                                            </div>
                                        </div>

                                        <div style="display: none;">
                                            <asp:Button ID="BT_Add" runat="server" CssClass="inpu" OnClick="BT_Add_Click" Text="<%$ Resources:lang,XinJian%>" />
                                            <asp:Button ID="BT_Update" runat="server" CssClass="inpu" Enabled="false" OnClick="BT_Update_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                            <asp:Button ID="BT_Delete" runat="server" CssClass="inpu" Enabled="false" OnClick="BT_Delete_Click" Text="<%$ Resources:lang,ShanChu%>" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" />
                                        </div>
                                        <br />
                                        <br />
                                    </div>
                                </div>
                            </div>

                            <!-- 锟睫改猴拷牡锟斤拷锟斤拷撞锟斤拷锟脚?-->
                            <div id="popwindow_footer" class="layui-layer-btn" style="border-top: 1px solid #ccc; padding: 15px; text-align: center; background: white; position: sticky; bottom: 0;">
                                <asp:LinkButton ID="BT_New" runat="server"
                                    OnClick="BT_New_Click"
                                    Text="<%$ Resources:lang,BaoCun%>"
                                    CssClass="popup-button">
                                </asp:LinkButton>
                                <a onclick="return popClose();" class="popup-button cancel" style="margin-left: 10px;">
                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                                </a>
                            </div>
                        </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            </div>
            <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </div>
</body>
</html>