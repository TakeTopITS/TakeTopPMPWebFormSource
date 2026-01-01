<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPCustomerInfoView.aspx.cs" Inherits="TTAPPCustomerInfoView" %>

<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=0.1; user-scalable=1" />

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        /* 移动端优化样式 */
        .mobile-view {
            max-width: 100%;
            margin: 0 auto;
            background: #f5f5f5;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        
        .mobile-header {
            background: #007aff;
            color: white;
            padding: 12px 15px;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            color: white;
            text-decoration: none;
            font-weight: 500;
            background: none;
            border: none;
            padding: 5px 0;
            font-size: 16px;
        }
        
        .back-button img {
            margin-right: 8px;
            filter: brightness(0) invert(1);
        }
        
        .accordion-container {
            padding: 10px;
        }
        
        .accordion-panel {
            background: white;
            border-radius: 8px;
            margin-bottom: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .accordion-header {
            background: #007aff;
            color: white;
            padding: 15px;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .accordion-header.active {
            background: #0056cc;
        }
        
        .accordion-content {
            padding: 0;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease-out;
        }
        
        .accordion-content.active {
            max-height: 5000px;
            padding: 15px;
        }
        
        .accordion-icon {
            font-weight: bold;
            font-size: 18px;
        }
        
        /* 移动端基本信息表格样式 - 每行一个字段 */
        .mobile-info-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .mobile-info-row {
            border-bottom: 1px solid #eee;
            display: block;
            padding: 12px 0;
        }
        
        .mobile-info-label {
            font-weight: 600;
            color: #666;
            font-size: 14px;
            margin-bottom: 4px;
            display: block;
        }
        
        .mobile-info-value {
            color: #333;
            font-size: 15px;
            word-break: break-word;
            display: block;
        }
        
        /* DataGrid 移动端样式 - 垂直布局 */
        .datagrid-mobile-container {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        
        .datagrid-mobile-item {
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 15px;
            padding: 12px;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .datagrid-field {
            margin-bottom: 10px;
            display: flex;
            flex-direction: column;
        }
        
        .datagrid-label {
            font-weight: 600;
            color: #666;
            font-size: 13px;
            margin-bottom: 4px;
        }
        
        .datagrid-value {
            color: #333;
            font-size: 14px;
            word-break: break-word;
        }
        
        .datagrid-link {
            color: #007aff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .datagrid-button {
            display: inline-block;
            padding: 8px 15px;
            background: #007aff;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            text-align: center;
            margin: 5px 0;
            border: none;
            font-size: 14px;
        }
        
        .progress-container {
            background: #e9ecef;
            border-radius: 10px;
            height: 20px;
            margin: 5px 0;
            overflow: hidden;
        }
        
        .progress-bar {
            background: #28a745;
            height: 100%;
            border-radius: 10px;
            text-align: center;
            color: white;
            font-size: 12px;
            line-height: 20px;
            transition: width 0.3s ease;
        }
        
        /* 特殊样式 */
        .phone-link {
            color: #007aff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .email-link {
            color: #007aff;
            text-decoration: none;
            word-break: break-all;
        }
        
        .address-block {
            line-height: 1.4;
            padding: 3px 0;
        }
        
        .mobile-button {
            display: inline-block;
            padding: 10px 20px;
            background: #007aff;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            text-align: center;
            margin: 10px 0;
            border: none;
            font-size: 15px;
            width: 100%;
            box-sizing: border-box;
        }
        
        /* 状态徽章 */
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-active { background: #d4edda; color: #155724; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-closed { background: #f8d7da; color: #721c24; }
        .status-default { background: #d1ecf1; color: #0c5460; }
        
        /* 响应式调整 */
        @media (max-width: 480px) {
            .accordion-header {
                padding: 12px;
                font-size: 15px;
            }
            
            .mobile-info-row {
                padding: 10px 0;
            }
            
            .datagrid-mobile-item {
                padding: 10px;
            }
        }
    </style>
    
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();

            // 手风琴功能
            $('.accordion-header').click(function () {
                var $content = $(this).next('.accordion-content');
                var $icon = $(this).find('.accordion-icon');

                // 关闭其他打开的部分
                $('.accordion-content').not($content).removeClass('active').slideUp(300);
                $('.accordion-header').not(this).removeClass('active');
                $('.accordion-icon').not($icon).text('+');

                // 切换当前部分
                $content.toggleClass('active');
                $(this).toggleClass('active');
                if ($content.hasClass('active')) {
                    $content.slideDown(300);
                    $icon.text('−');
                } else {
                    $content.slideUp(300);
                    $icon.text('+');
                }
            });

            // 默认打开第一个部分
            $('.accordion-header').first().click();

            // 电话号码长按时提示
            $('.phone-link').on('contextmenu', function (e) {
                e.preventDefault();
                var phoneNumber = $(this).text().trim();
                if (phoneNumber) {
                    alert('电话号码: ' + phoneNumber + '\n\n点击可以拨打此号码');
                }
                return false;
            });
        });
    </script>
</head>
<body>
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>
        
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="mobile-view">
                    <!-- 移动端头部 -->
                    <div class="page_topbj">
                        <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" class="back-button">
                            <img src="ImagesSkin/return.png" alt="" width="20" height="20" />
                            <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,Back%>"></asp:Label>
                        </a>
                    </div>
                    
                    <div class="accordion-container">
                        <!-- 基本信息 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,JiBenXinXi%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <table cellpadding="0" cellspacing="0" width="90%">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <asp:DataList ID="DataList2" runat="server" Height="1px" Width="100%" CellPadding="0"
                                                ForeColor="#333333">
                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                <ItemTemplate>
                                                    <div class="mobile-info-table">
                                                        <!-- 客户代码 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,KeHuDaiMa%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "CustomerCode") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 客户名称 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,KeHuMingCheng%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "CustomerName") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 归属部门 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,GuiShuBuMen%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "BelongDepartCode") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "BelongDepartName") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 英文名 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,YingWenMing%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "CustomerEnglishName") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 行业类型 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,HangYeLeiXing%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "Type") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 主要联系人 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,ZhuYaoLianXiRen%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "ContactName") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 业务员 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,YeWuYuan%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "SalesPerson") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 发票地址 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,FaPiaoDiZhi%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "InvoiceAddress") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 币别 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,BiBie%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "Currency") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 银行账号 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,YinHangZhangHao%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "BankAccount") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 折扣率 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,ZheKouLv%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "Discount") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 开户银行 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,KaiHuYinHang%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "Bank") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 信用等级 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,XinYongDengJi%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "CreditRate") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 电话一 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,DianHuaYi%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <a href='tel:<%#DataBinder.Eval(Container.DataItem, "Tel1") %>' class="phone-link">
                                                                    <%#DataBinder.Eval(Container.DataItem, "Tel1") %>
                                                                </a>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 电话二 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,DianHuaEr%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <a href='tel:<%#DataBinder.Eval(Container.DataItem, "Tel2") %>' class="phone-link">
                                                                    <%#DataBinder.Eval(Container.DataItem, "Tel2") %>
                                                                </a>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 传真 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,ChuanZhen%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "Fax") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 电子邮件 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                E_Mail:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <a href='mailto:<%#DataBinder.Eval(Container.DataItem, "EmailAddress") %>' class="email-link">
                                                                    <%#DataBinder.Eval(Container.DataItem, "EmailAddress") %>
                                                                </a>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 网址 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,WangZhi%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "WebSite") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 邮政编码 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,YouZhengBianMa%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "ZP") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 国家 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,GuoJia%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "Country") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 省份 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,ShengFen%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "State") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 城市 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,ChengShi%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "City") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 区域 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label66" runat="server" Text="<%$ Resources:lang,QuYu%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "AreaAddress") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 详细地址(中文) -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,XiangXiDiZhiZhong%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value address-block">
                                                                <%#DataBinder.Eval(Container.DataItem, "RegistrationAddressCN") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 详细地址(英文) -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,XiangXiDiZhiYing%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value address-block">
                                                                <%#DataBinder.Eval(Container.DataItem, "RegistrationAddressEN") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 备注 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,BeiZhu%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "Comment") %>
                                                            </span>
                                                        </div>
                                                        
                                                        <!-- 建立日期 -->
                                                        <div class="mobile-info-row">
                                                            <span class="mobile-info-label">
                                                                <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,JianLiRiQi%>"></asp:Label>:
                                                            </span>
                                                            <span class="mobile-info-value">
                                                                <%#DataBinder.Eval(Container.DataItem, "CreateDate") %>
                                                            </span>
                                                        </div>
                                                        
                                                     <%--   <!-- 相关联系人按钮 -->
                                                        <div class="mobile-info-row" style="border-bottom: none; padding-top: 20px;">
                                                            <a href='TTContactList.aspx?RelatedType=Customer&RelatedID=<%#DataBinder.Eval(Container.DataItem, "CustomerCode")%>'
                                                                target="DetailArea" class="mobile-button">
                                                                <asp:Label ID="Label63" runat="server" Text="<%$ Resources:lang,XiangGuanLianXiRen%>"></asp:Label>
                                                            </a>
                                                        </div>--%>
                                                    </div>
                                                </ItemTemplate>
                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                <ItemStyle CssClass="itemStyle" />
                                            </asp:DataList>

                                          <%--  <!-- 保持原有的HyperLink控件 -->
                                            <asp:HyperLink ID="HL_RelatedContactInfor" runat="server" Enabled="false" Visible="false" Target="_blank" Text="<%$ Resources:lang,XiangGuanLianXiRen%>"></asp:HyperLink>--%>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        <!-- 客服记录 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,KeFuJiLu%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <div class="datagrid-mobile-container">
                                    <!-- 保持原有的DataGrid结构 -->
                                    <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False" ShowHeader="False"
                                        Height="1px" Width="100%"
                                        CellPadding="4" ForeColor="#333333" GridLines="None">
                                        <ItemStyle CssClass="itemStyle" />
                                        <HeaderStyle Horizontalalign="left" BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <Columns>
                                            <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="Type" HeaderText="Type">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTCustomerQuestionHandleRecordList.aspx?ID={0}"
                                                DataTextField="Question" HeaderText="问题" Target="_blank">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="40%" />
                                            </asp:HyperLinkColumn>
                                            <asp:TemplateColumn HeaderText="Status">
                                                <ItemTemplate>
                                                    <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                            </asp:TemplateColumn>
                                            <asp:HyperLinkColumn DataNavigateUrlField="OperatorCode" DataNavigateUrlFormatString="TTUserInforSimple.aspx?UserCode={0}"
                                                DataTextField="OperatorName" HeaderText="受理人" Target="_blank">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:HyperLinkColumn>
                                            <asp:TemplateColumn HeaderText="Status">
                                                <ItemTemplate>
                                                    <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("OperatorStatus").ToString()) %>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                            </asp:TemplateColumn>
                                            <asp:HyperLinkColumn DataNavigateUrlField="RecorderCode" DataNavigateUrlFormatString="TTUserInforSimple.aspx?UserCode={0}"
                                                DataTextField="RecorderCode" HeaderText="记录人" Target="_blank">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:HyperLinkColumn>
                                            <asp:TemplateColumn>
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ID", "TTCustomerQuestionRelatedDoc.aspx?RelatedID={0}") %>'
                                                        Target="_blank"><img src="ImagesSkin/Doc.gif" class="noBorder" /></asp:HyperLink>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                    </asp:DataGrid>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 关联项目 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label41" runat="server" Text="<%$ Resources:lang,GuanLianXiangMu%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <div class="datagrid-mobile-container">
                                    <!-- 保持原有的DataGrid结构 -->
                                    <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False" ShowHeader="False"
                                        GridLines="None" Width="100%">
                                        <Columns>
                                            <asp:BoundColumn DataField="ProjectID" HeaderText="Number">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="ProjectName" HeaderText="项目名称">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="25%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="开始日期">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="结束日期">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="MakeDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="立项日期">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:TemplateColumn HeaderText="Status">
                                                <ItemTemplate>
                                                    <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderText="完成程度">
                                                <ItemTemplate>
                                                    <asp:Label ID="LB_FinishPercent" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"FinishPercent")%> '></asp:Label>%
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <EditItemStyle BackColor="#2461BF" />
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <HeaderStyle BackColor="#507CD1" BorderColor="#394F66" BorderStyle="Solid" BorderWidth="1px"
                                            Font-Bold="True" ForeColor="White" Horizontalalign="left" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 关联合同 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label49" runat="server" Text="<%$ Resources:lang,GuanLianHeTong%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <table class="ItemAlignLeft" cellpadding="0" cellspacing="0" width="98%">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <asp:Label ID="Label1" runat="server" Font-Bold="True" Width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="datagrid-mobile-container">
                                                <!-- 保持原有的DataGrid结构 -->
                                                <asp:DataGrid ID="DataGrid6" runat="server" AutoGenerateColumns="False" ShowHeader="False"
                                                    Height="1px" Width="100%" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ConstractCode" HeaderText="ContractCode">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:HyperLinkColumn DataNavigateUrlField="ConstractCode" DataNavigateUrlFormatString="TTConstractView.aspx?ConstractCode={0}"
                                                            DataTextField="ConstractName" HeaderText="ContractName">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="17%" />
                                                        </asp:HyperLinkColumn>
                                                        <asp:BoundColumn DataField="Type" HeaderText="Type">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Status">
                                                            <ItemTemplate>
                                                                <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="5%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SignDate" HeaderText="SigningDate" DataFormatString="{0:yyyy/MM/dd}">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Amount" HeaderText="Amount">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Currency" HeaderText="Currency">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PartA" HeaderText="PartyAUnit">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PartB" HeaderText="乙方单位">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                </asp:DataGrid>
                                                <asp:Label ID="Label4" runat="server" Visible="False"></asp:Label>
                                                <asp:Label ID="Label5" runat="server" Font-Bold="False" Font-Size="9pt"
                                                    Visible="False" Width="57px"></asp:Label>
                                                <asp:Label ID="Label6" runat="server" Font-Bold="False" Font-Size="9pt"
                                                    Visible="False" Width="57px"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        <!-- 物料销售订单 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label59" runat="server" Text="<%$ Resources:lang,GuanLianShangPinXiaoShouDingDan%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <div class="datagrid-mobile-container">
                                    <!-- 保持原有的DataGrid结构 -->
                                    <asp:DataGrid ID="DataGrid5" runat="server" AutoGenerateColumns="False"
                                        CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px"
                                        ShowHeader="False"
                                        Width="100%">
                                        <Columns>
                                            <asp:BoundColumn DataField="SOID" HeaderText="Number">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:HyperLinkColumn DataNavigateUrlField="SOID" DataNavigateUrlFormatString="TTGoodsSaleOrderView.aspx?SOID={0}"
                                                DataTextField="SOName" HeaderText="Name" Target="_blank">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="25%" />
                                            </asp:HyperLinkColumn>
                                            <asp:BoundColumn DataField="Amount" HeaderText="总金额">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="SaleTime" DataFormatString="{0:yyyy/MM/dd}" HeaderText="销售时间">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:HyperLinkColumn DataNavigateUrlField="SalesCode" DataNavigateUrlFormatString="TTUserInforSimple.aspx?UserCode={0}"
                                                DataTextField="SalesName" HeaderText="Salesperson" Target="_blank">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:HyperLinkColumn>
                                            <asp:TemplateColumn HeaderText="Status">
                                                <ItemTemplate>
                                                    <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <ItemStyle CssClass="itemStyle" />
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                    </asp:DataGrid>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 物料退货单 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label66" runat="server" Text="<%$ Resources:lang,GuanLianShangPinTuiHuoDan%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <div class="datagrid-mobile-container">
                                    <!-- 保持原有的DataGrid结构 -->
                                    <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False"
                                        ShowHeader="False" Height="1px"
                                        Width="100%" CellPadding="4" ForeColor="#333333" GridLines="None">
                                        <Columns>
                                            <asp:BoundColumn DataField="ROID" HeaderText="Number">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                            </asp:BoundColumn>
                                            <asp:HyperLinkColumn DataNavigateUrlField="ROID" DataNavigateUrlFormatString="TTGoodsReturnOrderView.aspx?ROID={0}"
                                                DataTextField="ReturnName" HeaderText="Name" Target="_blank">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="40%" />
                                            </asp:HyperLinkColumn>
                                            <asp:BoundColumn DataField="Amount" HeaderText="Amount">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="CurrencyType" HeaderText="Currency">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="Applicant" HeaderText="Applicant">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="20%" />
                                            </asp:BoundColumn>
                                        </Columns>
                                        <EditItemStyle BackColor="#2461BF" />
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 报价单 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label72" runat="server" Text="<%$ Resources:lang,XiangGuanBaoJiaDan%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <div class="datagrid-mobile-container">
                                    <!-- 保持原有的DataGrid结构 -->
                                    <asp:DataGrid ID="DataGrid7" runat="server" AutoGenerateColumns="False"
                                        CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px"
                                        ShowHeader="False"
                                        Width="100%">
                                        <Columns>
                                            <asp:BoundColumn DataField="QOID" HeaderText="Number">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:HyperLinkColumn DataNavigateUrlField="QOID" DataNavigateUrlFormatString="TTGoodsSaleQuotationOrderView.aspx?QOID={0}"
                                                DataTextField="QOName" HeaderText="Name" Target="_blank">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="40%" />
                                            </asp:HyperLinkColumn>
                                            <asp:BoundColumn DataField="Amount" HeaderText="总金额">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="CurrencyType" HeaderText="Currency">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="QuotationTime" DataFormatString="{0:yyyy/MM/dd}" HeaderText="报价时间">
                                                <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:TemplateColumn HeaderText="Status">
                                                <ItemTemplate>
                                                    <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <EditItemStyle BackColor="#2461BF" />
                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                    </asp:DataGrid>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 物料保修 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label79" runat="server" Text="<%$ Resources:lang,ShangPinBaoXiu%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <div style="margin-bottom: 20px;">
                                    <asp:Label ID="Label93" runat="server" Text="<%$ Resources:lang,ShouHouRenWu%>"></asp:Label>
                                    <div class="datagrid-mobile-container">
                                        <!-- 保持原有的DataGrid结构 -->
                                        <asp:DataGrid ID="DataGrid9" runat="server" AutoGenerateColumns="False" OnItemCommand="DataGrid9_ItemCommand"
                                            ShowHeader="False" Height="1px"
                                            Width="100%" CellPadding="4" ForeColor="#333333" GridLines="None">
                                            <Columns>
                                                <asp:TemplateColumn HeaderText="系列号">
                                                    <ItemTemplate>
                                                        <asp:Button ID="BT_GoodsSN" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SN") %>'
                                                            class="datagrid-button" CommandArgument='<%# Eval("SN") %>' />
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:TemplateColumn>
                                                <asp:HyperLinkColumn DataNavigateUrlField="FinalCustomerCode" DataNavigateUrlFormatString="TTCustomerInfoView.aspx?CustomerCode={0}"
                                                    DataTextField="FinalCustomerName" Target="_blank">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                </asp:HyperLinkColumn>
                                                <asp:BoundColumn DataField="GoodsName" HeaderText="MaterialName">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="ModelNumber" HeaderText="Model">
                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Spec" HeaderText="Specification">
                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Number" HeaderText="Quantity">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="UnitName" HeaderText="Unit">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Manufacturer" HeaderText="厂家">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="ShipmentNO" HeaderText="出库单号">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                </asp:BoundColumn>
                                                <asp:HyperLinkColumn DataNavigateUrlField="CustomerCode" DataNavigateUrlFormatString="TTCustomerInfoView.aspx?CustomerCode={0}"
                                                    DataTextField="CustomerName" Target="_blank">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                </asp:HyperLinkColumn>
                                                <asp:BoundColumn DataField="ShipTime" HeaderText="出库时间" DataFormatString="{0:yyyy/MM/dd}">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="WarrantyPeriod" HeaderText="保修期">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="WarrantyEndTime" HeaderText="EndTime" DataFormatString="{0:yyyy/MM/dd}">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                </asp:BoundColumn>
                                            </Columns>
                                            <EditItemStyle BackColor="#2461BF" />
                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                            <ItemStyle CssClass="itemStyle" />
                                            <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                    </div>
                                </div>
                                
                                <div style="margin-bottom: 20px;">
                                    <asp:Label ID="Label105" runat="server" Text="<%$ Resources:lang,LingYongPeiJian%>"></asp:Label>
                                    <div class="datagrid-mobile-container">
                                        <!-- 保持原有的DataGrid结构 -->
                                        <asp:DataGrid runat="server" AutoGenerateColumns="False" ShowHeader="False"
                                            Height="30px" Width="100%" ID="DataGrid8">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="GoodsName" HeaderText="物料名">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="20%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="ModelNumber" HeaderText="Model">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Spec" HeaderText="Specification">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="20%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Number" HeaderText="Quantity">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Unit" HeaderText="Unit">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="CheckOutNumber" HeaderText="已出库">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Manufacturer" HeaderText="厂家">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                            </Columns>
                                            <ItemStyle CssClass="itemStyle"></ItemStyle>
                                            <PagerStyle Horizontalalign="center"></PagerStyle>
                                        </asp:DataGrid>
                                    </div>
                                </div>
                                
                                <!-- 售后任务 -->
                                <div style="margin-bottom: 20px;">
                                    <asp:Label ID="Label106" runat="server" Text="<%$ Resources:lang,ShouHouRenWu%>"></asp:Label>
                                    <div class="datagrid-mobile-container">
                                        <!-- 保持原有的DataGrid结构 -->
                                        <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False"
                                            ShowHeader="False" OnItemCommand="DataGrid3_ItemCommand"
                                            Width="100%" Height="1px" CellPadding="4" ForeColor="#333333" GridLines="None">
                                            <Columns>
                                                <asp:TemplateColumn HeaderText="Number">
                                                    <ItemTemplate>
                                                        <asp:Button ID="BT_TaskID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"TaskID") %>'
                                                            CssClass="datagrid-button" CommandArgument='<%# Eval("TaskID") %>' />
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="9%" />
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="Type" HeaderText="Type">
                                                    <ItemStyle CssClass="itemBorder" Width="8%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Task" HeaderText="Task">
                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="12%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Priority" HeaderText="优先级">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                </asp:BoundColumn>
                                                <asp:TemplateColumn HeaderText="Status">
                                                    <ItemTemplate>
                                                        <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:BoundColumn>
                                                <asp:BoundColumn DataField="Budget" HeaderText="Budget">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:BoundColumn>
                                                <asp:TemplateColumn HeaderText="完成程度">
                                                    <ItemTemplate>
                                                        <asp:Label ID="LB_FinishPercent" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"FinishPercent")%> '></asp:Label>%
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="Expense" HeaderText="Expense">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:BoundColumn>
                                                <asp:TemplateColumn HeaderText="Status">
                                                    <ItemTemplate>
                                                        <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="7%" />
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <EditItemStyle BackColor="#2461BF" />
                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                            <ItemStyle CssClass="itemStyle" />
                                            <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 关联物料 -->
                        <div class="accordion-panel">
                            <div class="accordion-header">
                                <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,GuanLianLiaoPin%>"></asp:Label>
                                <span class="accordion-icon">+</span>
                            </div>
                            <div class="accordion-content">
                                <br />
                                <table class="ItemAlignLeft" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <asp:Label ID="LB_GoodsOwner" runat="server" Font-Bold="True" Width="100%"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="datagrid-mobile-container">
                                                <!-- 保持原有的DataGrid结构 -->
                                                <asp:DataGrid ID="DataGrid12" runat="server" AutoGenerateColumns="False"
                                                    CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px"
                                                    ShowHeader="False"
                                                    Width="100%">
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ID" HeaderText="ID">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="GoodsCode" HeaderText="Code">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="GoodsName" HeaderText="Name">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="20%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Spec" HeaderText="Specification">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="15%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ModelNumber" HeaderText="Model">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="13%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Unit" HeaderText="Unit">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Price" HeaderText="UnitPrice">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                </asp:DataGrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
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
        
        <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="LB_ProjectID" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="LB_UserName" runat="server" Visible="False"></asp:Label>
    </form>
</body>
</html>