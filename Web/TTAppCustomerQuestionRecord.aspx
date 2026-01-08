<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppCustomerQuestionRecord.aspx.cs" Inherits="TTAppCustomerQuestionRecord" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />


    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();

            //// 移动端触摸优化
            //$('.list-item, .action-button, .mobile-button, .datagrid-table a').addClass('touch-feedback');

            // 防止双击放大
            var lastTouchEnd = 0;
            document.addEventListener('touchend', function (event) {
                var now = (new Date()).getTime();
                if (now - lastTouchEnd <= 300) {
                    event.preventDefault();
                }
                lastTouchEnd = now;
            }, false);

            //// 优化滚动性能
            //$('.content-wrapper').on('touchmove', function (e) {
            //    e.stopPropagation();
            //});

            //// 显示加载状态
            //$('form').on('submit', function () {
            //    showLoading();
            //});

            // 返回按钮点击
            $('.header-back').on('click', function () {
                window.history.back();
            });

            // 弹窗适配移动端
            adaptPopupForMobile();

            // 优化删除确认
            $(document).on('click', '.custom-delete-icon', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var $this = $(this);
                if (confirm('确认删除吗？')) {
                    $this.closest('td').find('a[href*="Delete"]').click();
                }
                return false;
            });

            // 优化日期选择器在移动端的显示
            enhanceDatePickers();

            // 修复新建按钮点击事件
            fixCreateButton();
        });

        function showLoading() {
            $('<div class="loading"><div class="loading-spinner"></div></div>').appendTo('body');
        }

        function hideLoading() {
            $('.loading').remove();
        }

        function adaptPopupForMobile() {
            // 弹窗显示时调整位置和大小
            $(document).on('click', '[data-popup]', function () {
                setTimeout(function () {
                    var $popup = $('.layui-layer-iframe:visible');
                    if ($popup.length) {
                        var windowHeight = $(window).height();
                        var popupHeight = Math.min(windowHeight - 40, 600);

                        $popup.css({
                            'top': '20px',
                            'left': '50%',
                            'transform': 'translateX(-50%)',
                            'width': '95%',
                            'height': popupHeight + 'px',
                            'max-width': '500px'
                        });

                        // 确保内容可滚动
                        var contentHeight = popupHeight - 120; // 减去标题和底部按钮的高度
                        $popup.find('.layui-layer-content').css({
                            'max-height': contentHeight + 'px',
                            'overflow-y': 'auto'
                        });
                    }
                }, 100);
            });
        }


        function enhanceDatePickers() {
            // 为日期输入框添加移动端优化
            $('input[type="text"][id*="DLC_"]').each(function () {
                var $input = $(this);
                $input.addClass('date-input');

                // 设置输入模式为日期
                $input.attr('inputmode', 'numeric');
                $input.attr('pattern', '[0-9]*');

                // 添加日期图标提示
                if (!$input.parent().find('.date-icon').length) {
                    $input.parent().append('<span class="date-icon" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #999; pointer-events: none;">📅</span>');
                    $input.css('padding-right', '40px');
                }
            });

            // 修复AjaxControlToolkit日历控件在移动端的显示
            if (typeof (Sys) !== 'undefined' && typeof (Sys.Extended) !== 'undefined' && typeof (Sys.Extended.UI.CalendarBehavior) !== 'undefined') {
                Sys.Extended.UI.CalendarBehavior.prototype._onShown = function () {
                    var $calendar = $('.ajax__calendar');
                    if ($calendar.length && $(window).width() <= 768) {
                        $calendar.css({
                            'position': 'fixed',
                            'top': '50% !important',
                            'left': '50% !important',
                            'transform': 'translate(-50%, -50%)',
                            'width': '300px',
                            'z-index': '10000'
                        });
                    }
                };
            }
        }

        function fixCreateButton() {
            // 确保新建按钮能正常触发弹窗
            $('#BT_Create').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                // 显示弹窗
                var $popup = $('#popwindow');
                if ($popup.length) {
                    // 重置表单
                    $popup.find('input[type="text"], select, textarea').val('');

                    // 显示弹窗和遮罩
                    $('#popwindow_shade').show();
                    $popup.show();

                    // 调整弹窗位置和大小
                    var windowHeight = $(window).height();
                    var popupHeight = Math.min(windowHeight - 40, 600);

                    $popup.css({
                        'top': '20px',
                        'left': '50%',
                        'transform': 'translateX(-50%)',
                        'width': '95%',
                        'height': popupHeight + 'px',
                        'max-width': '500px'
                    });

                    // 确保内容可滚动
                    var contentHeight = popupHeight - 120;
                    $popup.find('.layui-layer-content').css({
                        'max-height': contentHeight + 'px',
                        'overflow-y': 'auto'
                    });

                    // 滚动到顶部
                    $popup.find('.layui-layer-content').scrollTop(0);
                }
                return false;
            });

            // 修复弹窗内的保存按钮
            $('#LinkButton1').on('click', function (e) {
                // 确保表单能正常提交
                return true;
            });
        }

        // 确保popClose函数存在
        if (typeof popClose !== 'function') {
            function popClose() {
                $('.layui-layer-iframe:visible').hide();
                $('#popwindow_shade').hide();
                return false;
            }
        }
    </script>
</head>
<body>
   
    <!-- 移动端头部 -->
    <table style="width: 100%" cellpadding="0" cellspacing="0" class="ItemAlignLeft">
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
                    <!-- 新建按钮 -->
                    <div style="margin-bottom: 15px;">
                        <asp:Button ID="BT_Create" runat="server" Text="<%$ Resources:lang,New%>"
                            CssClass="mobile-button yellow" OnClick="BT_Create_Click" />
                    </div>

                    <!-- 问题记录列表 -->
                    <div class="mobile-card">

                        <div class="card-body datagrid-container">
                            <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False" GridLines="None"
                                OnItemCommand="DataGrid4_ItemCommand" OnPageIndexChanged="DataGrid4_PageIndexChanged"
                                AllowCustomPaging="false" AllowPaging="true" PageSize="10" ShowHeader="False"
                                Width="100%" CssClass="datagrid-table">
                                <ItemStyle CssClass="itemStyle" />
                                <Columns>

                                    <asp:ButtonColumn ButtonType="LinkButton" CommandName="Update" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 alt='Modify' /&gt;&lt;/div&gt;">
                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                    </asp:ButtonColumn>


                                    <asp:TemplateColumn HeaderText="Delete">
                                        <ItemTemplate>
                                            <div onclick="return showSimpleDeleteModal(this, event);" style="cursor: pointer; display: inline-block;" class="custom-delete-icon" title="Delete">
                                                <img src="ImagesSkin/Delete.png" border="0" alt='Delete' />
                                            </div>
                                            <asp:LinkButton ID="LBT_Delete" CommandName="Delete" runat="server" Style="display: none;"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                    </asp:TemplateColumn>

                                    <asp:BoundColumn DataField="ID" HeaderText="Number">
                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                    </asp:BoundColumn>

                                    <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTAPPCustomerQuestionHandleDetailForCreate.aspx?ID={0}" DataTextField="Question" HeaderText="服务需求" Target="_blank">
                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" />
                                    </asp:HyperLinkColumn>
                                </Columns>
                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab pagination" />
                            </asp:DataGrid>
                        </div>
                    </div>

                    <!-- 统计图表 -->
                    <asp:Repeater ID="RP_ChartList" runat="server">
                        <ItemTemplate>
                            <div class="mobile-card">
                                <div class="card-header">
                                    <asp:Label ID="LB_ChartName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ChartName") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="LB_ChartType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ChartType") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="LB_SqlCode" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SqlCode") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="LB_ChartTitle" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ChartName") %>'></asp:Label>
                                </div>
                                <div class="card-body">
                                    <div style="width: 100%; height: 250px; overflow: hidden;">
                                        <iframe src="TTTakeTopAnalystChartSet.aspx?FormType=<%# DataBinder.Eval(Container.DataItem,"FormType") %>&ChartType=<%# DataBinder.Eval(Container.DataItem,"ChartType") %>&ChartName=<%# DataBinder.Eval(Container.DataItem,"ChartName") %>"
                                            style="width: 100%; height: 100%; border: none;"></iframe>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <!-- 图表设置链接 -->
                    <div style="text-align: center; margin: 20px 0; display: none;">
                        <asp:HyperLink ID="HL_SystemAnalystChartRelatedUserSet" runat="server"
                            Text="<%$ Resources:lang,FenXiTuSheZhi%>"
                            Style="color: #1976D2; text-decoration: none; font-weight: 500;"></asp:HyperLink>
                    </div>

                    <!-- 弹窗区域 (优化高度和按钮显示) -->
                    <div class="layui-layer layui-layer-iframe" id="popwindow" name="fixedDiv"
                        style="z-index: 9999; width: 98%; height: auto; position: absolute; overflow: hidden; display: none; border-radius: 10px; max-height: 600px;">
                        <div class="layui-layer-title" style="background: #e7e7e8;" id="popwindow_title">
                            <asp:Label ID="Label3" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                        </div>
                        <div id="popwindow_content" class="layui-layer-content" style="overflow: auto; text-align: left; padding: 15px; max-height: 450px;">
                            <div style="width: 100%;">
                                <!-- 使用div布局替代表格布局 -->
                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,XuQiuLeiBie%>"></asp:Label>
                                    </div>
                                    <asp:DropDownList ID="DL_CustomerQuestionType" runat="server" CssClass="mobile-select" DataTextField="Type" DataValueField="Type">
                                    </asp:DropDownList>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,CYHSJ%>"></asp:Label>
                                    </div>
                                    <asp:DropDownList ID="DL_IsImportant" runat="server" CssClass="mobile-select">
                                        <asp:ListItem>NO</asp:ListItem>
                                        <asp:ListItem>YES</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,XuQiuShangJiMiaoShu%>"></asp:Label>
                                        <span class="required-star">*</span>
                                    </div>
                                    <CKEditor:CKEditorControl ID="TB_Question" runat="server" Width="100%" Height="120px" Visible="False" />
                                    <CKEditor:CKEditorControl runat="server" ID="HT_Question" Width="100%" Height="120px" Visible="False" />
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,KeHuMingCheng%>"></asp:Label>
                                        <span class="required-star">*</span>
                                    </div>
                                    <div class="form-input-group">
                                        <asp:TextBox ID="TB_Company" runat="server" CssClass="mobile-input"></asp:TextBox>
                                        <asp:Button ID="BT_FindExistSame" runat="server" CssClass="mobile-button" OnClick="BT_FindExistSame_Click" Text="<%$ Resources:lang,CXSFYCZ%>" Style="padding: 10px 15px; white-space: nowrap;" />
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>
                                        <span class="required-star">*</span>
                                    </div>
                                    <asp:TextBox ID="TB_ContactPerson" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,LianXiFangFa%>"></asp:Label>
                                        <span class="required-star">*</span>
                                    </div>
                                    <asp:TextBox ID="TB_PhoneNumber" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,YaoQiuDaFuShiJian%>"></asp:Label>
                                    </div>
                                    <div style="position: relative;">
                                        <asp:TextBox ID="DLC_AnswerTime" runat="server" CssClass="date-input"></asp:TextBox>
                                        <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender1" runat="server" TargetControlID="DLC_AnswerTime" Enabled="True"></ajaxToolkit:CalendarExtender>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,LianXiDiZhi%>"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="TB_Address" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,EMail%>"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="TB_EMail" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,YouBian%>"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="TB_PostCode" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label" style="font-weight: bold; color: #1976D2; margin-top: 20px;">
                                        <asp:Label ID="Label47" runat="server" Text="<%$ Resources:lang,SHANGJIXINXI%>"></asp:Label>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,YIQICHENGJIAOSHIJIAN%>"></asp:Label>
                                    </div>
                                    <div style="position: relative;">
                                        <asp:TextBox ID="DLC_ExpectedTime" runat="server" CssClass="date-input" ></asp:TextBox>
                                        <cc2:CalendarExtender ID="CalendarExtender2" runat="server" Enabled="True" Format="yyyy-MM-dd" TargetControlID="DLC_ExpectedTime"></cc2:CalendarExtender>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,YIQICHENGJIAOJINGE%>"></asp:Label>
                                    </div>
                                    <NickLee:NumberBox ID="NB_ExpectedEarnings" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" CssClass="mobile-input">0.00</NickLee:NumberBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,CHENGGONGGANJIANYINGSHU%>"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="TB_SucessKeyReason" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,SHIBAIGANJIANYINGSHU%>"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="TB_FailedKeyReason" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label48" runat="server" Text="<%$ Resources:lang,ShangJiJieDuan%>"></asp:Label>
                                    </div>
                                    <asp:DropDownList ID="DL_Stage" runat="server" CssClass="mobile-select" AutoPostBack="true" DataTextField="Stage" DataValueField="Stage" OnSelectedIndexChanged="DL_Stage_SelectedIndexChanged"></asp:DropDownList>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,YingLu%>"></asp:Label>
                                    </div>
                                    <NickLee:NumberBox ID="NB_Possibility" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Precision="0" CssClass="mobile-input">0</NickLee:NumberBox>
                                    <span style="margin-left: 10px; color: #666;">%</span>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label35" runat="server" Text="<%$ Resources:lang,KeHuShangJiJieDuan%>"></asp:Label>
                                    </div>
                                    <asp:DropDownList ID="DL_CustomerStage" runat="server" CssClass="mobile-select" DataTextField="Stage" DataValueField="Stage"></asp:DropDownList>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,SHANGJIDAILI%>"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="TB_AgencyName" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <div class="form-row">
                                    <div class="form-label">
                                        <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,SHANGJILAIYUAN%>"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="TB_BusinessSource" runat="server" CssClass="mobile-input"></asp:TextBox>
                                </div>

                                <!-- 隐藏字段 -->
                                <div style="display: none;">
                                    <asp:TextBox ID="TB_BusinessName" runat="server"></asp:TextBox>
                                    <asp:TextBox ID="TB_CustomerName" runat="server" />
                                    <asp:TextBox ID="TB_CustomerManager" runat="server"></asp:TextBox>
                                    <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="LB_UserName" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="LB_Sql4" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="LB_ID" runat="server" Visible="False"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <div id="popwindow_footer" class="layui-layer-btn" style="border-top: 1px solid #ccc; padding: 15px; text-align: center; background: white; position: sticky; bottom: 0;">
                            <asp:LinkButton ID="LinkButton1" runat="server" 
                                OnClick="BT_New_Click" 
                                Text="<%$ Resources:lang,BaoCun%>" 
                                Style="display: inline-block; width: 30%; height: 40px; line-height: 40px; background: #1976D2; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; margin-right: 4%; cursor: pointer; text-decoration: none;">
                            </asp:LinkButton>
                            <a  onclick="return popClose();" 
                                Style="display: inline-block; width: 30%; height: 40px; line-height: 40px; background: #f5f5f5; color: #333; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; text-decoration: none;">
                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                            </a>
                        </div>
                        <span class="layui-layer-setwin"><a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;"></a></span>
                    </div>


                   <div class="layui-layer layui-layer-iframe" id="popwindow" name="fixedDiv"
    style="z-index: 9999; width: 98%; height: auto; position: fixed; /* 改为 fixed */
           top: 20px; left: 50%; transform: translateX(-50%); /* 居中定位 */
           display: none; border-radius: 10px; max-height: 600px;">
                        <div class="layui-layer-title" style="background: #e7e7e8;" id="popwindow_title1">
                            <asp:Label ID="Label9" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                        </div>
                        <div id="popwindow_content1" class="layui-layer-content" style="overflow: auto; text-align: left;">
                            <asp:DataList runat="server" HorizontalAlign="left" CellPadding="0" ForeColor="#333333" Height="1px" Width="98%"
                                ID="DataList3">
                                <AlternatingItemStyle BackColor="White"></AlternatingItemStyle>
                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White"></FooterStyle>
                                <HeaderTemplate>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td width="7%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong>
                                                        </td>
                                                        <td width="10%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label></strong>
                                                        </td>
                                                        <td width="20%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,LianXiFangShi%>"></asp:Label></strong>
                                                        </td>
                                                        <td width="15%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,FuWuFangFa%>"></asp:Label></strong>
                                                        </td>
                                                        <td width="20%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,ChuLiShiJian%>"></asp:Label></strong>
                                                        </td>
                                                        <td width="8%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,YongShiChangDu%>"></asp:Label></strong>
                                                        </td>
                                                        <td width="10%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong>
                                                        </td>
                                                        <td width="10%" class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ShouLiRen%>"></asp:Label></strong>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="6" align="right">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" /></td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemStyle CssClass="itemStyle"></ItemStyle>
                                <ItemTemplate>
                                    <table cellpadding="4" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="tdLeft" style="width: 7%; text-align: left;">
                                                <%#DataBinder .Eval (Container .DataItem ,"ID") %> 
                                            </td>
                                            <td class="tdLeft" style="width: 10%; padding-left: 5px; text-align: left;">
                                                <%#DataBinder.Eval(Container.DataItem, "CustomerAcceptor")%>
                                            </td>
                                            <td class="tdLeft" style="width: 20%; text-align: left;">
                                                <%#DataBinder.Eval(Container.DataItem, "AcceptorContactWay")%>
                                            </td>
                                            <td class="tdLeft" style="width: 15%; text-align: left;">
                                                <%#DataBinder.Eval(Container.DataItem, "HandleWay")%>
                                            </td>
                                            <td class="tdLeft" style="width: 20%; text-align: left;">
                                                <%#DataBinder.Eval(Container.DataItem, "HandleTime","{0:yyyy/MM/dd hh:MM:ss}")%>
                                            </td>
                                            <td class="tdLeft" style="width: 8%; text-align: left;">
                                                <%#DataBinder .Eval (Container .DataItem ,"UsedTime") %>
                                                <%#DataBinder .Eval (Container .DataItem ,"TimeUnit") %>       
                                            </td>
                                            <td class="tdLeft" style="width: 10%; text-align: left;">
                                                <%#DataBinder .Eval (Container .DataItem ,"HandleStatus") %>
                                            </td>
                                            <td class="tdRight" style="width: 10%; text-align: left;">
                                                <%#DataBinder .Eval (Container .DataItem ,"OperatorName") %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tdLeft" style="width: 5%; text-align: left; font-size: 10pt;">
                                                <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>"></asp:Label>
                                            </td>
                                            <td class="tdRight" colspan="7" style="width: 95%; text-align: left; padding-left: 5px">
                                                <%#DataBinder.Eval(Container.DataItem, "HandleDetail")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tdLeft" style="width: 5%; text-align: left; font-size: 10pt;">
                                                <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,KeFangPingJia%>"></asp:Label>
                                            </td>
                                            <td class="tdRight" colspan="7" style="width: 95%; text-align: left; padding-left: 5px">
                                                <%#DataBinder.Eval(Container.DataItem, "CustomerComment")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tdLeft" style="width: 5%; text-align: left; font-size: 10pt;">
                                                <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,XiaCiFuWuShiJian%>"></asp:Label>
                                            </td>
                                            <td class="tdRight" style="width: 10%; text-align: left; padding-left: 5px">
                                                <%#DataBinder.Eval(Container.DataItem, "NextServiceTime")%>                   
                                            </td>
                                            <td class="tdLeft" style="width: 20%; text-align: left; font-size: 10pt;">
                                                <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,TiQianTongZhiTianShu%>"></asp:Label>
                                            </td>
                                            <td class="tdRight" colspan="6" style="text-align: left; padding-left: 5px">
                                                <%#DataBinder.Eval(Container.DataItem, "PreDays")%>                   
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333"></SelectedItemStyle>
                            </asp:DataList>
                        </div>

                        <div id="popwindow_footer1" class="layui-layer-btn" style="border-top: 1px solid #ccc; padding: 15px; text-align: center;">
                            <a class="layui-layer-btn notTab mobile-button" onclick="return popClose();" style="display: inline-block; width: auto; padding: 10px 20px;">
                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                            </a>
                        </div>
                        <span class="layui-layer-setwin"><a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;"></a></span>
                    </div>

                    <div class="layui-layer-shade" id="popwindow_shade" style="z-index: 9998; background-color: #000; opacity: 0.3; filter: alpha(opacity=30); display: none;"></div>

                    <!-- 隐藏的树形视图 -->
                    <asp:TreeView ID="TreeView1" runat="server" NodeWrap="True" Visible="false" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged"
                        ShowLines="True" Width="220px">
                        <RootNodeStyle CssClass="rootNode" />
                        <NodeStyle CssClass="treeNode" />
                        <LeafNodeStyle CssClass="leafNode" />
                        <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                    </asp:TreeView>

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