�?%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppOtherTaskDetail.aspx.cs" Inherits="TTAppOtherTaskDetail" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />


    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script src="js/My97DatePicker/WdatePicker.js"></script>

    <link href="js/layer/mobile/need/layer.css" rel="stylesheet" />
    <script src="js/layer/mobile/layer.js"></script>
    <script src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

    <script src="js/exif.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();// 锟斤拷始锟斤拷锟斤拷锟斤拷锟斤拷锟截癸拷锟斤�?
            //选锟斤拷图片锟斤拷压锟斤拷图�?            $("#AttachFile").change(function () {
                var _ua = window.navigator.userAgent;
                var _simpleFile = this.files[0];
                //锟叫讹拷锟角凤拷为图�?                if (!/\/(?:jpeg|png|gif|png|bmp)/i.test(_simpleFile.type)) return;

                //锟斤拷锟絜xif.js锟斤拷取ios图片锟侥凤拷锟斤拷锟斤拷�?                var _orientation;
                EXIF.getData(_simpleFile, function () {
                    _orientation = EXIF.getTag(this, 'Orientation');
                });

                //1.锟斤拷取锟侥硷拷锟斤拷通锟斤拷FileReader锟斤拷锟斤拷图片锟侥硷拷转锟斤拷为DataURL锟斤拷锟斤拷data:img/png;base64锟斤拷锟斤拷头锟斤拷url锟斤拷锟斤拷锟斤拷直锟接凤拷锟斤拷image.src锟斤�?
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

        });

        function aHandler() {

            $("a").not(".notTab").each(function () {

                var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

                var url = $(this).attr("href");
                var click = $(this).attr("onclick");

                //锟叫讹拷锟角凤拷锟斤拷tree锟斤拷锟斤拷锟竭凤拷�?                if (click != "" && click != null && click != undefined) {
                    if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                        $(this).click(function () {

                            if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {
                                //popShowByURL(url, 800, 600,window.location);
                                top.frames["rightTabFrame"].popShowByURL(url, title, 800, 600, window.location);
                                return false;
                            }
                        });
                    }
                }
                else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
                    $(this).click(function () {
                        if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1) {
                            if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {
                                //popShowByURL(url, 800, 600,window.location);
                                top.frames["rightTabFrame"].popShowByURL(url, 800, 600, window.location);
                                return false;
                            }
                        }
                    });
                }

            });
        }

        /**
         * 锟斤拷锟斤拷图片锟侥尺寸，锟斤拷锟捷尺达拷压锟斤�?         * 1. iphone锟街伙拷html5锟较达拷图片锟斤拷锟斤拷锟斤拷锟解，锟斤拷锟斤拷exif.js
         * 2. 锟斤拷卓UC锟斤拷锟斤拷锟斤拷锟街э拷�?new Blob()锟斤拷使锟斤拷BlobBuilder
         * @param {Object} _img     图片
         * @param {Number} _orientation 锟斤拷片锟斤拷息
         * @return {String}       压锟斤拷锟斤拷base64锟斤拷式锟斤拷图�?         */
        function compress(_img, _orientation) {
            //2.锟斤拷锟斤拷锟斤拷锟侥匡拷锟竭达拷锟斤拷锟街碉拷锟斤拷锟斤拷洗锟酵计拷目锟斤拷叨锟斤拷锟斤拷锟侥匡拷锟酵硷拷锟斤拷锟侥匡拷锟酵硷拷缺锟窖癸拷锟斤拷锟斤拷锟斤拷锟斤拷一锟斤拷小锟节ｏ拷锟斤拷锟较达拷图片锟饺比放达�?            var _goalWidth = 640,         //目锟斤拷锟斤拷锟?
                _goalHeight = 480,         //目锟斤拷叨锟?
                _imgWidth = _img.naturalWidth,   //图片锟斤拷锟斤拷
                _imgHeight = _img.naturalHeight,  //图片锟竭讹拷
                _tempWidth = _imgWidth,      //锟脚达拷锟斤拷锟叫★拷锟斤拷锟斤拷时锟斤拷锟斤拷
                _tempHeight = _imgHeight,     //锟脚达拷锟斤拷锟叫★拷锟斤拷锟斤拷时锟斤拷锟斤拷
                _r = 0;              //压锟斤拷锟斤�?
            if (_imgWidth > _goalWidth || _imgHeight > _goalHeight) {//锟斤拷锟斤拷叽锟斤拷锟侥匡拷锟酵硷拷锟斤拷锟饺憋拷压锟斤�?                _r = _imgWidth / _goalWidth;
                if (_imgHeight / _goalHeight < _r) {
                    _r = _imgHeight / _goalHeight;
                }
                _tempWidth = Math.ceil(_imgWidth / _r);
                _tempHeight = Math.ceil(_imgHeight / _r);
            }

            //3.锟斤拷锟斤拷canvas锟斤拷图片锟斤拷锟叫裁硷拷锟斤拷锟饺比放达拷锟斤拷锟叫★拷锟斤拷锟叫撅拷锟叫裁硷�?            var _canvas = $("#myCanvas")[0];

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
            if (!!_degree) {
                _context.rotate(_degree * Math.PI / 180);
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            } else {
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            }
            //toDataURL锟斤拷锟斤拷锟斤拷锟斤拷锟皆伙拷取锟斤拷式为"data:image/png;base64,***"锟斤拷base64图片锟斤拷息锟斤�?            var _data = _canvas.toDataURL('image/jpeg');
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
                //锟斤拷锟斤拷锟斤拷锟捷的革拷�?                //锟斤拷锟斤拷锟斤拷之前锟斤拷锟矫的猴拷锟斤拷
                beforeSend: function () {
                    $("#IMG_Waiting").show();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                },
                //锟缴癸拷锟斤拷锟斤拷之锟斤拷锟斤拷玫暮锟斤拷�?
                success: function (data) {
                    if (data.indexOf("img") > 0) {
                        $(document.getElementsByTagName("iframe")[0]).contents().find("body").append(data);
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
    </script>
</head>
<body class="napbac" data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    <!-- 锟斤拷锟斤拷锟斤拷锟斤拷锟斤�?-->

    <script type="text/javascript" language="javascript">
        var txtQrCode = '#<%=TB_QrCode.ClientID%>';
        var btnSaveQrCode = '#<%=BT_SaveQrCode.ClientID%>';

        var loadingIndex; //锟斤拷示锟斤拷index
        var isWxConfigReady = false; //config锟角凤拷锟斤拷证通锟斤拷
        $(function () {
            initSwipeBack();// 锟斤拷始锟斤拷锟斤拷锟斤拷锟斤拷锟截癸拷锟斤�? initSwipeBack();// 锟斤拷始锟斤拷锟斤拷锟斤拷锟斤拷锟截癸拷锟斤�?
            try {
                if ('<%=signModel.appId %>' == '') {
                    return;
                }

                var ids = "," + "@Model.MenuIds" + ",";
                $("a[id^='my_a_']").each(function (i, item) {
                    var val = $(this).attr("id").replace("my_a_", "");
                    if (ids.indexOf("," + val + ",") == -1) {
                        $(this).hide();
                    }
                });
                wxApi();

                //删锟斤拷锟斤拷锟解弹锟斤拷锟斤拷
                if (isWxConfigReady == false) {
                    var m = document.getElementById("layui-layer1");
                    m.parentNode.removeChild(m);

                    var k = document.getElementById("layui-layer-shade1");
                    k.parentNode.removeChild(k);
                }
            }
            catch
            {

            }
        });

        function wxApi() {
            var loadingIndex = layer.open({
                type: 2
                // , content: 'ImagesSkin/Processing.gif'
            });
            wx.config({
                debug: false, // 锟斤拷锟斤拷锟斤拷锟斤拷模式,锟斤拷锟矫碉拷锟斤拷锟斤拷api锟侥凤拷锟斤拷值锟斤拷锟节客伙拷锟斤拷alert锟斤拷锟斤拷锟斤拷锟斤拷要锟介看锟斤拷锟斤拷牟锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟絧c锟剿打开ｏ拷锟斤拷锟斤拷锟斤拷息锟斤拷通锟斤拷log锟斤拷锟斤拷锟斤拷锟斤拷锟絧c锟斤拷时锟脚伙拷锟接★拷�?
                appId: '<%=signModel.appId %>', // 锟斤拷锟筋，锟斤拷锟节号碉拷唯一锟斤拷识
                timestamp: '<%=signModel.time %>', // 锟斤拷锟筋，锟斤拷锟斤拷签锟斤拷锟斤拷时锟斤拷锟?锟斤拷锟斤拷锟叫?
                nonceStr: '<%=signModel.randstr %>', // 锟斤拷锟筋，锟斤拷锟斤拷签锟斤拷锟斤拷锟斤拷锟斤拷锟?锟斤拷锟斤拷锟叫?
                signature: '<%=signModel.signstr %>', // 锟斤拷锟筋，签锟斤拷锟斤拷锟斤拷锟斤拷录1

                jsApiList: [
                    'checkJsApi',
                    'onMenuShareTimeline',
                    'onMenuShareAppMessage',
                    'onMenuShareQQ',
                    'onMenuShareWeibo',
                    'hideMenuItems',
                    'showMenuItems',
                    'hideAllNonBaseMenuItem',
                    'showAllNonBaseMenuItem',
                    'translateVoice',
                    'startRecord',
                    'stopRecord',
                    'onRecordEnd',
                    'playVoice',
                    'pauseVoice',
                    'stopVoice',
                    'uploadVoice',
                    'downloadVoice',
                    'chooseImage',
                    'previewImage',
                    'uploadImage',
                    'downloadImage',
                    'getNetworkType',
                    'openLocation',
                    'getLocation',
                    'hideOptionMenu',
                    'showOptionMenu',
                    'closeWindow',
                    'scanQRCode',
                    'chooseWXPay',
                    'openProductSpecificView',
                    'addCard',
                    'chooseCard',
                    'openCard'
                ] // 锟斤拷锟筋，锟斤拷要使锟矫碉拷JS锟接匡拷锟叫憋拷锟斤拷锟斤拷锟斤拷JS锟接匡拷锟叫憋拷锟斤拷锟斤拷�?
            });

            wx.ready(function () {
                layer.close(loadingIndex);
                // config锟斤拷息锟斤拷证锟斤拷锟街达拷锟絩eady锟斤拷锟斤拷锟斤拷锟斤拷锟叫接口碉拷锟矫讹拷锟斤拷锟斤拷锟斤拷config锟接口伙拷媒锟斤拷之锟斤拷config锟斤拷一锟斤拷锟酵伙拷锟剿碉拷锟届步锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟揭拷锟揭筹拷锟斤拷锟斤拷时锟酵碉拷锟斤拷锟斤拷亟涌冢锟斤拷锟斤拷锟斤拷锟斤拷亟涌诜锟斤拷锟絩eady锟斤拷锟斤拷锟叫碉拷锟斤拷锟斤拷确锟斤拷锟斤拷确执锟叫★拷锟斤拷锟斤拷锟矫伙拷锟斤拷锟斤拷时锟脚碉拷锟矫的接口ｏ拷锟斤拷锟斤拷锟街憋拷拥锟斤拷茫锟斤拷锟斤拷锟揭拷锟斤拷锟絩eady锟斤拷锟斤拷锟叫★拷
                isWxConfigReady = true;
            });
            wx.error(function (res) {
                layer.close(loadingIndex);
                alert(JSON.stringify(res));
                // config锟斤拷息锟斤拷证失锟杰伙拷执锟斤拷error锟斤拷锟斤拷锟斤拷锟斤拷签锟斤拷锟斤拷锟节碉拷锟斤拷锟斤拷证失锟杰ｏ拷锟斤拷锟斤拷锟斤拷锟斤拷锟较拷锟斤拷源锟絚onfig锟斤拷debug模式锟介看锟斤拷也锟斤拷锟斤拷锟节凤拷锟截碉拷res锟斤拷锟斤拷锟叫查看锟斤拷锟斤拷锟斤拷SPA锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷锟角╋拷锟斤拷锟?
            });
        }

        function qrcode() {
            wx.scanQRCode({
                needResult: 1, // 默锟斤拷�?锟斤拷扫锟斤拷锟斤拷锟斤拷微锟脚达拷锟斤拷锟斤拷1锟斤拷直锟接凤拷锟斤拷扫锟斤拷锟斤拷锟斤�?                scanType: ["qrCode", "barCode"], // 锟斤拷锟斤拷指锟斤拷扫锟斤拷维锟诫还锟斤拷一维锟诫，默锟较讹拷锟竭讹拷锟斤拷
                success: function (res) {
                    var result = res.resultStr; // 锟斤拷needResult �?1 时锟斤拷扫锟诫返锟截的斤拷锟?
                    if (typeof (result) != "undefined") {
                        result = result.substring(result.indexOf(',') + 1, result.length);
                        //锟侥憋拷锟斤拷�?                        $(txtQrCode).val(result);
                        //锟斤拷锟斤拷锟窖拷锟脚?
                        $(btnSaveQrCode).click();
                    }
                }
            });
        }
    </script>
    <canvas id="myCanvas" style="display: none;"></canvas>
        <form id="form1" runat="server" method="post" enctype="multipart/form-data" class="napf">
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
                                                            <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="锟斤拷锟皆候，达拷锟斤拷锟斤拷..." style="display: none;" />
                                            </a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td colspan="2" style="text-align: left; padding-left: 5px;">
                                            <div class="npb">
                                                <div class="cline"></div>
                                                <h3>
                                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,RenWu%>"></asp:Label>:<asp:Label ID="LB_TaskID" runat="server"></asp:Label>
                                                    <asp:Label ID="LB_Task" runat="server"></asp:Label></h3>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="ItemAlignLeft">

                                            <table width="100%" cellpadding="3" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <div class="napbox">
                                                            <div class="npbx">
                                                                <div class="npb">
                                                                    <div class="cline"></div>
                                                                    <h3>
                                                                        <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,RenWuChuLi%>"></asp:Label></h3>
                                                                </div>
                                                                <div class="npbxs">
                                                                    <h3>
                                                                        <asp:HyperLink ID="HL_StartupBusinessForm" runat="server" Text="<%$ Resources:lang,XiangGuanYeWuDan %>"></asp:HyperLink>
                                                                        <asp:HyperLink ID="HL_GoodsApplication" runat="server" Text="<%$ Resources:lang,LiaoPingLingYong %>"></asp:HyperLink>
                                                                        <asp:Image ID="IMG_QrCode" runat="server" CssClass="inpuQrCode" onclick="qrcode()" Width="16px" />
                                                                        <asp:Button ID="BT_SaveQrCode" runat="server" Style="display: none;" CssClass="inpu" Text="<%$ Resources:lang,BaoCun %>" OnClick="BT_SaveQrCode_Click" />
                                                                        <asp:TextBox ID="TB_QrCode" runat="server" Style="display: none;"></asp:TextBox>
                                                                    </h3>

                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,GongShi2 %>"></asp:Label>
                                                                        </h4>
                                                                        <NickLee:NumberBox ID="NB_ManHour" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" OnBlur="" OnFocus="" OnKeyPress="" PositiveColor="" Width="99%">0.00</NickLee:NumberBox>
                                                                    </div>
                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,JinDu %>"></asp:Label>
                                                                        </h4>
                                                                        <NickLee:NumberBox ID="NB_FinishPercent" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" OnBlur="" OnFocus="" OnKeyPress="" PositiveColor="" Precision="0" Width="94%">0</NickLee:NumberBox>
                                                                        <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="%"></asp:Label>
                                                                    </div>
                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="LB_TaskProgress" runat="server" Text="<%$ Resources:lang,ZhengTi %>"></asp:Label>
                                                                        </h4>
                                                                        <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000" ID="NB_TaskProgress" runat="server" OnBlur="" OnFocus="" OnKeyPress="" Enabled="False"
                                                                            PositiveColor="" Precision="0" Width="94%">0</NickLee:NumberBox>
                                                                        <asp:Label ID="Label52" runat="server" Font-Bold="True" Text="%"></asp:Label>
                                                                    </div>
                                                                </div>

                                                                <div class="npbxs">
                                                                    <h3>
                                                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZongJie %>"></asp:Label>
                                                                    </h3>
                                                                    <CKEditor:CKEditorControl ID="HE_FinishContent" Toolbar="" Height="80px" Width="99%" runat="server" Visible="False" />

                                                                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <div class="nmar">
                                                                                <table>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <Upload:InputFile ID="AttachFile" runat="server" name="photo" Accept="image/*;capture=camera" Width="160px" />
                                                                                            <input type="hidden" val="" id="imgData" runat="server" /></td>
                                                                                        <td>
                                                                                            <input type="button" id="BtnUP" onclick="upload()" value="Upload" />
                                                                                            <img id="IMG_Uploading" src="Images/Processing.gif" alt="锟斤拷锟皆候，达拷锟斤拷锟斤拷..." style="display: none;" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <br />
                                                                                <br />
                                                                            </div>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>

                                                                    <div class="manyspan" style="display: none;">
                                                                        <asp:CheckBox ID="CB_ReturnMsg" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaXinXi %>" />
                                                                        <asp:CheckBox ID="CB_ReturnMail" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaYouJian %>" />
                                                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,TongZhiFenPaiRen %>"></asp:Label>
                                                                        <asp:TextBox ID="TB_Message" runat="server" Width="45%"></asp:TextBox>
                                                                        <asp:Button ID="BT_Send" runat="server" OnClick="BT_Send_Click" Text="<%$ Resources:lang,FaSong %>" CssClass="inpu" />
                                                                    </div>

                                                                    <!-- 锟睫改碉�?锟斤拷锟斤拷 npbtn npbtn-inline 锟斤拷为 equal-buttons -->
                                                                    <div class="equal-buttons">
                                                                        <asp:Button ID="BT_Activity" runat="server" CssClass="inpu" OnClick="BT_Activity_Click" Text="<%$ Resources:lang,BaoCun %>" />
                                                                        <asp:Button ID="BT_Finish" runat="server" CssClass="inpu" Font-Bold="True" OnClick="BT_Finish_Click" Text="<%$ Resources:lang,WanChengTiJiao %>" />
                                                                    </div>

                                                                    <!-- 锟睫改碉�?锟斤拷锟斤拷 npbtn npbtn-inline 锟斤拷为 equal-buttons -->
                                                                    <div class="equal-buttons" style="margin-top: 10px;">
                                                                        <asp:Button ID="BT_TBD" runat="server" CssClass="inpu" Visible="False" OnClick="BT_TBD_Click" Text="<%$ Resources:lang,GuaQi %>" />
                                                                        <asp:Button ID="BT_CloseTask" runat="server" CssClass="inpu" Visible="False" Enabled="False" OnClick="BT_CloseTask_Click" Text="<%$ Resources:lang,GuanBiCiRenWu %>" />
                                                                        <asp:Button ID="BT_ActiveTask" runat="server" CssClass="inpu" Visible="False" Enabled="False" OnClick="BT_ActiveTask_Click" Text="<%$ Resources:lang,JiHuoCiRenWu %>" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>


                                            <table width="100%" cellpadding="3" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <div class="napbox">
                                                            <div class="npbx">
                                                                <div class="npb">
                                                                    <div class="cline"></div>
                                                                    <h3>
                                                                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,JiXuFenPai%>"></asp:Label></h3>
                                                                </div>
                                                                <div class="npbxs">
                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,LeiXing %>"></asp:Label>
                                                                        </h4>
                                                                        <asp:DropDownList ID="DL_RecordType" runat="server" DataTextField="Type" DataValueField="Type" Width="99%">
                                                                        </asp:DropDownList>
                                                                        <strong>
                                                                            <asp:Label ID="LB_ID" runat="server" Visible="False"></asp:Label>
                                                                        </strong>
                                                                    </div>
                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,ShouLiRen %>"></asp:Label>
                                                                        </h4>
                                                                        <asp:DropDownList ID="DL_OperatorCode" runat="server" DataTextField="UserName" DataValueField="UserCode" Width="99%">
                                                                        </asp:DropDownList>
                                                                    </div>
                                                                </div>

                                                                <div class="npbxs">
                                                                    <h3>
                                                                        <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,YaoQiu %>"></asp:Label>
                                                                    </h3>
                                                                    <CKEditor:CKEditorControl ID="HE_Operation" runat="server" Toolbar="" Height="150px" Visible="False" Width="99%" />
                                                                    <asp:DropDownList ID="DL_WorkRequest" runat="server" AutoPostBack="True" DataTextField="Operation"
                                                                        DataValueField="Operation" OnSelectedIndexChanged="DL_WorkRequest_SelectedIndexChanged" Width="99%">
                                                                    </asp:DropDownList>

                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,KaiShi %>"></asp:Label>
                                                                        </h4>
                                                                        <asp:TextBox ID="DLC_BeginDate" ReadOnly="false" runat="server" Width="99%">
                                                                        </asp:TextBox>
                                                                        <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender1" runat="server"
                                                                            TargetControlID="DLC_BeginDate">
                                                                        </ajaxToolkit:CalendarExtender>
                                                                    </div>

                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,JieShu %>"></asp:Label>
                                                                        </h4>
                                                                        <asp:TextBox ID="DLC_EndDate" ReadOnly="false" runat="server" Width="99%">
                                                                        </asp:TextBox>
                                                                        <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender2" runat="server"
                                                                            TargetControlID="DLC_EndDate">
                                                                        </ajaxToolkit:CalendarExtender>
                                                                    </div>

                                                                    <div class="manyspan" style="display: none;">
                                                                        <asp:CheckBox ID="CB_SendMsg" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaXinXi %>" />
                                                                        <asp:CheckBox ID="CB_SendMail" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaYouJian %>" />
                                                                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,TongZhiShouLiRen %>"></asp:Label>
                                                                        <asp:TextBox ID="TB_AssignMessage" runat="server" Width="45%"></asp:TextBox>
                                                                        <asp:Button ID="BT_SendAssignMsg" runat="server" CssClass="inpu" OnClick="BT_SendAssignMsg_Click"
                                                                            Text="<%$ Resources:lang,FaSong %>" />
                                                                    </div>

                                                                    <!-- 锟睫改碉�?锟斤拷锟斤拷 npbtn npbtn-inline 锟斤拷为 equal-buttons -->
                                                                    <div class="equal-buttons">
                                                                        <asp:Button ID="BT_Assign" runat="server" CssClass="inpu" OnClick="BT_Assign_Click" Text="<%$ Resources:lang,FenPai %>" />
                                                                        <asp:Button ID="BT_UpdateAssign" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_UpdateAssign_Click" Text="<%$ Resources:lang,BaoCun %>" />
                                                                        <asp:Button ID="BT_DeleteAssign" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_DeleteAssign_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu %>" />
                                                                    </div>

                                                                    <div class="npbxs">
                                                                        <h3>
                                                                            <strong>
                                                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,CiRenWuFenPaiJiLuZiJiLu %>"></asp:Label>(<span style="font-size: 9pt"><asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,XuanZeKeZaiShangMianXiuGai %>"></asp:Label>):</span></strong>
                                                                        </h3>
                                                                        <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                                            ShowHeader="false" ForeColor="#333333" GridLines="None" Height="1px" OnItemCommand="DataGrid2_ItemCommand"
                                                                            Width="99%">
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="">
                                                                                    <ItemTemplate>
                                                                                        <div class="npb npbs">
                                                                                            <div class="nplef">
                                                                                                <asp:Button ID="BT_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'
                                                                                                    CssClass="tt-sms-btn" />
                                                                                            </div>
                                                                                            <div class="nprig">
                                                                                                <h5><%# DataBinder.Eval(Container.DataItem,"OperatorName") %>  <sub></sub></h5>
                                                                                                <h6><%# DataBinder.Eval(Container.DataItem,"Operation") %></h6>
                                                                                            </div>
                                                                                        </div>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                            <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                        </asp:DataGrid>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                        <tr>
                            <td></td>
                        </tr>
                        <tr style="display: none;">
                            <td class="formItemBgStyleForAlignLeft">
                                <asp:HyperLink ID="HL_ProjectDetail" runat="server">
                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,DangTianXiangMuRiZhi%>"></asp:Label>
                                </asp:HyperLink>
                                <asp:HyperLink ID="HL_TaskReview" runat="server" Enabled="False">---&gt;<asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,RenWuPingShen%>"></asp:Label></asp:HyperLink>
                                <asp:HyperLink ID="HL_MakeProjectReq" runat="server">--&gt;<asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,JianLiHeFenPaiXuQiu%>"></asp:Label></asp:HyperLink>
                                <asp:HyperLink ID="HL_TestCase" runat="server" NavigateUrl="TTMakeTaskTestCase.aspx">
                                    <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,CeShiYongLi%>"></asp:Label>
                                </asp:HyperLink>
                                <asp:HyperLink ID="HL_TaskRelatedDoc" runat="server" NavigateUrl="TTProTaskRelatedDoc.aspx">
                                    <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,XiangGuanWenDang%>"></asp:Label>
                                </asp:HyperLink>
                                <asp:HyperLink ID="HL_TaskAssignRecord" runat="server" NavigateUrl="TTTaskAssignRecord.aspx">
                                    <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,SuoYouFenPaiJiLu%>"></asp:Label>
                                </asp:HyperLink>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>(<asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,GuanLianHuiYi%>"></asp:Label>:<asp:HyperLink ID="HL_RelatedMeetingID" runat="server"></asp:HyperLink>
                                <asp:HyperLink ID="HL_RelatedMeetingName" runat="server"></asp:HyperLink>
                                )
                                <asp:Label ID="LB_ProjectID" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="LB_UserName" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
                                <asp:HyperLink ID="HL_Expense" runat="server" NavigateUrl="TTProExpense.aspx">
                                    <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,FeiYongMingXi%>"></asp:Label>
                                </asp:HyperLink>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td style="width: 50px;" class="formItemBgStyleForAlignLeft">
                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,FeiYong %>"></asp:Label>
                            </td>
                            <td class="formItemBgStyleForAlignLeft">
                                <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000" ID="TB_Expense" runat="server" OnBlur="" OnFocus="" OnKeyPress=""
                                    PositiveColor="" Visible="False" Width="100px">0.00</NickLee:NumberBox>
                                <span style="text-decoration: underline">
                                    <asp:Label ID="LB_AssignID" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="LB_RouteNumber" runat="server" Visible="False"></asp:Label>
                                </span>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td width="65%" class="formItemBgStyleForAlignLeft">
                                <asp:DataList ID="DataList2" runat="server" Width="100%" Height="1px" CellPadding="0"
                                    ForeColor="#333333">
                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <ItemTemplate>
                                        <table style="width: 100%;" cellpadding="4" cellspacing="0">
                                            <tr>
                                                <td style="width: 15%; text-align: right;">
                                                    <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,JiLuBianHao%>"></asp:Label>:
                                                </td>
                                                <td style="width: 20%" class="ItemAlignLeft">
                                                    <%# DataBinder.Eval(Container.DataItem,"ID") %>
                                                </td>
                                                <td style="width: 10%; text-align: right;">
                                                    <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,LuXianBianHao%>"></asp:Label>:
                                                </td>
                                                <td style="width: 15%" class="ItemAlignLeft">
                                                    <%# DataBinder.Eval(Container.DataItem,"RouteNumber") %>
                                                </td>
                                                <td style="width: 20%; text-align: right;">
                                                    <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,RenWu%>"></asp:Label>:
                                                </td>
                                                <td style="width: 20%; font-size: 10pt" class="ItemAlignLeft">
                                                    <a href='TTProjectTaskView.aspx?TaskID=<%# DataBinder.Eval(Container.DataItem,"TaskID") %>'
                                                        target="_blank">
                                                        <%# DataBinder.Eval(Container.DataItem,"TaskID") %></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right;">
                                                    <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,WoDeGongZuo%>"></asp:Label>:
                                                </td>
                                                <td colspan="5" style="text-align: left">
                                                    <b>
                                                        <%# DataBinder.Eval(Container.DataItem,"Operation") %>
                                                    </b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right;">
                                                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,KaiShiShiJian%>"></asp:Label>:
                                                </td>
                                                <td class="ItemAlignLeft">
                                                    <%# DataBinder.Eval(Container.DataItem,"BeginDate","{0:yyyy/MM/dd}") %>
                                                </td>
                                                <td style="text-align: right;">
                                                    <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,JieShuShiJian%>"></asp:Label>:
                                                </td>
                                                <td class="ItemAlignLeft">
                                                    <%# DataBinder.Eval(Container.DataItem, "EndDate", "{0:yyyy/MM/dd}")%>
                                                </td>
                                                <td style="text-align: right;">
                                                    <asp:Label ID="Label35" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label>:
                                                </td>
                                                <td style="text-align: left;">
                                                    <%# DataBinder.Eval(Container.DataItem,"AssignManName") %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right">
                                                    <asp:Label ID="Label36" runat="server" Text="<%$ Resources:lang,WoDeFanKui%>"></asp:Label>:
                                                </td>
                                                <td colspan="3" style="text-align: left">
                                                    <%# DataBinder.Eval(Container.DataItem,"OperatorContent") %>
                                                </td>
                                                <td style="text-align: right"></td>
                                                <td style="text-align: left"></td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: right">
                                                    <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,GongShi%>"></asp:Label>:
                                                </td>
                                                <td class="ItemAlignLeft">
                                                    <%# DataBinder.Eval(Container.DataItem,"ManHour") %>
                                                </td>
                                                <td style="text-align: right">
                                                    <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,FeiYong%>"></asp:Label>:
                                                </td>
                                                <td class="ItemAlignLeft">
                                                    <%# DataBinder.Eval(Container.DataItem,"Expense") %>
                                                </td>
                                                <td style="text-align: right">
                                                    <asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>:
                                                </td>
                                                <td style="text-align: left">
                                                    <%# DataBinder.Eval(Container.DataItem,"Status") %>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                    <ItemStyle BackColor="#f5f7fa" />
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                </asp:DataList>
                            </td>
                            <td width="35%" style="text-align: left; background-color: #f5f7fa;">
                                <asp:DataList ID="DataList3" runat="server" CellPadding="0" ForeColor="#333333" Height="1px"
                                    Width="100%">
                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                    <ItemTemplate>
                                        <table cellpadding="4" cellspacing="0" style="width: 100%;">
                                            <tr>
                                                <td style="text-align: left">
                                                    <asp:Label ID="Label40" runat="server" Text="<%$ Resources:lang,RenWuNeiRong%>"></asp:Label>:
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: left">
                                                    <%# DataBinder.Eval(Container.DataItem,"Task") %>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                    <ItemStyle BackColor="#f5f7fa" />
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                </asp:DataList>
                            </td>
                        </tr>
                    </table>
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
</body>
</html>
