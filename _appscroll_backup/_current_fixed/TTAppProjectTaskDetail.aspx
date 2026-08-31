�?%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppProjectTaskDetail.aspx.cs" Inherits="TTAppProjectTaskDetail" %>

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
            initSwipeBack();// 鍒濆鍖栨粦鍔ㄨ繑鍥炲姛�?

            //閫夋嫨鍥剧墖鍚庡帇缂╁浘�?
            $("#AttachFile").change(function () {
                var _ua = window.navigator.userAgent;
                var _simpleFile = this.files[0];
                //鍒ゆ柇鏄惁涓哄浘鐗?
                if (!/\/(?:jpeg|png|gif|png|bmp)/i.test(_simpleFile.type)) return;

                //鎻掍欢exif.js鑾峰彇ios鍥剧墖鐨勬柟鍚戜俊鎭?
                var _orientation;
                EXIF.getData(_simpleFile, function () {
                    _orientation = EXIF.getTag(this, 'Orientation');
                });

                //1.璇诲彇鏂囦欢锛岄€氳繃FileReader锛屽皢鍥剧墖鏂囦欢杞寲涓篋ataURL锛屽嵆data:img/png;base64锛屽紑澶寸殑url锛屽彲浠ョ洿鎺ユ斁鍦╥mage.src�?
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


                //鍒ゆ柇鏄惁鏄痶ree锛屾垨鑰呭垎�?
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
         * 璁＄畻鍥剧墖鐨勫昂瀵革紝鏍规嵁灏哄鍘嬬缉
         * 1. iphone鎵嬫満html5涓婁紶鍥剧墖鏂瑰悜闂锛屽€熷姪exif.js
         * 2. 瀹夊崜UC娴忚鍣ㄤ笉鏀寔 new Blob()锛屼娇鐢˙lobBuilder
         * @param {Object} _img     鍥剧�?         * @param {Number} _orientation 鐓х墖淇℃�?         * @return {String}       鍘嬬缉鍚巄ase64鏍煎紡鐨勫浘�?
         */
        function compress(_img, _orientation) {
            //2.璁＄畻绗﹀悎鐩爣灏哄瀹介珮鍊硷紝鑻ヤ笂浼犲浘鐗囩殑瀹介珮閮藉ぇ浜庣洰鏍囧浘锛屽鐩爣鍥剧瓑姣斿帇缂╋紱濡傛灉鏈変竴杈瑰皬浜庯紝瀵逛笂浼犲浘鐗囩瓑姣旀斁澶с�?
            var _goalWidth = 640,         //鐩爣瀹藉�?                _goalHeight = 480,         //鐩爣楂樺害
                _imgWidth = _img.naturalWidth,   //鍥剧墖瀹藉�?                _imgHeight = _img.naturalHeight,  //鍥剧墖楂樺害
                _tempWidth = _imgWidth,      //鏀惧ぇ鎴栫缉灏忓悗鐨勪复鏃跺�?
                _tempHeight = _imgHeight,     //鏀惧ぇ鎴栫缉灏忓悗鐨勪复鏃跺�?
                _r = 0;              //鍘嬬缉姣?

            if (_imgWidth > _goalWidth || _imgHeight > _goalHeight) {//瀹芥垨楂樺ぇ浜庣洰鏍囧浘锛岄渶绛夋瘮鍘嬬�?                _r = _imgWidth / _goalWidth;
                if (_imgHeight / _goalHeight < _r) {
                    _r = _imgHeight / _goalHeight;
                }
                _tempWidth = Math.ceil(_imgWidth / _r);
                _tempHeight = Math.ceil(_imgHeight / _r);
            }

            //3.鍒╃敤canvas瀵瑰浘鐗囪繘琛岃鍓紝绛夋瘮鏀惧ぇ鎴栫缉灏忓悗杩涜灞呬腑瑁佸壀
            var _canvas = $("#myCanvas")[0];

            var _context = _canvas.getContext('2d');
            _canvas.width = _tempWidth;
            _canvas.height = _tempHeight;
            var _degree;

            //ios bug锛宨phone鎵嬫満涓婂彲鑳戒細閬囧埌鍥剧墖鏂瑰悜閿欒闂�?            switch (_orientation) {
                //iphone妯睆鎷嶆憚锛屾鏃秇ome閿湪宸︿晶
                case 3:
                    _degree = 180;
                    _tempWidth = -_imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone绔栧睆鎷嶆憚锛屾鏃秇ome閿湪涓嬫柟(姝ｅ父鎷挎墜鏈虹殑鏂瑰悜)
                case 6:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 90;
                    _tempWidth = _imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone绔栧睆鎷嶆憚锛屾鏃秇ome閿湪涓婃柟
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
            //toDataURL鏂规硶锛屽彲浠ヨ幏鍙栨牸寮忎�?data:image/png;base64,***"鐨刡ase64鍥剧墖淇℃伅�?
            var _data = _canvas.toDataURL('image/jpeg');
            return _data;
        }

        function upload() {
            $.ajax({
                //鎻愪氦鏁版嵁鐨勭被鍨?POST GET
                type: "POST",
                //鎻愪氦鐨勭綉鍧€
                url: "Handler/UploadPhotoToServerSite.ashx",
                //鎻愪氦鐨勬暟�?
                data: { FileData: $("#imgData").val(), FileName: $("#AttachFile").val() },
                //杩斿洖鏁版嵁鐨勬牸寮?
                //鍦ㄨ姹備箣鍓嶈皟鐢ㄧ殑鍑芥�?                beforeSend: function () {
                    $("#IMG_Waiting").show();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                },
                //鎴愬姛杩斿洖涔嬪悗璋冪敤鐨勫嚱鏁?
                success: function (data) {
                    if (data.indexOf("img") > 0) {

                        $(document.getElementsByTagName("iframe")[0]).contents().find("body").append(data);
                    }
                    else {
                        alert(data);
                    }
                },
                //璋冪敤鎵ц鍚庤皟鐢ㄧ殑鍑芥暟
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
    <!-- 婊戝姩鍙嶉�?-->

    <script type="text/javascript" language="javascript">

        var txtQrCode = '#<%=TB_QrCode.ClientID%>';
        var btnSaveQrCode = '#<%=BT_SaveQrCode.ClientID%>';

        var loadingIndex; //鎻愮ず灞俰ndex
        var isWxConfigReady = false; //config鏄惁楠岃瘉閫氳�?        $(function () {
            initSwipeBack();// 鍒濆鍖栨粦鍔ㄨ繑鍥炲姛�? initSwipeBack();// 鍒濆鍖栨粦鍔ㄨ繑鍥炲姛�?



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

                //鍒犻櫎鎰忓寮瑰嚭灞?
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
                debug: false, // 寮€鍚皟璇曟ā寮?璋冪敤鐨勬墍鏈塧pi鐨勮繑鍥炲€间細鍦ㄥ鎴风alert鍑烘潵锛岃嫢瑕佹煡鐪嬩紶鍏ョ殑鍙傛暟锛屽彲浠ュ湪pc绔墦寮€锛屽弬鏁颁俊鎭細閫氳繃log鎵撳嚭锛屼粎鍦╬c绔椂鎵嶄細鎵撳嵃銆?
                appId: '<%=signModel.appId %>', // 蹇呭～锛屽叕浼楀彿鐨勫敮涓€鏍囪�?                timestamp: '<%=signModel.time %>', // 蹇呭～锛岀敓鎴愮鍚嶇殑鏃堕棿�?闅忎究濉啓)
                nonceStr: '<%=signModel.randstr %>', // 蹇呭～锛岀敓鎴愮鍚嶇殑闅忔満�?闅忎究濉啓)
                signature: '<%=signModel.signstr %>', // 蹇呭～锛岀鍚嶏紝瑙侀檮褰?

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
                ] // 蹇呭～锛岄渶瑕佷娇鐢ㄧ殑JS鎺ュ彛鍒楄〃锛屾墍鏈塉S鎺ュ彛鍒楄〃瑙侀檮褰?
            });

            wx.ready(function () {
                layer.close(loadingIndex);
                // config淇℃伅楠岃瘉鍚庝細鎵цready鏂规硶锛屾墍鏈夋帴鍙ｈ皟鐢ㄩ兘蹇呴』鍦╟onfig鎺ュ彛鑾峰緱缁撴灉涔嬪悗锛宑onfig鏄竴涓鎴风鐨勫紓姝ユ搷浣滐紝鎵€浠ュ鏋滈渶瑕佸湪椤甸潰鍔犺浇鏃跺氨璋冪敤鐩稿叧鎺ュ彛锛屽垯椤绘妸鐩稿叧鎺ュ彛鏀惧湪ready鍑芥暟涓皟鐢ㄦ潵纭繚姝ｇ‘鎵ц銆傚浜庣敤鎴疯Е鍙戞椂鎵嶈皟鐢ㄧ殑鎺ュ彛锛屽垯鍙互鐩存帴璋冪敤锛屼笉闇€瑕佹斁鍦╮eady鍑芥暟涓€?
                isWxConfigReady = true;
            });
            wx.error(function (res) {
                layer.close(loadingIndex);
                alert(JSON.stringify(res));
                // config淇℃伅楠岃瘉澶辫触浼氭墽琛宔rror鍑芥暟锛屽绛惧悕杩囨湡瀵艰嚧楠岃瘉澶辫触锛屽叿浣撻敊璇俊鎭彲浠ユ墦寮€config鐨刣ebug妯″紡鏌ョ湅锛屼篃鍙互鍦ㄨ繑鍥炵殑res鍙傛暟涓煡鐪嬶紝瀵逛簬SPA鍙互鍦ㄨ繖閲屾洿鏂扮鍚嶃�?
            });
        }

        function qrcode() {
            wx.scanQRCode({
                needResult: 1, // 榛樿涓?锛屾壂鎻忕粨鏋滅敱寰俊澶勭悊锛?鍒欑洿鎺ヨ繑鍥炴壂鎻忕粨鏋滐�?                scanType: ["qrCode", "barCode"], // 鍙互鎸囧畾鎵簩缁寸爜杩樻槸涓€缁寸爜锛岄粯璁や簩鑰呴兘鏈?
                success: function (res) {
                    var result = res.resultStr; // 褰搉eedResult �?1 鏃讹紝鎵爜杩斿洖鐨勭粨�?
                    if (typeof (result) != "undefined") {

                        result = result.substring(result.indexOf(',') + 1, result.length);

                        //鏂囨湰妗嗚祴�?
                        $(txtQrCode).val(result);
                        //鐐瑰嚮鏌ヨ鎸夐�?                        $(btnSaveQrCode).click();
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
                                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5"></td>
                                                    </tr>
                                                </table>
                                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="璇风◢鍊欙紝澶勭悊涓?.." style="display: none;" />
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
                                                                        <asp:HyperLink ID="HL_StartupBusinessForm" runat="server" Text="<%$ Resources:lang,XiangGuanYeWuDan %>" Visible="false"></asp:HyperLink>
                                                                        <asp:HyperLink ID="HL_GoodsApplication" runat="server" Text="<%$ Resources:lang,LiaoPingLingYong %>" Visible="false" ></asp:HyperLink>
                                                                        <asp:Image ID="IMG_QrCode" runat="server" CssClass="inpuQrCode" onclick="qrcode()" Width="16px" />
                                                                        <asp:Button ID="BT_SaveQrCode" runat="server" Style="display: none;" CssClass="inpuQrCode" Text="<%$ Resources:lang,BaoCun %>" OnClick="BT_SaveQrCode_Click" />
                                                                        <asp:TextBox ID="TB_QrCode" runat="server" Style="display: none;"></asp:TextBox>
                                                                    </h3>

                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,JinDu %>"></asp:Label></h4>

                                                                        <NickLee:NumberBox ID="NB_FinishPercent" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" OnBlur="" OnFocus="" OnKeyPress="" PositiveColor="" Precision="0" Width="94%">0</NickLee:NumberBox><asp:Label ID="Label1" runat="server" Text="%"></asp:Label>
                                                                    </div>
                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="LB_TaskProgress" runat="server" Text="<%$ Resources:lang,ZhengTi %>"></asp:Label></h4>

                                                                        <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000" ID="NB_TaskProgress" runat="server" OnBlur="" OnFocus="" OnKeyPress="" Enabled="False"
                                                                            PositiveColor="" Precision="0" Width="94%">
                                                                            0</NickLee:NumberBox><asp:Label ID="Label52" runat="server" Text="%"></asp:Label>
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
                                                                                            <img id="IMG_Uploading" src="Images/Processing.gif" alt="璇风◢鍊欙紝澶勭悊涓?.." style="display: none;" />
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

                                                                        <asp:Button ID="BT_Send" runat="server" CssClass="inpu" OnClick="BT_Send_Click" Text="<%$ Resources:lang,FaSong %>" />

                                                                        <asp:Label ID="LB_AssignID" runat="server" Visible="False"></asp:Label>

                                                                        <asp:Label ID="LB_RouteNumber" runat="server" Visible="False"></asp:Label>
                                                                    </div>

                                                                    <div class="equal-buttons">
                                                                        <asp:Button ID="BT_Activity" runat="server" CssClass="inpu" OnClick="BT_Activity_Click" Text="<%$ Resources:lang,BaoCun %>" />
                                                                        <asp:Button ID="BT_Finish" runat="server" CssClass="inpu" OnClick="BT_Finish_Click" Text="<%$ Resources:lang,WanChengTiJiao %>" />
                                                                        <asp:Button ID="BT_ConfirmEffectPlanProgress" runat="server" CssClass="inpu" Text="<%$ Resources:lang,QueRenJinDu %>" OnClick="BT_ConfirmEffectPlanProgress_Click" />
                                                                    </div>

                                                                    <div class="equal-buttons">
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
                                                                            <asp:Label ID="LB_ID" runat="server" Visible="False"></asp:Label>

                                                                        </h4>
                                                                        <asp:DropDownList ID="DL_RecordType" runat="server" DataTextField="Type" DataValueField="Type" Width="99%">
                                                                        </asp:DropDownList>

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
                                                                        <asp:Label ID="Label45" runat="server" Text="<%$ Resources:lang,YaoQiu %>"></asp:Label>

                                                                    </h3>

                                                                    <CKEditor:CKEditorControl ID="HE_Operation" runat="server" Width="99%" Height="80px" Visible="False" Toolbar="" />



                                                                    <asp:DropDownList ID="DL_WorkRequest" runat="server" AutoPostBack="True" DataTextField="Operation" Width="99%"
                                                                        DataValueField="Operation" OnSelectedIndexChanged="DL_WorkRequest_SelectedIndexChanged">
                                                                    </asp:DropDownList>

                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,KaiShi %>"></asp:Label>
                                                                        </h4>

                                                                        <asp:TextBox ID="DLC_BeginDate" ReadOnly="false" runat="server" Width="99%"> </asp:TextBox>
                                                                        <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender1" runat="server"
                                                                            TargetControlID="DLC_BeginDate">
                                                                        </ajaxToolkit:CalendarExtender>
                                                                    </div>

                                                                    <div class="mline">
                                                                        <h4>
                                                                            <asp:Label ID="Label47" runat="server" Text="<%$ Resources:lang,JieShu %>"></asp:Label>

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
                                                                    <br />
                                                                    <div class="equal-buttons">
                                                                        <asp:Button ID="BT_Assign" runat="server" CssClass="inpu" OnClick="BT_Assign_Click" Text="<%$ Resources:lang,FenPai %>" />
                                                                        <asp:Button ID="BT_UpdateAssign" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_UpdateAssign_Click" Text="<%$ Resources:lang,BaoCun %>" />
                                                                        <asp:Button ID="BT_DeleteAssign" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_DeleteAssign_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu %>" />

                                                                    </div>


                                                                    <div class="npbxs">
                                                                        <h3>
                                                                            <strong>
                                                                                <asp:Label ID="Label49" runat="server" Text="<%$ Resources:lang,CiRenWuFenPaiJiLuZiJiLu %>"></asp:Label>(<span style="font-size: 9pt"><asp:Label ID="Label50" runat="server" Text="<%$ Resources:lang,XuanZeKeZaiShangMianXiuGai %>"></asp:Label>):</span></strong>

                                                                        </h3>

                                                                        <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                                            ShowHeader="false" ForeColor="#333333" GridLines="None" Height="1px" OnItemCommand="DataGrid2_ItemCommand"
                                                                            Width="99%">

                                                                            <Columns>

                                                                                <asp:TemplateColumn HeaderText="">
                                                                                    <ItemTemplate>

                                                                                        <div class="npb npbs">
                                                                                            <div class="nplef">
                                                                                                <asp:Button ID="BT_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CssClass="tt-sms-btn" />
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

                    <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0">
                        <tr>
                            <td></td>
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

                                (<asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,GuanLianXiangMu%>"></asp:Label>:<asp:HyperLink ID="HL_RelatedProjectID"
                                    runat="server">[HL_RelatedProjectID]</asp:HyperLink>

                                <asp:HyperLink ID="HL_RelatedProjectName" runat="server">[HL_RelatedProjectID]</asp:HyperLink>
                                )<asp:Label ID="LB_ProjectID" runat="server" Visible="False"></asp:Label>
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
                    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Style="display: none;">
                        <div class="modalPopup-text">
                            <div class="modalPopup-content">
                                <div class="modalPopup-header">
                                    <asp:ImageButton ID="IMBT_Close" ImageUrl="ImagesSkin/Close4.jpg" runat="server"
                                        CssClass="modalPopup-close" />
                                </div>
                                <div class="modalPopup-tree">
                                    <asp:TreeView ID="TreeView2" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView2_SelectedNodeChanged"
                                        ShowLines="True" Width="100%">
                                        <RootNodeStyle CssClass="rootNode" />
                                        <NodeStyle CssClass="treeNode" />
                                        <LeafNodeStyle CssClass="leafNode" />
                                        <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                    </asp:TreeView>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
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
