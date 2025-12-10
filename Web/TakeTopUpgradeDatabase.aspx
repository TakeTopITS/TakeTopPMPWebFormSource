<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TakeTopUpgradeDatabase.aspx.cs" Inherits="TakeTopUpgradeDatabase" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        a:link {
            font-size: 12px;
            text-decoration: none;
            color: #000000;
        }
    </style>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {

        });

    </script>
</head>
<body>
    <center>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                    <div style="position: relative; top: 70px;">
                        <table style="width: 980px">
                            <tr>
                                <td style="width: 980px; height: 40px; text-align: center;">

                                    <asp:ImageButton ID="IMB_Logo" runat="server" ImageUrl="~/Logo/logo.gif" OnClick="IMB_Logo_Click" />

                                </td>
                            </tr>
                        </table>

                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: absolute; left: 50%; top: 50%;">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </center>
</body>

<script type="text/javascript" language="javascript">
    // 页面加载完成后执行
    window.addEventListener('load', function () {
        // 设置3秒延迟，以便演示效果
        setTimeout(function () {
            // 获取ImageButton并触发点击事件
            var imageButton = document.getElementById('IMB_Logo');
            if (imageButton) {
                imageButton.click();
                console.log('ImageButton已被自动点击');
            }
        }, 3000);
    });

    // ImageButton点击事件处理函数
    function handleLogoClick() {
        // 显示状态消息
        var statusBox = document.getElementById('statusMessage');
        statusBox.classList.add('visible');

        // 5秒后隐藏消息
        setTimeout(function () {
            statusBox.classList.remove('visible');
        }, 5000);
    }
</script>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
