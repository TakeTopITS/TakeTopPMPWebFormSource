<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTWarehouseSet.aspx.cs" Inherits="TTWarehouseSet" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1. Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <style type="text/css">
        select {
            height: 30px;
        }


        .action-icons {
            display: flex;
            gap: 5px;
            margin: 5px 0;
        }

        .action-icon {
            cursor: pointer;
            font-size: 14px;
            padding: 4px 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            background: #f5f5f5;
            transition: all 0.3s ease;
        }

            .action-icon:hover {
                background: #e0e0e0;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }

        .action-add {
            color: green;
            border-color: green;
        }

        .action-edit {
            color: blue;
            border-color: blue;
        }

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
            /* 居中样式 */
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
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
    </style>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        function showModal(modalId) {
            var modal = $('#' + modalId);
            modal.show();

            // 居中显示模态框
            var modalElement = modal.find('.modal-content')[0];
            $(modalElement).css({
                'top': '50%',
                'left': '50%',
                'transform': 'translate(-50%, -50%)'
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
            showModal(modalId);
            return false; // 阻止默认行为
        }

        // 全局函数，供后端调用
        function openModal(modalId) {
            showModal(modalId);
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
                                <td colspan="2" height="31" class="page_topbj">
                                    <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table width="345" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,ChuangKuSheZi%>"></asp:Label>
                                                            <asp:Label ID="LB_DepartString" runat="server" Visible="false"></asp:Label>
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td width="250px">
                                    <asp:TreeView ID="TreeView3" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView3_SelectedNodeChanged"
                                        ShowLines="True" Width="220px">
                                        <RootNodeStyle CssClass="rootNode" />
                                        <NodeStyle CssClass="treeNode" />
                                        <LeafNodeStyle CssClass="leafNode" />
                                        <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                    </asp:TreeView>
                                </td>
                                <td>
                                    <table style="width: 100%; text-align: left">
                                        <tr>

                                            <td class="ItemAlignRight" style="padding-left: 20px;">
                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,CangKu%>"></asp:Label>
                                                <span class="grid-add-icon" onclick="return handleAddClick('modalWarehouse', event)">+</span>

                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td>
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="15%"><strong>
                                                                        <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="15%"><strong>
                                                                        <asp:Label ID="Label32228" runat="server" Text="<%$ Resources:lang,ZiJinSuanFa%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label381" runat="server" Text="<%$ Resources:lang,FuChuangKu%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,GuiShuBuMenDaiMa%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label382" runat="server" Text="<%$ Resources:lang,GuiShuBuMenMingCheng%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft"><strong>
                                                                        <asp:Label ID="Label383" runat="server" Text="<%$ Resources:lang,ShunXu%>"></asp:Label>
                                                                    </strong></td>

                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid21" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid21_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="WHName" HeaderText="仓库">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="CapitalMethod" HeaderText="资金算法">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ParentWH" HeaderText="父仓库">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="BelongDepartCode" HeaderText="DepartmentCode">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="BelongDepartName" HeaderText="DepartmentName">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                        </asp:BoundColumn>

                                                    </Columns>
                                                    <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft">

                                                <table style="width: 100%; text-align: left">
                                                    <tr>
                                                        <td><b>
                                                            <asp:Label ID="Label234232" runat="server" Text="<%$ Resources:lang,ChengFangChuangWei%>"></asp:Label>
                                                        </b></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                    </td>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td class="ItemAlignLeft" width="30%"><strong>
                                                                                    <asp:Label ID="Label234233" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="20%"><strong>
                                                                                    <asp:Label ID="Label234234" runat="server" Text="<%$ Resources:lang,GuiShuCangKu%>"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft"><strong>
                                                                                    <asp:Label ID="Label234237" runat="server" Text="Remark"></asp:Label>
                                                                                </strong></td>
                                                                                <td class="ItemAlignLeft" width="20%"><strong>
                                                                                    <span class="grid-add-icon" onclick="return handleAddClick('modalWarehousePosition', event)">+</span>
                                                                                </strong></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="right" width="6">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <asp:DataGrid ID="DataGrid22" runat="server" AutoGenerateColumns="False" OnItemCommand="DataGrid22_ItemCommand" CellPadding="4" ForeColor="#333333" GridLines="None" PageSize="2" ShowHeader="false" Width="98%">
                                                                <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="仓位">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_WHPositionName" runat="server" CssClass="inpuLongest" Text='<%# DataBinder.Eval(Container.DataItem,"PositionName") %>' CommandName="Edit" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="WHName" HeaderText="归属仓库">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="Comment" HeaderText="DepartmentName">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemStyle Width="20%" HorizontalAlign="Center" />
                                                                    </asp:TemplateColumn>
                                                                </Columns>
                                                                <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                            </asp:DataGrid>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- 仓库设置模态框 -->
                    <div id="modalWarehouse" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalWarehouse" runat="server" Text="<%$ Resources:lang,CangKu%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label234231" runat="server" Text="<%$ Resources:lang,FuChuangKu%>"></asp:Label>
                                    <asp:TextBox ID="TB_ParentWH" runat="server" Width="200px"></asp:TextBox>
                                    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground" CancelControlID="IMBT_CloseParentWH" Enabled="True" PopupControlID="Panel2" TargetControlID="TB_ParentWH" Y="15">
                                    </cc1:ModalPopupExtender>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label384" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                    <asp:TextBox ID="TB_WHName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label383335" runat="server" Text="<%$ Resources:lang,KuCunZiJinSuanFa%>"></asp:Label>
                                    <asp:DropDownList ID="DL_CapitalMethod" runat="server" Width="200px">
                                        <asp:ListItem Value="FIFO" Text="<%$ Resources:lang,XianJingXianChu%>" />
                                        <asp:ListItem Value="MWAM" Text="<%$ Resources:lang,JiaQuanPingJIng%>" />
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label385" runat="server" Text="<%$ Resources:lang,ShunXu%>"></asp:Label>
                                    <asp:TextBox ID="TB_WHSortNumber" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label386" runat="server" Text="<%$ Resources:lang,GuiShuBuMen%>"></asp:Label>
                                    <asp:TextBox ID="TB_DepartCode" runat="server" Width="200px"></asp:TextBox>
                                    <cc1:ModalPopupExtender ID="TB_DepartCode_ModalPopupExtender" runat="server" BackgroundCssClass="modalBackground" CancelControlID="IMBT_Close" Enabled="True" PopupControlID="Panel1" TargetControlID="TB_DepartCode" Y="15">
                                    </cc1:ModalPopupExtender>
                                    <asp:Label ID="LB_DepartName" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="modal-footer" style="text-align: center;">

                                <asp:Button ID="BT_UpdateWH" runat="server" CssClass="inpu" OnClick="BT_UpdateWH_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteWH" runat="server" CssClass="inpu" OnClick="BT_DeleteWH_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                &nbsp;&nbsp; &nbsp;&nbsp;
                                <asp:Button ID="BT_AddWH" runat="server" CssClass="inpu" OnClick="BT_AddWH_Click" Text="<%$ Resources:lang,ZengJiaZiJieDian%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalWarehouse')">
                                    <asp:Label ID="LabelWarehouseClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 仓位设置模态框 -->
                    <div id="modalWarehousePosition" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalWarehousePosition" runat="server" Text="<%$ Resources:lang,ChengFangChuangWei%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label234239" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                    <asp:TextBox ID="TB_WHPositionName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label234240" runat="server" Text="<%$ Resources:lang,BeiZhu%>"></asp:Label>
                                    <asp:TextBox ID="TB_Comment" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label234238" runat="server" Text="<%$ Resources:lang,GuiShuCangKu%>"></asp:Label>
                                    <asp:Label ID="LB_BelongWHName" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="modal-footer" style="text-align: center;">
                                <asp:Button ID="BT_AddWHPosition" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_AddWHPosition_Click" />
                                <asp:Button ID="BT_DeleteWHPosition" runat="server" CssClass="inpu" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_DeleteWHPosition_Click" />
                                <button type="button" class="close-modal" onclick="hideModal('modalWarehousePosition')">
                                    <asp:Label ID="LabelWarehousePositionClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" Style="display: none;">
                        <div class="modalPopup-text" style="width: 273px; height: 400px; overflow: auto;">
                            <table>
                                <tr>
                                    <td style="width: 220px; padding: 5px 5px 5px 5px;" valign="top" class="ItemAlignLeft">
                                        <asp:TreeView ID="TreeView1" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged"
                                            ShowLines="True" Width="220px">
                                            <RootNodeStyle CssClass="rootNode" />
                                            <NodeStyle CssClass="treeNode" />
                                            <LeafNodeStyle CssClass="leafNode" />
                                            <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                        </asp:TreeView>
                                    </td>
                                    <td style="width: 6px; padding: 5px 5px 5px 5px;" valign="top" class="ItemAlignLeft">
                                        <asp:ImageButton ID="IMBT_Close" ImageUrl="ImagesSkin/Close4.jpg" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="Panel2" runat="server" CssClass="modalPopup" Style="display: none;">
                        <div class="modalPopup-text" style="width: 273px; height: 400px; overflow: auto;">
                            <table>
                                <tr>
                                    <td style="width: 220px; padding: 5px 5px 5px 5px;" valign="top" class="ItemAlignLeft">
                                        <asp:TreeView ID="TreeView2" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView2_SelectedNodeChanged"
                                            ShowLines="True" Width="220px">
                                            <RootNodeStyle CssClass="rootNode" />
                                            <NodeStyle CssClass="treeNode" />
                                            <LeafNodeStyle CssClass="leafNode" />
                                            <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                        </asp:TreeView>
                                    </td>
                                    <td style="width: 6px; padding: 5px 5px 5px 5px;" valign="top" class="ItemAlignLeft">
                                        <asp:ImageButton ID="IMBT_CloseParentWH" ImageUrl="ImagesSkin/Close4.jpg" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: absolute; left: 5%; top: 5%;">
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
