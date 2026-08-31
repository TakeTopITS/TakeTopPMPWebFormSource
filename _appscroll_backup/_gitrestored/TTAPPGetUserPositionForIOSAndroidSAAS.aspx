<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPGetUserPositionForIOSAndroidSAAS.aspx.cs" Inherits="TTAPPGetUserPositionForIOSAndroidSAAS" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />
<meta http-equiv="Content-Type" content="textml; charset=UTF-8" />

<!DOCTYPE html>
<html>


<head runat="server">
    <title></title>
    <link href="css/app.css" rel="stylesheet" type="text/css">
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        #container {
            height: auto !important;
            height: 530px;
            min-height: 530px;
        }

        .round {
            border: 1px solid #dedede;
            border-radius: 10%;
        }
    </style>

    <script type="text/javascript" src="https://lib.sinaapp.com/js/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="https://api.map.baidu.com/api?v=2.0&ak=Mesj2KjbrDAqsfcUrFBY7DNrQ4GZAUS0"></script>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();// 鍒濆鍖栨粦鍔ㄨ繑鍥炲姛鑳? initSwipeBack();// 鍒濆鍖栨粦鍔ㄨ繑鍥炲姛鑳?

        });

    </script>


</head>
<body>
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" />
    </div>
    <!-- 婊戝姩鍙嶉灞?-->
    <form id="form1" runat="server">
        <div id="appScroll" class="app-scroll">
        <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
            <tr>
                <td height="31" class="page_topbj">
                    <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="480" class="ItemAlignLeft">

                                <table width="100%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="30" align="right">
                                            <img src="ImagesSkin/Return.png" alt="" />
                                        </td>
                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                            <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                <asp:Label ID="Label8" runat="server" Style="color: red;" Text="<%$ Resources:lang,Back%>" />
                                            </a>
                                        </td>
                                        <td id="TD_LeaderName" runat="server" class="titleziAPP" align="right">
                                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,ZhuGuan%>" />
                                        </td>
                                        <td id="TD_LeaderList" runat="server" class="titleziAPP" style="text-align: left; padding-top: 5px;">
                                            <asp:DropDownList ID="DL_Leader" DataTextField="LeaderName" DataValueField="LeaderCode" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                        <td class="titleziAPP">
                                            <img id="IMG_Waiting" src="Images/Processing.gif" alt="璇风◢鍊欙紝澶勭悊涓?.." style="display: none;" /></td>
                                    </tr>
                                </table>

                            </td>

                            <td align="right" style="padding-top: 1px; padding-bottom: 1px; padding-right: 8px;">
                                <asp:Button ID="BT_SavePosition" runat="server" CssClass="inpuLong" Height="30px" OnClick="BT_SavePosition_Click" Text="<%$ Resources:lang,DingWeiBingFanHuiZhuYe%>" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="99%">
                        <tr>
                            <td style="width: 50%; text-align: left; vertical-align: middle;">
                                <asp:RadioButtonList ID="RBL_ShiftType" runat="server" TextAlign="Left" CellPadding="10" CellSpacing="10">
                                </asp:RadioButtonList></td>
                            <td style="vertical-align: middle; text-align: center;" class="round">
                                <br />
                                <br />
                                <asp:Button ID="BT_Attendance" runat="server" CssClass="inpuLong" Style="border: 1px solid #dedede; border-radius: 10%;" Width="80%" Height="30px" OnClick="BT_Attendance_Click" Text="<%$ Resources:lang,DaKaBingFanHuiZhuYe%>" />
                                <br />
                                <br />
                                <br />
                            </td>
                        </tr>
                    </table>

                </td>
                <tr>
                    <td>
                        <table width="99%">
                            <tr>
                                <td alight="right" style="vertical-align: middle;">
                                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,Jing%>"></asp:Label>:</td>
                                <td>
                                    <input type="text" id="LNG_value" runat="server" style="width: 125px;" readonly></input>
                                </td>
                                <td style="vertical-align: middle;">
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,Wei%>"></asp:Label>:</td>
                                <td>
                                    <input type="text" id="LAT_value" runat="server" style="width: 125px;" readonly></input>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            <tr>
                <td>
                    <div id="status" style="text-align: center">
                        <a href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';"></a>
                    </div>
                    <div id="container" style="width: 99%; border: 1px solid gray; margin: 5px auto"></div>
                </td>
            </tr>
        </table>
        <asp:Label ID="LB_Sql" runat="server"></asp:Label>
    </div>
    </form>
</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>


<script type="text/javascript">

    var isWxConfigReady = false; //config鏄惁楠岃瘉閫氳繃
    var loadingIndex;
    var mk, map;
    function wxApi() {
        var loadingIndex = layer.open({
            type: 2
            , content: 'ImagesSkin/Processing.gif'
        });
        wx.config({
            debug: false, // 寮€鍚皟璇曟ā寮?璋冪敤鐨勬墍鏈塧pi鐨勮繑鍥炲€间細鍦ㄥ鎴风alert鍑烘潵锛岃嫢瑕佹煡鐪嬩紶鍏ョ殑鍙傛暟锛屽彲浠ュ湪pc绔墦寮€锛屽弬鏁颁俊鎭細閫氳繃log鎵撳嚭锛屼粎鍦╬c绔椂鎵嶄細鎵撳嵃銆?
            appId: '<%=signModel.appId %>', // 蹇呭～锛屽叕浼楀彿鐨勫敮涓€鏍囪瘑
            timestamp: '<%=signModel.time %>', // 蹇呭～锛岀敓鎴愮鍚嶇殑鏃堕棿鎴?闅忎究濉啓)
            nonceStr: '<%=signModel.randstr %>', // 蹇呭～锛岀敓鎴愮鍚嶇殑闅忔満涓?闅忎究濉啓)
            signature: '<%=signModel.signstr %>', // 蹇呭～锛岀鍚嶏紝瑙侀檮褰?

            jsApiList: [
                'getLocation',
                'openLocation'
            ] // 蹇呭～锛岄渶瑕佷娇鐢ㄧ殑JS鎺ュ彛鍒楄〃锛屾墍鏈塉S鎺ュ彛鍒楄〃瑙侀檮褰?
        });


        wx.ready(function () {
            layer.close(loadingIndex);
            // config淇℃伅楠岃瘉鍚庝細鎵цready鏂规硶锛屾墍鏈夋帴鍙ｈ皟鐢ㄩ兘蹇呴』鍦╟onfig鎺ュ彛鑾峰緱缁撴灉涔嬪悗锛宑onfig鏄竴涓鎴风鐨勫紓姝ユ搷浣滐紝鎵€浠ュ鏋滈渶瑕佸湪椤甸潰鍔犺浇鏃跺氨璋冪敤鐩稿叧鎺ュ彛锛屽垯椤绘妸鐩稿叧鎺ュ彛鏀惧湪ready鍑芥暟涓皟鐢ㄦ潵纭繚姝ｇ‘鎵ц銆傚浜庣敤鎴疯Е鍙戞椂鎵嶈皟鐢ㄧ殑鎺ュ彛锛屽垯鍙互鐩存帴璋冪敤锛屼笉闇€瑕佹斁鍦╮eady鍑芥暟涓€?
            isWxConfigReady = true;

            wx.getLocation({
                type: 'wgs84', // 榛樿涓簑gs84鐨刧ps鍧愭爣锛屽鏋滆杩斿洖鐩存帴缁檕penLocation鐢ㄧ殑鐏槦鍧愭爣锛屽彲浼犲叆'gcj02'
                success: function (res) {
                    var latitude = res.latitude; // 绾害锛屾诞鐐规暟锛岃寖鍥翠负90 ~ -90
                    var longitude = res.longitude; // 缁忓害锛屾诞鐐规暟锛岃寖鍥翠负180 ~ -180銆?

                    var lng = '';	//鐧惧害缁忓害
                    var lat = '';	//鐧惧害绾害
                    var convertor = new BMap.Convertor();
                    var ggPoint = new BMap.Point(longitude, latitude);
                    var pointArr = [];
                    pointArr.push(ggPoint);
                    convertor.translate(pointArr, 1, 5, function (data) {
                        if (data.status === 0) {
                            var point = data.points[0];
                            lng = point.lng;
                            lat = point.lat;

                            document.getElementById("LNG_value").value = lng;
                            document.getElementById("LAT_value").value = lat;

                            mk = new BMap.Marker(point);
                            map = new BMap.Map("container");
                            map.addOverlay(mk);
                            map.centerAndZoom(point, 18);

                        }
                        else {
                            showAlertAtMouse('鍧愭爣杞崲澶辫触');
                        }
                    });
                }
            });
        });
        wx.error(function (res) {
            layer.close(loadingIndex);
            showAlertAtMouse('failed' + JSON.stringify(res));
            // config淇℃伅楠岃瘉澶辫触浼氭墽琛宔rror鍑芥暟锛屽绛惧悕杩囨湡瀵艰嚧楠岃瘉澶辫触锛屽叿浣撻敊璇俊鎭彲浠ユ墦寮€config鐨刣ebug妯″紡鏌ョ湅锛屼篃鍙互鍦ㄨ繑鍥炵殑res鍙傛暟涓煡鐪嬶紝瀵逛簬SPA鍙互鍦ㄨ繖閲屾洿鏂扮鍚嶃€?
        });
    }

    window.onload = function () {
        wxApi();
    };

</script>
