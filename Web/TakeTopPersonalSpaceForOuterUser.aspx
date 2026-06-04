<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TakeTopPersonalSpaceForOuterUser.aspx.cs" Inherits="TakeTopPersonalSpaceForOuterUser" %>

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
                    color: red;
                }

            #navlist a:link, #navlist a:visited {
                display: block;
                color: #ffffff;
                font-style: normal;
                font-variant: normal;
                font-weight: normal;
                font-size: 14px;
                line-height: 33px;
                font-family: Helvetica, Tahoma;
            }

            #navlist a.current:link, #nav a.current:visited {
                color: red;
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

        #nav2, #nav3 {
            width: 98%;
            text-align: center;
            border: none;
            display: block;
            justify-content: space-around;
            align-items: center;
        }

        #nav2 { margin: -5px 0 0 0; }
        #nav3 { margin: -22px 0 0 0; }

        /* --- 核心修改部分 --- */
        #navlist2 li, #navlist3 li {
            position: relative; /* 必须：使内部绝对定位的loading参考此容器 */
            flex: 0 0 100%;
            margin: 0;
            list-style: none;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0px 0px 15px rgb(0 0 0 / 15%);
            margin-bottom: 10px;
            overflow: hidden;
        }

        #navlist3 li {
            flex: 0 0 49.5%;
        }

        .loading {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 100;
            background-color: rgba(255, 255, 255, 0.8); /* 半透明背景 */
            display: flex;          /* 使用Flexbox轻松居中 */
            align-items: center;    /* 垂直居中 */
            justify-content: center;/* 水平居中 */
        }

        .loading img {
            width: 32px; /* 根据gif实际大小调整 */
            height: 32px;
            margin: 0 !important;
        }
        /* ------------------ */

        ul#navlist2, ul#navlist3 {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            padding: 0;
        }

        .NflexBox {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            width: 100%;
            height: 95%;
            align-content: flex-start;
        }

        .container {
            position: relative;
        }

        #div_username {
            align-items: center;
            color: white;
            font-size: 12px;
        }

        #div_updatepersoninfor img {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
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

        // 新增：iframe加载完成后隐藏loading
        function hideLoading(iframe) {
            $(iframe).siblings('.loading').fadeOut(300);
        }

        function ChangeMenu(way) {
            if (way == 1) {
                var frame = window.parent.parent.document.getElementById("TakeTopLRMDI");
                if (frame.cols === '45,*') {
                    frame.cols = '180,*';
                    window.parent.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");
                    setExtendValue("YES");
                } else {
                    frame.cols = '45,*';
                    window.parent.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "no");
                    setExtendValue("NO");
                }
            }
        }

        function setExtendValue(isFalse) {
            top.frames[0].frames[2].parent.frames["leftMiddleFrame"].setExtendValue(isFalse);
        }

        function OnMouseDownEvent(obj) {
            jQuery(obj).parent().parent().find("a").removeClass("current");
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
                    <ContentTemplate>
                        <ul id="navlist">
                            <li style="padding-top: 7px;">
                                <asp:ImageButton ID="IM_Extend" ImageUrl="ImagesSkin/news.png" Width="23" Height="20"
                                    OnClientClick="javascript: ChangeMenu(1);" runat="server" OnClick="BT_Extend_Click" />
                            </li>
                            <asp:Repeater ID="RP_NewsTypeList" runat="server">
                                <ItemTemplate>
                                    <li>
                                        <asp:HyperLink ID="HL_NavBar" runat="server" onmousedown="OnMouseDownEvent(this)" Style="text-decoration: none;" 
                                            NavigateUrl='<%# DataBinder.Eval(Container.DataItem,"PageName").ToString().Trim() + "?Type=" +  DataBinder.Eval(Container.DataItem,"Type").ToString().Trim() + "&HomeName=" +  DataBinder.Eval(Container.DataItem,"HomeName").ToString().Trim () +"&Flag=" + Session["SkinFlag"].ToString() %>'
                                            Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>' Target="IF_NewsList"></asp:HyperLink>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <table border="0" align="right" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="center" style="padding-top: 7px; padding-bottom: 0px;">
                            <a runat="server" class="titleSpan" href="javascript:top.frames[0].frames[2].parent.frames['rightTabFrame'].popShowByURL('TTUpdateUserInfor.aspx', 'UserInformation', 800, 600, window.location);">
                                <div class="container">
                                    <div id="div_username"><asp:Label ID="LB_UserName" runat="server"></asp:Label></div>
                                    <div id="div_updatepersoninfor"><img src="ImagesSkin/UpdatePersonInfor.png" width="22" height="22"></div>
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
                        <td width="40px" align="center" style="padding-top: 7px; padding-bottom: 5px;">
                            <asp:ImageButton ID="IM_ExitSystem" ImageUrl="ImagesSkin/ExitAPP.png" Width="25" Height="23"
                                OnClientClick="javascript:return confirmExit(getExitMsgByLangCode(), this, event, 'Default.aspx');"
                                runat="server" />
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
                                        <img src="Images/Processing.gif" alt="Loading..." />
                                    </div>
                                    <div class="personal-space-cline"></div>
                                    <iframe id="IF_Module" name="IF_Module" 
                                        onload="hideLoading(this);"
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
                                        <img src="Images/Processing.gif" alt="Loading..." />
                                    </div>
                                    <div class="personal-space-cline"></div>
                                    <iframe id="IF_Module" name="IF_Module" 
                                        onload="hideLoading(this);"
                                        src='<%# DataBinder.Eval(Container.DataItem, "ModulePage") + "&Flag=" + Session["SkinFlag"].ToString()  %>'
                                        style="width: 100%; height: 350px;" frameborder="no" marginwidth="0" marginheight="0"
                                        scrolling="auto"></iframe>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
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