<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DefaultAPP.aspx.cs" Inherits="DefaultAPP" %>

<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=0.1; user-scalable=1" />

<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        body {
            margin-top: 60px;
            /*background-image: url(Images/login_bj.jpg);*/
            background-repeat: repeat-x;
            font: normal 100% Helvetica, Arial, sans-serif;
        }


        #AboveDiv {
            max-width: 1024px;
            width: expression(document.body.clientWidth >= 1024? "1024px" : "auto");
            min-width: 277px;
            width: expression(document.body.clientWidth <= 277? "277px" : "auto");
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
    </style>


    <style type="text/css">
        /*--------------------------------∂Ã∞¥≈•---------------------------*/
        .inpuLogon {
            /*            background-image: url(ImagesSkin/Logon.jpg);*/
            margin: 0px;
            height: 30px;
            width: 100%;
            text-align: center;
            border-top-style: none;
            border-right-style: none;
            border-bottom-style: none;
            border-left-style: none;
            /*font-size: 12px;*/
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
            border-left-style: none;
            /*font-size: 12px;*/
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
            /*            background: url(ImagesSkin/MouseHover.gif);*/
            background: #fe3c69;
            color: #FCF8F8;
        }

        a:active, button:active, input[type="submit"]:active {
            background: #fe3c69;
            opacity: 0.8;
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

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" src="js/TakeTopCookie.js"> </script>
    <script type="text/javascript">
        window.onload = function () {


            //◊‘∂ØÃÓ≥‰’ ∫≈∫Õ√‹¬Î
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


        };

        function RemmberUserNameAndPassord() {

            document.getElementById('IMG_Waiting').style.display = 'block';

            var userName = document.getElementById("TB_UserCode").value;
            var password = document.getElementById("TB_Password").value;

            setCookie("loginUserName", userName, 1000);
            setCookie("loginPassword", password, 1000);
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
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
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
                                <td>

                                    <asp:TextBox ID="TB_UserCode" runat="server" placeholder="<%$ Resources:lang,QingShuRuNiDeDaiMa%>" onFocus="javascript:this.value='';document.getElementById('LB_ErrorMsg').style.display = 'none';" ForeColor="#000000" class="dengl" Width="100%"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">&nbsp;</td>
                                <td style="text-align: left;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">&nbsp;</td>
                                <td style="text-align: left;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="center">

                                    <asp:TextBox ID="TB_Password" runat="server" placeholder="<%$ Resources:lang,QingShuRuNiDeMiMa%>" TextMode="Password" onFocus="javascript:this.value='';document.getElementById('LB_ErrorMsg').style.display = 'none';" ForeColor="#000000" class="dengl" Width="100%"></asp:TextBox>
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
                                <td style="text-align: right;">&nbsp;</td>
                                <td style="text-align: left;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">&nbsp;</td>
                                <td style="text-align: left;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <img id="IMG_Waiting" src="Images/Processing.gif" alt="Loading,please wait..." style="text-align: center; display: none;" />
                                    <asp:Button ID="BT_Login" runat="server" CssClass="inpuLogon" Text="<%$ Resources:lang,Login%>" OnClientClick="RemmberUserNameAndPassord()"
                                        OnClick="LB_Login_Click" />

                                    <asp:ImageButton ID="IB_GetSMS" runat="server" ImageUrl="~/Images/SMS.jpg" Width="22px"
                                        Height="22px" OnClick="IB_GetSMS_Click" Visible="False" />
                                    <br />
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
                                            <td></td>
                                        </tr>
                                        <tr>

                                            <td align="center">
                                                <asp:Label ID="LB_Copyright" runat="server" Text="Copyright TakeTop Software 2006-2036 "></asp:Label>
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td align="center">[
                                                  <asp:DropDownList ID="ddlLangSwitcher" runat="server" DataValueField="LangCode" DataTextField="Language" AutoPostBack="true" OnSelectedIndexChanged="ddlLangSwitcher_SelectedIndexChanged" Style="height: 22px;">
                                                  </asp:DropDownList>
                                                ]
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td align="center">
                                                <br />
                                                <em runat="server" id="emSAAS" visible="false" style="text-align: center; font-style: normal;">

                                                    <asp:HyperLink ID="HL_UserRegister" NavigateUrl="TTUserRegisteredSAAS.aspx?Type=APP" Text="<%$ Resources:lang,MianFeiZhuCe%>" runat="server"></asp:HyperLink>

                                                    &nbsp;&nbsp;

                                                <asp:HyperLink ID="HL_FindPWD" NavigateUrl="TTUserPWDFindSAAS.aspx?Type=APP" Text="<%$ Resources:lang,ZhaoHuiMiMa%>" runat="server"></asp:HyperLink>
                                                </em>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td align="center">
                                    <asp:Label ID="LB_User" Text="USER:" Font-Size="X-Small" runat="server"></asp:Label>
                                    <asp:HyperLink ID="HL_UserID" runat="server" Target="_blank" Font-Size="X-Small"></asp:HyperLink>
                                </td>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: absolute; left: 45%; top: 40%;">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <%--  <img id="IMG_Waiting" src="Images/Processing.gif" alt="Loading,please wait..." />--%>
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </center>
</body>
</html>
