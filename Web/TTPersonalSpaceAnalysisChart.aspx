<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTPersonalSpaceAnalysisChart.aspx.cs" Inherits="TTPersonalSpaceAnalysisChart" %>

<%--<%@ OutputCache Duration="3600" VaryByParam="*" %>--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        html {
            overflow-x: hidden;
        }

        .loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 100;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

            .loading img {
                display: block;
                margin: 0 auto;
            }

        #divRenyList {
            position: relative;
            width: 100%;
            height: 165px;
            overflow: hidden;
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        var chartLoadCount = 0;
        var totalCharts = 0;

        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }

            // 计算总图表数
            totalCharts = $('iframe').length;
            if ($('#litSystemAnalystChartHTML').children().length > 0) {
                totalCharts += 1;
            }

            // 如果总图表数为0，隐藏loading
            if (totalCharts === 0) {
                document.getElementById("loading").style.display = "none";
            }
        });

        function chartLoaded() {
            chartLoadCount++;
            if (chartLoadCount >= totalCharts) {
                document.getElementById("loading").style.display = "none";
            }
        }

        function displayScroll() {
            document.getElementById("divRenyList").style.overflow = "auto";
        }

        function hideScroll() {
            document.getElementById("divRenyList").style.overflow = "hidden";
        }

        function displayProcessing(varStatus) {
            document.getElementById("loading").style.display = varStatus;
        }

    </script>

</head>
<body>
    <center>
        <form id="form1" runat="server">
      
            <table width="98%" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top" align="center" style="padding: 0px 1px 1px 1px; border: 0px solid rgba(193, 189, 189, 0.39)" onmouseenter="javascript:displayScroll();" onmousemove="javascript:displayScroll();" onmouseover="javascript:displayScroll();" onmouseout="javascript:hideScroll();">
                        <div id="loading" class="loading" style="display: block;">
                            <img src="Images/Processing.gif" alt="Loading,please wait..." />
                        </div>
                        <div id="divRenyList" class="renyList" style="width: 100%; height: 165px; overflow: hidden;">
                            <asp:Repeater ID="RP_ChartList" runat="server">
                                <ItemTemplate>
                                    <asp:Label ID="LB_ChartName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ChartName") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="LB_ChartType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ChartType") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="LB_SqlCode" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SqlCode") %>' Visible="false"></asp:Label>
                                    <iframe id="iframeChart" src="TTTakeTopAnalystChartSet.aspx?FormType=<%# DataBinder.Eval(Container.DataItem,"FormType") %>&ChartType=<%# DataBinder.Eval(Container.DataItem,"ChartType") %>&ChartName=<%# DataBinder.Eval(Container.DataItem,"ChartName") %>" style="width: 300px; height: 295px; border: 1px solid white; overflow: hidden;" onload="chartLoaded()"></iframe>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Literal ID="litSystemAnalystChartHTML" runat="server"></asp:Literal>
                        </div>
                    </td>
                </tr>
            </table>
        
        </form>
    </center>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>