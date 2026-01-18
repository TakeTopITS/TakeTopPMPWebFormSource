<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TTSystemAnalystChartRelatedUserSet.aspx.cs" Inherits="TTSystemAnalystChartRelatedUserSet" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>
          <asp:Literal ID="LiteralTitle" runat="server" Text="<%$ Resources:lang,WeDeYeWuFenXiTu%>"></asp:Literal>
    </title>
   <link href="css/TopRightMain.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        function reloadPrentPage() {
            parent.reloadPage();
        }

        function showLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'flex';
                setTimeout(function () {
                    overlay.style.display = 'none';
                }, 30000);
            }
        }

        function hideLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
        }

        // 只能输入数字的函数
        function allowOnlyNumbers(event) {
            var key = event.keyCode || event.which;
            var keyChar = String.fromCharCode(key);

            // 允许功能键: backspace, delete, tab, escape, enter, 箭头键
            var specialKeys = [8, 9, 13, 27, 35, 36, 37, 38, 39, 40, 45, 46];

            // 允许数字键 (0-9) 和功能键
            if ((key >= 48 && key <= 57) || (key >= 96 && key <= 105) ||
                $.inArray(key, specialKeys) !== -1) {
                return true;
            }

            // 允许 Ctrl + A, Ctrl + C, Ctrl + V, Ctrl + X
            if ((event.ctrlKey || event.metaKey) &&
                (keyChar === 'a' || keyChar === 'c' || keyChar === 'v' || keyChar === 'x')) {
                return true;
            }

            event.preventDefault();
            return false;
        }

        // 粘贴时验证内容是否为数字
        function validatePaste(event) {
            var clipboardData = event.clipboardData || window.clipboardData;
            var pastedText = clipboardData.getData('text');

            // 检查粘贴的内容是否只包含数字
            if (!/^\d+$/.test(pastedText)) {
                event.preventDefault();
                return false;
            }
            return true;
        }

        // 绑定文本框的输入限制
        function bindNumberInputEvents() {
            var sortInputs = document.querySelectorAll('.sort-number-input');
            sortInputs.forEach(function (input) {
                // 按键事件
                input.addEventListener('keydown', allowOnlyNumbers);

                // 粘贴事件
                input.addEventListener('paste', validatePaste);

                // 输入事件（处理中文输入法等）
                input.addEventListener('input', function (e) {
                    // 移除非数字字符
                    this.value = this.value.replace(/[^\d]/g, '');

                    // 移除前导零（可选，根据需求决定）
                    // if (this.value.length > 1 && this.value.startsWith('0')) {
                    //     this.value = this.value.replace(/^0+/, '');
                    // }
                });

                // 失去焦点时验证
                input.addEventListener('blur', function () {
                    if (this.value === '') {
                        this.value = '0';
                    }
                });
            });
        }

        // 绑定按钮点击事件
        document.addEventListener('DOMContentLoaded', function () {
            var btnSave = document.getElementById('<%= BT_Save.ClientID %>');
            if (btnSave) {
                btnSave.addEventListener('click', function () {
                    showLoading();
                });
            }

            // 绑定数字输入限制
            bindNumberInputEvents();
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                    <tr>
                        <td height="31" class="page_topbj">
                            <!-- 修改为居中的标题结构 -->
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="center">
                                        <div style="display: inline-block; text-align: center;">
                                            📊 
                                            <asp:Label ID="Label4" runat="server" CssClass="titlezi"
                                                Text="<%$ Resources:lang,WeDeYeWuFenXiTu%>"></asp:Label>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>


                <div class="chart-setup-container">
                    <div class="content-section">
                        <!-- 左栏：图表列表 -->
                        <div class="chart-list-container">
                            <div class="chart-list-header">
                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,FenXiTu%>"></asp:Label>
                            </div>
                            <div class="chart-list-content">
                                <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False"
                                    OnItemCommand="DataGrid1_ItemCommand" ShowHeader="false" Width="100%">
                                    <Columns>
                                        <asp:TemplateColumn>
                                            <ItemTemplate>
                                                <asp:Button ID="BT_ChartName" runat="server"
                                                    CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ChartName") %>'
                                                    CssClass="chart-button"
                                                    Text='<%# DataBinder.Eval(Container.DataItem,"ChartName") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <ItemStyle CssClass="itemStyle" HorizontalAlign="Left" />
                                </asp:DataGrid>
                            </div>
                        </div>

                        <!-- 右栏：已选图表表格 -->

                        <div class="unified-table-container">
                            <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False"
                                OnItemCommand="DataGrid4_ItemCommand" ShowHeader="true" CssClass="unified-table">
                                <HeaderStyle BackColor="#374151" Font-Bold="True" ForeColor="White"
                                    HorizontalAlign="Left" VerticalAlign="Middle" Height="40px" />
                                <Columns>
                                    <asp:BoundColumn DataField="ID" HeaderText="ID">
                                        <ItemStyle CssClass="chart-id-column" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="chart-id-column" HorizontalAlign="Left" />
                                    </asp:BoundColumn>
                                    <asp:TemplateColumn HeaderText="<%$ Resources:lang,MingChengZhongWen%>">
                                        <ItemTemplate>
                                            <asp:Label ID="LB_ModuleName" runat="server"
                                                Text='<%# DataBinder.Eval(Container.DataItem,"ChartName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="chart-name-column" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="chart-name-column" HorizontalAlign="Left" />
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderText="<%$ Resources:lang,ShongXuHao%>">
                                        <ItemTemplate>
                                            <asp:TextBox ID="TB_SortNumber" runat="server"
                                                CssClass="form-control sort-number-input"
                                                Text='<%# DataBinder.Eval(Container.DataItem,"SortNumber") %>'
                                                onkeypress="return allowOnlyNumbers(event)"
                                                onpaste="return validatePaste(event)"></asp:TextBox>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="chart-sort-column" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="chart-sort-column" HorizontalAlign="Left" />
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderText="">
                                        <ItemTemplate>
                                            <asp:Button ID="BT_DeleteChart" runat="server"
                                                CommandName="DELETE"
                                                CssClass="btn-danger"
                                                Text="<%$ Resources:lang,ShanChu%>" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="chart-action-column" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="chart-action-column" HorizontalAlign="Left" />
                                    </asp:TemplateColumn>
                                </Columns>
                                <ItemStyle CssClass="itemStyle" HorizontalAlign="Left" />
                            </asp:DataGrid>

                            <!-- 保存按钮 -->
                            <div class="chart-btn-group">
                                <asp:Button ID="BT_Save" runat="server" CssClass="btn btn-success"
                                    Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_Save_Click"
                                    OnClientClick="showLoading(); return true;" />
                            </div>
                            
                        </div>


                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- 原有进度条容器 -->
        <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
            <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                    <img src="Images/Processing.gif" alt="Loading,please wait..." />
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </form>
</body>
<script type="text/javascript" language="javascript">
    // 只能输入数字的函数
    function allowOnlyNumbers(event) {
        var key = event.keyCode || event.which;
        var keyChar = String.fromCharCode(key);

        // 允许功能键: backspace, delete, tab, escape, enter, 箭头键
        var specialKeys = [8, 9, 13, 27, 35, 36, 37, 38, 39, 40, 45, 46];

        // 允许数字键 (0-9) 和功能键
        if ((key >= 48 && key <= 57) || (key >= 96 && key <= 105) ||
            specialKeys.indexOf(key) !== -1) {
            return true;
        }

        // 允许 Ctrl + A, Ctrl + C, Ctrl + V, Ctrl + X
        if ((event.ctrlKey || event.metaKey) &&
            (keyChar === 'a' || keyChar === 'c' || keyChar === 'v' || keyChar === 'x')) {
            return true;
        }

        event.preventDefault();
        return false;
    }

    // 粘贴时验证内容是否为数字
    function validatePaste(event) {
        var clipboardData = event.clipboardData || window.clipboardData;
        var pastedText = clipboardData.getData('text');

        // 检查粘贴的内容是否只包含数字
        if (!/^\d+$/.test(pastedText)) {
            event.preventDefault();
            return false;
        }
        return true;
    }

    // 隐藏加载动画（AJAX完成时调用）
    function hideLoading() {
        var overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.style.display = 'none';
        }
    }

    // 绑定数字输入限制
    function bindNumberInputEvents() {
        var sortInputs = document.querySelectorAll('.sort-number-input');
        sortInputs.forEach(function (input) {
            // 按键事件
            input.addEventListener('keydown', allowOnlyNumbers);

            // 粘贴事件
            input.addEventListener('paste', validatePaste);

            // 输入事件（处理中文输入法等）
            input.addEventListener('input', function (e) {
                // 移除非数字字符
                this.value = this.value.replace(/[^\d]/g, '');
            });

            // 失去焦点时验证
            input.addEventListener('blur', function () {
                if (this.value === '') {
                    this.value = '0';
                }
            });
        });
    }

    // 绑定AJAX完成事件
    if (typeof Sys !== 'undefined') {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            hideLoading();

            // 确保文本框内容正确显示
            var sortInputs = document.querySelectorAll('.sort-number-input');
            sortInputs.forEach(function (input) {
                if (input.value === '' || input.value === null) {
                    input.value = '0';
                }
            });

            // 重新绑定数字输入事件（因为UpdatePanel可能重新渲染了控件）
            bindNumberInputEvents();

            // 确保所有文本左对齐
            var allCells = document.querySelectorAll('.unified-table td, .unified-table th');
            allCells.forEach(function (cell) {
                cell.style.textAlign = 'left';
            });
        });
    }

    // 页面加载完成后检查和修正对齐
    document.addEventListener('DOMContentLoaded', function () {
        setTimeout(function () {
            // 绑定数字输入限制
            bindNumberInputEvents();

            // 检查排序号文本框
            var sortInputs = document.querySelectorAll('.sort-number-input');
            sortInputs.forEach(function (input) {
                if (input.value === '' || input.value === null) {
                    input.value = '0';
                }
            });

            // 强制所有列左对齐
            var allCells = document.querySelectorAll('.unified-table td, .unified-table th');
            allCells.forEach(function (cell) {
                cell.style.textAlign = 'left';
            });

            // 确保表头也左对齐
            var headerCells = document.querySelectorAll('.unified-table th');
            headerCells.forEach(function (cell) {
                cell.style.textAlign = 'left';
            });
        }, 500);
    });
</script>
</html>