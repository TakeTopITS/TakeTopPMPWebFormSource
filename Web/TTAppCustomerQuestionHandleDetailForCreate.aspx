<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppCustomerQuestionHandleDetailForCreate.aspx.cs" Inherits="TTAppCustomerQuestionHandleDetailForCreate" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>
        <asp:Literal ID="LiteralTitle" runat="server" Text="" />
    </title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>

    <script src="js/exif.js" type="text/javascript"></script>
    <style type="text/css">
        /* 修复日期选择器样式 */
        .ajax__calendar_container {
            z-index: 10000 !important;
            position: fixed !important;
        }

        /* 确保弹窗内的日历正确显示 */
        #popDetailWindow .ajax__calendar_container {
            position: absolute !important;
        }

        /* 调整弹窗内的输入框布局 */
        .popup-input-group {
            position: relative;
            width: 100%;
        }

            .popup-input-group input[type="text"] {
                width: 100%;
                box-sizing: border-box;
            }

        /* 日历按钮样式 */
        .calendar-button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: url('ImagesSkin/calendar.png') no-repeat center;
            background-size: 16px 16px;
            width: 20px;
            height: 20px;
            border: none;
            cursor: pointer;
            z-index: 2;
        }

        /* 移动端优化样式 */
        .mobile-content {
            padding: 10px;
        }

        .mobile-section {
            background: #f5f5f5;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .data-row {
            display: flex;
            margin-bottom: 10px;
            align-items: flex-start;
        }

        .data-label {
            width: 120px;
            flex-shrink: 0;
            font-weight: bold;
            color: #666;
        }

        .data-value {
            flex: 1;
            min-width: 0;
            word-wrap: break-word;
            color: #333;
        }

        .data-item {
            border-bottom: 1px solid #ddd;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }

        .mobile-form-group {
            margin-bottom: 15px;
        }

        .mobile-dropdown {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: white;
        }

        .mobile-input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .equal-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

            .equal-buttons .inpu {
                flex: 1;
                min-width: 120px;
            }

        /* 上传按钮样式 */
        .upload-button {
            margin-top: 10px;
        }
    </style>
</head>
<body data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>

    <!-- 滑动反馈层 -->
    <canvas id="myCanvas" style="display: none;"></canvas>

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
                                                        <td width="5"></td>
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
                                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XuQiuMingCheng%>" />
                                </div>
                                <div class="data-value">
                                    <asp:Label ID="LB_ServiceID" runat="server"></asp:Label>
                                    &nbsp;
                                    <asp:Label ID="LB_ServiceName" runat="server"></asp:Label>
                                </div>
                            </div>

                            <div class="data-row">
                                <div class="data-label">
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,KeHuMingCheng%>" />
                                </div>
                                <div class="data-value">
                                    <asp:Label ID="LB_CompanyName" runat="server"></asp:Label>
                                </div>
                            </div>

                            <div class="data-row">
                                <div class="data-label">
                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,LeiXing%>" />
                                </div>
                                <div class="data-value">
                                    <asp:Label ID="LB_Type" runat="server"></asp:Label>
                                </div>
                            </div>

                            <div class="data-row">
                                <div class="data-label">
                                    <asp:Label ID="Label42" runat="server" Text="<%$ Resources:lang,LianXiRen%>" />
                                </div>
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

                        <div class="npbxs">
                            <div class="mline">
                                <div style="display: flex; margin-bottom: 5px;">
                                    <div style="width: 100%;">
                                        <table width="100%">
                                            <tr>
                                                <td style="vertical-align: middle;">
                                                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ZhiJieChengYuan%>"></asp:Label>:
                                                </td>
                                                <td>

                                                    <asp:DropDownList ID="DL_Operator" DataTextField="UserName" Width="100%" DataValueField="UserCode" runat="server" CssClass="mobile-dropdown">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>


                                    </div>
                                </div>
                            </div>

                            <div class="equal-buttons">
                                <asp:Button ID="BT_TransferOperator" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ZhiDingWeiShouLiRen%>" OnClick="BT_TransferOperator_Click" />
                            </div>
                        </div>

                        <!-- 新建按钮 -->
                        <div class="mobile-section">
                            <div class="equal-buttons">
                                <asp:Button ID="BT_Create" runat="server" Text="<%$ Resources:lang,New%>" CssClass="inpu" OnClick="BT_Create_Click" OnClientClick="popShow(); return false;" />
                            </div>
                        </div>

                        <!-- 客服记录 -->
                        <div class="mobile-section">
                            <div class="npb">
                                <div class="cline"></div>
                                <h3>
                                    <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,KeFuJiLu%>" /></h3>
                            </div>

                            <asp:DataList ID="DataList3" runat="server" CellPadding="0" ForeColor="#333333" OnItemCommand="DataList3_ItemCommand"
                                Height="1px" Width="100%">
                                <ItemTemplate>
                                    <div style="margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                                        <!-- 第一行：ID按钮 -->
                                        <div style="margin-bottom: 8px;">
                                            <asp:Button ID="BT_ID" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "ID") %>'
                                                CssClass="inpu" CommandName="Update" OnClientClick="popShow(); return false;" />
                                        </div>

                                        <!-- 第二行开始：详细信息 -->
                                        <div style="display: flex; flex-wrap: wrap; gap: 5px 0;">
                                            <!-- 联系人 -->
                                            <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                    <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,LianXiRen%>" />
                                                </div>
                                                <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                    <%#DataBinder.Eval(Container.DataItem, "CustomerAcceptor")%>
                                                </div>
                                            </div>

                                            <!-- 受理人 -->
                                            <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ShouLiRen%>" />
                                                </div>
                                                <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                    <%#DataBinder.Eval(Container.DataItem, "OperatorName")%>
                                                </div>
                                            </div>

                                            <!-- 客房意见 -->
                                            <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                    <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,KeFangYiJian%>" />
                                                </div>
                                                <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                    <%#DataBinder.Eval(Container.DataItem, "CustomerComment")%>
                                                </div>
                                            </div>

                                            <!-- 联系方式 -->
                                            <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                    <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,LianXiRen%>" />
                                                </div>
                                                <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                    <%#DataBinder.Eval(Container.DataItem, "CustomerAcceptor")%> &nbsp;
                                                    <a href='tel:<%#DataBinder.Eval(Container.DataItem, "AcceptorContactWay")%>' target="_blank"><%#DataBinder.Eval(Container.DataItem,"AcceptorContactWay")%></a>
                                                </div>
                                            </div>

                                            <!-- 处理内容 -->
                                            <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>" />
                                                </div>
                                                <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                    <%#DataBinder.Eval(Container.DataItem, "HandleDetail")%>
                                                </div>
                                            </div>

                                            <!-- 下次服务时间 -->
                                            <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                    <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,XiaCiFuWuShiJian%>" />
                                                </div>
                                                <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                    <%#DataBinder.Eval(Container.DataItem, "NextServiceTime")%>
                                                </div>
                                            </div>

                                            <!-- 提前通知天数 -->
                                            <div style="flex: 0 0 100%; display: flex; margin-bottom: 5px;">
                                                <div style="width: 100px; flex-shrink: 0; font-weight: bold;">
                                                    <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,TiQianTongZhiTianShu%>" />
                                                </div>
                                                <div style="flex: 1; min-width: 0; word-wrap: break-word;">
                                                    <%#DataBinder.Eval(Container.DataItem, "PreDays")%>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:DataList>
                        </div>

                        <!-- 隐藏部分 -->
                        <div style="display: none;">
                            <asp:DataList ID="DataList2" runat="server" CellPadding="0" ForeColor="#333333" Height="1px"
                                Width="100%" Style="display: none;">
                            </asp:DataList>

                            <div class="equal-buttons">
                                <asp:HyperLink ID="HL_RelatedDoc" runat="server" NavigateUrl="TTCollaborationRelatedDoc.aspx"
                                    CssClass="inpu">
                                    <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,XiangGuanWenJian%>" />
                                </asp:HyperLink>

                                &nbsp;
                                <asp:HyperLink ID="HL_Expense" runat="server" NavigateUrl="TTProExpense.aspx" CssClass="inpu">
                                    <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,FeiYongMingXiYuBaoXiao%>" />
                                </asp:HyperLink>

                                &nbsp;
                                <asp:HyperLink ID="HL_ResoveResultReview" runat="server" NavigateUrl="TTCustomerQuestionResultReviewWF.aspx" CssClass="inpu">
                                    <asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,TiJiaoPingShen%>" />
                                </asp:HyperLink>

                                &nbsp;
                                <asp:HyperLink ID="HL_QuestionToCustomer" runat="server" CssClass="inpu">
                                    <asp:Label ID="Label40" runat="server" Text="<%$ Resources:lang,ZhuanChengKeHuHuoGuanLianKeHu%>" />
                                </asp:HyperLink>
                            </div>
                        </div>
                    </div>

                    <!-- 弹窗部分 -->
                    <div class="layui-layer-shade" id="popwindow_shade" style="z-index: 9998; background-color: #000; opacity: 0.3; filter: alpha(opacity=30); display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;"></div>

                    <div class="layui-layer layui-layer-iframe" id="popDetailWindow" name="fixedDiv"
                        style="z-index: 9999; width: 96%; max-width: 500px; height: auto; max-height: 80vh; position: fixed; overflow: hidden; display: none; border-radius: 10px; left: 50%; transform: translateX(-50%); background: white; box-shadow: 0 5px 15px rgba(0,0,0,0.3);">
                        <div class="layui-layer-title" style="background: #e7e7e8; padding: 10px 15px; border-bottom: 1px solid #ddd;" id="popwindow_title">
                            <asp:Label ID="Label5" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                            <span class="layui-layer-setwin" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%);">
                                <a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;" style="display: block; width: 30px; height: 30px; line-height: 30px; text-align: center;">×</a>
                            </span>
                        </div>
                        <div id="popwindow_content" class="layui-layer-content" style="overflow: auto; padding: 15px; max-height: calc(80vh - 100px);">
                            <div style="margin: 0;">
                                <div>
                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,KeHuYiJian%>" />
                                        </div>
                                        <div>
                                            <CKEditor:CKEditorControl ID="HE_CustomerComment" runat="server" Toolbar="" Width="100%" Height="150px" Visible="false" />
                                        </div>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ChuLiFangShi%>" />
                                        </div>
                                        <div style="display: flex; flex-wrap: wrap; gap: 10px; align-items: center;">
                                            <asp:TextBox ID="TB_HandleWay" runat="server" CssClass="mobile-input" Width="120px"></asp:TextBox>
                                            <asp:DropDownList ID="DL_HandleWay" runat="server" CssClass="mobile-dropdown" AutoPostBack="true" OnSelectedIndexChanged="DL_ContactWay_SelectedIndexChanged">
                                                <asp:ListItem Value="" Text="<%$ Resources:lang,QingXuanZe%>" />
                                                <asp:ListItem Value="Telephone" Text="<%$ Resources:lang,DianHua%>" />
                                                <asp:ListItem Value="InstantMessaging" Text="<%$ Resources:lang,IM%>" />
                                                <asp:ListItem Value="RemoteControl" Text="<%$ Resources:lang,YuanChengKongZhi%>" />
                                                <asp:ListItem Value="EMail" Text="<%$ Resources:lang,EMail%>" />
                                                <asp:ListItem Value="DoorToDoorVisit" Text="<%$ Resources:lang,ShangMenBaiFang%>" />
                                                <asp:ListItem Value="OtherMethods" Text="<%$ Resources:lang,QiTaFangShi%>" />
                                            </asp:DropDownList>
                                            <asp:Label ID="LB_ID" runat="server" Visible="false"></asp:Label>
                                        </div>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ZhuangTai%>" />
                                        </div>
                                        <div>
                                            <asp:DropDownList ID="DL_HandleStatus" runat="server" CssClass="mobile-dropdown" Width="100%">
                                                <asp:ListItem Value="InProgress" Text="<%$ Resources:lang,ChuLiZhong%>" />
                                                <asp:ListItem Value="Reviewing" Text="<%$ Resources:lang,PingShenZhong%>" />
                                                <asp:ListItem Value="Suspended" Text="<%$ Resources:lang,GuaQi%>" />
                                                <asp:ListItem Value="Completed" Text="<%$ Resources:lang,WanCheng%>" />
                                                <asp:ListItem Value="Cancel" Text="<%$ Resources:lang,QuXiao%>" />
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,YongShi%>" />
                                        </div>
                                        <div style="display: flex; gap: 10px; align-items: center;">
                                            <NickLee:NumberBox ID="NB_UsedTime" runat="server" CssClass="mobile-input" MaxAmount="1000000000000" MinAmount="-1000000000000" Width="100px" Amount="1">1.00</NickLee:NumberBox>
                                            <asp:DropDownList ID="DL_TimeUnit" runat="server" CssClass="mobile-dropdown" Width="100px">
                                                <asp:ListItem Value="Minutes" Text="<%$ Resources:lang,FenZhong%>" />
                                                <asp:ListItem Value="Hours" Text="<%$ Resources:lang,XiaoShi%>" />
                                                <asp:ListItem Value="Days" Text="<%$ Resources:lang,Tian%>" />
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,LianLuoRen%>" />
                                        </div>
                                        <div style="display: flex; gap: 10px; align-items: center;">
                                            <asp:TextBox ID="TB_CustomerAcceptor" runat="server" CssClass="mobile-input" Width="200px"></asp:TextBox>
                                            <asp:HyperLink ID="HL_AcceptorContactWay" runat="server"></asp:HyperLink>
                                        </div>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,LianXiFangFa%>" />
                                        </div>
                                        <div>
                                            <asp:TextBox ID="TB_AcceptorContactWay" runat="server" CssClass="mobile-input" Width="100%"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>" />
                                        </div>
                                        <div>
                                            <CKEditor:CKEditorControl ID="HE_HandleDetail" Toolbar="" runat="server" CssClass="mobile-input" Width="100%" Height="100px" Visible="False" />
                                        </div>
                                    </div>
                                    <div style="margin-bottom: 15px;">

                                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <div class="nmar">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <Upload:InputFile ID="AttachFile" runat="server" name="photo" Accept="image/*;capture=camera" Width="160px" />
                                                                <input type="hidden" val="" id="imgData" runat="server" /></td>
                                                            <td>
                                                                <input type="button" id="BtnUP" onclick="upload()" value="Upload" />
                                                                <img id="IMG_Uploading" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                    <br />
                                                </div>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>

                                    <div style="margin-bottom: 15px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,XiaCi%>" />
                                        </div>
                                        <!-- 修复日期选择器位置 -->
                                        <div class="popup-input-group">
                                            <asp:TextBox ID="DLC_NextServiceTime" ReadOnly="false" runat="server" CssClass="mobile-input" Width="100%" Style="padding-right: 30px;"></asp:TextBox>
                                            <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender1" runat="server" TargetControlID="DLC_NextServiceTime"
                                                PopupPosition="BottomLeft">
                                            </ajaxToolkit:CalendarExtender>
                                            <button type="button" class="calendar-button" onclick="document.getElementById('<%= DLC_NextServiceTime.ClientID %>').focus(); return false;"></button>
                                        </div>
                                    </div>

                                    <div style="margin-bottom: 20px;">
                                        <div style="font-weight: bold; margin-bottom: 5px;">
                                            <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,TiQian%>" />
                                        </div>
                                        <div style="display: flex; gap: 10px; align-items: center;">
                                            <NickLee:NumberBox ID="NB_PreDays" runat="server" CssClass="mobile-input" MaxAmount="1000000000000" MinAmount="-1000000000000" Precision="0" Width="100px">0</NickLee:NumberBox>
                                            <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,Tian%>" />
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                    <div style="display: none;">
                                        <asp:Button ID="BT_Add" runat="server" CssClass="inpu" OnClick="BT_Add_Click" Text="<%$ Resources:lang,XinJian%>" />
                                        <asp:Button ID="BT_Update" runat="server" CssClass="inpu" Enabled="false" OnClick="BT_Update_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                        <asp:Button ID="BT_Delete" runat="server" CssClass="inpu" Enabled="false" OnClick="BT_Delete_Click" Text="<%$ Resources:lang,ShanChu%>" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 修改后的弹窗底部按钮 -->
                        <div id="popwindow_footer" class="layui-layer-btn" style="border-top: 1px solid #ccc; padding: 15px; text-align: center; background: white; position: sticky; bottom: 0;">
                            <asp:LinkButton ID="BT_New" runat="server"
                                OnClick="BT_New_Click"
                                Text="<%$ Resources:lang,BaoCun%>"
                                CssClass="popup-button">
                            </asp:LinkButton>
                            <a onclick="return popClose();" class="popup-button cancel" style="margin-left: 10px;">
                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                            </a>
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
    </div>

    <script type="text/javascript" language="javascript">
        //页面加载完成,ajax回发加载完成后执行的操作，传入一个funtion
        var $load = function (loadFunc) {
            $(function () {
                initSwipeBack();// 初始化滑动返回功能
                if (typeof (Sys) != 'undefined') {
                    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(loadFunc);
                }
                else {
                    loadFunc();
                }
            });
        };

        $load(function () {
            //选择图片后压缩图片
            $("#AttachFile").change(function () {
                var _ua = window.navigator.userAgent;
                var _simpleFile = this.files[0];
                //判断是否为图片
                if (!/\/(?:jpeg|png|gif|png|bmp)/i.test(_simpleFile.type)) return;

                //插件exif.js获取ios图片的方向信息
                var _orientation;
                EXIF.getData(_simpleFile, function () {
                    _orientation = EXIF.getTag(this, 'Orientation');
                });

                //读取文件
                var _reader = new FileReader(),
                    _img = new Image(),
                    _url;

                _reader.onload = function () {
                    _img.onload = function () {
                        $("#imgData").val(compress(_img, _orientation));
                    };
                    _url = this.result;
                    _img.src = _url;
                };
                _reader.readAsDataURL(_simpleFile);
            });

            // 修复日历控件的显示
            fixCalendarPosition();

            // 监听弹窗显示事件
            $(document).on('click', '[onclientclick*="popShow"]', function () {
                setTimeout(fixCalendarPosition, 100);
            });

        });

        // 图片压缩函数
        function compress(_img, _orientation) {
            var _goalWidth = 640,
                _goalHeight = 480,
                _imgWidth = _img.naturalWidth,
                _imgHeight = _img.naturalHeight,
                _tempWidth = _imgWidth,
                _tempHeight = _imgHeight,
                _r = 0;

            if (_imgWidth > _goalWidth || _imgHeight > _goalHeight) {
                _r = _imgWidth / _goalWidth;
                if (_imgHeight / _goalHeight < _r) {
                    _r = _imgHeight / _goalHeight;
                }
                _tempWidth = Math.ceil(_imgWidth / _r);
                _tempHeight = Math.ceil(_imgHeight / _r);
            }

            var _canvas = document.getElementById("myCanvas");
            var _context = _canvas.getContext('2d');
            _canvas.width = _tempWidth;
            _canvas.height = _tempHeight;
            var _degree;

            //ios bug处理
            switch (_orientation) {
                case 3:
                    _degree = 180;
                    _tempWidth = -_imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                case 6:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 90;
                    _tempWidth = _imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                case 8:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 270;
                    _tempWidth = -_imgWidth;
                    _tempHeight = _imgHeight;
                    break;
            }

            if (!!_degree) {
                _context.rotate(_degree * Math.PI / 180);
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            } else {
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            }

            var _data = _canvas.toDataURL('image/jpeg');
            return _data;
        }

        // 修复日历控件位置
        function fixCalendarPosition() {
            var dateInput = $('#popDetailWindow').find('input[id*="DLC_NextServiceTime"]');
            if (dateInput.length > 0) {
                var calendarContainer = $('.ajax__calendar_container');
                if (calendarContainer.length > 0) {
                    calendarContainer.css({
                        'position': 'absolute',
                        'z-index': '10001'
                    });

                    var inputOffset = dateInput.offset();
                    var inputWidth = dateInput.outerWidth();

                    calendarContainer.css({
                        'left': inputOffset.left + 'px',
                        'top': (inputOffset.top + dateInput.outerHeight()) + 'px'
                    });
                }
            }
        }

        // 弹窗控制函数
        function popShow() {
            var popWindow = document.getElementById('popDetailWindow');
            var popShade = document.getElementById('popwindow_shade');
            if (popWindow && popShade) {
                popWindow.style.display = 'block';
                popShade.style.display = 'block';

                // 居中显示
                var windowHeight = window.innerHeight || document.documentElement.clientHeight;
                var popHeight = popWindow.offsetHeight;
                var top = (windowHeight - popHeight) / 2;
                if (top < 0) top = 0;
                popWindow.style.top = top + 'px';

                // 设置焦点到第一个输入框
                setTimeout(function () {
                    var firstInput = popWindow.querySelector('input, select, textarea');
                    if (firstInput) {
                        firstInput.focus();
                    }
                }, 100);
            }
        }

        function popClose() {
            var popWindow = document.getElementById('popDetailWindow');
            var popShade = document.getElementById('popwindow_shade');
            if (popWindow && popShade) {
                popWindow.style.display = 'none';
                popShade.style.display = 'none';
            }
            return false;
        }

        // 添加页面点击事件，点击弹窗外部关闭
        document.addEventListener('click', function (e) {
            var popWindow = document.getElementById('popDetailWindow');
            var popShade = document.getElementById('popwindow_shade');

            if (popWindow && popWindow.style.display === 'block' &&
                popShade && e.target === popShade) {
                popClose();
            }
        });

        // 添加键盘事件，按ESC键关闭弹窗
        document.addEventListener('keydown', function (e) {
            if (e.keyCode === 27) { // ESC键
                popClose();
            }
        });
    </script>
</body>
</html>
