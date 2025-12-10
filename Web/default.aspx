<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="_default" %>

<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" type="text/css" href="css/reset.css" />
    <link rel="stylesheet" type="text/css" href="Logo/css/login.css" />

    <style>
        html, body {
            width: 100%;
            height: 100%;
            overflow: scroll;
            overflow: hidden;
        }

        .loginleft {
            width: 50%;
            height: 100%;
            background: url(Logo/loginbg.jpg) no-repeat 0px 0px;
            float: left;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            background-size: cover;
            background-position: bottom;
        }

        .loginright {
            width: 50%;
            height: 100%;
            background: #fff;
            float: left;
            display: flex;
            justify-content: flex-start;
            align-items: center;
        }

        .Nfo {
            height: 100%;
        }

        .lfbox {
            padding-right: 80px;
            margin-bottom: 100px;
        }

            .lfbox p {
                height: 60px;
                font: 36px/60px "microsoft yahei";
                color: #fff;
                display: flex;
                justify-content: flex-end;
                text-align: right;
            }

        .lflogo {
            background: url(Logo/logo.png) no-repeat 120px center;
            padding-left: 80px;
        }

        input#TB_CheckCode {
            width: 100px;
            height: 34px;
            padding: 0 15px;
            font: 14px/34px "microsoft yahei";
            color: #9CABC1;
            display: inline-block;
            background: #ffffff;
            border-radius: 5px;
            border: 1px solid #E1E7ED;
        }

        center {
            width: 100%;
            height: 100%;
            display: flex;
        }

        select#ddlLangSwitcher {
            float: left;
            width: 75px;
            border: 0;
            font: 12px/24px "Arial";
            color: #9CABC1;
        }

        em.emt {
            width: 60px;
            display: block;
            float: left;
            line-height: 34px;
            padding-right: 5px;
            text-align: left;
            font-size: 14px;
        }

        .container {
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: red;
        }

        .codea {
            display: inline-block;
            padding-left: 0px;
            font: 14px/34px "microsoft yahei";
            color: #9CABC1;
            text-align: left;
        }

            .codea img {
                height: 34px;
                border-radius: 5px;
            }

        .loading-center {
            display: none; /* 初始隐藏 */
            text-align: center;
            margin: 10px auto;
            width: 100%;
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script language="javascript" type="text/javascript">

        function is_iPad() {
            var ua = navigator.userAgent.toLowerCase();
            if (ua.match(/iPad/i) == "ipad") {
                return true;
            } else {
                return false;
            }
        }

        function displayQRCode() {
            this.document.getElementById["logoImg"].src = "ImagesSkin/TakeTopXMB.jpg"
        }

        function popShow(id, rememberScroll, childId) {
            nowId = id;
            $("#" + id).show();
            childDivId = childId;
            $("#" + id).css("z-index", "9999");
            if (childId) {
                $("#" + childId).show();
                $("#" + childId).css("z-index", "10000");
                move(childId, 1);

            }
            $("#popwindow_shade").show();
            setPostion();
            if (rememberScroll == "true") {
                $("#" + nowId + ">div:eq(1)")[0].scrollTop = GetCookie("popScrollTop");
            }
            else {
                $("#" + nowId + ">div:eq(1)")[0].scrollTop = 0;
            }

            $("#" + nowId + ">div:eq(1)").scroll(function () {
                SetScrollTop($(this));
            });

            if (popWindowLeft != 0 && popWindowTop != 0) {
                $("#" + id).css({ left: popWindowLeft, top: popWindowTop });
            }

            move(id);

            return false;
        }

        function popUpdateWindow() {
            var intUpdateColumnMark = parseInt('<%=LB_UpdateColumnMark.Text %>');
            var intUpdateModuleMark = parseInt('<%=LB_UpdateModuleMark.Text %>');

            if (intUpdateColumnMark == 0 || intUpdateModuleMark == 0) {
                popShow('popwindow', 'true');
            }
        }

        function refreshCheckCode() {
            var img = document.getElementById('IM_CheckCode');
            if (img) {
                // 添加时间戳参数确保每次都是新请求，同时清除缓存
                img.src = 'TTCheckCode.aspx?t=' + new Date().getTime() + '&refresh=true';
            }
        }

        function displayBTLogin(varDisplay) {
            this.document.getElementById("BT_Login").style.display = varDisplay;
        }
        function displayLBMessage(varDisplay) {
            this.document.getElementById("loadingContainer").style.display = varDisplay;
            this.document.getElementById("LB_Message").style.display = varDisplay;
        }


    </script>
</head>
<body>
    <div id="wrapper">
        <div class="wrapper">
            <form id="form1" runat="server" class="Nfo">
                <div class="loginWrap">
                    <div class="loginleft">
                        <div class="lfbox">
                            <p>
                                <asp:Label ID="LB_SystemName" runat="server"></asp:Label>

                            </p>
                        </div>
                    </div>
                    <div class="loginright">
                        <div class="loginForm clearfix">
                            <h2></h2>
                            <p>
                                <em class="emt">
                                    <asp:Label ID="LB_UserID" runat="server" Text="<%$ Resources:lang,UserAccount%>"></asp:Label>:</em>
                                <asp:TextBox ID="TB_UserCode" runat="server" class="text"></asp:TextBox>
                            </p>
                            <p>
                                <em class="emt">
                                    <asp:Label ID="LB_Password" runat="server" Text="<%$ Resources:lang,PWD%>"></asp:Label>:</em>
                                <asp:TextBox ID="TB_Password" runat="server" class="text" TextMode="Password"></asp:TextBox>
                            </p>
                            <p id="pCheckCode" runat="server">
                                <em class="emt">
                                    <asp:Label ID="LB_Verification" runat="server" Text="<%$ Resources:lang,Verification%>"></asp:Label>:</em>
                                <em>
                                    <asp:TextBox ID="TB_CheckCode" runat="server" class="textcode" Width="75px"></asp:TextBox>
                                </em>
                                <em>
                                    <a id="aCheckCode" href="javascript:refreshCheckCode();" class="codea">
                                        <!-- 移除初始的ImageUrl，通过JavaScript动态设置 -->
                                        <asp:Image ID="IM_CheckCode" runat="server" ClientIDMode="Static" />
                                    </a>
                                </em>
                                <asp:ImageButton ID="IB_GetSMS" runat="server" ImageUrl="~/Images/SMS.jpg" Width="22px"
                                    Height="22px" OnClick="IB_GetSMS_Click" Visible="False" />

                                <asp:DropDownList ID="ddlLangSwitcher" runat="server" DataValueField="LangCode" DataTextField="Language" Visible="false"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLangSwitcher_SelectedIndexChanged">
                                </asp:DropDownList>
                            </p>
                            <p>
                                <!-- 减少margin，使用小间距 -->
                                <div id="loadingContainer" style="display: none; text-align: center; margin: 2px 0;">
                                    <img id="IMG_Waiting" src="Images/Processing.gif" alt="Loading,please wait..." />
                                </div>

                                <asp:Label ID="LB_Message" runat="server" Text="<%$ Resources:lang,ZZSJSJKSHSFZQXH%>"
                                    Style="display: none;" ForeColor="Red"></asp:Label>


                                <asp:Button ID="BT_Login" runat="server" CssClass="btn" Text="<%$ Resources:lang,Login%>"
                                    OnClick="LB_Login_Click"
                                    OnClientClick="javascript:document.getElementById('loadingContainer').style.display = 'block';setHiddenFields();" />
                            </p>
                            <center>
                                <em runat="server" id="emSAAS" visible="false"><a onclick="popShow('popDetailWindow','true')">
                                    <asp:Label runat="server" Text="<%$ Resources:lang,MianFeiZhuCe%>"></asp:Label></a>
                                    &nbsp;&nbsp; <a onclick="popShow('popwindow','true')">
                                        <asp:Label runat="server" Text="<%$ Resources:lang,ZhaoHuiMiMa%>"></asp:Label></a>
                                    &nbsp;&nbsp;
                               
                                    <asp:LinkButton ID="LB_WeChatQRCode" runat="server" Text="<%$ Resources:lang,WeiXinDeng%>" OnClick="LB_WeChatQRCode_Click"></asp:LinkButton>
                                    &nbsp;&nbsp;<asp:HyperLink ID="HL_UserManual" NavigateUrl="UserManual/TakeTopGLBGuide.zip" Text="<%$ Resources:lang,YongHuShouCe%>" runat="server"></asp:HyperLink>
                                </em>
                                <em class="copy">
                                    <asp:Label ID="LB_Copyright" runat="server" Text="<a href=TTVersionRegister.aspx>Copyright TakeTop Software</a> 2006-2026 <a href=https://www.taketopits.com>http://www.taketopits.com</a>"></asp:Label>
                                </em>
                            </center>

                            <div id="divIframeModuleFlowHTML">
                                <asp:Literal ID="litIframeModuleFlowHTML" runat="server"></asp:Literal>
                            </div>
                            <div id="divSystemAnalystChartHTML">
                                <asp:Literal ID="litSystemAnalystChartHTML" runat="server"></asp:Literal>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="footer" style="display: none;">
                    <asp:HyperLink ID="HL_UserID" runat="server" Target="_blank"></asp:HyperLink>
                    <br />
                    <asp:Label ID="LB_Slogon" runat="server"></asp:Label>

                    <iframe id="IF_DBUpgrade" src="TakeTopDBUpgrade.aspx" runat="server">Upgrade Database,please wait...
                    </iframe>

                </div>
            </form>
        </div>
    </div>
    <!-- 其他HTML内容保持不变 -->
    <div style="display: none;">
        <asp:Label ID="LB_UpdateColumnMark" runat="server"></asp:Label>
        <asp:Label ID="LB_UpdateModuleMark" runat="server"></asp:Label>
    </div>
</body>
</html>
