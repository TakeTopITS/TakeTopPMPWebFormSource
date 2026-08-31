�?%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppCustomerQuestionRecord.aspx.cs" Inherits="TTAppCustomerQuestionRecord" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        /* APP椋庢牸DataGrid鏍峰�?*/
        .mobile-datagrid {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 16px;
        }

        .mobile-datagrid-item {
            display: flex;
            align-items: flex-start;
            padding: 16px;
            border-bottom: 1px solid #f0f0f0;
            background: #fff;
            transition: background-color 0.2s;
            position: relative;
        }

            .mobile-datagrid-item:last-child {
                border-bottom: none;
            }

            .mobile-datagrid-item:hover {
                background-color: #f8f9fa;
            }

            .mobile-datagrid-item.touch-active {
                background-color: #e3f2fd !important;
            }

        .mobile-datagrid-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
            margin-right: 12px;
        }

        .mobile-action-btn {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f5f5f5;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            padding: 0;
        }

            .mobile-action-btn.update-btn {
                background: linear-gradient(135deg, #1976D2, #42A5F5);
            }

            .mobile-action-btn.delete-btn {
                background: linear-gradient(135deg, #E53935, #EF5350);
            }

            .mobile-action-btn img {
                width: 18px;
                height: 18px;
                filter: brightness(0) invert(1);
            }

            .mobile-action-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            }

        .mobile-datagrid-content {
            flex: 1;
            overflow: hidden;
            min-width: 0;
        }

        .mobile-datagrid-id {
            font-size: 12px;
            color: #666;
            font-weight: 500;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
        }

            .mobile-datagrid-id::before {
                content: "#";
                margin-right: 2px;
                color: #999;
            }

        .mobile-datagrid-question-container {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            width: 100%;
        }

        .mobile-datagrid-question {
            font-size: 15px;
            color: #333;
            line-height: 1.4;
            font-weight: 500;
            margin: 0;
            word-break: break-word;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex: 1;
            min-width: 0;
        }

            .mobile-datagrid-question a {
                color: #1976D2;
                text-decoration: none;
                display: block;
                padding: 2px 0;
            }

                .mobile-datagrid-question a:hover {
                    color: #1565C0;
                    text-decoration: none;
                }

        .delete-icon-wrapper {
            flex-shrink: 0;
            margin-left: auto;
            display: flex;
            align-items: center;
            height: 24px;
        }

        .custom-delete-icon {
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
        }

            .custom-delete-icon img {
                width: 18px;
                height: 18px;
            }

        /* 鍒嗛〉鏍峰紡 */
        .mobile-pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            padding: 16px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            margin-top: 16px;
        }

            .mobile-pagination a {
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 36px;
                height: 36px;
                padding: 0 12px;
                border-radius: 8px;
                background: #f5f5f5;
                color: #333;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.2s;
            }

                .mobile-pagination a:hover {
                    background: #e0e0e0;
                }

            .mobile-pagination span {
                min-width: 36px;
                height: 36px;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 0 12px;
                border-radius: 8px;
                background: #1976D2;
                color: #fff;
                font-size: 14px;
                font-weight: 500;
            }

        /* 绌虹姸鎬?*/
        .mobile-datagrid-empty {
            padding: 48px 16px;
            text-align: center;
            color: #999;
            font-size: 14px;
            background: #fff;
            border-radius: 12px;
        }

        .mobile-datagrid-empty-icon {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        /* 寮瑰嚭灞備紭鍖栨牱寮?*/
        .layui-layer-iframe {
            max-height: 80vh !important;
            top: 20px !important;
            bottom: auto !important;
        }
        
        .layui-layer-content {
            max-height: calc(80vh - 120px) !important;
            overflow-y: auto !important;
        }

        /* 鍝嶅簲寮忚皟�?*/
        @media (max-width: 480px) {
            .mobile-datagrid-item {
                padding: 12px;
            }

            .mobile-datagrid-actions {
                margin-right: 8px;
            }

            .mobile-action-btn {
                width: 32px;
                height: 32px;
            }

                .mobile-action-btn img {
                    width: 16px;
                    height: 16px;
                }

            .mobile-datagrid-question {
                font-size: 14px;
            }

            .custom-delete-icon {
                width: 20px;
                height: 20px;
            }

                .custom-delete-icon img {
                    width: 16px;
                    height: 16px;
                }
            
            .layui-layer-iframe {
                width: 95% !important;
                max-height: 85vh !important;
                top: 10px !important;
            }
            
            .layui-layer-content {
                max-height: calc(85vh - 120px) !important;
            }
        }

        /* 鍔犺浇鐘舵€?*/
        .datagrid-loading {
            padding: 32px;
            text-align: center;
            color: #1976D2;
        }

            .datagrid-loading::after {
                content: "";
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 2px solid #e0e0e0;
                border-top-color: #1976D2;
                border-radius: 50%;
                animation: datagrid-spin 0.8s linear infinite;
                margin-left: 8px;
            }

        @keyframes datagrid-spin {
            to {
                transform: rotate(360deg);
            }
        }
        
        /* 琛ㄥ崟鏍峰紡 */
        .form-row {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            margin-bottom: 5px;
            font-weight: 500;
            color: #333;
        }
        
        .mobile-input, .mobile-select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .required-star {
            color: #ff4444;
            margin-left: 2px;
        }
        
        .form-input-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();

            // 绉诲姩绔Е鎽镐紭�?
            $('.mobile-datagrid-item').on('touchstart', function () {
                $(this).addClass('touch-active');
            }).on('touchend touchcancel', function () {
                $(this).removeClass('touch-active');
            });

            // 闃叉鍙屽嚮鏀惧ぇ
            var lastTouchEnd = 0;
            document.addEventListener('touchend', function (event) {
                var now = (new Date()).getTime();
                if (now - lastTouchEnd <= 300) {
                    event.preventDefault();
                }
                lastTouchEnd = now;
            }, false);

            // 杩斿洖鎸夐挳鐐瑰�?            $('.header-back').on('click', function () {
                window.history.back();
            });

            // 寮圭獥閫傞厤绉诲姩绔?
            adaptPopupForMobile();

            // 浼樺寲鏃ユ湡閫夋嫨鍣ㄥ湪绉诲姩绔殑鏄剧�?            enhanceDatePickers();

            // 淇鏂板缓鎸夐挳鐐瑰嚮浜嬩�?            fixCreateButton();

            // DataGrid鍒濆鍖?
            initMobileDataGrid();

            // 浼樺寲寮瑰嚭灞傛樉绀轰綅�?
            optimizePopupPosition();
        });

        function optimizePopupPosition() {
            // 鐩戝惉绐楀彛澶у皬鍙樺寲锛岄噸鏂拌皟鏁村脊鍑哄眰浣嶇�?            $(window).on('resize', function () {
                adjustPopupPosition();
            });
        }

        function adjustPopupPosition() {
            var $popup = $('#popwindow:visible');
            if ($popup.length) {
                var windowHeight = $(window).height();
                var popupHeight = Math.min(windowHeight - 40, 600);

                $popup.css({
                    'top': '20px',
                    'left': '50%',
                    'transform': 'translateX(-50%)',
                    'width': '95%',
                    'height': 'auto',
                    'max-height': popupHeight + 'px',
                    'max-width': '500px',
                    'position': 'fixed'
                });

                // 纭繚鍐呭鍙粴鍔?
                var contentHeight = popupHeight - 120;
                $popup.find('.layui-layer-content').css({
                    'max-height': contentHeight + 'px',
                    'overflow-y': 'auto'
                });
            }

            var $popupList = $('#popwindowList:visible');
            if ($popupList.length) {
                var windowHeight = $(window).height();
                var popupHeight = Math.min(windowHeight - 40, 600);

                $popupList.css({
                    'top': '20px',
                    'height': 'auto',
                    'max-height': popupHeight + 'px'
                });

                var contentHeight = popupHeight - 80;
                $popupList.find('.layui-layer-content').css({
                    'max-height': contentHeight + 'px'
                });
            }
        }

        function initMobileDataGrid() {
            // 澶勭悊鍒嗛〉鎸夐挳鏍峰�?            $('.pagination a').each(function () {
                var $this = $(this);
                if ($this.attr('href')) {
                    $this.addClass('mobile-page-btn');
                    // 绉婚櫎鍘熸湁鐨勬暟瀛楁牱寮?
                    $this.css({
                        'text-decoration': 'none',
                        'display': 'inline-flex',
                        'align-items': 'center',
                        'justify-content': 'center',
                        'min-width': '36px',
                        'height': '36px',
                        'padding': '0 12px',
                        'border-radius': '8px',
                        'background': '#f5f5f5',
                        'color': '#333',
                        'font-size': '14px',
                        'font-weight': '500',
                        'margin': '0 2px',
                        'transition': 'all 0.2s'
                    });
                }
            });

            // 褰撳墠椤垫牱�?
            $('.pagination span').each(function () {
                var $this = $(this);
                if ($this.text().match(/^\d+$/)) {
                    $this.css({
                        'display': 'inline-flex',
                        'align-items': 'center',
                        'justify-content': 'center',
                        'min-width': '36px',
                        'height': 36,
                        'padding': '0 12px',
                        'border-radius': '8px',
                        'background': '#1976D2',
                        'color': '#fff',
                        'font-size': '14px',
                        'font-weight': '500',
                        'margin': '0 2px'
                    });
                }
            });
        }

        function showLoading() {
            $('<div class="loading"><div class="loading-spinner"></div></div>').appendTo('body');
        }

        function hideLoading() {
            $('.loading').remove();
        }

        function adaptPopupForMobile() {
            // 寮圭獥鏄剧ず鏃惰皟鏁翠綅缃拰澶у�?            $(document).on('click', '[data-popup]', function () {
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
                            'height': 'auto',
                            'max-height': popupHeight + 'px',
                            'max-width': '500px',
                            'position': 'fixed'
                        });

                        // 纭繚鍐呭鍙粴鍔?
                        var contentHeight = popupHeight - 120;
                        $popup.find('.layui-layer-content').css({
                            'max-height': contentHeight + 'px',
                            'overflow-y': 'auto'
                        });
                    }
                }, 100);
            });
        }

        function enhanceDatePickers() {
            // 涓烘棩鏈熻緭鍏ユ娣诲姞绉诲姩绔紭�?
            $('input[type="text"][id*="DLC_"]').each(function () {
                var $input = $(this);
                $input.addClass('date-input');

                // 璁剧疆杈撳叆妯″紡涓烘棩鏈?
                $input.attr('inputmode', 'numeric');
                $input.attr('pattern', '[0-9]*');

                // 娣诲姞鏃ユ湡鍥炬爣鎻愮ず
                if (!$input.parent().find('.date-icon').length) {
                    $input.parent().append('<span class="date-icon" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #999; pointer-events: none;">馃搮</span>');
                    $input.css('padding-right', '40px');
                }
            });

            // 淇AjaxControlToolkit鏃ュ巻鎺т欢鍦ㄧЩ鍔ㄧ鐨勬樉绀?
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
            // 纭繚鏂板缓鎸夐挳鑳芥甯歌Е鍙戝脊绐?
            $('#BT_Create').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                // 鏄剧ず寮圭獥
                var $popup = $('#popwindow');
                if ($popup.length) {
                    // 閲嶇疆琛ㄥ崟
                    $popup.find('input[type="text"], select, textarea').val('');

                    // 鏄剧ず寮圭獥鍜岄伄缃?
                    $('#popwindow_shade').show();
                    $popup.show();

                    // 璋冩暣寮圭獥浣嶇疆鍜屽ぇ�?
                    var windowHeight = $(window).height();
                    var popupHeight = Math.min(windowHeight - 40, 600);

                    $popup.css({
                        'top': '20px',
                        'left': '50%',
                        'transform': 'translateX(-50%)',
                        'width': '95%',
                        'height': 'auto',
                        'max-height': popupHeight + 'px',
                        'max-width': '500px',
                        'position': 'fixed'
                    });

                    // 纭繚鍐呭鍙粴鍔?
                    var contentHeight = popupHeight - 120;
                    $popup.find('.layui-layer-content').css({
                        'max-height': contentHeight + 'px',
                        'overflow-y': 'auto'
                    });

                    // 婊氬姩鍒伴《閮?
                    $popup.find('.layui-layer-content').scrollTop(0);

                    // 娣诲姞鍏抽棴鎸夐挳浜嬩欢
                    $popup.find('.layui-layer-close').off('click').on('click', function () {
                        $('#popwindow_shade').hide();
                        $popup.hide();
                        return false;
                    });
                }
                return false;
            });

            // 淇寮圭獥鍐呯殑淇濆瓨鎸夐�?            $('#LinkButton1').on('click', function (e) {
                // 纭繚琛ㄥ崟鑳芥甯告彁�?
                return true;
            });
        }

        // 纭繚popClose鍑芥暟瀛樺�?        if (typeof popClose !== 'function') {
            function popClose() {
                $('.layui-layer-iframe:visible').hide();
                $('#popwindow_shade').hide();
                return false;
            }
        }
    </script>
</head>
<body class="napbac" data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    <!-- 绉诲姩绔ご�?-->
    <table cellpadding="0" cellspacing="0" width="100%" class="bian">
        <tr>
            <td colspan="2" height="31" class="page_topbj">
                <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="ItemAlignLeft">
                            <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="29">
                                            <img src="ImagesSkin/return.png" alt="" />
                                        </td>
                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                            <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,Back%>" />
                                        </td>
                                        <td width="5"></td>
                                    </tr>
                                </table>
                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="璇风◢鍊欙紝澶勭悊涓?.." style="display: none;" />
                            </a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <!-- 涓昏鍐呭鍖哄�?-->
    <div class="content-wrapper">
        <form id="form1" runat="server" class="napf">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                <div id="appScroll" class="app-scroll">
                    <!-- 鏂板缓鎸夐挳 -->
                    <div style="margin-bottom: 15px;">
                        <asp:Button ID="BT_Create" runat="server" Text="<%$ Resources:lang,New%>"
                            CssClass="mobile-button yellow" OnClick="BT_Create_Click" />
                    </div>

                    <!-- APP椋庢牸鐨勯棶棰樿褰曞垪�?-->
                    <div class="mobile-datagrid">
                        <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False" GridLines="None"
                            OnItemCommand="DataGrid4_ItemCommand" OnPageIndexChanged="DataGrid4_PageIndexChanged"
                            AllowCustomPaging="false" AllowPaging="true" PageSize="10" ShowHeader="False"
                            Width="100%" CssClass="datagrid-table">
                            <HeaderStyle CssClass="datagrid-header" />
                            <ItemStyle CssClass="itemStyle" />
                            <AlternatingItemStyle CssClass="alternatingItemStyle" />
                            <Columns>
                                <asp:TemplateColumn>
                                    <ItemTemplate>
                                        <div class="mobile-datagrid-item">
                                            <!-- 鎿嶄綔鎸夐挳鍖哄�?-->
                                            <!-- 鍐呭鍖哄煙 -->
                                            <div class="mobile-datagrid-content">
                                                <!-- 缂栬緫鎸夐挳 -->
                                                <asp:LinkButton ID="LB_Update" runat="server" CommandName="Update" CssClass="mobile-button blue" Text='<%# DataBinder.Eval(Container.DataItem, "ID") %>' />




                                                <!-- ID -->
                                                <div class="mobile-datagrid-id" style="display: none;">
                                                    <asp:Label ID="LB_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ID") %>'></asp:Label>
                                                </div>

                                                <!-- 闂鎻忚堪鍜屽垹闄ゆ寜閽鍣?-->
                                                <div class="mobile-datagrid-question-container">
                                                    <!-- 闂鎻忚堪 -->
                                                    <div class="mobile-datagrid-question">
                                                        <asp:HyperLink ID="HL_Question" runat="server"
                                                            NavigateUrl='<%# "TTAPPCustomerQuestionHandleDetailForCreate.aspx?ID=" + DataBinder.Eval(Container.DataItem, "ID") %>'
                                                            Text='<%# DataBinder.Eval(Container.DataItem, "Question") %>'
                                                            Target="_blank">
                                                        </asp:HyperLink>
                                                    </div>

                                                    <!-- 鍒犻櫎鎸夐挳锛堟斁鍦ㄩ棶棰樻弿杩扮殑鍙充晶锛?-->
                                                    <div class="delete-icon-wrapper">
                                                        <div onclick="return showSimpleDeleteModal(this, event);" class="custom-delete-icon" title="Delete">
                                                            <img src="ImagesSkin/Delete.png" border="0" alt='Delete' />
                                                        </div>
                                                        <asp:LinkButton ID="LBT_Delete" CommandName="Delete" runat="server" Style="display: none;"></asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                            </Columns>
                            <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                        </asp:DataGrid>

                        <!-- 绌虹姸鎬佹樉绀?-->
                        <asp:Label ID="LB_EmptyMessage" runat="server" Visible="false">
                            <div class="mobile-datagrid-empty">
                                <div class="mobile-datagrid-empty-icon">馃搫</div>
                                <div>鏆傛棤鏁版嵁</div>
                            </div>
                        </asp:Label>
                    </div>

                    <!-- 缁熻鍥捐�?-->
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

                    <!-- 鍥捐〃璁剧疆閾炬�?-->
                    <div style="text-align: center; margin: 20px 0; display: none;">
                        <asp:HyperLink ID="HL_SystemAnalystChartRelatedUserSet" runat="server"
                            Text="<%$ Resources:lang,FenXiTuSheZhi%>"
                            Style="color: #1976D2; text-decoration: none; font-weight: 500;"></asp:HyperLink>
                    </div>

                    <!-- 寮圭獥鍖哄煙 (浼樺寲楂樺害鍜屾寜閽樉绀? -->
                    <div class="layui-layer layui-layer-iframe" id="popwindow" name="fixedDiv"
                        style="z-index: 9999; width: 98%; height: auto; position: fixed; overflow: hidden; display: none; border-radius: 10px; max-height: 600px; top: 20px; left: 50%; transform: translateX(-50%);">
                        <div class="layui-layer-title" style="background: #e7e7e8;" id="popwindow_title">
                            <asp:Label ID="Label3" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                        </div>
                        <div id="popwindow_content" class="layui-layer-content" style="overflow: auto; text-align: left; padding: 15px; max-height: 450px;">
                            <div style="width: 100%;">
                                <!-- 浣跨敤div甯冨眬鏇夸唬琛ㄦ牸甯冨眬 -->
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
                                        <asp:TextBox ID="DLC_ExpectedTime" runat="server" CssClass="date-input"></asp:TextBox>
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

                                <!-- 闅愯棌瀛楁�?-->
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
                                Style="display: inline-block; width: 30%; height: 40px; line-height: 40px; background: #1976D2; color: #ffffff; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; margin-right: 4%; cursor: pointer; text-decoration: none;">
                            </asp:LinkButton>
                            <a onclick="return popClose();"
                                style="display: inline-block; width: 30%; height: 40px; line-height: 40px; background: #1976D2; color: #ffffff; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; text-decoration: none;">
                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                            </a>
                        </div>
                        <span class="layui-layer-setwin"><a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;"></a></span>
                    </div>


                    <div class="layui-layer layui-layer-iframe" id="popwindowList" name="fixedDiv"
                        style="z-index: 9999; width: 98%; height: auto; position: fixed; top: 20px; left: 50%; transform: translateX(-50%); display: none; border-radius: 10px; max-height: 600px;">
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

                    <!-- 闅愯棌鐨勬爲褰㈣鍥?-->
                    <asp:TreeView ID="TreeView1" runat="server" NodeWrap="True" Visible="false" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged"
                        ShowLines="True" Width="220px">
                        <RootNodeStyle CssClass="rootNode" />
                        <NodeStyle CssClass="treeNode" />
                        <LeafNodeStyle CssClass="leafNode" />
                        <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                    </asp:TreeView>

                </ContentTemplate>
            </asp:UpdatePanel>

            </div>

            <!-- 鍔犺浇鎸囩ず�?-->
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

    <!-- 绛夊緟鍥炬爣 -->
    <img id="IMG_Waiting" src="Images/Processing.gif" alt="璇风◢鍊欙紝澶勭悊涓?.." style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 9999;" />
</body>
</html>