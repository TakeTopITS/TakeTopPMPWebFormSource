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

        /* 动感 loading 动画：有色部分慢慢延展 */
        @keyframes tt-progress {
            0% { --progress: 0%; }
            50% { --progress: 75%; }
            100% { --progress: 100%; }
        }

        @keyframes tt-rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* 备用方案：使用 clip-path 实现有色部分延展 */
        .tt-loading-progress {
            animation: tt-rotate 2s linear infinite;
        }

        .tt-loading-progress::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: conic-gradient(#367E7F 0% var(--progress, 0%), transparent var(--progress, 0%) 100%);
            animation: tt-fill-progress 2s ease-in-out infinite;
        }

        @keyframes tt-fill-progress {
            0% { background: conic-gradient(#367E7F 0deg, #ddd 0deg); }
            25% { background: conic-gradient(#367E7F 90deg, #ddd 90deg); }
            50% { background: conic-gradient(#367E7F 180deg, #ddd 180deg); }
            75% { background: conic-gradient(#367E7F 270deg, #ddd 270deg); }
            100% { background: conic-gradient(#367E7F 360deg, #ddd 360deg); }
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        var chartLoadCount = 0;
        var totalCharts = 0;
        var reloadTimer = null;
        var initialCheckTimer = null;
        var hasReloaded = false; // 标记是否已经刷新过，防止重复刷新
        var allChartsLoaded = false; // 标记所有图表是否已加载完成

        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }

            // 计算总图表数
            totalCharts = $('iframe').length;
            if ($('#litSystemAnalystChartHTML').children().length > 0) {
                totalCharts += 1;
            }

            // 如果总图表数为0，隐藏loading，10秒后刷新一次
            if (totalCharts === 0) {
                document.getElementById("loading").style.display = "none";
                allChartsLoaded = true;
                startReloadAfterLoaded();
            } else {
                // 启动初始检查定时器：5秒后检查是否所有图表都加载完成
                initialCheckTimer = setTimeout(function() {
                    checkAllChartsLoaded();
                }, 5000);
                
                // 启动强制检测：8秒后无论如何都执行一次数据检测
                forceCheckAfterDelay();
            }
        });

        // 图表加载完成后10秒刷新一次
        function startReloadAfterLoaded() {
            if (hasReloaded) return;
            console.log("图表加载完成，10秒后自动刷新...");
            setTimeout(function() {
                if (!hasReloaded) {
                    hasReloaded = true;
                    reloadCharts();
                }
            }, 10000);
        }

        function chartLoaded(iframe, loadingId) {
            chartLoadCount++;
            console.log("图表加载完成: " + chartLoadCount + "/" + totalCharts);
            
            // 隐藏对应图表的 loading 覆盖层
            if (loadingId) {
                var loadingEl = document.getElementById(loadingId);
                if (loadingEl) {
                    loadingEl.style.display = "none";
                }
            }
            
            if (chartLoadCount >= totalCharts) {
                document.getElementById("loading").style.display = "none";
                allChartsLoaded = true;
                // 所有图表加载完成后10秒刷新一次
                startReloadAfterLoaded();
            }
        }

        // 检查所有图表是否已加载（防止 onload 事件未触发）
        function checkAllChartsLoaded() {
            if (chartLoadCount < totalCharts) {
                console.log("图表加载不完整，强制检查...");
                // 强制完成加载计数
                chartLoadCount = totalCharts;
                document.getElementById("loading").style.display = "none";
                allChartsLoaded = true;
                // 强制加载完成后10秒刷新一次
                startReloadAfterLoaded();
            }
        }

        // 检查图表是否有数据
        function checkChartData() {
            var hasEmptyData = false;
            
            // 方法1：检查当前页面内容是否包含 "--"
            var pageContent = document.body.innerHTML;
            if (pageContent.indexOf('--') !== -1) {
                hasEmptyData = true;
                console.log("检测到页面内容包含 '--'");
            }
            
            // 方法2：检查所有 iframe 的内容
            var iframes = document.querySelectorAll('iframe');
            for (var i = 0; i < iframes.length; i++) {
                try {
                    var iframeDoc = iframes[i].contentDocument || iframes[i].contentWindow.document;
                    if (iframeDoc && iframeDoc.body) {
                        var iframeContent = iframeDoc.body.innerHTML;
                        if (iframeContent.indexOf('--') !== -1) {
                            hasEmptyData = true;
                            console.log("检测到 iframe[" + i + "] 包含 '--'");
                        }
                    }
                } catch (e) {
                    // 跨域或无法访问时忽略
                }
            }
            
            if (hasEmptyData && !hasReloaded) {
                console.log("检测到数据不完整（包含 '--'），10秒后自动重载...");
                hasReloaded = true;
                startReloadTimer();
            } else if (!hasReloaded && allChartsLoaded) {
                // 数据完整且图表已加载完成，10秒后刷新一次
                console.log("图表数据完整，10秒后自动刷新...");
                hasReloaded = true;
                startReloadTimer();
            } else {
                console.log("所有图表数据完整，无需刷新");
            }
        }

        // 启动重载定时器
        function startReloadTimer() {
            if (reloadTimer || hasReloaded) {
                return; // 已经刷新过就不再启动定时器
            }
            reloadTimer = setTimeout(function() {
                if (!hasReloaded) {
                    hasReloaded = true;
                    reloadCharts();
                }
            }, 10000); // 10秒后重载
        }

        // 强制检测（用于页面加载后延迟检测）
        function forceCheckAfterDelay() {
            setTimeout(function() {
                console.log("执行强制检测...");
                checkChartData();
            }, 8000); // 页面加载8秒后强制检测
        }

        // 重新加载图表（清除缓存后重新查询）
        function reloadCharts() {
            console.log("检测到数据为空，清除缓存并重新加载...");
            // 添加 clearCache=1 参数，让后端清除缓存并重新执行查询
            window.location.href = window.location.pathname + '?clearCache=1&reload=' + new Date().getTime();
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
                                    <!-- 每个图表容器：包含 loading 覆盖层和 iframe -->
                                    <div class="chart-container" style="position: relative; display: inline-block; width: 300px; height: 165px; overflow: hidden;">
                                        <!-- loading 覆盖层，iframe 加载完成后隐藏 -->
                                        <div class="chart-loading" id="chartLoading_<%# Container.ItemIndex %>" style="position: absolute; top: 0; left: 0; width: 100%; height: 165px; background: #f5f5f5; display: flex; align-items: center; justify-content: center; z-index: 10;">
                                            <div style="text-align: center;">
                                                <!-- 动感 loading：有色部分慢慢延展 -->
                                                <div class="tt-loading-progress" style="position: relative; width: 36px; height: 36px; border-radius: 50%; background: conic-gradient(#367E7F var(--progress, 0%), #ddd 0%); animation: tt-progress 2s ease-in-out infinite, tt-rotate 2s linear infinite;">
                                                    <div style="position: absolute; top: 3px; left: 3px; right: 3px; bottom: 3px; background: #f5f5f5; border-radius: 50%;"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <iframe id="iframeChart_<%# Container.ItemIndex %>" src="TTTakeTopAnalystChartSet.aspx?FormType=<%# DataBinder.Eval(Container.DataItem,"FormType") %>&ChartType=<%# DataBinder.Eval(Container.DataItem,"ChartType") %>&ChartName=<%# DataBinder.Eval(Container.DataItem,"ChartName") %>&SqlCode=<%# System.Web.HttpUtility.UrlEncode(DataBinder.Eval(Container.DataItem,"SqlCode").ToString()) %>" style="width: 300px; height: 295px; border: 1px solid white; overflow: hidden;" onload="chartLoaded(this, 'chartLoading_<%# Container.ItemIndex %>')"></iframe>
                                    </div>
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