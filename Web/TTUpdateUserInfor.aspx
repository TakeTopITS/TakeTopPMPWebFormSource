<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTUpdateUserInfor.aspx.cs" Inherits="TTUpdateUserInfor" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>
        <asp:Literal ID="LiteralTitle" runat="server" Text="<%$ Resources:lang,WoDeDangAnSheZhi%>"></asp:Literal>
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

            if (password && password.value && password.value.length < 8) {
                showAlertAtMouse('密码必须至少8位字符');
                return false;
            }

            if (password && confirmPassword && password.value !== confirmPassword.value) {
                showAlertAtMouse('两次输入的密码不一致');
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

        <%--   <!-- 加载遮罩层 -->
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
                                    <table style="width: 100%; max-width: 800px;" cellpadding="3" cellspacing="0" class="formBgStyle">
                                        <!-- 基本信息行 -->
                                        <tr>
                                            <td style="width: 130px;" class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,DaiMa%>"></asp:Label>
                                            </td>
                                            <td style="width: 250px;" class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="TB_UserCode" runat="server" Enabled="False"></asp:Label>
                                            </td>
                                            <td style="width: 154px" class="formItemBgStyleForAlignLeft" rowspan="4">
                                                <div class="photo-container">
                                                    <asp:Image ID="IM_MemberPhoto" runat="server" Height="140px" Width="154px" AlternateText="UserPhoto"
                                                        ImageAlign="Left" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,YongHu%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="TB_UserName" runat="server" Enabled="False" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,XingBie%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="LB_Gender" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,NianLin%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000" ID="TB_Age" runat="server" Precision="0" Width="93%">0</NickLee:NumberBox>
                                            </td>
                                        </tr>

                                        <!-- 密码修改部分 -->
                                        <tr class="password-section">
                                            <td class="formItemBgStyleForAlignLeft" colspan="3" style="background: #f0f9ff; border-left: 4px solid #4F46E5;">
                                                <strong>🔐 Password Set</strong>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,YuanMiMa%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <div style="display: flex; gap: 10px; align-items: center;">
                                                    <asp:TextBox ID="TB_OldPassword" runat="server" Width="100%" TextMode="Password"></asp:TextBox>
                                                    <button type="button" class="inline-btn btn-secondary" onclick="togglePasswordVisibility('<%= TB_OldPassword.ClientID %>')">👁️</button>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,XinMiMa%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <div style="display: flex; gap: 10px; align-items: center;">
                                                    <asp:TextBox ID="TB_Password" runat="server" Width="100%" TextMode="Password"></asp:TextBox>
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
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <div style="display: flex; gap: 10px; align-items: center;">
                                                    <asp:TextBox ID="TB_ConfirmPassword" runat="server" Width="100%" TextMode="Password"></asp:TextBox>
                                                    <button type="button" class="inline-btn btn-secondary" onclick="togglePasswordVisibility('<%= TB_ConfirmPassword.ClientID %>')">👁️</button>
                                                </div>
                                                <div class="password-requirements">
                                                    <span style="font-size: 8pt; color: red">
                                                        <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,ZhiShaoBaWeiZhiFu%>"></asp:Label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- 联系信息部分 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ZhiWu%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:Label ID="TB_Duty" runat="server" ReadOnly="True" />
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,ZhiChen%>"></asp:Label></td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:Label ID="TB_JobTitle" runat="server" />
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,BuMen%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:Label ID="LB_Department" runat="server"></asp:Label>
                                            </td>

                                        </tr>
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,ZhiBuMen%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:Label ID="TB_ChildDepartment" runat="server" Enabled="false" Width="220px" />
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,BanGongDianHua%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:TextBox ID="TB_OfficePhone" runat="server" Width="50%"></asp:TextBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,ShouJi%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:TextBox ID="TB_MobilePhone" runat="server" Width="50%"></asp:TextBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">E_Mail</td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:TextBox ID="TB_EMail" runat="server" Width="50%"></asp:TextBox>
                                            </td>

                                        </tr>

                                        <!-- 系统信息部分 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,JiaRuRiQi%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2">
                                                <asp:Label ID="TB_JoinDate" runat="server" ReadOnly="True" Enabled="False" />
                                            </td>

                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,XingZhi%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:Label ID="LB_UserType" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                            </td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="LB_Status" runat="server" />
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,ZhuJieMianFengGe%>"></asp:Label></td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_CssDirectory" runat="server" Enabled="false">
                                                    <asp:ListItem Value="CssBlue" Text="<%$ Resources:lang,LanSe%>" />
                                                    <asp:ListItem Value="CssGreen" Text="<%$ Resources:lang,LuSe%>" />
                                                    <asp:ListItem Value="CssRed" Text="<%$ Resources:lang,HongSe%>" />
                                                    <asp:ListItem Value="CssGolden" Text="<%$ Resources:lang,JinSe%>" />
                                                    <asp:ListItem Value="CssGray" Text="<%$ Resources:lang,HuiSe%>" />
                                                    <asp:ListItem Value="CssBlack" Text="<%$ Resources:lang,HeiSe%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <!-- 系统设置部分 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,JieMianYuYan%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="ddlLangSwitcher" runat="server" DataValueField="LangCode" DataTextField="Language"></asp:DropDownList></td>
                                        </tr>

                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,YongXuDengLuSeBei%>"></asp:Label></td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_AllowDevice" runat="server" Enabled="false">
                                                    <asp:ListItem Value="ALL" Text="<%$ Resources:lang,QuanBu%>" />
                                                    <asp:ListItem Value="PC" Text="<%$ Resources:lang,DianNao%>" />
                                                    <asp:ListItem Value="MOBILE" Text="<%$ Resources:lang,YiDongSheBei%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <!-- 操作按钮 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft"></td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <asp:Button ID="BT_Update" CssClass="inpu" runat="server" Text="<%$ Resources:lang,BaoCun%>"
                                                    OnClick="BT_Update_Click" OnClientClick="showLoading(); if(!validatePassword()) { hideLoading(); return false; }" />
                                                <br />
                                                <br />
                                            </td>
                                        </tr>

                                        <!-- 扩展功能部分 -->
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,ZhanKaiZouBianLian%>"></asp:Label></td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_LeftBarExtend" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DL_LeftBarExtend_SelectedIndexChanged">
                                                    <asp:ListItem Value="NO" Text="<%$ Resources:lang,Fou%>" />
                                                    <asp:ListItem Value="YES" Text="<%$ Resources:lang,Shi%>" />
                                                    <asp:ListItem Value="NO" Text="<%$ Resources:lang,Fou%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="padding-top: 20px;">
                                                <asp:Label ID="LB_SetAgent" runat="server" Text="<%$ Resources:lang,SetAgent%>" />&nbsp;</td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft" style="padding-top: 20px;">
                                                <asp:DropDownList ID="DL_MemberAgency" runat="server" DataTextField="UserName"
                                                    DataValueField="UserCode" AutoPostBack="True" OnSelectedIndexChanged="DL_MemberAgency_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft" style="padding-bottom: 20px;"></td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <div class="quick-links">
                                                    <asp:HyperLink ID="HL_MemberOtherSet" NavigateUrl="~/TTMyMemberLevelSet.aspx" Text="<%$ Resources:lang,OtherSet%>" runat="server" CssClass="quick-link"></asp:HyperLink>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- 隐藏的行（保持原有） -->
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,ZhuJieMianFengGe%>"></asp:Label></td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:DropDownList ID="DL_SystemMDIStyle" runat="server" DataTextField="MDIStyle" DataValueField="MDIStyle">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,YongGongleixing%>"></asp:Label></td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <asp:DropDownList ID="DL_WorkType" runat="server" DataTextField="TypeName" DataValueField="TypeName" Enabled="false">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,CanKaoGongHao%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:Label ID="TB_RefUserCode" runat="server" />
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,RTXHao%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:Label ID="TB_UserRTXCode" runat="server" Width="220px" Enabled="False" />
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft" style="height: 12px;">
                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,SongXuHao%>"></asp:Label>
                                            </td>
                                            <td class="formItemBgStyleForAlignLeft" colspan="2" style="height: 12px;">
                                                <asp:Label ID="NB_SortNumber" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,GongZuoFanWei%>"></asp:Label>
                                            </td>
                                            <td colspan="2" class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="TB_WorkScope" runat="server" />
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
