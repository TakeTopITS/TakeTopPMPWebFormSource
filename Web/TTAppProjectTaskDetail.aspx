<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppProjectTaskDetail.aspx.cs" Inherits="TTAppProjectTaskDetail" %>

<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=1" />

<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        body {
            /*margin-top: 5px;*/
            /*background-image: url(Images/login_bj.jpg);*/
            background-repeat: repeat-x;
            font: normal 100% Helvetica, Arial, sans-serif;
            /* 防止横向滚动 */
            overflow-x: hidden;
            width: 100%;
            position: relative;
        }

        #AboveDiv {
            max-width: 1024px;
            width: expression (document.body.clientWidth >= 1024? "1024px" : "auto" ));
            min-width: 277px;
            width: expression (document.body.clientWidth <= 277? "277px" : "auto" ));
        }

        /* 新增：防止横向滚动的样式 */
        center {
            width: 100%;
            max-width: 100%;
            overflow-x: hidden;
        }

        #AboveTable, .napbox, .npbx, .ajax_tab_menu, .modalPopup {
            max-width: 100%;
            overflow-x: hidden;
        }

        table {
            max-width: 100%;
            table-layout: fixed;
        }

        /* 确保输入框等元素不超出容器 */
        .npbxs, .mline, .npbtn {
            max-width: 100%;
        }

        .CKEditor, .inpu, .NumberBox {
            max-width: 100%;
            box-sizing: border-box;
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script src="js/My97DatePicker/WdatePicker.js"></script>

    <link href="js/layer/mobile/need/layer.css" rel="stylesheet" />
    <script src="js/layer/mobile/layer.js"></script>
    <script src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

    <script src="js/exif.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        $(function () { initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能

            //选择图片后压缩图片
            $("#TabContainer1_TabPanel2_AttachFile").change(function () {

                //alert("KKK");

                //console.log(this.files[0]);
                var _ua = window.navigator.userAgent;
                var _simpleFile = this.files[0];
                //判断是否为图片
                if (!/\/(?:jpeg|png|gif|png|bmp)/i.test(_simpleFile.type)) return;

                //插件exif.js获取ios图片的方向信息
                var _orientation;
                //if (_ua.indexOf('iphone') > 0) {
                EXIF.getData(_simpleFile, function () {
                    _orientation = EXIF.getTag(this, 'Orientation');
                });
                //}

                //1.读取文件，通过FileReader，将图片文件转化为DataURL，即data:img/png;base64，开头的url，可以直接放在image.src中;
                var _reader = new FileReader(),
                    _img = new Image(),
                    _url;

                _reader.onload = function () {
                    _img.onload = function () {
                        var data = compress(_img);
                        $("#TabContainer1_TabPanel2_imgData").val(compress(_img, _orientation));
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


                //判断是否是tree，或者分页
                if (click != "" && click != null && click != undefined) {
                    if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                        $(this).click(function () {

                            if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {

                                popShowByURL(url, 800, 600, window.location);
                                return false;
                            }

                            //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, 800, 600,window.location);


                        });
                    }
                }
                else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
                    $(this).click(function () {
                        if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1) {

                            if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {

                                popShowByURL(url, 800, 600, window.location);
                                return false;
                            }

                            //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, 800, 600,window.location);


                        }
                    });
                }

            });
        }



        /**
         * 计算图片的尺寸，根据尺寸压缩
         * 1. iphone手机html5上传图片方向问题，借助exif.js
         * 2. 安卓UC浏览器不支持 new Blob()，使用BlobBuilder
         * @param {Object} _img     图片
         * @param {Number} _orientation 照片信息
         * @return {String}       压缩后base64格式的图片
         */
        function compress(_img, _orientation) {
            //2.计算符合目标尺寸宽高值，若上传图片的宽高都大于目标图，对目标图等比压缩；如果有一边小于，对上传图片等比放大。
            var _goalWidth = 640,         //目标宽度
                _goalHeight = 480,         //目标高度
                _imgWidth = _img.naturalWidth,   //图片宽度
                _imgHeight = _img.naturalHeight,  //图片高度
                _tempWidth = _imgWidth,      //放大或缩小后的临时宽度
                _tempHeight = _imgHeight,     //放大或缩小后的临时宽度
                _r = 0;              //压缩比

            if (_imgWidth > _goalWidth || _imgHeight > _goalHeight) {//宽或高大于目标图，需等比压缩
                _r = _imgWidth / _goalWidth;
                if (_imgHeight / _goalHeight < _r) {
                    _r = _imgHeight / _goalHeight;
                }
                _tempWidth = Math.ceil(_imgWidth / _r);
                _tempHeight = Math.ceil(_imgHeight / _r);
            }

            //3.利用canvas对图片进行裁剪，等比放大或缩小后进行居中裁剪
            var _canvas = $("#myCanvas")[0];

            var _context = _canvas.getContext('2d');
            _canvas.width = _tempWidth;
            _canvas.height = _tempHeight;
            var _degree;

            //ios bug，iphone手机上可能会遇到图片方向错误问题
            switch (_orientation) {
                //iphone横屏拍摄，此时home键在左侧
                case 3:
                    _degree = 180;
                    _tempWidth = -_imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone竖屏拍摄，此时home键在下方(正常拿手机的方向)
                case 6:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 90;
                    _tempWidth = _imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone竖屏拍摄，此时home键在上方
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
            //toDataURL方法，可以获取格式为"data:image/png;base64,***"的base64图片信息；
            var _data = _canvas.toDataURL('image/jpeg');
            return _data;
        }

        function upload() {
            $.ajax({
                //提交数据的类型 POST GET
                type: "POST",
                //提交的网址
                url: "Handler/UploadPhotoToServerSite.ashx",
                //提交的数据
                data: { FileData: $("#TabContainer1_TabPanel2_imgData").val(), FileName: $("#TabContainer1_TabPanel2_AttachFile").val() },
                //返回数据的格式
                //在请求之前调用的函数
                beforeSend: function () {
                    $("#IMG_Waiting").show();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                },
                //成功返回之后调用的函数
                success: function (data) {
                    if (data.indexOf("img") > 0) {

                        $(document.getElementsByTagName("iframe")[0]).contents().find("body").append(data);
                    }
                    else {
                        alert(data);
                    }
                },
                //调用执行后调用的函数
                complete: function (XMLHttpRequest, textStatus) {
                    $("#IMG_Waiting").hide();
                }
            });
        }
    </script>
</head>
<body class="napbac"><div id="swipeFeedback" class="swipe-feedback"><asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" /></div> <!-- 滑动反馈层 -->


    <script type="text/javascript" language="javascript">

        var txtQrCode = '#<%=TB_QrCode.ClientID%>';
        var btnSaveQrCode = '#<%=BT_SaveQrCode.ClientID%>';

        var loadingIndex; //提示层index
        var isWxConfigReady = false; //config是否验证通过
        $(function () { initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能

        

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

                //删除意外弹出层
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
                debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                appId: '<%=signModel.appId %>', // 必填，公众号的唯一标识
                timestamp: '<%=signModel.time %>', // 必填，生成签名的时间戳(随便填写)
                nonceStr: '<%=signModel.randstr %>', // 必填，生成签名的随机串(随便填写)
                signature: '<%=signModel.signstr %>', // 必填，签名，见附录1

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
                    //,

                    //'openEnterpriseChat',
                    //'openEnterpriseContact',
                    //'onMenuShareQZone',
                    //'onVoiceRecordEnd',
                    //'onVoicePlayEnd',
                    //'translateVoice',

                ] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
            });

            wx.ready(function () {
                layer.close(loadingIndex);
                // config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
                isWxConfigReady = true;
            });
            wx.error(function (res) {
                layer.close(loadingIndex);
                alert(JSON.stringify(res));
                // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
            });
        }

        function qrcode() {
            wx.scanQRCode({
                needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
                scanType: ["qrCode", "barCode"], // 可以指定扫二维码还是一维码，默认二者都有
                success: function (res) {
                    var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
                    if (typeof (result) != "undefined") {

                        result = result.substring(result.indexOf(',') + 1, result.length);

                        //文本框赋值
                        $(txtQrCode).val(result);
                        //点击查询按钮
                        $(btnSaveQrCode).click();
                    }
                }
            });

        }
    </script>
    <canvas id="myCanvas" style="display: none;"></canvas>
    <center>
        <form id="form1" runat="server" method="post" enctype="multipart/form-data">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td height="31" class="page_topbj">
                                            <table width="94%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class="ItemAlignLeft">
                                                        <%--<a href="TTAppTask.aspx" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">--%>
                                                        <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                            <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td width="29">
                                                                        <img src="ImagesSkin/return.png" alt="" />
                                                                    </td>
                                                                    <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                                        <asp:Label runat="server" Text="<%$ Resources:lang,Back%>" />
                                                                    </td>
                                                                    <td width="5">
                                                                        <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
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
                                                        <span class="style1">
                                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,RenWu%>"></asp:Label>:<asp:Label ID="LB_TaskID" runat="server"></asp:Label>
                                                            <asp:Label ID="LB_Task" runat="server"></asp:Label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" class="ItemAlignLeft">
                                                        <cc1:TabContainer CssClass="ajax_tab_menu" ID="TabContainer1" runat="server" ActiveTabIndex="0" Width="100%">
                                                            <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="TaskHandling">
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,RenWuChuLi%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ContentTemplate>
                                                                    <table width="100%" cellpadding="3" cellspacing="0">
                                                                        <tr>
                                                                            <td>
                                                                                <div class="napbox">
                                                                                    <div class="npbx">
                                                                                        <div class="cline"></div>
                                                                                        <div class="npbxs">
                                                                                            <h3>
                                                                                                <asp:HyperLink ID="HL_StartupBusinessForm" runat="server" Text="<%$ Resources:lang,XiangGuanYeWuDan %>"></asp:HyperLink>
                                                                                                <asp:HyperLink ID="HL_GoodsApplication" runat="server" Text="<%$ Resources:lang,LiaoPingLingYong %>"></asp:HyperLink>
                                                                                                <asp:Image ID="IMG_QrCode" runat="server" CssClass="inpuQrCode"  onclick="qrcode()"  Width="16px" />
                                                                                                <asp:Button ID="BT_SaveQrCode" runat="server"  Style="display: none;" CssClass="inpuQrCode" Text="<%$ Resources:lang,BaoCun %>" OnClick="BT_SaveQrCode_Click" />
                                                                                                <asp:TextBox ID="TB_QrCode" runat="server" Style="display: none;"></asp:TextBox>
                                                                                                <%--<asp:Button ID="BT_Qrcode" runat="server" CssClass="inpuQrCode"  OnClientClick="qrcode()" />--%>
                                                                                            </h3>

                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,JinDu %>"></asp:Label></h4>

                                                                                                <NickLee:NumberBox ID="NB_FinishPercent" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" OnBlur="" OnFocus="" OnKeyPress="" PositiveColor="" Precision="0" Width="94%">0</NickLee:NumberBox>
                                                                                                <asp:Label ID="Label1" runat="server" Text="%"></asp:Label>
                                                                                            </div>
                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="LB_TaskProgress" runat="server" Text="<%$ Resources:lang,ZhengTi %>"></asp:Label></h4>

                                                                                                <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000" ID="NB_TaskProgress" runat="server" OnBlur="" OnFocus="" OnKeyPress="" Enabled="False"
                                                                                                    PositiveColor="" Precision="0" Width="94%">0</NickLee:NumberBox>
                                                                                                <asp:Label ID="Label52" runat="server" Text="%"></asp:Label>
                                                                                            </div>
                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,GongShi2 %>"></asp:Label></h4>

                                                                                                <NickLee:NumberBox ID="NB_ManHour" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" OnBlur="" OnFocus="" OnKeyPress="" PositiveColor="" Width="99%">0.00</NickLee:NumberBox>
                                                                                            </div>
                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="Label41" runat="server" Text="<%$ Resources:lang,YiWanChengLiang%>" /></h4>

                                                                                                <NickLee:NumberBox ID="NB_FinishedNumber" runat="server" MaxAmount="1000000000000" MinAmount="0" Width="99%" OnBlur="" OnFocus="" OnKeyPress="" PositiveColor="">0.00</NickLee:NumberBox>
                                                                                            </div>
                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="LB_UnitName" runat="server"></asp:Label></h4>
                                                                                                <br />
                                                                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,FeiYong %>" Visible="False"></asp:Label>
                                                                                                <NickLee:NumberBox ID="TB_Expense" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" OnBlur="" OnFocus="" OnKeyPress="" PositiveColor="" Width="99%" Visible="False">0.00</NickLee:NumberBox>
                                                                                            </div>
                                                                                        </div>



                                                                                        <div class="npbxs">

                                                                                            <h3>
                                                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZongJie %>"></asp:Label></h3>

                                                                                            <CKEditor:CKEditorControl ID="HE_FinishContent" runat="server" Height="170px" Toolbar="" Visible="False" Width="99%"></CKEditor:CKEditorControl>

                                                                                            <CKEditor:CKEditorControl ID="HT_FinishContent" runat="server" Height="170px" Toolbar="" Visible="False" Width="99%" />

                                                                                            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                                                                                <ContentTemplate>
                                                                                                    <div class="nmar">
                                                                                                        <Upload:InputFile ID="AttachFile" runat="server" name="photo" Accept="image/*;capture=camera" Width="180px" />
                                                                                                        <input type="hidden" val="" id="imgData" runat="server" />
                                                                                                        &nbsp;<input type="button" id="BtnUP" onclick="upload()" value="Upload" />
                                                                                                        <img id="IMG_Uploading" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />

                                                                                                        <br />

                                                                                                        <%--<div id="ProgressBar">
                                                                                                    <Upload:ProgressBar ID="ProgressBar1" runat='server' Width="500px" Height="100px">
                                                                                                    </Upload:ProgressBar>
                                                                                                </div>--%>
                                                                                                    </div>
                                                                                                </ContentTemplate>
                                                                                            </asp:UpdatePanel>

                                                                                            <div class="manyspan" style="display: none;">

                                                                                                <asp:CheckBox ID="CB_ReturnMsg" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaXinXi %>" />

                                                                                                <asp:CheckBox ID="CB_ReturnMail" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaYouJian %>" />

                                                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,TongZhiFenPaiRen %>"></asp:Label>

                                                                                                <asp:TextBox ID="TB_Message" runat="server" Width="45%"></asp:TextBox>

                                                                                                <asp:Button ID="BT_Send" runat="server" CssClass="inpu" OnClick="BT_Send_Click" Text="<%$ Resources:lang,FaSong %>" />

                                                                                                <asp:Label ID="LB_AssignID" runat="server" Visible="False"></asp:Label>

                                                                                                <asp:Label ID="LB_RouteNumber" runat="server" Visible="False"></asp:Label>
                                                                                            </div>

                                                                                            <div class="npbtn">
                                                                                                <asp:Button ID="BT_Activity" runat="server" CssClass="inpu" OnClick="BT_Activity_Click" Text="<%$ Resources:lang,BaoCun %>" />

                                                                                                <asp:Button ID="BT_Finish" runat="server" CssClass="inpu" Font-Bold="True" OnClick="BT_Finish_Click" Text="<%$ Resources:lang,WanChengTiJiao %>" />
                                                                                                &nbsp;&nbsp;
                                                                                                <asp:Button ID="BT_ConfirmEffectPlanProgress" runat="server" CssClass="inpu" Text="<%$ Resources:lang,QueRenJinDu %>" OnClick="BT_ConfirmEffectPlanProgress_Click" />

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
                                                                </ContentTemplate>
                                                            </cc1:TabPanel>
                                                            <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="继续分派">
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,JiXuFenPai%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ContentTemplate>



                                                                    <table width="100%" cellpadding="3" cellspacing="0">
                                                                        <tr>
                                                                            <td>

                                                                                <div class="napbox">
                                                                                    <div class="npbx">
                                                                                        <div class="cline"></div>
                                                                                        <div class="npbxs">



                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,LeiXing %>"></asp:Label>
                                                                                                    <asp:Label ID="LB_ID" runat="server" Visible="False"></asp:Label>

                                                                                                </h4>
                                                                                                <asp:DropDownList ID="DL_RecordType" runat="server" DataTextField="Type" DataValueField="Type" Width="99%">
                                                                                                </asp:DropDownList>

                                                                                            </div>
                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,ShouLiRen %>"></asp:Label>
                                                                                                </h4>
                                                                                                <asp:TextBox ID="TB_OperatorCode" runat="server" Width="99%"></asp:TextBox>

                                                                                                <cc1:ModalPopupExtender ID="TB_OperatorCode_ModalPopupExtender" runat="server" BackgroundCssClass="modalBackground" CancelControlID="IMBT_Close" DynamicServicePath="" Enabled="True" PopupControlID="Panel1" TargetControlID="TB_OperatorCode" Y="150">
                                                                                                </cc1:ModalPopupExtender>

                                                                                                <asp:Label ID="LB_OperatorManName" runat="server"></asp:Label>
                                                                                            </div>


                                                                                        </div>



                                                                                        <div class="npbxs">

                                                                                            <h3>
                                                                                                <asp:Label ID="Label45" runat="server" Text="<%$ Resources:lang,YaoQiu %>"></asp:Label>

                                                                                            </h3>

                                                                                            <CKEditor:CKEditorControl ID="HE_Operation" runat="server" Width="99%" Height="80px" Visible="False" Toolbar="" />

                                                                                            <CKEditor:CKEditorControl ID="HT_Operation" runat="server" Width="99%" Height="80px" Visible="False" Toolbar="" />

                                                                                            <asp:DropDownList ID="DL_WorkRequest" runat="server" AutoPostBack="True" DataTextField="Operation" Width="99%"
                                                                                                DataValueField="Operation" OnSelectedIndexChanged="DL_WorkRequest_SelectedIndexChanged">
                                                                                            </asp:DropDownList>

                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,KaiShi %>"></asp:Label>
                                                                                                </h4>
                                                                                                <asp:TextBox ID="DLC_BeginDate" runat="server" Width="99%" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" onFocus="WdatePicker({lang:'auto'})"></asp:TextBox>

                                                                                            </div>

                                                                                            <div class="mline">
                                                                                                <h4>
                                                                                                    <asp:Label ID="Label47" runat="server" Text="<%$ Resources:lang,JieShu %>"></asp:Label>

                                                                                                </h4>
                                                                                                <asp:TextBox ID="DLC_EndDate" runat="server" Width="99%" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" onFocus="WdatePicker({lang:'auto'})"></asp:TextBox>

                                                                                            </div>



                                                                                            <div class="manyspan" style="display: none;">


                                                                                                <asp:CheckBox ID="CB_SendMsg" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaXinXi %>" />

                                                                                                <asp:CheckBox ID="CB_SendMail" runat="server" Font-Bold="False" Text="<%$ Resources:lang,FaYouJian %>" />

                                                                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,TongZhiShouLiRen %>"></asp:Label>

                                                                                                <asp:TextBox ID="TB_AssignMessage" runat="server" Width="45%"></asp:TextBox>

                                                                                                <asp:Button ID="BT_SendAssignMsg" runat="server" CssClass="inpu" OnClick="BT_SendAssignMsg_Click"
                                                                                                    Text="<%$ Resources:lang,FaSong %>" />

                                                                                            </div>

                                                                                            <div class="npbtn">

                                                                                                <asp:Button ID="BT_UpdateAssign" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_UpdateAssign_Click" Text="<%$ Resources:lang,BaoCun %>" />
                                                                                                &nbsp;
                                                                                                <asp:Button ID="BT_DeleteAssign" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_DeleteAssign_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu %>" />
                                                                                                &nbsp;
                                                                                                <asp:Button ID="BT_Assign" runat="server" CssClass="inpu" OnClick="BT_Assign_Click" Text="<%$ Resources:lang,FenPai %>" />
                                                                                            </div>


                                                                                            <div class="npbxs">
                                                                                                <h3>
                                                                                                    <strong>
                                                                                                        <asp:Label ID="Label49" runat="server" Text="<%$ Resources:lang,CiRenWuFenPaiJiLuZiJiLu %>"></asp:Label>（<span style="font-size: 9pt"><asp:Label ID="Label50" runat="server" Text="<%$ Resources:lang,XuanZeKeZaiShangMianXiuGai %>"></asp:Label>）:</span></strong>

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
                                                                                                                            CssClass="inpu" />
                                                                                                                    </div>
                                                                                                                    <div class="nprig">

                                                                                                                        <h5><%# DataBinder.Eval(Container.DataItem,"OperatorName") %>  <sub></sub></h5>
                                                                                                                        <h6><%# DataBinder.Eval(Container.DataItem,"Operation") %></h6>

                                                                                                                    </div>
                                                                                                                </div>

                                                                                                            </ItemTemplate>
                                                                                                        </asp:TemplateColumn>


                                                                                                    </Columns>


                                                                                                    <%-- <EditItemStyle BackColor="#2461BF" />--%>
                                                                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />

                                                                                                    <%-- <ItemStyle CssClass="itemStyle" />--%>

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
                                                                </ContentTemplate>
                                                            </cc1:TabPanel>
                                                        </cc1:TabContainer>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td class="formItemBgStyleForAlignLeft">
                                <asp:HyperLink ID="HL_TaskReview" runat="server" Enabled="False">---&gt;<asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,RenWuPingShen%>"></asp:Label></asp:HyperLink>

                                <asp:HyperLink ID="HL_MakeProjectReq" runat="server">--&gt;<asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,JianLiHeFenPaiXuQiu%>"></asp:Label></asp:HyperLink>

                                <asp:HyperLink ID="HL_TestCase" runat="server" NavigateUrl="TTMakeTaskTestCase.aspx">
                                    <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,CeShiYongLi%>"></asp:Label>
                                </asp:HyperLink>

                                <asp:HyperLink ID="HL_TaskRelatedDoc" runat="server" NavigateUrl="TTProTaskRelatedDoc.aspx">
                                    <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,XiangGuanWenDang%>"></asp:Label>
                                </asp:HyperLink>

                                <asp:HyperLink ID="HL_TaskAssignRecord" runat="server" NavigateUrl="TTTaskAssignRecord.aspx">
                                    <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,SuoYouFenPaiJiLu%>"></asp:Label>
                                </asp:HyperLink>

                                <asp:HyperLink ID="HL_ProjectDetail" runat="server">
                                    <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,DangTianXiangMuRiZhi%>"></asp:Label>
                                </asp:HyperLink>

                                （<asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,GuanLianXiangMu%>"></asp:Label>:<asp:HyperLink ID="HL_RelatedProjectID"
                                    runat="server">[HL_RelatedProjectID]</asp:HyperLink>

                                <asp:HyperLink ID="HL_RelatedProjectName" runat="server">[HL_RelatedProjectID]</asp:HyperLink>
                                ）<asp:Label ID="LB_ProjectID" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="LB_UserName" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="LB_PlanID" runat="server" Visible="False"></asp:Label>
                                <asp:HyperLink ID="HL_Expense" runat="server" NavigateUrl="TTProExpense.aspx">
                                    <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,FeiYongMingXi%>"></asp:Label>
                                </asp:HyperLink>
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
                                    <ItemStyle BackColor="#EFF3FB" />
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                </asp:DataList>
                            </td>
                            <td width="35%" style="text-align: left; background-color: #EFF3FB;">
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
                                    <ItemStyle BackColor="#EFF3FB" />
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                </asp:DataList>
                            </td>
                        </tr>
                    </table>
                    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Style="display: none;">
                        <div class="modalPopup-text" style="width: 273px; height: 400px; overflow: auto;">
                            <table>
                                <tr>
                                    <td style="padding: 5px 5px 0px 5px; text-align: left; vertical-align: top;" width="200px"
                                        class="formItemBgStyleForAlignLeft">
                                        <asp:TreeView ID="TreeView2" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView2_SelectedNodeChanged"
                                            ShowLines="True" Width="220px">
                                            <RootNodeStyle CssClass="rootNode" />
                                            <NodeStyle CssClass="treeNode" />
                                            <LeafNodeStyle CssClass="leafNode" />
                                            <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                        </asp:TreeView>
                                    </td>
                                    <td style="width: 60px; padding: 2px 2px 2px 2px;" valign="top" class="ItemAlignLeft">
                                        <asp:ImageButton ID="IMBT_Close" ImageUrl="ImagesSkin/Close4.jpg" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </center>
</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>
