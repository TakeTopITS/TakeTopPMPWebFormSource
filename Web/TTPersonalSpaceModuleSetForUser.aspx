<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TTPersonalSpaceModuleSetForUser.aspx.cs" Inherits="TTPersonalSpaceModuleSetForUser" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>
        <asp:Literal ID="LiteralTitle" runat="server" Text="<%$ Resources:lang,GeRenKongJianLanWeiSheZhi%>"></asp:Literal>
    </title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        //刷新父页面
        function reloadPrentPage() {
            parent.reloadPage();
        }

        // 只能输入数字的函数
        function allowOnlyNumbers(event) {
            var key = event.keyCode || event.which;
            var keyChar = String.fromCharCode(key);

            // 允许功能键: backspace, delete, tab, escape, enter, 箭头键等
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

        // 绑定数字输入限制到所有排序号文本框
        function bindNumberInputEvents() {
            var sortInputs = document.querySelectorAll('.sort-number-input, .module-sort-input');
            sortInputs.forEach(function (input) {
                // 按键事件
                input.addEventListener('keydown', function (e) {
                    return allowOnlyNumbers(e);
                });

                // 粘贴事件
                input.addEventListener('paste', function (e) {
                    return validatePaste(e);
                });

                // 输入事件（处理中文输入法等）
                input.addEventListener('input', function (e) {
                    // 移除非数字字符
                    var originalValue = this.value;
                    var cleanedValue = originalValue.replace(/[^\d]/g, '');

                    // 如果值发生变化，更新文本框
                    if (originalValue !== cleanedValue) {
                        this.value = cleanedValue;
                    }

                    // 处理负号（如果需要支持负数，可以保留此逻辑）
                    // 如果以负号开头，后面必须是数字
                    // if (cleanedValue === '-' && originalValue.startsWith('-')) {
                    //     this.value = '-';
                    // } else if (originalValue.startsWith('-')) {
                    //     this.value = '-' + cleanedValue;
                    // } else {
                    //     this.value = cleanedValue;
                    // }
                });

                // 失去焦点时验证
                input.addEventListener('blur', function () {
                    if (this.value === '' || this.value === '-') {
                        this.value = '0';
                    }
                });
            });
        }

        // 页面加载完成后初始化
        $(document).ready(function () {
            // 延迟执行以确保所有元素都已加载
            setTimeout(function () {
                bindNumberInputEvents();
            }, 500);
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div id="AboveDiv">
                    <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                        <tr>
                            <td height="31" class="page_topbj">
                                <!-- 修改为居中的标题结构 -->
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="center">
                                            <div style="display: inline-block; text-align: center;">
                                                ⚙️<asp:Label ID="Label1" runat="server" CssClass="titlezi"
                                                    Text="<%$ Resources:lang,GeRenKongJianLanWeiSheZhi%>"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td class="ItemAlignLeft" style="padding: 5px 5px 0px 5px;">
                                            <table style="width: 100%;">
                                                <tr>
                                                    <td>
                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                            <tr style="display: none;">
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="LB_UserCode" runat="server" Style="font-weight: 700"></asp:Label>
                                                                    <asp:Label ID="LB_UserName" runat="server" Style="font-weight: 700"></asp:Label>
                                                                    <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,ZiMoZuLieBiao%>"></asp:Label>(<asp:Label ID="LB_ModuleNumber" runat="server"></asp:Label>):
                                                                </td>
                                                            </tr>
                                                            <tr id="trNewsTypeList" runat="server">
                                                                <td>
                                                                    <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False"
                                                                        CellPadding="4" ForeColor="#333333" GridLines="None" ShowHeader="true"
                                                                        Width="100%" CssClass="DataGrid">
                                                                        <HeaderStyle BackColor="#374151" Font-Bold="True" ForeColor="White"
                                                                            HorizontalAlign="Left" VerticalAlign="Middle" Height="40px" />
                                                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                        <EditItemStyle BackColor="#2461BF" />
                                                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                        <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                        <ItemStyle CssClass="itemStyle" />
                                                                        <AlternatingItemStyle BackColor="#f9f9f9" />
                                                                        <Columns>
                                                                            <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false">
                                                                                <ItemStyle CssClass="type-column" HorizontalAlign="left" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Type" HeaderText="<%$ Resources:lang,LeiXing%>">
                                                                                <ItemStyle CssClass="type-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="type-column" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="HomeName" HeaderText="(Home)">
                                                                                <ItemStyle CssClass="home-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="home-column" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="LangCode" HeaderText="<%$ Resources:lang,YuYan%>">
                                                                                <ItemStyle CssClass="lang-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="lang-column" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="PageName" HeaderText="<%$ Resources:lang,YeMian%>">
                                                                                <ItemStyle CssClass="page-column" HorizontalAlign="Left" />
                                                                                <HeaderStyle CssClass="page-column" />
                                                                            </asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="<%$ Resources:lang,FanWei%>">
                                                                                <ItemTemplate>
                                                                                    <asp:DropDownList ID="DL_NewsScope" runat="server" Width="90px">
                                                                                        <asp:ListItem Value="ALL" Text="<%$ Resources:lang,QuanBu%>"></asp:ListItem>
                                                                                        <asp:ListItem Value="INNER" Text="<%$ Resources:lang,NeiBu%>"></asp:ListItem>
                                                                                        <asp:ListItem Value="OUTER" Text="<%$ Resources:lang,WaiBu%>"></asp:ListItem>
                                                                                    </asp:DropDownList>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="scope-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="scope-column" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="<%$ Resources:lang,KeShi%>">
                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="CB_Visible" runat="server" CssClass="bigcheck" />
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="visible-column" HorizontalAlign="Center" />
                                                                                <HeaderStyle CssClass="visible-column" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="<%$ Resources:lang,ShunXu%>">
                                                                                <ItemTemplate>
                                                                                    <asp:TextBox ID="TB_SortNumber" runat="server" Width="60px"
                                                                                        Text='<%# DataBinder.Eval(Container.DataItem,"SortNumber") %>'
                                                                                        CssClass="sort-number-input"
                                                                                        onkeypress="return allowOnlyNumbers(event)"
                                                                                        onpaste="return validatePaste(event)"></asp:TextBox>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="sort-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="sort-column" />
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="width: 100%; margin-top: 30px;">
                                                                    <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False"
                                                                        ShowHeader="true" Height="1px" Width="100%"
                                                                        CellPadding="4" ForeColor="#333333" GridLines="None" CssClass="DataGrid">
                                                                        <HeaderStyle BackColor="#374151" Font-Bold="True" ForeColor="White"
                                                                            HorizontalAlign="Left" VerticalAlign="Middle" Height="40px" />
                                                                        <ItemStyle CssClass="itemStyle" />
                                                                        <AlternatingItemStyle BackColor="#f9f9f9" />
                                                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                        <EditItemStyle BackColor="#2461BF" />
                                                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                        <Columns>
                                                                            <asp:BoundColumn DataField="ModuleName" HeaderText="<%$ Resources:lang,MoKuaiMingCheng%>">
                                                                                <ItemStyle CssClass="module-name-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="module-name-column" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="HomeModuleName" HeaderText="<%$ Resources:lang,MingChengBenYu%>">
                                                                                <ItemStyle CssClass="home-name-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="home-name-column" />
                                                                            </asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="<%$ Resources:lang,ShunXu%>">
                                                                                <ItemTemplate>
                                                                                    <asp:TextBox ID="TB_SortNumber" runat="server" Width="60px" Text="0"
                                                                                        CssClass="module-sort-input"
                                                                                        onkeypress="return allowOnlyNumbers(event)"
                                                                                        onpaste="return validatePaste(event)"></asp:TextBox>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="module-sort-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="module-sort-column" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="<%$ Resources:lang,KeYong%>">
                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="CB_ModuleVisible" runat="server" CssClass="bigcheck" />
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="module-visible-column" HorizontalAlign="Center" />
                                                                                <HeaderStyle CssClass="module-visible-column" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="<%$ Resources:lang,DuZhanYiHuang%>">
                                                                                <ItemTemplate>
                                                                                    <asp:DropDownList ID="DL_EveryRowColumnNumber" runat="server" Width="80px">
                                                                                        <asp:ListItem Value="1" Text="1"></asp:ListItem>
                                                                                        <asp:ListItem Value="2" Selected="True" Text="2"></asp:ListItem>
                                                                                        <asp:ListItem Value="3" Text="3"></asp:ListItem>
                                                                                        <asp:ListItem Value="4" Text="4"></asp:ListItem>
                                                                                    </asp:DropDownList>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="module-columns-column" HorizontalAlign="left" />
                                                                                <HeaderStyle CssClass="module-columns-column" />
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td style="width: 100%; padding-right: 310px;" align="right">
                                                                    <br />

                                                                    <!-- 保存按钮 -->
                                                                    <div class="chart-btn-group">
                                                                        <asp:Button ID="BT_ModuleSave" runat="server" CssClass="inpuLong"
                                                                            Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_ModuleSave_Click" />
                                                                    </div>


                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <asp:Label ID="LB_ErrorMsg" runat="server"></asp:Label>
                                                        <br />
                                                    </td>
                                                </tr>

                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
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
</body>
<script type="text/javascript" language="javascript">
    // 只能输入数字的函数
    function allowOnlyNumbers(event) {
        var key = event.keyCode || event.which;
        var keyChar = String.fromCharCode(key);

        // 允许功能键: backspace, delete, tab, escape, enter, 箭头键等
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

    // 绑定数字输入限制到所有排序号文本框
    function bindNumberInputEvents() {
        var sortInputs = document.querySelectorAll('.sort-number-input, .module-sort-input');
        sortInputs.forEach(function (input) {
            // 按键事件
            input.addEventListener('keydown', function (e) {
                return allowOnlyNumbers(e);
            });

            // 粘贴事件
            input.addEventListener('paste', function (e) {
                return validatePaste(e);
            });

            // 输入事件（处理中文输入法等）
            input.addEventListener('input', function (e) {
                // 移除非数字字符
                var originalValue = this.value;
                var cleanedValue = originalValue.replace(/[^\d]/g, '');

                // 如果值发生变化，更新文本框
                if (originalValue !== cleanedValue) {
                    this.value = cleanedValue;
                }
            });

            // 失去焦点时验证
            input.addEventListener('blur', function () {
                if (this.value === '' || this.value === '-') {
                    this.value = '0';
                }
            });
        });
    }

    // 页面加载完成后初始化
    document.addEventListener('DOMContentLoaded', function () {
        // 延迟执行以确保所有元素都已加载
        setTimeout(function () {
            bindNumberInputEvents();

            // 初始化空值
            var sortInputs = document.querySelectorAll('.sort-number-input, .module-sort-input');
            sortInputs.forEach(function (input) {
                if (input.value === '' || input.value === null) {
                    input.value = '0';
                }
            });
        }, 500);
    });

    // 绑定AJAX完成事件（处理UpdatePanel刷新）
    if (typeof Sys !== 'undefined') {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            // UpdatePanel刷新后重新绑定事件
            setTimeout(function () {
                bindNumberInputEvents();

                // 初始化空值
                var sortInputs = document.querySelectorAll('.sort-number-input, .module-sort-input');
                sortInputs.forEach(function (input) {
                    if (input.value === '' || input.value === null) {
                        input.value = '0';
                    }
                });
            }, 100);
        });
    }
</script>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>

</html>
