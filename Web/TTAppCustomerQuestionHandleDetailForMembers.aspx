<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppCustomerQuestionHandleDetailForMembers.aspx.cs" Inherits="TTAppCustomerQuestionHandleDetailForMembers" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
     <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />


    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();// 初始化滑动返回功能
        });
    </script>
</head>
<body class="napbac" data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>

    <div class="mobile-container">
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <!-- 头部 -->
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

                    <div class="mobile-content">
                        <!-- 需求基本信息 -->
                        <div class="mobile-section">
                            <div class="data-row">
                                <div class="data-label">
                                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XuQiuMingCheng%>"></asp:Label>:</div>
                                <div class="data-value">
                                    <asp:Label ID="LB_ServiceID" runat="server"></asp:Label>
                                    &nbsp;
                                    <asp:Label ID="LB_ServiceName" runat="server"></asp:Label>
                                </div>
                            </div>

                            <div class="data-row">
                                <div class="data-label">
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,KeHuMingCheng%>"></asp:Label>:</div>
                                <div class="data-value">
                                    <asp:Label ID="LB_CompanyName" runat="server"></asp:Label></div>
                            </div>

                            <div class="data-row">
                                <div class="data-label">
                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>:</div>
                                <div class="data-value">
                                    <asp:Label ID="LB_Type" runat="server"></asp:Label></div>
                            </div>

                            <div class="data-row">
                                <div class="data-label">
                                    <asp:Label ID="Label42" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>:</div>
                                <div class="data-value">
                                    <asp:Label ID="LB_ContactPerson" runat="server"></asp:Label>
                                    &nbsp;
                                    <asp:HyperLink ID="HL_PhoneNumber" runat="server" Text=""></asp:HyperLink>
                                </div>
                            </div>
                        </div>

                        <!-- 操作按钮 -->
                        <div class="mobile-section">
                              <div class="equal-buttons">
                                <asp:Button ID="BT_Accept" runat="server" CssClass="inpu" OnClick="BT_Accept_Click" Text="<%$ Resources:lang,ShouLi%>" />
                                <asp:Button ID="BT_Exit" runat="server" CssClass="inpu" OnClick="BT_Exit_Click" Text="<%$ Resources:lang,TuiChuShouLi%>" />
                                <asp:Button ID="BT_Finish" runat="server" CssClass="inpu" OnClick="BT_Finish_Click" Text="<%$ Resources:lang,WanCheng%>" />
                                <asp:Button ID="BT_DeleteQuestion" runat="server" CssClass="inpu" Visible="false" Text="<%$ Resources:lang,ShanChu%>" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" OnClick="BT_DeleteQuestion_Click" />
                            </div>

                            <div class="mobile-form-group" style="margin-top: 15px;">
                                <asp:DropDownList ID="DL_IsImportant" runat="server" CssClass="mobile-dropdown" AutoPostBack="true" OnSelectedIndexChanged="DL_IsImportant_SelectedIndexChanged">
                                    <asp:ListItem Value="NO" Text="<%$ Resources:lang,PuTong%>" />
                                    <asp:ListItem Value="YES" Text="<%$ Resources:lang,ShangJi%>" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- 直接成员和指定受理人 -->
                        <div class="mobile-section">
                            <div class="mobile-form-group">
                                <div class="mobile-label">
                                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ZhiJieChengYuan%>"></asp:Label>:</div>
                                <asp:DropDownList ID="DL_Operator" runat="server" CssClass="mobile-dropdown" DataTextField="UserName" DataValueField="UserCode">
                                </asp:DropDownList>
                            </div>

                              <div class="equal-buttons">
                                <asp:Button ID="BT_TransferOperator" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ZhiDingWeiShouLiRen%>" OnClick="BT_TransferOperator_Click" />
                            </div>
                        </div>

                        <!-- 客服记录 -->
                        <div class="mobile-section">
                            <div class="mobile-label">
                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,KeFuJiLu%>"></asp:Label>:</div>

                            <asp:DataList ID="DataList3" runat="server" CellPadding="0" ForeColor="#333333" Height="1px" Width="100%">
                                <ItemTemplate>
                                    <div class="data-item">
                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label>:</div>
                                            <div class="data-value"><%#DataBinder.Eval(Container.DataItem, "ID")%></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>:</div>
                                            <div class="data-value"><%#DataBinder.Eval(Container.DataItem, "CustomerAcceptor")%></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ShouLiRen%>"></asp:Label>:</div>
                                            <div class="data-value"><%#DataBinder.Eval(Container.DataItem, "OperatorName")%></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,KeFangYiJian%>"></asp:Label>:</div>
                                            <div class="data-value"><%#DataBinder.Eval(Container.DataItem, "CustomerComment")%></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>:</div>
                                            <div class="data-value">
                                                <%#DataBinder.Eval(Container.DataItem, "CustomerAcceptor")%> &nbsp; 
                                                <a href='tel:<%#DataBinder.Eval(Container.DataItem, "AcceptorContactWay")%>' target="_blank"><%#DataBinder.Eval(Container.DataItem,"AcceptorContactWay")%></a>
                                            </div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>"></asp:Label>:</div>
                                            <div class="data-value"><%#DataBinder.Eval(Container.DataItem, "HandleDetail")%></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,XiaCiFuWuShiJian%>"></asp:Label>:</div>
                                            <div class="data-value"><%#DataBinder.Eval(Container.DataItem, "NextServiceTime")%></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,TiQianTongZhiTianShu%>"></asp:Label>:</div>
                                            <div class="data-value"><%#DataBinder.Eval(Container.DataItem, "PreDays")%></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:DataList>
                        </div>

                        <!-- 隐藏部分 -->
                        <div style="display: none;">
                            <asp:DataList ID="DataList2" runat="server" CellPadding="0" ForeColor="#333333" Height="1px" Width="100%" Style="display: none;">
                            </asp:DataList>

                              <div class="equal-buttons">
                                <asp:HyperLink ID="HL_RelatedDoc" runat="server" NavigateUrl="TTCollaborationRelatedDoc.aspx" CssClass="inpu">
                                    <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,XiangGuanWenJian%>"></asp:Label>
                                </asp:HyperLink>

                                <asp:HyperLink ID="HL_Expense" runat="server" NavigateUrl="TTProExpense.aspx" CssClass="inpu">
                                    ---&gt;<asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,FeiYongMingXiYuBaoXiao%>"></asp:Label>
                                </asp:HyperLink>

                                <asp:HyperLink ID="HL_ResoveResultReview" runat="server" NavigateUrl="TTCustomerQuestionResultReviewWF.aspx" CssClass="inpu">
                                    ---&gt;<asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,TiJiaoPingShen%>"></asp:Label>
                                </asp:HyperLink>

                                <asp:HyperLink ID="HL_QuestionToCustomer" runat="server" CssClass="inpu">
                                    --&gt;<asp:Label ID="Label40" runat="server" Text="<%$ Resources:lang,ZhuanChengKeHuHuoGuanLianKeHu%>"></asp:Label>
                                </asp:HyperLink>
                            </div>
                        </div>
                    </div>

                    <!-- 模态框 -->
                    <div class="layui-layer layui-layer-iframe" id="popDetailWindow" name="fixedDiv"
                        style="z-index: 9999; width: 98%; height: 500px; position: absolute; overflow: hidden; display: none; border-radius: 10px;">
                        <div class="layui-layer-title" style="background: #e7e7e8;" id="popwindow_title">
                            <asp:Label ID="Label5" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                        </div>
                        <div id="popwindow_content" class="layui-layer-content" style="overflow: auto; padding: 0px 5px 0px 5px;">

                            <table style="width: 100%; padding: 5px 0px 0px 5px" cellpadding="3" cellspacing="0" class="formBgStyle">
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,KeHuYiJian%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <CKEditor:CKEditorControl ID="HE_CustomerComment" runat="server" Toolbar="" Width="99%" Height="170px" Visible="false" />

                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ChuLiFangShi%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:TextBox ID="TB_HandleWay" runat="server" Width="60%"></asp:TextBox>
                                        <asp:DropDownList ID="DL_HandleWay" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DL_ContactWay_SelectedIndexChanged">
                                            <asp:ListItem Value="" Text="<%$ Resources:lang,QingXuanZe%>" />
                                            <asp:ListItem Value="Telephone" Text="<%$ Resources:lang,DianHua%>" />
                                            <asp:ListItem Value="InstantMessaging" Text="<%$ Resources:lang,IM%>" />
                                            <asp:ListItem Value="RemoteControl" Text="<%$ Resources:lang,YuanChengKongZhi%>" />
                                            <asp:ListItem Value="EMail" Text="<%$ Resources:lang,EMail%>" />
                                            <asp:ListItem Value="DoorToDoorVisit" Text="<%$ Resources:lang,ShangMenBaiFang%>" />
                                            <asp:ListItem Value="OtherMethods" Text="<%$ Resources:lang,QiTaFangShi%>" />
                                        </asp:DropDownList>
                                        <asp:Label ID="LB_ID" runat="server" Visible="false"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:DropDownList ID="DL_HandleStatus" runat="server" Width="99%">
                                            <asp:ListItem Value="InProgress" Text="<%$ Resources:lang,ChuLiZhong%>" />
                                            <asp:ListItem Value="Reviewing" Text="<%$ Resources:lang,PingShenZhong%>" />
                                            <asp:ListItem Value="Suspended" Text="<%$ Resources:lang,GuaQi%>" />
                                            <asp:ListItem Value="Completed" Text="<%$ Resources:lang,WanCheng%>" />
                                            <asp:ListItem Value="Cancel" Text="<%$ Resources:lang,QuXiao%>" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,YongShi%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <NickLee:NumberBox ID="NB_UsedTime" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Width="60%" Amount="1">1.00</NickLee:NumberBox>
                                        <asp:DropDownList ID="DL_TimeUnit" runat="server">
                                            <asp:ListItem Value="Minutes" Text="<%$ Resources:lang,FenZhong%>" />
                                            <asp:ListItem Value="Hours" Text="<%$ Resources:lang,XiaoShi%>" />
                                            <asp:ListItem Value="Days" Text="<%$ Resources:lang,Tian%>" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,LianLuoRen%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:TextBox ID="TB_CustomerAcceptor" runat="server" Width="60%"></asp:TextBox>
                                        <asp:HyperLink ID="HL_AcceptorContactWay" runat="server"></asp:HyperLink>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,LianXiFangFa%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:TextBox ID="TB_AcceptorContactWay" runat="server" Width="90%"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <CKEditor:CKEditorControl ID="HE_HandleDetail" runat="server" Toolbar="" Width="90%" Height="170" Visible="false" />

                                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional" Visible="false">
                                            <ContentTemplate>
                                                <div>
                                                    <Upload:InputFile ID="AttachFile" runat="server" Width="180px" />
                                                    &nbsp;<asp:Button ID="BtnUP" runat="server" OnClick="BtnUP_Click" OnClientClick="javascript:document.getElementById('IMG_Uploading').style.display = 'block';" Text="<%$ Resources:lang,ShiYong%>" />
                                                    <img id="IMG_Uploading" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                                                </div>
                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="BtnUP" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,XiaCi%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:TextBox ID="DLC_NextServiceTime" ReadOnly="false" runat="server" Width="99%"></asp:TextBox>
                                        <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender1" runat="server" TargetControlID="DLC_NextServiceTime">
                                        </ajaxToolkit:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,TiQian%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formItemBgStyleForAlignLeft">
                                        <NickLee:NumberBox ID="NB_PreDays" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Precision="0" Width="90%">0</NickLee:NumberBox>
                                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,Tian%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr style="display: none;">
                                    <td class="formItemBgStyleForAlignLeft" colspan="2">
                                        <asp:Button ID="BT_Add" runat="server" CssClass="inpu" OnClick="BT_Add_Click" Text="<%$ Resources:lang,XinJian%>" />
                                        <asp:Button ID="BT_Update" runat="server" CssClass="inpu" Enabled="false" OnClick="BT_Update_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                        <asp:Button ID="BT_Delete" runat="server" CssClass="inpu" Enabled="false" OnClick="BT_Delete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <br />
                        </div>

                        <div id="popwindow_footer" class="layui-layer-btn" style="border-top: 1px solid #ccc;">
                            <asp:LinkButton ID="BT_New" runat="server" class="layui-layer-btn notTab" OnClick="BT_New_Click" Text="<%$ Resources:lang,BaoCun%>"></asp:LinkButton>
                            <a class="layui-layer-btn notTab" onclick="return popClose();">
                                <asp:Label ID="Label41" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                            </a>
                        </div>
                        <span class="layui-layer-setwin">
                            <a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;"></a>
                        </span>
                    </div>

                    <div class="layui-layer-shade" id="popwindow_shade" style="z-index: 9998; background-color: #000; opacity: 0.3; filter: alpha(opacity=30); display: none;"></div>
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
    </div>
</body>
</html>
