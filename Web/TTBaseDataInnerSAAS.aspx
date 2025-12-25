<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTBaseDataInnerSAAS.aspx.cs" Inherits="TTBaseDataInnerSAAS" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" src="js/SetSortTextBoxMustInputIntegerNumber.js"></script>

    <style type="text/css">
        .style1 {
            color: red;
        }

        select {
            height: 30px;
        }


        /* 模态框样式 */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
        }

        .modal-content {
            position: fixed;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            min-width: 400px;
            max-width: 90%;
            max-height: 80%;
            overflow-y: auto;
            border: 1px solid #ddd;
        }

        .modal-header {
            border-bottom: 2px solid #57CD1;
            padding-bottom: 10px;
            margin-bottom: 15px;
            color: #333;
        }

        .modal-footer {
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 15px;
            text-align: right;
        }

        .close-modal {
            background: #f44336;
            color: white;
            border: none;
            padding: 6px 12px;
            cursor: pointer;
            border-radius: 4px;
            margin-left: 10px;
        }

            .close-modal:hover {
                background: #d32f2f;
            }

        .form-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

            .form-group label {
                display: inline-block;
                width: 120px;
                font-weight: bold;
                margin-right: 10px;
            }

            .form-group input, .form-group select {
                flex: 1;
                padding: 6px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

        .grid-add-icon {
            cursor: pointer;
            color: green;
            font-weight: bold;
            margin-left: 10px;
            font-size: 16px;
            padding: 4px 8px;
            border: 1px solid green;
            border-radius: 4px;
            background: #f0fff0;
            display: inline-block;
            text-align: center;
            min-width: 30px;
        }

            .grid-add-icon:hover {
                background: #e0ffe0;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,255,0,0.2);
            }

        .header-with-button {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }

        .header-title {
            flex: 1;
        }

        .header-button {
            margin-left: auto;
        }
    </style>

    <script type="text/javascript" language="javascript">


        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        function showModal(modalId, buttonElement) {
            var modal = $('#' + modalId);
            modal.show();

            // 获取按钮在视口中的位置
            var buttonRect = buttonElement.getBoundingClientRect();

            // 获取模态框元素
            var modalElement = modal.find('.modal-content')[0];
            var modalWidth = modalElement.offsetWidth;
            var modalHeight = modalElement.offsetHeight;

            // 计算在按钮上方的位置(视口相对位置)
            var topPosition = buttonRect.top - modalHeight - 10; // 按钮上方10px
            var leftPosition = buttonRect.left;

            // 确保模态框不会超出视口
            var viewportWidth = window.innerWidth;
            var viewportHeight = window.innerHeight;

            // 水平方向调整
            if (leftPosition + modalWidth > viewportWidth) {
                leftPosition = Math.max(10, viewportWidth - modalWidth - 10);
            } else if (leftPosition < 0) {
                leftPosition = 10;
            }

            // 如果上方空间不够，调整到按钮下方
            if (topPosition < 0) {
                topPosition = buttonRect.bottom + 10;

                // 如果下方空间也不够，调整到视口中间
                if (topPosition + modalHeight > viewportHeight) {
                    topPosition = Math.max(10, (viewportHeight - modalHeight) / 2);
                }
            }

            // 确保不会超出底部边界
            if (topPosition + modalHeight > viewportHeight) {
                topPosition = Math.max(10, viewportHeight - modalHeight - 10);
            }

            // 设置模态框位置(相对于视口)
            $(modalElement).css({
                'top': topPosition + 'px',
                'left': leftPosition + 'px'
            });
        }

        function hideModal(modalId) {
            $('#' + modalId).hide();
        }

        // 为所有模态框添加点击外部关闭功能
        $(document).on('click', function (e) {
            $('.modal-overlay').each(function () {
                if ($(this).is(':visible') && !$(e.target).closest('.modal-content').length) {
                    $(this).hide();
                }
            });
        });

        // 阻止模态框内容点击事件冒泡
        $(document).on('click', '.modal-content', function (e) {
            e.stopPropagation();
        });

        // 处理新增按钮点击
        function handleAddClick(modalId, event) {
            if (event) {
                event.stopPropagation();
                event.preventDefault();
            }
            showModal(modalId, event.target);
            return false; // 阻止默认行为
        }

        // 全局函数，供后端调用
        function openModal(modalId) {
            var modal = $('#' + modalId);
            modal.show();

            // 居中显示模态框
            var modalElement = modal.find('.modal-content')[0];
            var topPosition = (window.innerHeight - modalElement.offsetHeight) / 2;
            var leftPosition = (window.innerWidth - modalElement.offsetWidth) / 2;

            // 设置模态框位置
            $(modalElement).css({
                'top': Math.max(topPosition, 20) + 'px',
                'left': Math.max(leftPosition, 20) + 'px'
            });
        }


    </script>
</head>
<body>
    <center>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div id="AboveDiv">
                        <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                            <tr>
                                <td height="31" class="page_topbj">
                                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="center" style="padding-top: 5px;">
                                                <table width="665" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,JiChuShuJu%>"></asp:Label>
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <table>
                                                                <tr>
                                                                    <td>(
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,YuYan%>"></asp:Label>:
                                                                    </td>
                                                                    <td>
                                                                        <asp:DropDownList ID="ddlLangSwitcher" runat="server" AutoPostBack="true" DataTextField="Language" DataValueField="LangCode" OnSelectedIndexChanged="ddlLangSwitcher_SelectedIndexChanged">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td style="padding-top: 3px;">
                                                                        <asp:Button ID="BT_CopyForHomeLanguage" runat="server" CssClass="inpuLong" OnClick="BT_CopyForHomeLanguage_Click" Text="<%$ Resources:lang,CopyFromHomeLanguage%>" />
                                                                    </td>
                                                                    <td>)
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="60px"></td>
                                            <td width="800px">
                                                <!-- 在页头或适当位置添加 -->
                                                <div style="text-align: left; margin-bottom: 10px;">
                                                    <a href="TTAIServerConfiguration.aspx" style="color: #4F46E5; text-decoration: none; font-weight: 600;">⚙️ AI Server Configuration
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <b>------&gt;<asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ZhuYiDai%>"></asp:Label><span style="color: red;">*</span><asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,XKNBCXNZZNXZBNSCHXG%>"></asp:Label></b></td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="width: 98%;" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="100%" style="padding: 5px 0px 0px 5px;" valign="top">
                                                <table style="width: 100%; height: 53px">
                                                    <tr>
                                                        <td style="width: 50%; height: 22px;" valign="top">
                                                            <div style="width: 100%; height: 22px; text-align: left; background-image: url('ImagesSkin/titleBG.jpg');">
                                                                <div class="header-button" style="text-align: right;">
                                                                    <span class="grid-add-icon" onclick="return handleAddClick('modalProjectType', event)">+</span>
                                                                </div>
                                                            </div>
                                                            <div style="width: 100%; height: 22px; text-align: left; background-image: url('ImagesSkin/titleBG.jpg');">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td width="30%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="15%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,GuanJianCi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="20%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="Label59" runat="server" Text="<%$ Resources:lang,MuBan%>"></asp:Label></strong>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>

                                                            <asp:DataGrid ID="DataGrid20" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                                ShowHeader="false" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid20_ItemCommand"
                                                                PageSize="20" Width="100%">
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="Type">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_ProjectType" runat="server" CssClass="inpu" Width="150px" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' ToolTip='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="KeyWord" HeaderText="关键词">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate>
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:HyperLink ID="HL_DocumentTemplate" Text="<%$ Resources:lang,WenDang%>" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.Type", "TTProjectTypeRelatedDoc.aspx?RelatedType=ProjectType&RelatedName={0}") %>'
                                                                                            Target="_blank"></asp:HyperLink></td>
                                                                                </tr>
                                                                            </table>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                    </asp:TemplateColumn>
                                                                </Columns>
                                                            </asp:DataGrid>

                                                            <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
                                                        </td>
                                                        <td style="width: 50%; height: 22px; text-align: left;">
                                                            <table width="100%" style="background-image: url('ImagesSkin/titleBG.jpg');">
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="LB_SelectedProjectType" runat="server"></asp:Label>&nbsp;<asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,DeZhuangTaiLieBiao%>"></asp:Label>

                                                                        <td>
                                                                            <div class="header-button" style="text-align: right;">
                                                                                <span class="grid-add-icon" onclick="return handleAddClick('modalProjectStatus', event)">+</span>
                                                                            </div>
                                                                        </td>
                                                                </tr>
                                                            </table>

                                                            <div class="header-with-button">
                                                                <div class="header-title" style="background-color: buttonface;">
                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                        <tr>
                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label>
                                                                            </strong></td>
                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                            </strong></td>
                                                                            <td class="ItemAlignLeft" width="18%"><strong>
                                                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                                (Home) </strong></td>
                                                                            <td class="ItemAlignLeft" width="10%"><strong>
                                                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,YuYan%>"></asp:Label>
                                                                            </strong></td>
                                                                            <td class="ItemAlignLeft" width="20%"><strong>
                                                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                            </strong></td>
                                                                            <td class="ItemAlignLeft" width="10%"><strong>
                                                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,KongZhiDian%>"></asp:Label>
                                                                            </strong></td>
                                                                            <td width="7%" class="ItemAlignLeft"><strong>
                                                                                <asp:Label ID="Label60" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                                            </strong></td>
                                                                        </tr>
                                                                    </table>
                                                                </div>

                                                            </div>
                                                            <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid3_ItemCommand" PageSize="20" ShowHeader="false" Width="100%">
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="Number">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_StatusID" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="Edit" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="Status" HeaderText="Status">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn HeaderText="模块名称(本语)">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TB_HomeName" runat="server" Width="100px" Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>'></asp:TextBox>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="18%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="LangCode" HeaderText="语言">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                        <HeaderStyle Font-Bold="True" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn HeaderText="顺序">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TB_SortNumber" runat="server" Width="50px" Text='<%# DataBinder.Eval(Container.DataItem,"SortNumber") %>'></asp:TextBox>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="ReviewControl" HeaderText="控制点">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="MakeType" HeaderText="Type">
                                                                        <ItemStyle Width="7%" CssClass="itemBorder" HorizontalAlign="left" />
                                                                    </asp:BoundColumn>
                                                                </Columns>
                                                            </asp:DataGrid>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" class="ItemAlignLeft">
                                                            <table style="width: 100%;" cellpadding="3" cellspacing="0" class="formBgStyle">
                                                                <tr>
                                                                    <td class="formItemBgStyleForAlignLeft" rowspan="2">
                                                                        <!-- 项目类型表单控件已移到模态窗口 -->
                                                                        <table style="width: 100%;" cellpadding="3" cellspacing="0" class="formBgStyle">
                                                                            <tr>
                                                                                <td colspan="8" class="formItemBgStyleForAlignLeft"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td>
                                                            <table style="width: 100%;" cellpadding="3" cellspacing="0" class="formBgStyle">
                                                                <tr>
                                                                    <td class="formItemBgStyleForAlignLeft">
                                                                        <!-- 项目状态表单控件已移到模态窗口 -->
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="formItemBgStyleForAlignLeft">
                                                                        <asp:Button ID="BT_ProjectStatusSave" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_ProjectStatusSave_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft" colspan="2" valign="top">
                                                <table style="width: 100%;">
                                                    <tr>
                                                        <td colspan="6" style="height: 15px; background-color: buttonface"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft" style="vertical-align: top;">
                                                            <div class="header-with-button">
                                                                <strong>
                                                                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,RenWuZhuangTaiSheDing%>"></asp:Label>
                                                                </strong><span style="color: red;">*</span>
                                                                <span class="grid-add-icon" onclick="return handleAddClick('modalTaskStatus', event)">+</span>
                                                            </div>
                                                        </td>
                                                        <td class="ItemAlignLeft" style="vertical-align: top;">
                                                            <div class="header-with-button">
                                                                <strong>
                                                                    <asp:Label ID="Label325" runat="server" Text="<%$ Resources:lang,ActorGroup%>"></asp:Label>
                                                                </strong>

                                                            </div>
                                                        </td>
                                                        <td class="ItemAlignLeft" style="vertical-align: top;">
                                                            <div class="header-with-button">
                                                                <strong>
                                                                    <asp:Label ID="Label304" runat="server" Text="<%$ Resources:lang,JiHuaZhuangTaiSheDing%>"></asp:Label>
                                                                </strong>
                                                                <span class="grid-add-icon" onclick="return handleAddClick('modalPlanStatus', event)">+</span>
                                                            </div>
                                                        </td>
                                                        <td class="ItemAlignLeft" style="vertical-align: top;">&nbsp;</td>
                                                        <td class="ItemAlignLeft" style="vertical-align: top;">
                                                            <div class="header-with-button">
                                                                <strong>
                                                                    <asp:Label ID="Label322" runat="server" Text="<%$ Resources:lang,CeShiZhuangTai%>"></asp:Label>
                                                                </strong>
                                                                <span class="grid-add-icon" onclick="return handleAddClick('modalTestStatus', event)">+</span>
                                                            </div>
                                                        </td>
                                                        <td style="height: 19px">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft" style="vertical-align: top;">
                                                            <table width="98%" border="0" cellpadding="" cellspacing="" background="ImagesSkin/main_n_bj.jpg">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                    </td>
                                                                    <td>
                                                                        <table border="0" cellpadding="" cellspacing="" width="100%">
                                                                            <tr>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                                    (Home) </strong></td>
                                                                                <td class="ItemAlignLeft" width="25%"><strong>
                                                                                    <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,YuYan%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="15%"><strong>
                                                                                    <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                                </strong></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td width="6" align="right">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td rowspan="5" style="vertical-align: top;" class="ItemAlignLeft">
                                                            <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="" cellspacing="" width="98%">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img height="26" src="ImagesSkin/main_n_l.jpg" width="7" />
                                                                    </td>
                                                                    <td>
                                                                        <table border="0" cellpadding="" cellspacing="" width="100%">
                                                                            <tr>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label326" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label327" runat="server" Text="<%$ Resources:lang,MIngCheng%>"></asp:Label>
                                                                                    (Home) </strong></td>
                                                                                <td class="ItemAlignLeft" width="25%"><strong>
                                                                                    <asp:Label ID="Label328" runat="server" Text="<%$ Resources:lang,YuYan%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="15%"><strong>
                                                                                    <asp:Label ID="Label329" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                                </strong></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="right" width="6">
                                                                        <img alt="" height="26" src="ImagesSkin/main_n_r.jpg" width="6" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <asp:DataGrid ID="DataGrid21" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" ShowHeader="false" Width="98%">
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="Status">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_GroupName" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"GroupName") %>' CommandName="Edit" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderText="模块名称(本语)">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TB_HomeName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>' Width="100px"></asp:TextBox>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="LangCode" HeaderText="语言">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                        <HeaderStyle Font-Bold="True" Width="25%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="MakeType" HeaderText="Type">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                </Columns>
                                                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                            </asp:DataGrid>
                                                            <br />
                                                            <asp:Button ID="BT_ActorGroupSave" runat="server" CssClass="inpu" OnClick="BT_ActorGroupSave_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                            &nbsp;
                                                        </td>
                                                        <td style="vertical-align: top;" class="ItemAlignLeft">
                                                            <table width="98%" border="0" cellpadding="" cellspacing="" background="ImagesSkin/main_n_bj.jpg">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                    </td>
                                                                    <td>
                                                                        <table border="0" cellpadding="" cellspacing="" width="100%">
                                                                            <tr>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                                    (Home) </strong></td>
                                                                                <td class="ItemAlignLeft" width="25%"><strong>
                                                                                    <asp:Label ID="Label35" runat="server" Text="<%$ Resources:lang,YuYan%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="10%"><strong>
                                                                                    <asp:Label ID="Label36" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                                </strong></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td width="6" align="right">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="vertical-align: top;">&nbsp;</td>
                                                        <td style="vertical-align: top;" class="ItemAlignLeft">
                                                            <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="" cellspacing="" width="98%">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                    </td>
                                                                    <td>
                                                                        <table border="0" cellpadding="" cellspacing="" width="100%">
                                                                            <tr>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label42" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                                    (Home) </strong></td>
                                                                                <td class="ItemAlignLeft" width="25%"><strong>
                                                                                    <asp:Label ID="Label44" runat="server" Text="<%$ Resources:lang,YuYan%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="15%"><strong>
                                                                                    <asp:Label ID="Label45" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                                </strong></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="right" width="6">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="height: 19px"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft" style="vertical-align: top;" rowspan="4">
                                                            <asp:DataGrid ID="DataGrid6" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid6_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="Status">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_Status" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Status") %>' CommandName="Edit" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderText="模块名称(本语)">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TB_HomeName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>' Width="100px"></asp:TextBox>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="LangCode" HeaderText="语言">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                        <HeaderStyle Font-Bold="True" Width="25%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="MakeType" HeaderText="Type">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                </Columns>
                                                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                            </asp:DataGrid>
                                                            <!-- 任务状态表单控件已移到模态窗口 -->
                                                            <br />
                                                            <asp:Button ID="BT_TaskStatusSave" runat="server" CssClass="inpu" OnClick="BT_TaskStatusSave_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                        </td>
                                                        <td style="vertical-align: top;" rowspan="4" class="ItemAlignLeft">
                                                            <asp:DataGrid ID="DataGrid8" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid8_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="Status">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_Status" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Status") %>' CommandName="Edit" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>

                                                                    <asp:TemplateColumn HeaderText="模块名称(本语)">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TB_HomeName" runat="server" Width="100px" Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>'></asp:TextBox>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="LangCode" HeaderText="语言">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                        <HeaderStyle Font-Bold="True" Width="25%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="MakeType" HeaderText="Type">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                </Columns>
                                                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                            </asp:DataGrid>
                                                            <!-- 计划状态表单控件已移到模态窗口 -->
                                                            <br />
                                                            <asp:Button ID="BT_PlanStatusSave" runat="server" CssClass="inpu" OnClick="BT_PlanStatusSave_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                        </td>
                                                        <td style="vertical-align: top;">&nbsp;</td>
                                                        <td style="vertical-align: top;" rowspan="4" class="ItemAlignLeft">
                                                            <asp:DataGrid ID="DataGrid16" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid16_ItemCommand" ShowHeader="false" Width="98%">
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="Status">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_Status" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Status") %>' CommandName="Edit" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderText="模块名称(本语)">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="TB_HomeName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>' Width="100px"></asp:TextBox>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="LangCode" HeaderText="语言">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                        <HeaderStyle Font-Bold="True" Width="25%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="MakeType" HeaderText="Type">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                    </asp:BoundColumn>
                                                                </Columns>
                                                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                            </asp:DataGrid>
                                                            <!-- 测试状态表单控件已移到模态窗口 -->
                                                            <br />
                                                            <asp:Button ID="BT_TestStatusSave" runat="server" CssClass="inpu" OnClick="BT_TestStatusSave_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                        </td>
                                                        <td rowspan="4">&nbsp;</td>
                                                    </tr>

                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>

                    </div>

                    <!-- 模态框定义 -->
                    <!-- 项目类型模态框 -->
                    <div id="modalProjectType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalProjectType" runat="server" Text="<%$ Resources:lang,XiangMuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="TB_ProjectType" runat="server" Width="100px"></asp:TextBox></td>
                                        <td style="text-align: Right;">
                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,GuanJianCi%>"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="TB_KeyWord" runat="server" Width="80px"></asp:TextBox></td>
                                        <td>
                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="TB_ProjectTypeSort" runat="server" Width="30px" Text="1"></asp:TextBox></td>
                                        <td style="display: none;">
                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,YXXMJLGXMZT%>"></asp:Label></td>
                                        <td style="display: none;">
                                            <asp:DropDownList ID="DL_AllowPMChangeStatus" runat="server">
                                                <asp:ListItem>YES</asp:ListItem>
                                                <asp:ListItem>NO</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td colspan="3">
                                            <asp:Label ID="Label63" runat="server" Text="<%$ Resources:lang,XMJDSXJYX%>"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="DL_ImpactByDetail" runat="server">
                                                <asp:ListItem>YES</asp:ListItem>
                                                <asp:ListItem>NO</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>

                                        <td colspan="3">
                                            <asp:Label ID="Label65" runat="server" Text="<%$ Resources:lang,RWJDYXJHJDYQRM%>"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="DL_PlanProgressNeedPlanerConfirm" runat="server">
                                                <asp:ListItem>NO</asp:ListItem>
                                                <asp:ListItem>YES</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>

                                    </tr>
                                    <tr style="display: none;">
                                        <td colspan="3">
                                            <asp:Label ID="Label61" runat="server" Text="<%$ Resources:lang,LXHZDFQLC%>"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="DL_AutoRunWFAfterMakeProject" runat="server">
                                                <asp:ListItem>NO</asp:ListItem>
                                                <asp:ListItem>YES</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td colspan="3" class="ItemAlignLeft">
                                            <asp:Label ID="Label69" runat="server" Text="<%$ Resources:lang,XMQDXYCJYHQRM%>"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="DL_ProjectStartupNeedSupperConfirm" runat="server">
                                                <asp:ListItem>NO</asp:ListItem>
                                                <asp:ListItem>YES</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="TB_ProjectTypeNew" runat="server" CssClass="inpu" OnClick="TB_ProejctTypeNew_Click"
                                    Text="<%$ Resources:lang,BaoCun%>" />
                                &nbsp;
                               
                                <asp:Button ID="BT_ProjectTypeDelete" runat="server" Enabled="false" CssClass="inpu" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" OnClick="BT_ProjectTypeDelete_Click"
                                    Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalProjectType')">
                                    <asp:Label ID="LabelClose1" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 项目状态模态框 -->
                    <div id="modalProjectStatus" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalProjectStatus" runat="server" Text="<%$ Resources:lang,XiangMuZhuangTai%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <table>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="LB_ID" runat="server"> </asp:Label>
                                        </td>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                        </td>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_ProjectStatus" runat="server"></asp:TextBox>
                                        </td>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,KongZhiDian%>"></asp:Label></td>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:DropDownList ID="DL_ReviewControl" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DL_ReviewControl_SelectedIndexChanged">
                                                <asp:ListItem Value="NO" Text="<%$ Resources:lang,Fou%>" />
                                                <asp:ListItem Value="YES" Text="<%$ Resources:lang,Shi%>" />
                                            </asp:DropDownList>
                                            <span style="color: red; font-size: 8pt;">(<asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,XuanZeKeGengGai%>"></asp:Label>)
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_ProjectStatusNew" runat="server" CssClass="inpu" OnClick="BT_ProjectStatusNew_Click"
                                    Text="<%$ Resources:lang,BaoCun%>" />
                                &nbsp;
                               
                                <asp:Button ID="BT_ProjectStatusDelete" runat="server" CssClass="inpu" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" OnClick="BT_ProjectStatusDelete_Click"
                                    Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalProjectStatus')">
                                    <asp:Label ID="LabelClose2" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 任务状态模态框 -->
                    <div id="modalTaskStatus" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalTaskStatus" runat="server" Text="<%$ Resources:lang,RenWuZhuangTai%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <asp:Label ID="Label48" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                <asp:TextBox ID="TB_TaskStatus" runat="server" Width="101px"></asp:TextBox>
                                <br />
                                <asp:Label ID="Label53" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                <asp:TextBox ID="TB_TaskSortNumber" runat="server" Width="101px"></asp:TextBox>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_TaskStatusNew" runat="server" CssClass="inpu" OnClick="BT_TaskStatusNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                &nbsp;
                               
                                <asp:Button ID="BT_TaskStatusDelete" runat="server" CssClass="inpu" OnClick="BT_TaskStatusDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalTaskStatus')">
                                    <asp:Label ID="LabelClose3" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 计划状态模态框 -->
                    <div id="modalPlanStatus" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalPlanStatus" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <asp:Label ID="Label307" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                <asp:TextBox ID="TB_PlanStatus" runat="server" Width="101px"></asp:TextBox>
                                <br />
                                <asp:Label ID="Label308" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                <asp:TextBox ID="TB_PlanStatusSort" runat="server" Width="101px"></asp:TextBox>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_PlanStatusNew" runat="server" CssClass="inpu" OnClick="BT_PlanStatusNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                &nbsp;
                               
                                <asp:Button ID="BT_PlanStatusDelete" runat="server" CssClass="inpu" OnClick="BT_PlanStatusDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalPlanStatus')">
                                    <asp:Label ID="LabelClose4" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 测试状态模态框 -->
                    <div id="modalTestStatus" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalTestStatus" runat="server" Text="<%$ Resources:lang,CeShiZhuangTai%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <asp:Label ID="Label323" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                <asp:TextBox ID="TB_TestStatus" runat="server" Width="101px"></asp:TextBox>
                                <br />
                                <asp:Label ID="Label324" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                <asp:TextBox ID="TB_TestStatusSort" runat="server" Width="101px"></asp:TextBox>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_TestStatusNew" runat="server" CssClass="inpu" OnClick="BT_TestStatusNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                &nbsp;
                               
                                <asp:Button ID="BT_TestStatusDelete" runat="server" CssClass="inpu" OnClick="BT_TestStatusDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalTestStatus')">
                                    <asp:Label ID="LabelClose5" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 角色组模态框 -->
                    <div id="modalActorGroup" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalActorGroup" runat="server" Text="<%$ Resources:lang,JueSeZu%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <asp:Label ID="LB_ActorGroupID" runat="server" Text=""></asp:Label>
                                <asp:Label ID="Label47" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                <asp:TextBox ID="TB_ActorGroupName" runat="server" Width="200px"></asp:TextBox>
                                <br />
                                <asp:Label ID="Label49" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                <asp:TextBox ID="TB_ActorGroupSort" runat="server" Width="200px"></asp:TextBox>
                            </div>
                            <div class="modal-footer">

                                <button type="button" class="close-modal" onclick="hideModal('modalActorGroup')">
                                    <asp:Label ID="LabelClose6" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
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
        </form>
    </center>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
