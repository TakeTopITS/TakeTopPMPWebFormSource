<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TTUpdateUserInforSAAS.aspx.cs" Inherits="TTUpdateUserInforSAAS" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>
        <asp:Literal ID="LiteralTitle" runat="server" Text="<%$ Resources:lang,GengGaiMiMa%>"></asp:Literal>
    </title>
    <link href="css/common-styles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        function changeLeftBarExtend(isExtend) {
            if (isExtend === "YES") {
                window.parent.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
            } else {
                window.parent.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
            }
            top.frames[0].frames[2].parent.frames["leftMiddleFrame"].setExtendValue(isExtend);
        }

        // 密码验证
        function validatePassword() {
            var password = document.getElementById('<%= TB_Password.ClientID %>');
            var confirmPassword = document.getElementById('<%= TB_ConfirmPassword.ClientID %>');
            var oldPassword = document.getElementById('<%= TB_OldPassword.ClientID %>');

            // 检查原密码是否填写
            if (oldPassword && (!oldPassword.value || oldPassword.value.trim() === '')) {
                showAlertAtMouse('请输入原密码');
                return false;
            }

            // 如果新密码有填写，则进行验证
            if (password && password.value && password.value.length < 8) {
                showAlertAtMouse('新密码必须至少8位字符');
                return false;
            }

            // 如果新密码和确认密码都有填写，则验证一致性
            if (password && confirmPassword && password.value && confirmPassword.value && password.value !== confirmPassword.value) {
                showAlertAtMouse('两次输入的新密码不一致');
                return false;
            }

            return true;
        }

        // 显示/隐藏密码
        function togglePasswordVisibility(inputId) {
            var input = document.getElementById(inputId);
            if (input) {
                if (input.type === 'password') {
                    input.type = 'text';
                } else {
                    input.type = 'password';
                }
            }
        }

        // 显示加载动画
        function showLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'flex';
            }
        }

        // 隐藏加载动画
        function hideLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>

        <%--  <!-- 加载遮罩层 -->
        <div class="loading-overlay" id="loadingOverlay">
            <div class="loading-content">
                <div class="spinner"></div>
                <div style="font-weight: 600; color: #374151; margin-bottom: 5px;">
                    正在保存...
                </div>
                <div style="color: #6B7280; font-size: 14px;">
                    请稍候...
                </div>
            </div>
        </div>--%>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="user-profile-container">


                    <div class="bian">
                        <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                            <tr>
                                <td height="31" class="page_topbj">
                                    <!-- 修改为居中的标题结构 -->
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="center">
                                                <div style="display: inline-block; text-align: center;">
                                                    ⚙️ 
                                                     <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,WoDeDangAnSheZhi%>"></asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 20px;" align="center">
                                    <table style="width: 100%; max-width: 600px;" cellpadding="3" cellspacing="0" class="formBgStyle">
                                        <!-- 用户信息部分 -->
                                        <tr>
                                            <td style="width: 130px;" class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,DaiMa%>"></asp:Label>
                                            </td>
                                            <td style="width: 400px;" class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_UserCode" runat="server" Enabled="False" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,YongHu%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_UserName" runat="server" Enabled="False" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>

                                        <!-- 密码修改部分 -->
                                        <tr class="password-section">
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="background: #f0f9ff; border-left: 4px solid #4F46E5;">
                                                <strong>🔐 Password Set</strong>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,YuanMiMa%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <div style="display: flex; gap: 10px; align-items: center;">
                                                    <asp:TextBox ID="TB_OldPassword" runat="server" CssClass="form-input" Width="100%" TextMode="Password"></asp:TextBox>
                                                    <button type="button" class="inline-btn btn-secondary" onclick="togglePasswordVisibility('<%= TB_OldPassword.ClientID %>')">👁️</button>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,XinMiMa%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <div style="display: flex; gap: 10px; align-items: center;">
                                                    <asp:TextBox ID="TB_Password" runat="server" CssClass="form-input" Width="100%" TextMode="Password"></asp:TextBox>
                                                    <button type="button" class="inline-btn btn-secondary" onclick="togglePasswordVisibility('<%= TB_Password.ClientID %>')">👁️</button>
                                                </div>
                                                <div class="password-requirements">
                                                    <span style="font-size: 8pt; color: red">
                                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZhiShaoBaWeiZhiFu%>"></asp:Label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,QueRenMiMa%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <div style="display: flex; gap: 10px; align-items: center;">
                                                    <asp:TextBox ID="TB_ConfirmPassword" runat="server" CssClass="form-input" Width="100%" TextMode="Password"></asp:TextBox>
                                                    <button type="button" class="inline-btn btn-secondary" onclick="togglePasswordVisibility('<%= TB_ConfirmPassword.ClientID %>')">👁️</button>
                                                </div>
                                                <div class="password-requirements">
                                                    <span style="font-size: 8pt; color: red">
                                                        <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,ZhiShaoBaWeiZhiFu%>"></asp:Label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- 界面设置部分 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,JieMianYuYan%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:DropDownList ID="ddlLangSwitcher" runat="server"
                                                    CssClass="form-input select" Width="100%"
                                                    DataValueField="LangCode" DataTextField="Language" AutoPostBack="true">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <!-- 侧边栏设置 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,ZhanKaiZouBianLian%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_LeftBarExtend" runat="server"
                                                    CssClass="form-input select" Width="100%"
                                                    AutoPostBack="True" OnSelectedIndexChanged="DL_LeftBarExtend_SelectedIndexChanged">
                                                    <asp:ListItem Value="NO" Text="<%$ Resources:lang,Fou%>" />
                                                    <asp:ListItem Value="YES" Text="<%$ Resources:lang,Shi%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <!-- 主题样式（默认隐藏） -->
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,ZhuJieMianFengGe%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_CssDirectory" runat="server" CssClass="form-input select" Width="100%">
                                                    <asp:ListItem Value="CssBlue" Text="<%$ Resources:lang,LanSe%>" />
                                                    <asp:ListItem Value="CssGreen" Text="<%$ Resources:lang,LuSe%>" />
                                                    <asp:ListItem Value="CssRed" Text="<%$ Resources:lang,HongSe%>" />
                                                    <asp:ListItem Value="CssGolden" Text="<%$ Resources:lang,JinSe%>" />
                                                    <asp:ListItem Value="CssGray" Text="<%$ Resources:lang,HuiSe%>" />
                                                    <asp:ListItem Value="CssBlack" Text="<%$ Resources:lang,HeiSe%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <!-- 操作按钮 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft"></td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <div style="text-align: center; margin-top: 20px;">
                                                    <asp:Button ID="BT_Update" CssClass="inpu" runat="server" Text="<%$ Resources:lang,BaoCun%>"
                                                        OnClick="BT_Update_Click"
                                                        OnClientClick="showLoading(); if(!validatePassword()) { hideLoading(); return false; }" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <!-- 隐藏的其他信息（保持原有结构） -->
                                    <table style="display: none; width: 100%; max-width: 600px;" cellpadding="3" cellspacing="0" class="formBgStyle">
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,XingBie%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:DropDownList ID="DL_Gender" runat="server" Enabled="False" CssClass="form-input select" Width="100%">
                                                    <asp:ListItem Value="Male" Text="<%$ Resources:lang,Nan%>" />
                                                    <asp:ListItem Value="Female" Text="<%$ Resources:lang,Nv%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,NianLin%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000"
                                                    ID="TB_Age" runat="server" Precision="0" Width="100%" CssClass="form-input">0</NickLee:NumberBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ZhiWu%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_Duty" runat="server" ReadOnly="True" Enabled="False" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" rowspan="5">
                                                <asp:Image ID="IM_MemberPhoto" runat="server" AlternateText="<%$ Resources:lang,YuanGongZhaoPian%>"
                                                    Height="140px" ImageAlign="Left" Width="154px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,ZhiChen%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_JobTitle" runat="server" Enabled="False" ReadOnly="True" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,BuMen%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:DropDownList ID="DL_Department" runat="server" DataTextField="DepartName"
                                                    DataValueField="DepartCode" Enabled="False" CssClass="form-input select" Width="100%">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,ZhiBuMen%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_ChildDepartment" runat="server" Enabled="false" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,BanGongDianHua%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_OfficePhone" runat="server" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,ShouJi%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_MobilePhone" runat="server" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">E_Mail:</td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_EMail" runat="server" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,GongZuoFanWei%>"></asp:Label>
                                            </td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_WorkScope" runat="server" Height="73px" ReadOnly="True"
                                                    TextMode="MultiLine" Enabled="False" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,JiaRuRiQi%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:TextBox ID="TB_JoinDate" runat="server" ReadOnly="True" Enabled="False" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,XingZhi%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_UserType" Enabled="false" runat="server" CssClass="form-input select" Width="100%">
                                                    <asp:ListItem Value="INNER" Text="<%$ Resources:lang,NeiBu%>" />
                                                    <asp:ListItem Value="OUTER" Text="<%$ Resources:lang,WaiBu%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                            </td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <asp:DropDownList ID="DL_Status" runat="server" Enabled="false" CssClass="form-input select" Width="100%">
                                                    <asp:ListItem Value="Employed" Text="<%$ Resources:lang,ZaiZhi%>" />
                                                    <asp:ListItem Value="Resign" Text="<%$ Resources:lang,LiZhi%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,YongGongleixing%>"></asp:Label>
                                            </td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <asp:DropDownList ID="DL_WorkType" runat="server" DataTextField="TypeName"
                                                    DataValueField="TypeName" Enabled="false" CssClass="form-input select" Width="100%">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,CanKaoGongHao%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:TextBox ID="TB_RefUserCode" runat="server" Enabled="False" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,RTXHao%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:TextBox ID="TB_UserRTXCode" runat="server" Enabled="False" CssClass="form-input" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,SongXuHao%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000"
                                                    ID="NB_SortNumber" runat="server" Precision="0" Width="100%" CssClass="form-input" Enabled="False">0</NickLee:NumberBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,ZhuJieMianFengGe%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_SystemMDIStyle" runat="server" DataTextField="MDIStyle"
                                                    DataValueField="MDIStyle" CssClass="form-input select" Width="100%">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,YongXuDengLuSeBei%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_AllowDevice" runat="server" Enabled="false" CssClass="form-input select" Width="100%">
                                                    <asp:ListItem Value="ALL" Text="<%$ Resources:lang,QuanBu%>" />
                                                    <asp:ListItem Value="PC" Text="<%$ Resources:lang,DianNao%>" />
                                                    <asp:ListItem Value="MOBILE" Text="<%$ Resources:lang,YiDongSheBei%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
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
    // 隐藏加载动画（AJAX完成时调用）
    function hideLoading() {
        var overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.style.display = 'none';
        }
    }

    // 绑定AJAX完成事件
    if (typeof Sys !== 'undefined') {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            hideLoading();
        });
    }
</script>
</html>
