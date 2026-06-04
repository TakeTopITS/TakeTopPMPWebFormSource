<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPMyMemProjectsRunStatus.aspx.cs" Inherits="TTAPPMyMemProjectsRunStatus" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="ZedGraph.Web" Namespace="ZedGraph.Web" TagPrefix="cc1" %>
<%@ Register Assembly="ZedGraph" Namespace="ZedGraph" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1700px;
            width: expression (document.body.clientWidth <= 1700? "1700px" : "auto" ));
        }
        
        /* 全屏弹窗样式 */
        .fullscreen-popup {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100% !important;
            height: 100% !important;
            margin: 0 !important;
            padding: 0 !important;
            border-radius: 0 !important;
            z-index: 10000 !important;
            background: white !important;
        }
        
        .fullscreen-popup .layui-layer-title {
            height: 45px !important;
            line-height: 45px !important;
            background: #e7e7e8 !important;
            border-radius: 0 !important;
            padding: 0 15px !important;
            font-size: 16px !important;
            font-weight: bold !important;
            border-bottom: 1px solid #ddd !important;
        }
        
        .fullscreen-popup .layui-layer-content {
            position: absolute !important;
            top: 45px !important;
            left: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            height: calc(100% - 45px) !important;
            margin: 0 !important;
            padding: 0 !important;
            overflow: hidden !important;
        }
        
        .fullscreen-popup iframe {
            width: 100% !important;
            height: 100% !important;
            border: none !important;
            display: block !important;
        }
        
        .fullscreen-overlay {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            background: rgba(0,0,0,0.5) !important;
            z-index: 9999 !important;
        }
        
        /* 自定义全屏弹窗样式 */
        .custom-fullscreen-popup {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: white;
            z-index: 10000;
            display: none;
        }
        
        .custom-popup-header {
            height: 45px;
            background: #e7e7e8;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 15px;
            border-bottom: 1px solid #ddd;
        }
        
        .custom-popup-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }
        
        .custom-popup-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s;
        }
        
        .custom-popup-close:hover {
            background: rgba(0,0,0,0.1);
        }
        
        .custom-popup-content {
            position: absolute;
            top: 45px;
            left: 0;
            right: 0;
            bottom: 0;
            overflow: hidden;
        }
        
        .custom-popup-iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
    </style>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>


    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();// 初始化滑动返回功能 

            /*  if (top.location != self.location) { } else { CloseWebPage(); }*/
        });

        function displayQueryDiv() {

            if (document.getElementById('DIV_GroupChart').style.display == 'block') {

                document.getElementById('DIV_GroupChart').style.display = 'none';

            }
            else {
                document.getElementById('DIV_GroupChart').style.display = 'block';
            }
        }

        function openNewWindow() {

            window.open('TTMyMemProjectsRunStatus.aspx', "_blank");
        }

        function refreshWindow() {

            location.reload();
        }

        //传入URL作为参数
        function popShowByURL(url, title, width, height, parentWindow) {
            var w = 'auto', h = 'auto', t = url.replace('.aspx', '').replace("TT", '');

            if (title) {
                t = title;
            }

            // 使用全屏弹窗，顶部和底部都对齐
            layer.open({
                type: 2,
                title: t,
                anim: 0,
                fixed: true,
                resize: false,
                scrollbar: false,
                moveOut: false,
                shade: 0.5,
                shadeClose: true,
                maxmin: false,
                content: url,
                area: ["100%", "100%"],
                offset: ['0px', '0px'], // 从顶部和左侧都为0
                zIndex: 10000,
                success: function (layero, index) {
                    // 添加全屏样式类
                    layero.addClass('fullscreen-popup');

                    // 设置弹窗位置和大小
                    layero.css({
                        'position': 'fixed',
                        'top': '0',
                        'left': '0',
                        'width': '100%',
                        'height': '100%',
                        'margin': '0',
                        'padding': '0',
                        'border-radius': '0'
                    });

                    // 设置标题栏
                    var titleBar = layero.find('.layui-layer-title');
                    titleBar.css({
                        'height': '45px',
                        'line-height': '45px',
                        'background': '#e7e7e8',
                        'border-radius': '0',
                        'padding': '0 15px',
                        'font-size': '16px',
                        'font-weight': 'bold',
                        'border-bottom': '1px solid #ddd',
                        'box-sizing': 'border-box'
                    });

                    // 设置内容区域 - 占据剩余全部空间
                    var content = layero.find('.layui-layer-content');
                    content.css({
                        'position': 'absolute',
                        'top': '45px',
                        'left': '0',
                        'right': '0',
                        'bottom': '0',
                        'width': '100%',
                        'height': 'calc(100% - 45px)',
                        'margin': '0',
                        'padding': '0',
                        'overflow': 'hidden',
                        'box-sizing': 'border-box'
                    });

                    // 设置iframe
                    var iframe = layero.find('iframe');
                    iframe.css({
                        'width': '100%',
                        'height': '100%',
                        'border': 'none',
                        'display': 'block'
                    });

                    // 设置关闭按钮位置
                    var closeBtn = layero.find('.layui-layer-setwin');
                    closeBtn.css({
                        'top': '8px',
                        'right': '10px'
                    });

                    // 强制刷新布局
                    setTimeout(function () {
                        content[0].style.height = (window.innerHeight - 45) + 'px';
                        if (iframe[0]) {
                            iframe[0].style.height = (window.innerHeight - 45) + 'px';
                        }
                    }, 100);

                    // 监听窗口大小变化
                    $(window).on('resize.fullscreenpopup', function () {
                        content.css('height', (window.innerHeight - 45) + 'px');
                        if (iframe.length) {
                            iframe.css('height', (window.innerHeight - 45) + 'px');
                        }
                    });
                },
                cancel: function (index, layero) {
                    // 移除窗口大小变化监听
                    $(window).off('resize.fullscreenpopup');
                    return true;
                },
                end: function () {
                    // 移除窗口大小变化监听
                    $(window).off('resize.fullscreenpopup');
                    parentUrl = parentWindow.href;
                }
            });
        }

        // 自定义全屏弹窗函数
        function showFullScreenPopup(url, title) {
            // 创建遮罩层
            var overlay = document.createElement('div');
            overlay.className = 'fullscreen-overlay';
            overlay.onclick = function () {
                closeFullScreenPopup();
            };

            // 创建弹窗容器
            var popup = document.createElement('div');
            popup.className = 'custom-fullscreen-popup';
            popup.id = 'fullscreen-popup-' + Date.now();

            // 创建标题栏
            var header = document.createElement('div');
            header.className = 'custom-popup-header';

            var titleSpan = document.createElement('span');
            titleSpan.className = 'custom-popup-title';
            titleSpan.textContent = title || 'Project Plan Gantt';

            var closeBtn = document.createElement('button');
            closeBtn.className = 'custom-popup-close';
            closeBtn.innerHTML = '&times;';
            closeBtn.onclick = function (e) {
                e.stopPropagation();
                closeFullScreenPopup();
            };

            header.appendChild(titleSpan);
            header.appendChild(closeBtn);

            // 创建内容区域
            var content = document.createElement('div');
            content.className = 'custom-popup-content';

            var iframe = document.createElement('iframe');
            iframe.className = 'custom-popup-iframe';
            iframe.src = url;
            iframe.frameBorder = '0';
            iframe.allowFullscreen = true;

            content.appendChild(iframe);
            popup.appendChild(header);
            popup.appendChild(content);

            // 添加到页面
            document.body.appendChild(overlay);
            document.body.appendChild(popup);

            // 显示弹窗
            setTimeout(function () {
                popup.style.display = 'block';

                // 设置iframe高度
                setTimeout(function () {
                    iframe.style.height = (window.innerHeight - 45) + 'px';
                }, 50);
            }, 10);

            // 禁止body滚动
            document.body.style.overflow = 'hidden';

            // 监听窗口大小变化
            var resizeHandler = function () {
                iframe.style.height = (window.innerHeight - 45) + 'px';
            };
            window.addEventListener('resize', resizeHandler);

            // 保存引用以便清理
            popup._resizeHandler = resizeHandler;
            popup._overlay = overlay;

            return false;
        }

        function closeFullScreenPopup() {
            var popup = document.querySelector('.custom-fullscreen-popup');
            var overlay = document.querySelector('.fullscreen-overlay');

            if (popup) {
                // 移除事件监听
                if (popup._resizeHandler) {
                    window.removeEventListener('resize', popup._resizeHandler);
                }

                // 移除元素
                popup.parentNode.removeChild(popup);
            }

            if (overlay) {
                overlay.parentNode.removeChild(overlay);
            }

            // 恢复body滚动
            document.body.style.overflow = '';
        }

        // 增强的弹窗函数 - 主要使用自定义全屏弹窗
        function showGanttPopup(projectId, projectName) {
            var url = 'TTWorkPlanGanttForProjectStandardActivityCompareMain.aspx?ProjectID=' + projectId;
            var title = 'Project Plan Gantt - ' + (projectName || '');

            // 优先使用自定义全屏弹窗
            return showFullScreenPopup(url, title);
        }

    </script>
</head>
<body>
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" /></div>
    <!-- 滑动反馈层 -->
    <center>
        <form id="form1" runat="server">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div>
                        <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                            <tr>
                                <td height="31" class="page_topbj" width="100%">
                                    <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <a id="aAPPBackPriorPage" href="TakeTopAPPMain.aspx" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                    <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td width="29">
                                                                <img src="ImagesSkin/return.png" alt="" width="29" height="31" /></td>
                                                            <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                            </td>
                                                            <td width="5">
                                                                <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%></td>
                                                        </tr>
                                                    </table>
                                                    <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="ItemAlignLeft" style="border-left: solid 1px #d0d0d0">
                                                <table width="100%" style="margin-top: 5px">
                                                    <tr>
                                                        <td>
                                                            <div class="napbox">
                                                                <div class="npb">
                                                                    <div class="cline"></div>
                                                                    <h3>
                                                                         <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XiangmuZhuangTai%>"></asp:Label>
                                                                      </h3>
                                                                </div>

                                                                <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" Width="100%" PageSize="30"
                                                                    ShowHeader="false" AllowPaging="True" OnPageIndexChanged="DataGrid3_PageIndexChanged"
                                                                    CellPadding="4" ForeColor="#333333" GridLines="None">
                                                                    <Columns>
                                                                        <asp:BoundColumn DataField="ProjectID" HeaderText="项目ID" Visible="false">
                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                                        </asp:BoundColumn>

                                                                        <asp:TemplateColumn HeaderText="">

                                                                            <ItemTemplate>

                                                                                <div class="npb npbs">
                                                                                    <div class="nplef">
                                                                                        <img src="ImagesSkin/napicon.png" />
                                                                                    </div>
                                                                                    <div class="nprig">
                                                                                        <h4>
                                                                                            <!-- 使用自定义全屏弹窗 -->
                                                                                            <a onclick="javascript:showGanttPopup('<%#DataBinder .Eval (Container .DataItem ,"ProjectID") %>', '<%# Server.HtmlEncode(Eval("ProjectName").ToString()) %>');return false;" style="cursor:pointer;color:#1976D2;text-decoration:none;">
                                                                                                <%# Eval("ProjectName") %>
                                                                                            </a>

                                                                                        </h4>
                                                                                        <h5>
                                                                                            <%# Eval("ProjectID").ToString() %><sub></sub></h5>
                                                                                        <h6>
                                                                                            <asp:Label ID="LB_DGProgress" runat="server" Text="<%$ Resources:lang,Progress%>"></asp:Label>


                                                                                            <div><%#DataBinder .Eval (Container .DataItem ,"FinishPercent") %>%</div>

                                                                                        </h6>
                                                                                        <h6>
                                                                                            <asp:Label ID="LB_DGStartTime" runat="server" Text="<%$ Resources:lang,ShiJian%>"></asp:Label>

                                                                                            <asp:Label ID="LB_MoreTime" runat="server" Text="<%$ Resources:lang,ChaoQi%>" Height="15px" Font-Size="XX-Small"
                                                                                                ForeColor="Red"></asp:Label>
                                                                                            <asp:Label ID="LB_Delaydays" runat="server" Height="15px" Font-Size="XX-Small"
                                                                                                ForeColor="Red"></asp:Label>
                                                                                            <asp:Label ID="LB_DayUnit" runat="server" Text="<%$ Resources:lang,Tian%>" Height="15px" Font-Size="XX-Small"
                                                                                                ForeColor="Red"></asp:Label>
                                                                                            <br />
                                                                                            <asp:Label ID="LB_BeginDate" runat="server" Height="20px" Font-Size="XX-Small"
                                                                                                BackColor="Yellow" Text=' <%#DataBinder.Eval (Container .DataItem ,"BeginDate") %>'></asp:Label>
                                                                                            ---
                                                                                                        <asp:Label ID="LB_EndDate" runat="server" Height="20px" Font-Size="XX-Small"
                                                                                                            BackColor="Yellow" Text='<%#DataBinder.Eval (Container .DataItem ,"EndDate") %>'></asp:Label>
                                                                                        </h6>
                                                                                        <h6>Data:2022.03.09</h6>
                                                                                        <label><%# ShareClass. GetStatusHomeNameByProjectStatus(Eval("Status").ToString(),Eval("ProjectType").ToString()) %></label>
                                                                                    </div>

                                                                                </div>


                                                                            </ItemTemplate>

                                                                        </asp:TemplateColumn>

                                                                    </Columns>


                                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                    <EditItemStyle BackColor="#2461BF" />
                                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                    <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText=">" PrevPageText="<" CssClass="notTab" />
                                                                </asp:DataGrid>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 100%; height: 12px; text-align: left;" valign="top">
                                                            <cc2:TabContainer CssClass="ajax_tab_menu" ID="TabContainer1" Width="100%" runat="server" ActiveTabIndex="0">
                                                                <cc2:TabPanel ID="TabPanel3" runat="server" HeaderText="项目状态">
                                                                    <HeaderTemplate>
                                                                        <asp:Label ID="LB_ProjectStatusChart" runat="server" Text="<%$ Resources:lang,ProjectStatusChart%>"></asp:Label>
                                                                    </HeaderTemplate>
                                                                    <ContentTemplate>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td>
                                                                                    <div class="renyList">
                                                                                        <asp:Repeater ID="RP_ChartList" runat="server">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="LB_ChartName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ChartName") %>' Visible="false"></asp:Label>
                                                                                                <asp:Label ID="LB_ChartType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ChartType") %>' Visible="false"></asp:Label>
                                                                                                <asp:Label ID="LB_SqlCode" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SqlCode") %>' Visible="false"></asp:Label>

                                                                                                <iframe src="TTTakeTopAnalystChartSet.aspx?FormType=<%# DataBinder.Eval(Container.DataItem,"FormType") %>&ChartType=<%# DataBinder.Eval(Container.DataItem,"ChartType") %>&ChartName=<%# DataBinder.Eval(Container.DataItem,"ChartName") %>" style="width: 300px; height: 295px; border: 1px solid white; text-align: left; overflow: hidden;"></iframe>
                                                                                            </ItemTemplate>
                                                                                        </asp:Repeater>
                                                                                        <br />
                                                                                        <br />
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align="center" style="vertical-align: bottom;">
                                                                                    <asp:HyperLink ID="HL_SystemAnalystChartRelatedUserSet" runat="server" Text="<%$ Resources:lang,FenXiTuSheZhi %>"></asp:HyperLink>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </ContentTemplate>
                                                                </cc2:TabPanel>
                                                                <cc2:TabPanel ID="TabPanel4" runat="server" HeaderText="综合查询">
                                                                    <HeaderTemplate>
                                                                        <asp:Label ID="LB_IntegratedQuery" runat="server" Text="<%$ Resources:lang,IntegratedQuery%>"></asp:Label>
                                                                    </HeaderTemplate>
                                                                    <ContentTemplate>

                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td class="ItemAlignLeft">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td style="width: 170px;">

                                                                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                                                                    <tr>

                                                                                                        <td valign="top" width="165" style="padding: 5px 5px 0px 5px; border-left: solid 1px #d0d0d0">
                                                                                                            <table width="100%">
                                                                                                                <tr>
                                                                                                                    <td style="width: 100%; text-align: left;">
                                                                                                                        <asp:Button ID="BT_AllProject" runat="server" CssClass="tt-sms-btn" OnClick="BT_AllProject_Click"
                                                                                                                            Text="<%$ Resources:lang,MyMemberProject%>" />
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td style="width: 165;">
                                                                                                                        <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0"
                                                                                                                            width="100%">
                                                                                                                            <tr>
                                                                                                                                <td width="7">
                                                                                                                                    <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                                                                        <tr>
                                                                                                                                            <td class="ItemAlignLeft" width="10%">
                                                                                                                                                <strong><strong>
                                                                                                                                                    <asp:Label ID="LB_DepartmentMember" runat="server" Text="<%$ Resources:lang,DepartmentMember%>"></asp:Label>
                                                                                                                                                </strong></strong>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td align="right" width="6">
                                                                                                                                    <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False" BorderColor="#394f66"
                                                                                                                            CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid1_ItemCommand"
                                                                                                                            ShowHeader="false" Width="100%">
                                                                                                                            <Columns>
                                                                                                                                <asp:TemplateColumn HeaderText="直接成员:">
                                                                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                                                                                    <ItemTemplate>
                                                                                                                                        <asp:Button ID="BT_UnderlingCode" runat="server" CssClass="inpu"
                                                                                                                                            Style="text-align: right" Text='<%# DataBinder.Eval(Container.DataItem,"UserCode") %>' />
                                                                                                                                        <asp:Button ID="BT_UnderlingName" runat="server" CssClass="inpu"
                                                                                                                                            Style="text-align: left" Text='<%# DataBinder.Eval(Container.DataItem,"UserName") %>' />
                                                                                                                                    </ItemTemplate>
                                                                                                                                </asp:TemplateColumn>
                                                                                                                            </Columns>
                                                                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                                                                            <EditItemStyle BackColor="#2461BF" />
                                                                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                                                                            <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                                                                            <ItemStyle CssClass="itemStyle" />
                                                                                                                        </asp:DataGrid>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td style="width: 170px; text-align: left; padding: 5px 0px 5px 0px;">
                                                                                                                        <asp:Button ID="BT_DisplayStatus" runat="server" CssClass="inpuLong" OnClick="BT_DisplayStatus_Click"
                                                                                                                            Text="<%$ Resources:lang,ShowStatus%>" />
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0"
                                                                                                                            width="100%">
                                                                                                                            <tr>
                                                                                                                                <td width="7">
                                                                                                                                    <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                                                                </td>
                                                                                                                                <td>
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                                                                        <tr>
                                                                                                                                            <td class="ItemAlignLeft" width="10%">
                                                                                                                                                <strong>
                                                                                                                                                    <asp:Label ID="LB_DGProjectStatus" runat="server" Text="<%$ Resources:lang,ProjectStatus%>"></asp:Label></strong>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td align="right" width="6">
                                                                                                                                    <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                                                                                            ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid2_ItemCommand" ShowHeader="false"
                                                                                                                            Visible="False" Width="100%">
                                                                                                                            <Columns>
                                                                                                                                <asp:TemplateColumn HeaderText="项目状态:">
                                                                                                                                    <ItemTemplate>
                                                                                                                                        <asp:Button ID="BT_Status" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Status") %>'
                                                                                                                                            CssClass="tt-sms-btn" Visible="false" />
                                                                                                                                        <asp:Button ID="BT_HomeName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>'
                                                                                                                                            CssClass="tt-sms-btn" />
                                                                                                                                    </ItemTemplate>
                                                                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                                                                                </asp:TemplateColumn>
                                                                                                                            </Columns>
                                                                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                                                                            <EditItemStyle BackColor="#2461BF" />
                                                                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                                                                            <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                                                                            <ItemStyle CssClass="itemStyle" />
                                                                                                                        </asp:DataGrid>
                                                                                                                        <asp:Label ID="LB_Underling" runat="server" Visible="False"></asp:Label>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td class="ItemAlignLeft">
                                                                                                <table cellpadding="3" cellspacing="0" class="formBgStyle">


                                                                                                    <tr>
                                                                                                        <td colspan="2" class="formItemBgStyleForAlignLeft"><span>
                                                                                                            <asp:Label ID="LB_ProjectName" runat="server" Text="<%$ Resources:lang,ProjectName %>"></asp:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>

                                                                                                        <td style="width: 70%;" class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:TextBox ID="TB_ProjectName" runat="server" Width="95%"></asp:TextBox></td>
                                                                                                        <td class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:Button ID="BT_HazyFind" runat="server" OnClick="BT_HazyFind_Click" Text="<%$ Resources:lang,FuzzySearch %>"
                                                                                                                CssClass="inpu" /></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2" class="formItemBgStyleForAlignLeft"><span>
                                                                                                            <asp:Label ID="LB_ProjectID" runat="server" Text="<%$ Resources:lang,ProjectID %>"></asp:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>

                                                                                                        <td class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:TextBox ID="TB_ProjectID" runat="server" Width="95%"></asp:TextBox></td>
                                                                                                        <td class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:Button ID="BT_ProjectIDFind" runat="server" Text="<%$ Resources:lang,Find %>"
                                                                                                                OnClick="BT_ProjectIDFind_Click" CssClass="inpu" /></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2" class="formItemBgStyleForAlignLeft"><span>
                                                                                                            <asp:Label ID="LB_ProjectCreator" runat="server" Text="<%$ Resources:lang,ProjectCreator %>"></asp:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>

                                                                                                        <td class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:TextBox ID="TB_MakeUser" runat="server" Width="95%"></asp:TextBox></td>
                                                                                                        <td class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:Button ID="BT_MakeUserFind" runat="server" OnClick="BT_MakeUserFind_Click" Text="<%$ Resources:lang,Find %>"
                                                                                                                CssClass="inpu" /></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2" class="formItemBgStyleForAlignLeft"><span>
                                                                                                            <asp:Label ID="LB_StartTime" runat="server" Text="<%$ Resources:lang,StartTime %>"></asp:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>

                                                                                                        <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:TextBox ID="DLC_BeginDate" runat="server" Width="95%"></asp:TextBox><ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender2" runat="server" TargetControlID="DLC_BeginDate" Enabled="True"></ajaxToolkit:CalendarExtender>
                                                                                                        </td>

                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2" class="formItemBgStyleForAlignLeft"><span>
                                                                                                            <asp:Label ID="LB_EndTime" runat="server" Text="<%$ Resources:lang,EndTime %>"></asp:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>

                                                                                                        <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:TextBox ID="DLC_EndDate" runat="server" Width="95%"></asp:TextBox><ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender1"
                                                                                                                runat="server" TargetControlID="DLC_EndDate" Enabled="True">
                                                                                                            </ajaxToolkit:CalendarExtender>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2" style="vertical-align: middle;" class="formItemBgStyleForAlignLeft">
                                                                                                            <asp:Button ID="BT_DateFind" runat="server" OnClick="BT_DateFind_Click" Text="<%$ Resources:lang,Find %>"
                                                                                                                CssClass="inpu" />
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <br />
                                                                    </ContentTemplate>
                                                                </cc2:TabPanel>
                                                            </cc2:TabContainer>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <asp:Label ID="LB_Sql" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="LB_UserCode" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="LB_UserName" runat="server" Visible="false"></asp:Label>
                        <asp:Timer ID="Timer_Refresh" runat="server" OnTick="Timer_Refresh_Tick">
                        </asp:Timer>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </center>
</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>