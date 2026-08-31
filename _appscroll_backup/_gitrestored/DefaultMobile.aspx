<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DefaultMobile.aspx.cs" Inherits="DefaultMobile" %>

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
            line-height: 2em;
        }

        input#TB_Password {
            border: none;
            border-bottom: 2px #249bf9 solid;
            line-height: 2em;
        }

        /*--------------------------------∂Ã∞¥≈•---------------------------*/
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
            color: #607d8b;
            background: #fde8e8;
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
            color: #607d8b;
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
    <script type="text/javascript" src="js/TakeTopCookie.js"> </script>
    <script language="javascript" type="text/javascript">

        window.onload = function () {


            //◊‘∂ØÃÓ≥‰’ ∫≈∫Õ√‹¬Î
            var userName = getCookie("loginUserName");
            var password = getCookie("loginPassword");

            if (userName != null) {
                document.getElementById("TB_UserCode").value = userName;
                document.getElementById("TB_Password").value = password;
            }
            //else {
            //    document.getElementById("TB_UserCode").focus();
            //}


            if (document.documentElement.scrollHeight <= document.documentElement.clientHeight) {
                bodyTag = document.getElementsByTagName('body')[0];
                bodyTag.style.height = document.documentElement.clientWidth / screen.width * screen.height + 'px';
            }
            setTimeout(function () {
                window.scrollTo(0, 1);
            }, 0);


        };

        function RemmberUserNameAndPassord() {

            //var isChecked = document.getElementById("saveUserName").checked;
            //if (isChecked) {
            //    setCookie("loginUserName", userName);
            //}

            var userName = document.getElementById("TB_UserCode").value;
            var password = document.getElementById("TB_Password").value;

            setCookie("loginUserName", userName, 1000);
            setCookie("loginPassword", password, 1000);
        }


        function is_iPad() {
            var ua = navigator.userAgent.toLowerCase();
            if (ua.match(/iPad/i) == "ipad") {
                return true;
            } else {
                return false;
            }
        }

        function refreshCheckCode() {
            var img = document.getElementById('IM_CheckCode');
            if (img) {
                img.src = 'TTCheckCode.aspx?t=' + new Date().getTime();
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
                        <td style="padding-left: 0px;">
                            <img alt="" src="Logo/APPLoginLogo.png" width="100%" />
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2" align="center">

                            <asp:TextBox ID="TB_UserCode" runat="server" placeholder="<%$ Resources:lang,QingShuRuNiDeDaiMa%>" onFocus="javascript:this.value='';document.getElementById('LB_ErrorMsg').style.display = 'none';" ForeColor="#000000" class="dengl" Width="103%"></asp:TextBox>

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

                            <asp:TextBox ID="TB_Password" runat="server" placeholder="<%$ Resources:lang,QingShuRuNiDeMiMa%>" TextMode="Password" onFocus="javascript:this.value='';document.getElementById('LB_ErrorMsg').style.display = 'none';" ForeColor="#000000" class="dengl" Width="103%"></asp:TextBox>
                            <asp:Label ID="LB_ErrorMsg" runat="server" Visible="false" ForeColor="Red"></asp:Label>

                        </td>
                    </tr>
                    <tr id="trCheckCode" runat="server" style="display: none;">
                        <td colspan="2" style="text-align: left;">
                            <br />
                            <table>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="TB_CheckCode" runat="server" ForeColor="black" Style="width: 100px; height: 32px;"></asp:TextBox>
                                    </td>
                                    <td>
                                        <a id="aCheckCode" href="javascript:refreshCheckCode();" class="codea">
                                            <asp:Image ID="IM_CheckCode" runat="server" ClientIDMode="Static" ImageUrl="TTCheckCode.aspx?refresh=<%=DateTime.Now.Ticks %>" />
                                        </a>
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
                            <img id="IMG_Waiting" src="Images/Processing.gif" alt="Loading,please wait..." style="text-align: center; display: none;" />
                            <asp:Button ID="BT_Login" runat="server" CssClass="inpuLogon" Text="<%$ Resources:lang,Login%>" OnClick="LB_Login_Click" OnClientClick="javascript:RemmberUserNameAndPassord();document.getElementById('IMG_Waiting').style.display = 'block';" />

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
                                <tr>
                                    <td align="center">
                                        <asp:Label ID="LB_Copyright" runat="server" Text="Copyright TakeTop Software 2006-2036 "></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center">[
                                    <asp:DropDownList ID="ddlLangSwitcher" runat="server" DataValueField="LangCode" DataTextField="Language"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlLangSwitcher_SelectedIndexChanged"
                                        Style="height: 22px;">
                                    </asp:DropDownList>
                                        ]
                                    </td>
                                </tr>
                                <tr>
                                    <td height="8"></td>
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
