<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTModuleFlowChartViewJS.aspx.cs" Inherits="TTModuleFlowChartViewJS" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>TakeTopWF.Designer</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1440px;
            width: expression (document.body.clientWidth <= 1440? "1440px" : "auto" ));
        }

        #divGuide {
            height: 39px;
        }

        html, body {
            height: 100%;
            overflow: auto;
        }

        body {
            padding: 0;
            margin: 0;
        }

        #silverlightControlHost {
            height: 100%;
            text-align: center;
        }

        @-moz-document url-prefix() {
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
                font-family: &#930;
            }

            #navlist a.current:link, #nav a.current:visited {
                color: red;
                background: #d44446;
                padding: 3px;
            }

        #nav1 {
            width: 98%;
            height: 323px;
            background: #fff;
            border-radius: 8px;
            margin: 15px 0;
            box-shadow: 0px 0px 15px rgb(0 0 0 / 15%);
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        #nav2 {
            width: 98%;
        }

        #navlist2 li {
            flex: 0 0 49.5%;
            margin: 0;
            list-style: none;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0px 0px 15px rgb(0 0 0 / 15%);
            margin-bottom: 20px;
        }

        ul#navlist2 {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            padding: 0;
        }

        .cline {
            height: 6px;
            width: 100%;
            background: linear-gradient(135deg, #4F46E5, #7C3AED);
            border-radius: 8px 8px 0px 0px;
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
            position: relative;
        }

        #div_username {
            align-items: center;
            color: #333;
            font-size: 12px;
        }

        #div_updatepersoninfor img {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">

        $(function () {
            if (top.location != self.location) {
                // 页面在iframe中，初始化图形
                initializeChart();
            }
            else {
                CloseWebPage();
            }
        });

        function initializeChart() {
            // 延迟执行以确保DOM完全加载
            setTimeout(function () {
                autoHeight();
                console.log('Chart initialized');
            }, 100);
        }

        //弹出消息框
        function clickPopMsgWindow() {
            top.frames[0].frames[2].parent.frames["rightTopFrame"].clickPopMsgWindow();
        }

        function autoHeight() {
            var b_height = Math.max(document.body.scrollHeight, document.body.clientHeight);
            this.document.getElementById("_WFDesignerFrame").style.width = (document.body.ClientWidth - 15) + "px";
            this.document.getElementById("_WFDesignerFrame").style.height = (document.body.clientHeight - 10) + "px";
            resizeSvg("auto");
        }

        function resizeSvg(varSvgStatus) {
            var iframe = document.getElementById('_WFDesignerFrame');
            var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
            var svgs = iframeDoc.getElementsByTagName("svg");

            for (i = 0; i < svgs.length; i++) {
                svgs[i].style.height = "2148px";
                svgs[i].style.overflow = varSvgStatus;
                var maxX = findMaxXOfChildRects(svgs[i]);
                svgs[i].style.width = (maxX + 216) + "px";
            }
        }

        //取得rect的最大x值
        function findMaxXOfChildRects(parentElement) {
            let maxX = 0;
            const childElements = parentElement.querySelectorAll('*');
            childElements.forEach(child => {
                const rect = child.getBoundingClientRect();
                if (rect.x > maxX) {
                    maxX = rect.x;
                }
            });
            return maxX;
        }

    </script>
</head>
<body onload="autoHeight()" onresize="autoHeight();">
    <form id="OboveForm" runat="server">
        <asp:ScriptManager ID="ScriptManager2" runat="server" />

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <Triggers>
  
            </Triggers>
            <ContentTemplate>
                <table style="width: 100%;">
                    <tr>
                        <td id="td_WFDesignerFrame" style="padding-top: 0px; overflow: hidden; text-align: center;">
                            <iframe id="_WFDesignerFrame" src="WFDesigner/TTTakeTopMFChartViewJS.aspx?IdentifyString=2020060217063966" style="width: 100%; height: 550px; overflow: auto;"></iframe>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td>
                            <asp:TextBox ID="TB_CopyRight" runat="server" Style="visibility: hidden"></asp:TextBox>
                            <asp:TextBox ID="TB_WFIdentifyString" runat="server" Style="visibility: hidden"></asp:TextBox>
                            <asp:TextBox ID="TB_WFXML" runat="server" Style="visibility: hidden"></asp:TextBox>
                            <asp:TextBox ID="TB_WFName" runat="server" Style="visibility: hidden;"></asp:TextBox>
                            <asp:TextBox ID="TB_WFChartString1" runat="server" Style="visibility: hidden"></asp:TextBox>
                            <asp:TextBox ID="TB_WFChartString2" runat="server" Style="visibility: hidden"></asp:TextBox>
                            <asp:TextBox ID="TB_WFChartString3" runat="server" Style="visibility: hidden"></asp:TextBox>
                            <asp:TextBox ID="TB_WFChartString4" runat="server" Style="visibility: hidden"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
