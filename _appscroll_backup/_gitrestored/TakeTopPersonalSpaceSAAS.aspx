<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TakeTopPersonalSpaceSAAS.aspx.cs" Inherits="TakeTopPersonalSpaceSAAS" %>

<%--<%@ OutputCache Duration="2678400" VaryByParam="*" %>--%>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>PersonalSpace</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <link href="css/personal-space-custom.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        @-moz-document url-prefix() {
            /* Firefox specific styles */
        }

        #divGuide {
            height: 39px;
        }

        #navlist {
            position: absolute;
            height: 31px;
            top: -10px;
        }

            #navlist li {
                float: left;
                display: inline;
                padding-left: 10px;
            }

                #navlist li a:hover {
                    color: #d44446;
                }

            #navlist a:link, #navlist a:visited {
                display: block;
                color: #333;
                font-style: normal;
                font-variant: normal;
                font-weight: normal;
                font-size: 14px;
                line-height: 33px;
                font-family: &#930;
                , Helvetica, Tahoma;
            }

            #navlist a.current:link, #nav a.current:visited {
                color: #fff;
                background: #d44446;
                padding: 3px;
            }

        #nav1 {
            width: 98%;
            height: 185px;
            background: #fff;
            border-radius: 8px;
            margin: 5px 0;
            box-shadow: 0px 0px 15px rgb(0 0 0 / 15%);
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        #nav2 {
            width: 98%;
            text-align: center;
            margin: -5px 0 0 0;
            border: none;
            display: block;
            justify-content: space-around;
            align-items: center;
        }

        #nav3 {
            width: 98%;
            text-align: center;
            margin: -22px 0 0 0;
            border: none;
            display: block;
            justify-content: space-around;
            align-items: center;
        }

        /* 鍏抽敭淇敼锛氫负li娣诲姞鐩稿瀹氫綅 */
        #navlist2 li, #navlist3 li {
            position: relative;
            flex: 0 0 100%;
            margin: 0;
            list-style: none;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0px 0px 15px rgb(0 0 0 / 15%);
            margin-bottom: 10px;
            overflow: hidden; /* 闃叉loading鍦嗚婧㈠嚭 */
        }

        #navlist3 li {
            flex: 0 0 49.5%;
        }

        ul#navlist2, ul#navlist3 {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            padding: 0;
        }

        .SpaceLine {
            height: 20px;
            background-color: #EFF2F7;
        }

        .NflexBox {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            width: 100%;
            height: 95%;
            align-content: flex-start;
        }

        #UpdatePanel1 td {
            border: 0px !important;
        }

        .container {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        #div_username {
            display: flex;
            align-items: center;
            color: #333;
            font-size: 12px;
            white-space: nowrap;
            min-width: 80px;
        }

        #div_updatepersoninfor {
            display: none;
        }

        .TextColor {
            color: #fff;
            background: #d44446;
            padding: 3px;
        }

        /* 鍏抽敭淇敼锛歀oading鏍峰紡 */
        .loading {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 100;
            background-color: rgba(255, 255, 255, 0.8); /* 鍗婇�忔槑鑳屾櫙 */
            display: flex;
            align-items: center; /* 鍨傜洿灞呬腑 */
            justify-content: center; /* 姘村钩灞呬腑 */
        }

            .loading img {
                display: block;
                width: 32px; /* 鏍规嵁瀹為檯鍥炬爣澶у皬璋冩暣 */
                height: 32px;
            }
    </style>
    <script type="text/javascript" src="css/tab.js"></script>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" src="js/layer/layer/layer.js"></script>
    <script type="text/javascript" src="js/popwindow.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            window.parent.parent.document.getElementById("rightFrame").rows = '0,0,*';

            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        // 新增：隐藏对应模块的加载动画
        function hideModuleLoading(iframeObj) {
            $(iframeObj).parent().find('.loading').fadeOut(300);
        }

        function ChangeMenu(way) {
            if (way == 1) {
                if (window.parent.parent.document.getElementById("TakeTopLRMDI").cols === '45,*') {
                    window.parent.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
                    window.parent.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");
                    setExtendValue("YES");
                } else {
                    window.parent.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
                    window.parent.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "no");
                    setExtendValue("NO");
                }
            }

            if (way == 3) {
                window.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
                window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");
                setExtendValue("YES");
            }

            if (way == 4) {
                window.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
                setExtendValue("NO");
            }
        }

        function setExtendValue(isFalse) {
            top.frames[0].frames[2].parent.frames["leftMiddleFrame"].setExtendValue(isFalse);
        }

        function clickPopMsgWindow() {
            top.frames[0].frames[2].parent.frames["rightTopFrame"].clickPopMsgWindow();
        }

        var varScreenFull = false;
        function setScreenStatus() {
            if (varScreenFull == false) {
                fullScreen();
            }
            else {
                exitScreen();
            }
        }

        function fullScreen() {
            var el = top.document.documentElement;
            var rfs = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullScreen;

            if (rfs) {
                rfs.call(el);
            }
            else if (typeof window.ActiveXObject !== "undefined") {
                var wscript = new ActiveXObject("WScript.Shell");
                if (wscript != null) {
                    wscript.SendKeys("{F11}");
                }
            }

            varScreenFull = true;
        }

        function exitScreen() {
            var el = document;
            var cfs = el.cancelFullScreen || el.webkitCancelFullScreen || el.mozCancelFullScreen || el.exitFullScreen;

            if (cfs) {
                cfs.call(el);
            }
            else if (typeof window.ActiveXObject !== "undefined") {
                var wscript = new ActiveXObject("WScript.Shell");
                if (wscript != null) {
                    wscript.SendKeys("{F11}");
                }
            }

            varScreenFull = false;
        }

        function OnMouseDownEvent(obj) {
            jQuery(obj).parent().parent().find("a").removeClass("current");
            jQuery(obj).parents().find("span").removeClass("TextColor");
            jQuery(obj).addClass("current");
        }
    </script>
</head>
<body class="personal-space-body">
    <center>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" />
            <div id="divGuide" class="nav">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <Triggers>
                    </Triggers>
                    <ContentTemplate>
                        <ul id="navlist">
                            <li style="padding-top: 7px;">
                                <asp:ImageButton ID="IM_Extend" ImageUrl="ImagesSkin/news.png" Width="23" Height="20"
                                    OnClientClick="javascript: ChangeMenu(1);" runat="server" OnClick="BT_Extend_Click" />
                            </li>
                            <asp:Repeater ID="RP_NewsTypeList" runat="server">
                                <ItemTemplate>
                                    <li>
                                        <asp:HyperLink ID="HL_NavBar" runat="server" onmousedown="OnMouseDownEvent(this)" Style="text-decoration: none;" NavigateUrl='<%# DataBinder.Eval(Container.DataItem,"PageName").ToString().Trim() + "?Type=" +  DataBinder.Eval(Container.DataItem,"Type").ToString().Trim() + "&HomeName=" +  DataBinder.Eval(Container.DataItem,"HomeName").ToString().Trim () +"&Flag=" + Session["SkinFlag"].ToString() %>'
                                            Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>' Target="IF_NewsList">
                                        </asp:HyperLink>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <table border="0" align="right" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="center" style="padding-top: 0px; padding-bottom: 0px; padding-right: 12px; vertical-align: middle;">
                            <a runat="server" class="titleSpan" href="javascript:top.frames[0].frames[2].parent.frames['rightTabFrame'].popShowByURL('TTUpdateUserInfor.aspx', 'UserInformation', 800, 600, window.location);">
                                <div class="container">
                                    <div id="div_username">
                                        <img src="ImagesSkin/UserAvatar.png" width="18" height="18" style="vertical-align: middle; margin-right: 4px; border-radius: 50%;"><asp:Label ID="LB_UserName" runat="server"></asp:Label>
                                    </div>
                                    <div id="div_updatepersoninfor">
                                        <img src="ImagesSkin/UpdatePersonInfor.png" width="22" height="22">
                                    </div>
                                </div>
                            </a>
                        </td>
                        <td width="40px" align="center" style="padding-top: 7px; padding-bottom: 5px;">
                            <a runat="server" class="titleSpan tt-topbar-icon-link" href="javascript:top.frames[0].frames[2].parent.frames['rightTabFrame'].popShowByURL('TTSystemAnalystChartRelatedUserSet.aspx?FormType=PersonalSpacePage', 'AnalysisChartSelect', 800, 600, window.location);">
                                <img src="ImagesSkin/AnalystChart.png" width="22" height="22"></a>
                        </td>

                        <td width="40px" align="center" style="padding-top: 7px; padding-bottom: 5px;">
                            <a runat="server" class="titleSpan tt-topbar-icon-link" href="javascript:top.frames[0].frames[2].parent.frames['rightTabFrame'].popShowByURL('TTPersonalSpaceModuleSetForUser.aspx', 'ModuleSelect', 800, 600, window.location);">
                                <img src="ImagesSkin/ModuleSelect.png" width="22" height="22"></a>
                        </td>

                        <td width="40px" align="center" style="padding-top: 7px; padding-bottom: 5px;">
                            <a runat="server" class="titleSpan tt-topbar-icon-link" href="javascript:top.frames[0].frames[2].parent.frames['rightTabFrame'].popShowByURL('TTAPPQRCodeForLocalSAAS.aspx', '', 800, 600,window.location);">
                                <img src="ImagesSkin/App.png" width="22" height="22"></a>
                        </td>
                        <td id="tdAI" runat="server" width="40px" align="center" style="padding-top: 7px; padding-bottom: 5px;">

                            <a id="a_AIURL" runat="server" class="titleSpan tt-topbar-icon-link" href="javascript:top.frames[0].frames[2].parent.frames['rightTabFrame'].openRightLayer('TTAIHandlerByDeepSeek.aspx','TakeTopAI');">
                                <img src="ImagesSkin/AI.png" width="22" height="22" alt="">
                            </a>
                        </td>

                        <td width="40px" align="center" style="padding-top: 7px; padding-bottom: 5px;">
                            <a href="#" onclick="return confirmExit(getExitMsgByLangCode(), this, event, 'Default.aspx');" class="tt-logout-btn" style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; font-size: 12px; text-decoration: none; white-space: nowrap;">&#x23FB;
                                <asp:Literal ID="LiteralExit" runat="server" Text="<%$ Resources:lang,Exit%>"></asp:Literal></a>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="NflexBox">
                <div id="nav1">
                    <iframe id="IF_NewsList" name="IF_NewsList" src='TTPersonalSpaceNews.aspx?Flag=<%=Session["SkinFlag"].ToString()%>'
                        style="width: 100%; height: 100%; text-align: center;" frameborder="no" marginwidth="0"
                        marginheight="0" scrolling="auto"></iframe>
                </div>
                <div id="nav2">
                    <ul id="navlist2">
                        <asp:Repeater ID="Repeater1" runat="server">
                            <ItemTemplate>
                                <li>
                                    <div class="loading">
                                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                                    </div>
                                    <div class="personal-space-cline"></div>
                                    <iframe id="IF_Module" name="IF_Module"
                                        onload="hideModuleLoading(this);"
                                        src='<%# DataBinder.Eval(Container.DataItem, "ModulePage") + "&Flag=" + Session["SkinFlag"].ToString()  %>'
                                        style="width: 100%; height: 320px;" frameborder="no" marginwidth="0" marginheight="0"
                                        scrolling="auto"></iframe>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
                <div id="nav3">
                    <ul id="navlist3">
                        <asp:Repeater ID="Repeater2" runat="server">
                            <ItemTemplate>
                                <li>
                                    <div class="loading">
                                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                                    </div>
                                    <div class="personal-space-cline"></div>
                                    <iframe id="IF_Module" name="IF_Module"
                                        onload="hideModuleLoading(this);"
                                        src='<%# DataBinder.Eval(Container.DataItem, "ModulePage") + "&Flag=" + Session["SkinFlag"].ToString()  %>'
                                        style="width: 100%; height: 350px;" frameborder="no" marginwidth="0" marginheight="0"
                                        scrolling="auto"></iframe>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>

                <div class="layui-layer layui-layer-iframe" id="popwindow" name="noConfirm"
                    style="z-index: 9999; width: 980px; height: 530px; position: absolute; overflow: hidden; display: none; border-radius: 10px;">
                    <div class="layui-layer-title" style="background: #e7e7e8;" id="popwindow_title">
                        <asp:Label ID="Label172" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                    </div>
                    <div id="popwindow_content" class="layui-layer-content" style="overflow: auto; padding: 0px 5px 0px 5px;">

                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="ItemAlignLeft" style="padding-top: 40px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请用微信扫描下面二维码关注:项目宝 公众号，并在公众号中点击: 登录使用  菜单，登录【项目宝】的微信端APP，登录后可以在手机中使用此APP和接受平台各种消息！
                                   
                                    <br />
                                    <br />
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;登录APP后，此提示信息将不会再显示！
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-top: 20px; text-align: center;">
                                    <img src="Logo/TakeTopXMB.png">
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="popwindow_footer" class="layui-layer-btn" style="border-top: 1px solid #ccc;">
                        <a class="layui-layer-btn notTab" onclick="return popClose();">
                            <asp:Label ID="Label173" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                        </a>
                    </div>
                    <span class="layui-layer-setwin"><a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;"></a></span>
                </div>

                <div class="layui-layer-shade" id="popwindow_shade" style="z-index: 9998; background-color: #000; opacity: 0.3; filter: alpha(opacity=30); display: none;"></div>

                <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
                    <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                        <ProgressTemplate>
                            <img src="Images/Processing3 .gif" alt="Loading,please wait..." />
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </div>
            </div>
        </form>
    </center>
</body>
<script type="text/javascript" language="javascript">
    var cssDirectory = '<%=Session["CssDirectory"] %>';
    var oLink = document.getElementById('mainCss');
    oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';
</script>
</html>
