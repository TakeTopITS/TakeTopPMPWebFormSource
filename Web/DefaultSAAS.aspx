<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DefaultSAAS.aspx.cs" Inherits="DefaultSAAS" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=yes, target-densitydpi=device-dpi" />
<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        body {
            margin-top: 60px; /*background-image: url(Images/login_bj.jpg);*/
            background-repeat: repeat-x;
            font: normal 100% Helvetica, Arial, sans-serif;
        }

        input#TB_UserCode {
            border: none;
            border-bottom: 2px #249bf9 solid;
            line-height: 1em;
        }

        input#TB_Password {
            border: none;
            border-bottom: 2px #249bf9 solid;
            line-height: 1em;
        }


        /*--------------------------------短按钮---------------------------*/
        .inpuLogon {
            /*background-image: url(ImagesSkin/Logon.jpg);*/
            margin: 0px;
            height: 30px;
            width: 100%;
            text-align: center;
            border-top-style: none;
            border-right-style: none;
            border-bottom-style: none;
            border-left-style: none; /*font-size: 12px;*/
            color: #29728D;
            background: #cbe5fe;
            border-radius: 5px;
        }

        .inpuRegister {
            background-image: url(ImagesSkin/Register.jpg);
            margin: 0px;
            height: 22px;
            width: 53px;
            text-align: center;
            border-top-style: none;
            border-right-style: none;
            border-bottom-style: none;
            border-left-style: none; /*font-size: 12px;*/
            color: #29728D;
        }

        a:link {
            /*font-size: 12px;*/
            text-decoration: none;
            color: #000000;
        }

        a:visited {
            background: url(ImagesSkin/MouseVisited.gif);
        }

        a:hover, button:hover, input[type="submit"]:hover {
            /*background: url(ImagesSkin/MouseHover.gif);*/
            background: #fe3c69;
            color: #FCF8F8;
        }

        a:active, button:active, input[type="submit"]:active {
            /*background: url(ImagesSkin/MouseActive.gif);*/
        }


        #info {
            height: 0px;
            width: 0px;
            top: 50%;
            left: 37%;
            position: absolute;
            background-image: url(login.png);
            background-repeat: no-repeat;
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
    </style>
    <style type="text/css">
        #AboveDiv {
            max-width: 1024px;
            width: expression (document.body.clientWidth >= 1024? "1024px" : "auto" ));
            min-width: 277px;
            width: expression (document.body.clientWidth <= 277? "277px" : "auto" ));
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

        function openMDIFrom(strMDIPageName) {

            window.open(strMDIPageName, '_top');

        }

        function displayWaitingIcon() {

            this.document.getElementById("IMG_Waiting").style.display = "block";
        }

        window.onload = function () {


            //自动填充帐号和密码
            var userName = getCookie("loginUserName");
            var password = getCookie("loginPassword");

            if (userName != null) {
                document.getElementById("TB_UserCode").value = userName;
                document.getElementById("TB_Password").value = password;
            }


            if (document.documentElement.scrollHeight <= document.documentElement.clientHeight) {
                bodyTag = document.getElementsByTagName('body')[0];
                bodyTag.style.height = document.documentElement.clientWidth / screen.width * screen.height + 'px';
            }
            setTimeout(function () {
                window.scrollTo(0, 1);
            }, 0);

            // 页面加载时初始化验证码图片
            var img = document.getElementById('IM_CheckCode');
            if (img) {
                // 使用时间戳确保每次页面加载都获取新的验证码
                img.src = 'TTCheckCode.aspx?t=' + new Date().getTime();
            }

        };

        function RemmberUserNameAndPassord() {

            javascript: document.getElementById('IMG_Waiting').style.display = 'block';

            var userName = document.getElementById("TB_UserCode").value;
            var password = document.getElementById("TB_Password").value;

            setCookie("loginUserName", userName, 1000);
            setCookie("loginPassword", password, 1000);
        }


        function openMDIFrom(strMDIPageName) {

            //alert(strMDIPageName);
            window.open(strMDIPageName, '_top');

        }

        function displayWaitingIcon() {

            this.document.getElementById("IMG_Waiting").style.display = "block";
        }

        function refreshCheckCode() {
            var img = document.getElementById('IM_CheckCode');

            if (img) {
                // 添加时间戳确保每次都是新请求，避免缓存
                img.src = 'TTCheckCode.aspx?t=' + new Date().getTime() + '&refresh=true';
            }
        }

    </script>
</head>
<body bgcolor="#FFFFFF">
    <center>
        <form id="form1" runat="server">
            <div id="AboveDiv">
                <table width="70%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="center" style="padding-right: 15px;">
                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,HanYing%>"></asp:Label>
                            <br />
                            <br />
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2" align="center">
                            <table width="100%">
                                <tr>
                                    <td align="center">
                                        <%--<asp:TextBox ID="TB_UserCode" runat="server"  placeholder="<%$ Resources:lang,QingShuRuNiDeDaiMa%>" OnFocus="javascript:if(this.value=='请输入你的登录帐号(UserCode)') {this.value='';this.style.color='blue'}"
                                        OnBlur="javascript:if(this.value==''){this.value='请输入你的登录帐号(UserCode)';this.style.color='gray'}"
                                        ForeColor="#000000" class="dengl" Width="100%"></asp:TextBox>--%>
                                        <asp:TextBox ID="TB_UserCode" runat="server" placeholder="<%$ Resources:lang,QingShuRuNiDeDaiMa%>" onClick="javascript:this.value='';document.getElementById('LB_ErrorMsg').style.display = 'none';" ForeColor="#000000" Width="100%"></asp:TextBox>

                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">&nbsp; 
                        
                        </td>
                        <td style="text-align: left;">&nbsp;
                        
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">&nbsp;
                        
                        </td>
                        <td style="text-align: left;">&nbsp;
                        
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <%--   <asp:TextBox ID="TB_Password" runat="server" Text="请输入密码(Password)" OnFocus="javascript:if(this.value=='请输入密码(Password)') {this.value='';this.style.color='blue'}"
                            OnBlur="javascript:if(this.value==''){this.value='请输入密码(Password)';this.style.color='gray'}"
                            ForeColor="#000000" class="dengl" Width="100%"></asp:TextBox>--%>

                            <asp:TextBox ID="TB_Password" runat="server" placeholder="<%$ Resources:lang,QingShuRuNiDeMiMa%>" TextMode="Password" ForeColor="#000000" Width="100%"></asp:TextBox>

                            <asp:Label ID="LB_ErrorMsg" runat="server" Visible="false" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr id="trCheckCode" runat="server">
                        <td class="formItemBgStyleForAlignLeft">
                            <br />
                            <table>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="TB_CheckCode" runat="server" ForeColor="black" Style="width: 100px; height: 32px;" onfocus="javascript:refreshCheckCode();"></asp:TextBox>
                                    </td>
                                    <td>
                                        <a id="aCheckCode" href="javascript:refreshCheckCode();" class="codea">
                                            <!-- 由JavaScript动态设置图片URL -->
                                            <asp:Image ID="IM_CheckCode" runat="server" ClientIDMode="Static" />
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="text-align: right;">&nbsp;
                    
                        </td>
                        <td style="text-align: left;">&nbsp;
                    
                        </td>
                    </tr>

                    <tr>
                        <td style="text-align: right;">&nbsp;
                    
                        </td>
                        <td style="text-align: left;">&nbsp;
                    
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <img id="IMG_Waiting" src="Images/Processing.gif" alt="Loading,please wait..." style="text-align: center; display: none;" />
                            <asp:Button ID="BT_Login" runat="server" CssClass="inpuLogon" Text="<%$ Resources:lang,Login%>" OnClientClick="RemmberUserNameAndPassord()"
                                OnClick="LB_Login_Click" />

                            <asp:ImageButton ID="IB_GetSMS" runat="server" ImageUrl="~/Images/SMS.jpg" Width="22px"
                                Height="22px" OnClick="IB_GetSMS_Click" Visible="False" />
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2" height="14"></td>
                    </tr>
                </table>
                <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="center">
                            <table width="100%">
                                <tr style="display: none;">
                                    <td align="center">
                                        <asp:Label ID="LB_Copyright" runat="server" Text="Copyright TakeTop Software 2006-2036 "></asp:Label>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td align="center">[
                                   
                                        <asp:DropDownList ID="ddlLangSwitcher" runat="server" DataValueField="LangCode" DataTextField="Language"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlLangSwitcher_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        ]
                                    </td>
                                </tr>
                               
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </center>
</body>
</html>
