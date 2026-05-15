<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPMyKPICheckSet.aspx.cs" Inherits="TTAPPMyKPICheckSet" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        /* 移动端优化样式 */
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #333;
            background-color: #f5f5f5;
            -webkit-text-size-adjust: 100%;
            -webkit-tap-highlight-color: transparent;
        }

        .mobile-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: 50px;
            background: linear-gradient(135deg, #1976D2 0%, #0D47A1 100%);
            color: white;
            z-index: 1000;
            display: flex;
            align-items: center;
            padding: 0 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header-title {
            flex: 1;
            text-align: center;
            font-size: 18px;
            font-weight: 500;
        }

        .header-back {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
        }

        .content-wrapper {
            margin-top: 5px;
            margin-bottom: 60px;
            padding: 15px;
        }

        .mobile-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 15px;
            overflow: hidden;
        }

        .card-header {
            padding: 15px;
            background: #f8f9fa;
            border-bottom: 1px solid #eee;
            font-weight: 500;
            color: #1976D2;
        }

        .card-body {
            padding: 15px;
        }

        .mobile-button {
            display: block;
            width: 100%;
            padding: 12px 15px;
            background: #1976D2;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            text-align: center;
            margin: 10px 0;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .mobile-button:hover,
            .mobile-button:active {
                background: #1565C0;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(25,118,210,0.3);
            }

            .mobile-button.yellow {
                background: #FFC107;
                color: #333;
            }

                .mobile-button.yellow:hover,
                .mobile-button.yellow:active {
                    background: #FFB300;
                }

        .list-item {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            background: white;
            transition: background 0.2s ease;
        }

            .list-item:active {
                background: #f5f5f5;
            }

        .action-buttons {
            display: flex;
            gap: 8px;
            margin: 8px 0;
        }

        .action-button {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: #f5f5f5;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

            .action-button:active {
                background: #e0e0e0;
                transform: scale(0.95);
            }

        .mobile-input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            margin: 8px 0;
            box-sizing: border-box;
            -webkit-appearance: none;
        }

            .mobile-input:focus {
                outline: none;
                border-color: #1976D2;
                box-shadow: 0 0 0 2px rgba(25,118,210,0.1);
            }

        .mobile-select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            margin: 8px 0;
            background: white;
            -webkit-appearance: none;
        }

        /* DataGrid移动端样式 */
        .datagrid-container {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .datagrid-table {
            min-width: 100%;
            background: white;
        }

            .datagrid-table .itemStyle {
                border-bottom: 1px solid #eee;
            }

            .datagrid-table .itemBorder {
                padding: 12px 8px;
                vertical-align: middle;
            }

                .datagrid-table .itemBorder img {
                    width: 20px;
                    height: 20px;
                }

        .pagination {
            justify-content: center;
            align-items: center;
            padding: 15px;
            background: white;
            border-top: 1px solid #eee;
        }

        /* KPI评分项样式 */
        .kpi-summary {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 15px 0;
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .kpi-item {
            flex: 1;
            min-width: 150px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 6px;
            text-align: center;
        }

        .kpi-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }

        .kpi-value {
            font-size: 18px;
            font-weight: bold;
            color: #1976D2;
        }

        .kpi-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            background: #E8F5E9;
            color: #388E3C;
        }

        /* 弹窗相关样式 */
        .popup-content {
            padding: 15px;
        }

        .score-section {
            margin-bottom: 20px;
        }

        .comment-section {
            margin-top: 15px;
        }

        .comment-item {
            background: #f9f9f9;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 12px;
            border-left: 4px solid #1976D2;
        }

        .comment-title {
            font-weight: bold;
            color: #1976D2;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .comment-meta {
            font-size: 12px;
            color: #666;
            margin-bottom: 8px;
        }

        .comment-content {
            background: white;
            padding: 10px;
            border-radius: 5px;
            font-size: 13px;
            line-height: 1.5;
        }

        /* 弹窗底部按钮区域 */
        .layui-layer-btn {
            padding: 15px;
            text-align: center;
            background: white;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .popup-button {
            display: inline-block;
            padding: 10px 25px;
            background: #1976D2;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            text-align: center;
            min-width: 120px;
        }

        .popup-button-close {
            background: #f5f5f5;
            color: #333;
            border: 1px solid #ddd;
        }

        /* 触摸反馈 */
        .touch-feedback {
            position: relative;
            overflow: hidden;
        }

            .touch-feedback:after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 5px;
                height: 5px;
                background: rgba(0,0,0,0.1);
                opacity: 0;
                border-radius: 100%;
                transform: scale(1, 1) translate(-50%);
                transform-origin: 50% 50%;
            }

            .touch-feedback:active:after {
                animation: ripple 0.6s ease-out;
            }

        @keyframes ripple {
            0% {
                transform: scale(0, 0);
                opacity: 0.5;
            }

            100% {
                transform: scale(20, 20);
                opacity: 0;
            }
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }



        /* 更新按钮样式 */
        .action-cell {
            padding: 12px 8px !important;
            text-align: center;
            vertical-align: middle;
        }

        .update-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, #1976D2 0%, #1565C0 100%);
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(25, 118, 210, 0.25);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

            .update-btn:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 100%);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .update-btn:hover:before,
            .update-btn:active:before {
                opacity: 1;
            }

            .update-btn:hover {
                transform: translateY(-2px) scale(1.05);
                box-shadow: 0 6px 16px rgba(25, 118, 210, 0.35);
            }

            .update-btn:active {
                transform: translateY(0) scale(0.98);
                box-shadow: 0 2px 6px rgba(25, 118, 210, 0.2);
            }

            .update-btn img {
                width: 28px !important;
                height: 28px !important;
                filter: brightness(0) invert(1);
                transition: transform 0.2s ease;
            }

            .update-btn:hover img {
                transform: scale(1.1);
            }

            .update-btn:active img {
                transform: scale(0.95);
            }

        /* 触摸设备优化 */
        @media (hover: none) {
            .update-btn:hover {
                transform: none;
                box-shadow: 0 4px 12px rgba(25, 118, 210, 0.25);
            }

            .update-btn:active {
                transform: scale(0.95);
                box-shadow: 0 2px 6px rgba(25, 118, 210, 0.2);
                background: linear-gradient(135deg, #1565C0 0%, #0D47A1 100%);
            }
        }

        /* 按钮点击涟漪效果 */
        .update-btn:after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
            background-image: radial-gradient(circle, rgba(255,255,255,0.4) 10%, transparent 10.01%);
            background-repeat: no-repeat;
            background-position: 50%;
            transform: scale(10, 10);
            opacity: 0;
            transition: transform .5s, opacity 1s;
        }

        .update-btn:active:after {
            transform: scale(0, 0);
            opacity: .3;
            transition: 0s;
        }
        
        /* 弹出层优化样式 */
        .layui-layer-iframe {
            max-height: 80vh !important;
            top: 20px !important;
            bottom: auto !important;
        }
        
        .layui-layer-content {
            max-height: calc(80vh - 130px) !important;
            overflow-y: auto !important;
            -webkit-overflow-scrolling: touch;
        }

        /* 响应式调整 */
        @media (max-width: 480px) {
            .layui-layer-iframe {
                width: 95% !important;
                max-height: 85vh !important;
                top: 10px !important;
            }
            
            .layui-layer-content {
                max-height: calc(85vh - 130px) !important;
            }
            
            .popup-button {
                min-width: 100px;
                padding: 8px 15px;
                font-size: 14px;
            }
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>

    <script type="text/javascript" language="javascript">
        // 使用与第二个页面相同的加载方式
        var $load = function (loadFunc) {
            $(function () {
                initSwipeBack(); // 初始化滑动返回功能
                if (typeof (Sys) != 'undefined') {
                    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(loadFunc);
                }
                else {
                    loadFunc();
                }
            });
        };

        $load(function () {
            // 防止双击放大
            var lastTouchEnd = 0;
            document.addEventListener('touchend', function (event) {
                var now = (new Date()).getTime();
                if (now - lastTouchEnd <= 300) {
                    event.preventDefault();
                }
                lastTouchEnd = now;
            }, false);

            // 显示加载状态
            $('form').on('submit', function () {
                showLoading();
            });

            // 返回按钮点击
            $('.header-back').on('click', function () {
                window.history.back();
            });

            // 为更新按钮添加点击事件，显示弹窗
            $('[id*="DataGrid2"] [commandname="Update"]').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                showKPIPopup();
                return false;
            });

            // 绑定遮罩层点击关闭事件
            $('#popwindow_shade').on('click', function () {
                popClose();
            });

            // 初始化弹出层位置调整
            optimizePopupPosition();
        });

        function showLoading() {
            $('<div style="position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(255,255,255,0.9); display:flex; align-items:center; justify-content:center; z-index:9999;"><div style="width:40px; height:40px; border:3px solid #f3f3f3; border-top:3px solid #1976D2; border-radius:50%; animation:spin 1s linear infinite;"></div></div>').appendTo('body');
        }

        function hideLoading() {
            $('[style*="position:fixed"][style*="background:rgba(255,255,255,0.9)"]').remove();
        }

        function adjustPopupPosition($popup) {
            var windowHeight = $(window).height();
            var windowWidth = $(window).width();

            // 设置弹窗始终靠近顶部
            var topPosition = 20; // 始终距离顶部20px

            // 计算弹窗高度（不超过窗口高度的85%）
            var maxPopupHeight = windowHeight - topPosition - 20; // 减去顶部和底部间距
            var popupHeight = Math.min(maxPopupHeight, 600);

            // 计算弹窗宽度（不超过窗口宽度的95%）
            var popupWidth = Math.min(windowWidth * 0.95, 500);

            // 设置弹窗样式 - 使用fixed定位确保始终可见
            $popup.css({
                'position': 'fixed',
                'top': topPosition + 'px',
                'left': '50%',
                'transform': 'translateX(-50%)',
                'width': popupWidth + 'px',
                'height': 'auto',
                'max-height': popupHeight + 'px',
                'display': 'block',
                'overflow': 'hidden',
                'z-index': '9999'
            });

            // 显示遮罩层
            $('#popwindow_shade').css({
                'display': 'block',
                'position': 'fixed',
                'top': '0',
                'left': '0',
                'right': '0',
                'bottom': '0',
                'z-index': '9998'
            });

            // 计算内容区域可用高度
            var titleHeight = $popup.find('.layui-layer-title').outerHeight() || 50;
            var footerHeight = $popup.find('#popwindow_footer').outerHeight() || 70;
            var contentHeight = popupHeight - titleHeight - footerHeight;

            // 设置内容区域高度
            $popup.find('.layui-layer-content').css({
                'height': contentHeight + 'px',
                'max-height': contentHeight + 'px',
                'overflow-y': 'auto'
            });

            // 滚动到顶部
            $popup.find('.layui-layer-content').scrollTop(0);

            // 强制刷新布局
            $popup[0].offsetHeight;
        }

        function showKPIPopup() {
            var $popup = $('#popwindow');
            if ($popup.length) {
                adjustPopupPosition($popup);
            }
        }

        function optimizePopupPosition() {
            // 监听窗口大小变化，重新调整弹出层位置
            $(window).on('resize', function () {
                var $popup = $('#popwindow');
                if ($popup.is(':visible')) {
                    adjustPopupPosition($popup);
                }
            });

            // 监听触摸事件，防止弹窗内滚动传播到body
            $('#popwindow').on('touchmove', function (e) {
                e.stopPropagation();
            });
        }

        // 弹窗关闭函数
        function popClose() {
            $('#popwindow').hide();
            $('#popwindow_shade').hide();
            return false;
        }

        // 添加窗口大小变化时的调整
        $(window).on('resize', function () {
            var $popup = $('#popwindow');
            if ($popup.is(':visible')) {
                adjustPopupPosition($popup);
            }
        });

        // 添加键盘ESC关闭弹窗
        $(document).on('keydown', function (e) {
            if (e.keyCode === 27) { // ESC键
                if ($('#popwindow').is(':visible')) {
                    popClose();
                }
            }
        });
    </script>
</head>
<body data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
       <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    <!-- 滑动反馈层 -->
    <canvas id="myCanvas" style="display: none;"></canvas>
    <!-- 移动端头部 -->
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td height="31" class="page_topbj">
                <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="ItemAlignLeft">
                            <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_parent" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">

                                <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="29">
                                            <img src="ImagesSkin/return.png" alt="" />
                                        </td>
                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                            <asp:Label runat="server" Text="<%$ Resources:lang,Back%>" />
                                        </td>
                                        <td width="5">
                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                        </td>
                                    </tr>
                                </table>
                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                            </a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <!-- 主要内容区域 -->
    <div class="content-wrapper">
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>


                    <!-- KPI列表 -->
                    <div class="mobile-card" style="text-align: center;">
                        <div class="card-header">
                            KPI List
                        </div>
                        <div class="card-body datagrid-container">
                            <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False" GridLines="None"
                                OnItemCommand="DataGrid2_ItemCommand" OnPageIndexChanged="DataGrid2_PageIndexChanged"
                                AllowCustomPaging="false" AllowPaging="true" PageSize="10" ShowHeader="False"
                                Width="100%" CssClass="datagrid-table">
                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                <EditItemStyle BackColor="#2461BF" />
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />

                                <ItemStyle CssClass="itemStyle" />
                                <Columns>
                                    <asp:ButtonColumn ButtonType="LinkButton" CommandName="Update"
                                        Text="&lt;div class='update-btn'&gt;&lt;img src='ImagesSkin/Update.png' alt='修改' /&gt;&lt;/div&gt;">
                                        <ItemStyle CssClass="action-cell" Width="70px" />
                                    </asp:ButtonColumn>
                                    <asp:BoundColumn DataField="ID" HeaderText="ID">
                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="KPI" HeaderText="KPI">
                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" />
                                    </asp:BoundColumn>
                                </Columns>
                            </asp:DataGrid>
                        </div>
                    </div>

                    <!-- KPI信息摘要 -->
                    <div class="mobile-card">
                        <div class="card-header">
                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label>:
                            <asp:Label ID="LB_KPICheckID" runat="server"></asp:Label>
                            &nbsp;<asp:Label ID="LB_KPICheckName" runat="server"></asp:Label>
                            &nbsp;KPI
                        </div>
                        <div class="card-body">
                            <!-- KPI评分摘要 -->
                            <div class="kpi-summary">
                                <div class="kpi-item">
                                    <div class="kpi-label">
                                        <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,ZiPingZongFen%>"></asp:Label>
                                    </div>
                                    <div class="kpi-value">
                                        <asp:Label ID="LB_TotalSelfPoint" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="kpi-item">
                                    <div class="kpi-label">
                                        <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,LingDaoPingZongFen%>"></asp:Label>
                                    </div>
                                    <div class="kpi-value">
                                        <asp:Label ID="LB_TotalLeaderPoint" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="kpi-item">
                                    <div class="kpi-label">
                                        <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,DiSanFangPingZongFen%>"></asp:Label>
                                    </div>
                                    <div class="kpi-value">
                                        <asp:Label ID="LB_TotalThirdPartPoint" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="kpi-item">
                                    <div class="kpi-label">
                                        <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,XiTongZongPingFen%>"></asp:Label>
                                    </div>
                                    <div class="kpi-value">
                                        <asp:Label ID="LB_TotalSqlPoint" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="kpi-item">
                                    <div class="kpi-label">
                                        <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,RenShiPingZongFen%>"></asp:Label>
                                    </div>
                                    <div class="kpi-value">
                                        <asp:Label ID="LB_TotalHRPoint" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="kpi-item">
                                    <div class="kpi-label">
                                        <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,ZongFen%>"></asp:Label>
                                    </div>
                                    <div class="kpi-value">
                                        <asp:Label ID="LB_TotalPoint" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="kpi-item">
                                    <div class="kpi-label">
                                        <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                    </div>
                                    <div class="kpi-value">
                                        <asp:Label ID="LB_Status" runat="server"></asp:Label>
                                    </div>
                                </div>
                            </div>
                            <asp:Label ID="LB_Sql" runat="server" Visible="false"></asp:Label>
                        </div>
                    </div>



                    <!-- 修改后的弹窗区域 - 修复布局问题 -->
                    <div class="layui-layer layui-layer-iframe" id="popwindow" name="fixedDiv"
                        style="z-index: 9999; display: none; border-radius: 10px; background: white; box-shadow: 0 4px 20px rgba(0,0,0,0.15); position: fixed; left: 0; top: 0; margin: 0;">
                        <div class="layui-layer-title" style="background: #e7e7e8; padding: 12px 15px; font-weight: 500; border-radius: 10px 10px 0 0;" id="popwindow_title">
                            <asp:Label ID="Label172" runat="server" Text="KPI评分"></asp:Label>
                        </div>
                        <div id="popwindow_content" class="layui-layer-content" style="overflow-y: auto; -webkit-overflow-scrolling: touch; max-height: calc(100% - 130px);">
                            <div class="popup-content">
                                <!-- 评分输入区 -->
                                <div class="score-section">
                                    <asp:Label ID="LB_KPIID" runat="server" Visible="false"></asp:Label>
                                    <div style="margin-bottom: 15px;">
                                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,ZiPingFen%>" Style="display: block; margin-bottom: 8px; font-weight: 500; color: #333;"></asp:Label>
                                        <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000" ID="NB_SelfPoint" runat="server" Width="100%" CssClass="mobile-input">0.00</NickLee:NumberBox>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,YiJian%>" Style="display: block; margin-bottom: 8px; font-weight: 500; color: #333;"></asp:Label>
                                        <CKEditor:CKEditorControl ID="HE_SelfSummary" runat="server" Toolbar="" Height="150px" Width="100%" Visible="false" />
                                    </div>
                                </div>

                                <!-- 评论显示区 -->
                                <div class="comment-section">
                                    <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,PingHeYiJian%>" Style="display: block; margin-bottom: 15px; font-weight: 500; color: #1976D2; font-size: 16px;"></asp:Label>

                                    <!-- 自评评论 -->
                                    <asp:DataList ID="DataList1" runat="server" CellPadding="0" ForeColor="#333333" Height="16px" Width="100%">
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="comment-item">
                                                <div class="comment-title">
                                                    <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,ZiPing%>"></asp:Label>
                                                </div>
                                                <div class="comment-content">
                                                    <%#DataBinder.Eval(Container.DataItem, "SelfComment")%>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <ItemStyle CssClass="itemStyle" />
                                    </asp:DataList>

                                    <!-- 第三方评论 -->
                                    <asp:DataList ID="DataList3" runat="server" CellPadding="0" ForeColor="#333333" Height="16px" Width="100%">
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="comment-item">
                                                <div class="comment-title">
                                                    <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,DiSanFangPing%>"></asp:Label>
                                                </div>
                                                <div class="comment-meta">
                                                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,PingHeRen%>"></asp:Label>: *******
                                                </div>
                                                <div class="comment-content">
                                                    <%#DataBinder.Eval(Container.DataItem, "Comment")%>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <ItemStyle CssClass="itemStyle" />
                                    </asp:DataList>

                                    <!-- 领导评论 -->
                                    <asp:DataList ID="DataList2" runat="server" CellPadding="0" ForeColor="#333333" Height="16px" Width="100%">
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="comment-item">
                                                <div class="comment-title">
                                                    <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,LingDaoPing%>"></asp:Label>
                                                </div>
                                                <div class="comment-meta">
                                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,PingHeRen%>"></asp:Label>: <%#DataBinder.Eval(Container.DataItem, "LeaderName")%>
                                                </div>
                                                <div class="comment-content">
                                                    <%#DataBinder.Eval(Container.DataItem, "Comment")%>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <ItemStyle CssClass="itemStyle" />
                                    </asp:DataList>

                                    <!-- 人事评论 -->
                                    <asp:DataList ID="DataList4" runat="server" CellPadding="0" ForeColor="#333333" Height="16px" Width="100%">
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <HeaderTemplate></HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="comment-item">
                                                <div class="comment-title">
                                                    <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,RenShiPing%>"></asp:Label>
                                                </div>
                                                <div class="comment-meta">
                                                    <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,PingHeRen%>"></asp:Label>: <%#DataBinder.Eval(Container.DataItem, "HRName")%>
                                                </div>
                                                <div class="comment-content">
                                                    <%#DataBinder.Eval(Container.DataItem, "Comment")%>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <ItemStyle CssClass="itemStyle" />
                                    </asp:DataList>
                                </div>
                            </div>
                        </div>

                        <!-- 底部按钮区域 - 修复布局 -->
                        <div id="popwindow_footer" class="layui-layer-btn" style="border-top: 1px solid #eee; position: absolute; bottom: 0; left: 0; right: 0; padding: 15px; background: white; border-radius: 0 0 10px 10px;">
                            <asp:LinkButton ID="BT_NewMain" runat="server"
                                OnClick="BT_NewMain_Click"
                                CssClass="popup-button">
                                <asp:Label runat="server" Text="<%$ Resources:lang,BaoCun%>" />
                            </asp:LinkButton>

                            <a onclick="return popClose();"
                                class="popup-button popup-button-close">
                                <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                            </a>
                        </div>

                        <span class="layui-layer-setwin">
                            <a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;" style="top: 12px; right: 12px;"></a>
                        </span>
                    </div>

                    <div class="layui-layer-shade" id="popwindow_shade" style="z-index: 9998; background-color: #000; opacity: 0.3; filter: alpha(opacity=30); display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;"></div>

                    <!-- 图表 -->
                    <div class="mobile-card" style="display: none;">
                        <div class="card-header">
                            KPI图表
                        </div>
                        <div class="card-body">
                            <iframe runat="server" id="IFrame_Chart1" src="TTTakeTopAnalystChartSet.aspx" style="width: 100%; height: 250px; border: none;"></iframe>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <!-- 加载指示器 -->
            <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <div style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.9); display: flex; align-items: center; justify-content: center; z-index: 9999;">
                            <div style="width: 40px; height: 40px; border: 3px solid #f3f3f3; border-top: 3px solid #1976D2; border-radius: 50%; animation: spin 1s linear infinite;"></div>
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </div>

    <!-- 等待图标 -->
    <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 9999;" />
</body>
</html>