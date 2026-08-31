<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTProTaskRelatedDocSAAS.aspx.cs" Inherits="TTProTaskRelatedDocSAAS" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>


<!DOCTYPE html>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>

    <link href="WebUploader/webuploader.css" rel="stylesheet" />
    <script type="text/javascript" src="WebUploader/webuploader.js"></script>

    <script type="text/javascript">

        var i = 0;
        var j = 0;

        // 文件上传
        jQuery(function () {
            var $ = jQuery,
                $list = $('#thelist'),
                $btn = $('#ctlBtn'),
                state = 'pending',
                uploader;

            uploader = WebUploader.create({

                // 不压缩image
                resize: false,

                // swf文件路径
                swf: 'WebUploader/Uploader.swf',

                // 文件接收服务端。
                server: 'Handler/UploadHandler.ashx',

                // 选择文件的按钮。可选。
                // 内部根据当前运行是创建，可能是input元素，也可能是flash.
                pick: '#picker'
            });

            //上传前附件参数
            uploader.on('uploadBeforeSend', function (obj, data) {

                //判断文档类型是否为空
                if (document.getElementById("TabContainer1_TabPanel1_TB_DocType").value == "") {
                    alert("Warning,the doc type can not null,please check!");
                    return;
                }

                //传入表单参数
                data = $.extend(data, {

                    relatedType: "Task",
                    relatedID: $("#TabContainer1_TabPanel1_LB_TaskID").text(),
                    docTypeID: $("#TabContainer1_TabPanel1_LB_DocTypeID").text(),
                    docType: $("#TabContainer1_TabPanel1_TB_DocType").val(),
                    author: $("#TabContainer1_TabPanel1_TB_Author").val(),
                    userVisible: $('#TabContainer1_TabPanel1_DL_Visible option:selected').val()

                });

            });

            // 当有文件添加进来的时候
            uploader.on('fileQueued', function (file) {
                $list.append('<div id="' + file.id + '" class="item">' +
                    '<h4 class="info">' + file.name + '</h4>' +
                    '<p class="state">Waiting upload...</p>' +
                    '</div>');

                i = i + 1;
            });

            // 文件上传过程中创建进度条实时显示。
            uploader.on('uploadProgress', function (file, percentage) {
                var $li = $('#' + file.id),
                    $percent = $li.find('.progress .progress-bar');

                // 避免重复创建
                if (!$percent.length) {
                    $percent = $('<div class="progress progress-striped active">' +
                        '<div class="progress-bar" role="progressbar" style="width: 0%">' +
                        '</div>' +
                        '</div>').appendTo($li).find('.progress-bar');
                }

                $li.find('p.state').text('Uploading');

                $percent.css('width', percentage * 100 + '%');
            });

            uploader.on('uploadSuccess', function (file) {
                $('#' + file.id).find('p.state').text('Uploaded');
            });

            uploader.on('uploadError', function (file) {
                $('#' + file.id).find('p.state').text('Upload Error');
            });

            uploader.on('uploadComplete', function (file) {
                $('#' + file.id).find('.progress').fadeOut();

                j++;
                if (j == i) {
                    $("#TabContainer1_TabPanel1_BT_LoadDoc").click();

                    i = 0;
                    j = 0;
                }
            });

            uploader.on('all', function (type) {
                if (type === 'startUpload') {
                    state = 'uploading';
                } else if (type === 'stopUpload') {
                    state = 'paused';
                } else if (type === 'uploadFinished') {
                    state = 'done';
                }

                if (state === 'uploading') {
                    $btn.text('Pause Upload');
                } else {
                    $btn.text('Start Upload');
                }
            });

            $btn.on('click', function () {

                if (state === 'uploading') {
                    uploader.stop();
                } else {
                    uploader.upload();
                }

            });

        });
    </script>

    <script type="text/javascript" language="javascript">
        $(function () {

            if (top.location != self.location) { } else { CloseWebPage(); }

        });
    </script>

</head>
<body>

    <center>
        <form id="form1" runat="server">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                    <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                        <tr>

                            <td height="31" class="page_topbj">
                                <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <table width="345" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="29">
                                                        <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%></td>
                                                    <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,XiangGuanWenDang%>"></asp:Label>
                                                    </td>
                                                    <td width="5">
                                                        <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding: 5px 0px 0px 5px; text-align: left;">
                                <cc1:TabContainer CssClass="ajax_tab_menu" ID="TabContainer1" runat="server" ActiveTabIndex="0" Width="98%">
                                    <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="文档上传">
                                        <HeaderTemplate>
                                            <asp:Label ID="LB_tabUploadDoc" runat="server" Text="<%$ Resources:lang,UploadDoc%>"></asp:Label>
                                        </HeaderTemplate>
                                        <ContentTemplate>

                                            <table width="100%" cellpadding="0" cellspacing="0">

                                                <tr>

                                                    <td style="width: 18%; text-align: left;" valign="top">
                                                        <asp:UpdatePanel ID="UpdatePanel5" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>
                                                                <asp:TreeView ID="TreeView1" runat="server" Font-Bold="False" Font-Names="宋体" Font-Size="10pt"
                                                                    NodeWrap="True" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged" ShowLines="True"
                                                                    Width="100%">

                                                                    <RootNodeStyle CssClass="rootNode" />
                                                                    <NodeStyle CssClass="treeNode" />
                                                                    <LeafNodeStyle CssClass="leafNode" />
                                                                    <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                                                </asp:TreeView>

                                                            </ContentTemplate>
                                                            <Triggers>
                                                                <asp:PostBackTrigger ControlID="TreeView1" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>
                                                    </td>

                                                    <td style="text-align: left; padding: 5px 5px 5px 5px">

                                                        <table width="100%" cellpadding="0" cellspacing="0">

                                                            <tr style="display: none;">

                                                                <td>

                                                                    <asp:Label ID="LB_FindCondition" runat="server" Font-Bold="False" Font-Size="9pt"></asp:Label><asp:Label
                                                                        ID="LB_UserCode" runat="server" Font-Bold="True"
                                                                        Visible="False"></asp:Label><asp:Label ID="LB_UserName" runat="server"
                                                                            Visible="False"></asp:Label><asp:Label ID="LB_TaskID"
                                                                                runat="server"></asp:Label><asp:Label ID="LB_ProjectID"
                                                                                    runat="server" Visible="False"></asp:Label>

                                                                    <asp:UpdatePanel ID="UpdatePanel6" runat="server" UpdateMode="Conditional">
                                                                        <ContentTemplate>
                                                                            <asp:Button ID="BT_LoadDoc" runat="server" CssClass="ButtonCss" Height="22px" OnClick="BT_LoadDoc_Click" Text="<%$ Resources:lang,refresh %>" />
                                                                        </ContentTemplate>
                                                                        <Triggers>
                                                                            <asp:PostBackTrigger ControlID="BT_LoadDoc" />
                                                                        </Triggers>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>

                                                            <tr>

                                                                <td class="ItemAlignLeft" valign="top">

                                                                    <table width="98%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                        <tr>
                                                                            <td width="7">
                                                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                            </td>
                                                                            <td>
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td width="5%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,XuHao %>"></asp:Label></strong>
                                                                                        </td>

                                                                                        <td width="10%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,LeiXing %>"></asp:Label></strong>
                                                                                        </td>
                                                                                        <td width="18%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,WenJianMing %>"></asp:Label></strong>
                                                                                        </td>
                                                                                        <td width="9%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZuoZhe %>"></asp:Label></strong>
                                                                                        </td>
                                                                                        <td width="12%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ShangChuanZhe %>"></asp:Label></strong>
                                                                                        </td>
                                                                                        <td width="14%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,ShangChuanShiJian %>"></asp:Label></strong>
                                                                                        </td>
                                                                                        <td width="10%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,QuanXian %>"></asp:Label></strong>
                                                                                        </td>
                                                                                        <td width="8%" class="ItemAlignLeft">
                                                                                            <strong>
                                                                                                <asp:Label ID="Label45" runat="server" Text="<%$ Resources:lang,ZhuangTai %>"></asp:Label></strong>
                                                                                        </td>
                                                                                        <td class="ItemAlignLeft">
                                                                                            <strong></strong>
                                                                                        </td>
                                                                                        <td class="ItemAlignLeft">
                                                                                            <strong></strong>
                                                                                        </td>
                                                                                        <td class="ItemAlignLeft">
                                                                                            <strong></strong>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                            <td width="6" align="right">
                                                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <asp:DataGrid runat="server" AllowPaging="True" AutoGenerateColumns="False" CellPadding="4"
                                                                        ShowHeader="False" GridLines="None" ForeColor="#333333" Height="1px" Width="98%"
                                                                        ID="DataGrid1" OnItemCommand="DataGrid1_ItemCommand" OnPageIndexChanged="DataGrid1_PageIndexChanged">
                                                                        <AlternatingItemStyle BackColor="White"></AlternatingItemStyle>
                                                                        <Columns>
                                                                            <asp:BoundColumn DataField="DocID" HeaderText="序号">
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                                            </asp:BoundColumn>

                                                                            <asp:BoundColumn DataField="DocType" HeaderText="类型">
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="DocName" HeaderText="文件名" Visible="false">
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                            </asp:BoundColumn>
                                                                            <asp:TemplateColumn>
                                                                                <ItemTemplate>
                                                                                    <a href='<%#DataBinder.Eval(Container.DataItem, "Address")%>' class="address-cell">
                                                                                        <%#DataBinder.Eval(Container.DataItem, "DocID")%>_<%#DataBinder.Eval(Container.DataItem, "DocName")%>
                                                                                    </a>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="18%" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:BoundColumn DataField="Author" HeaderText="作者">
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="9%" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="UploadManName" HeaderText="上传者">
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="12%" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="UploadTime" HeaderText="上传时间">
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="13%" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Visible" HeaderText="权限">
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Address" Visible="False"></asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="评审状态">
                                                                                <ItemTemplate>
                                                                                    <%# DataBinder.Eval(Container.DataItem, "Status").ToString() %>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="8%" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn>
                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="CB_Select" runat="server" Checked="false" />
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Delete">
                                                                                <ItemTemplate>
                                                                                    <asp:LinkButton ID="LBT_Delete" CommandName="Delete" runat="server" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="&lt;div&gt;&lt;img src=ImagesSkin/Delete.png border=0 alt='删除' /&gt;&lt;/div&gt;"></asp:LinkButton>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                            </asp:TemplateColumn>

                                                                            <asp:TemplateColumn>
                                                                                <ItemTemplate>
                                                                                    <a href='TTDocRelatedUser.aspx?DocID= <%#DataBinder.Eval(Container.DataItem, "DocID")%>'>
                                                                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,QiTaKeShiRenYuan%>"></asp:Label>
                                                                                    </a>
                                                                                </ItemTemplate>
                                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                        <EditItemStyle BackColor="#2461BF"></EditItemStyle>
                                                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White"></FooterStyle>
                                                                        <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333"></SelectedItemStyle>
                                                                    </asp:DataGrid>

                                                                </td>
                                                            </tr>

                                                            <tr style="font-size: 12pt">

                                                                <td style="width: 850px; height: 12px; text-align: left;">

                                                                    <asp:Label ID="LB_Sql" runat="server" Visible="False"></asp:Label><asp:Label
                                                                        ID="LB_FileName" runat="server" Visible="False"></asp:Label>&#160;&#160;

                                                                <asp:Label ID="LB_TotalCount" runat="server"></asp:Label>
                                                                </td>
                                                            </tr>



                                                            <tr>

                                                                <td class="ItemAlignLeft">
                                                                    <table class="FullBorderTable" style="width: 100%">

                                                                        <tr>

                                                                            <td style="width: 100%; height: 21px; text-align: left;">

                                                                                <span><strong>
                                                                                    <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,WenJianShangChuan %>"></asp:Label>:</strong>
                                                                                </span>

                                                                                <asp:Label ID="Label1" runat="server" Visible="False"></asp:Label>
                                                                            </td>
                                                                        </tr>

                                                                        <tr>

                                                                            <td style="width: 100%; height: 25px; text-align: left;">
                                                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,LeiXing %>"></asp:Label>:
                                                                                       <asp:Label ID="LB_DocTypeID" runat="server"></asp:Label>
                                                                                <asp:TextBox ID="TB_DocType" runat="server" Width="125px"></asp:TextBox>
                                                                                <cc1:ModalPopupExtender ID="TB_DocType_ModalPopupExtender" runat="server"
                                                                                    Enabled="True" TargetControlID="TB_DocType" PopupControlID="Panel3"
                                                                                    CancelControlID="IMBT_Close" BackgroundCssClass="modalBackground" Y="150" DynamicServicePath="">
                                                                                </cc1:ModalPopupExtender>

                                                                                &#160;
                                                                                        <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,QuanXian %>"></asp:Label>:<asp:DropDownList ID="DL_Visible" runat="server" DataTextField="HomeName"
                                                                                            DataValueField="GroupName" CssClass="DDList">
                                                                                        </asp:DropDownList>

                                                                                &#160;
                                                                                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,ZuoZhe %>"></asp:Label>:<asp:TextBox ID="TB_Author" runat="server" Width="74px"></asp:TextBox>
                                                                            </td>
                                                                        </tr>

                                                                        <tr>
                                                                            <td style="width: 100%; text-align: left;">
                                                                                <div>
                                                                                    <asp:Label ID="Label10" Text="<%$ Resources:lang,WenJianShangChuan%>" runat="server"></asp:Label>:<br />
                                                                                    <asp:UpdatePanel ID="UpdatePanel12" runat="server" UpdateMode="Conditional">
                                                                                        <ContentTemplate>
                                                                                            <div>
                                                                                                <Upload:InputFile ID="AttachFile" runat="server" Width="300px" Height="22px" />

                                                                                                <asp:Button ID="BtnUP" runat="server" OnClick="BtnUP_Click" Text="<%$ Resources:lang,ShangChuan%>" />
                                                                                                <br />
                                                                                                <div id="ProgressBar">
                                                                                                    <Upload:ProgressBar ID="ProgressBar1" runat='server' Width="500px" Height="100px">
                                                                                                    </Upload:ProgressBar>
                                                                                                </div>
                                                                                            </div>
                                                                                        </ContentTemplate>
                                                                                        <Triggers>
                                                                                            <asp:PostBackTrigger ControlID="BtnUP" />
                                                                                        </Triggers>
                                                                                    </asp:UpdatePanel>
                                                                                </div>
                                                                                <br />
                                                                                <div id="uploader" class="wu-example">
                                                                                    <div id="thelist" class="uploader-list">
                                                                                        <asp:Label ID="Label11" Text="<%$ Resources:lang,DuWenJianShangZhuan%>" runat="server"></asp:Label>:
                                                                                    </div>
                                                                                    <div id="btns" class="btns">
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <div id="picker">
                                                                                                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,XuanZeWenJian%>"></asp:Label>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td style="padding-top: 10px; padding-left: 20px;">
                                                                                                    <button id="ctlBtn" class="btn btn-default">
                                                                                                        <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,ShangChuan%>"></asp:Label>
                                                                                                    </button>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 100%; text-align: left;"></td>
                                                                        </tr>

                                                                        <tr>

                                                                            <td style="width: 100%; text-align: left">

                                                                                <asp:CheckBox ID="CB_SMS" runat="server" Font-Bold="False" Font-Size="10pt" Text="<%$ Resources:lang,FaXinXi %>" /><asp:CheckBox
                                                                                    ID="CB_Mail" runat="server" Font-Bold="False" Font-Size="10pt" Text="<%$ Resources:lang,FaYouJian %>" />&#160;<asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,TongZhiXiangMuZuChengYuan %>"></asp:Label><br />

                                                                                <asp:TextBox ID="TB_Message" runat="server" Width="288px"></asp:TextBox>

                                                                                <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional">
                                                                                    <ContentTemplate>

                                                                                        <asp:Button ID="BT_Send" runat="server" Height="22px" OnClick="BT_Send_Click" Text="<%$ Resources:lang,FaSong %>"
                                                                                            CssClass="ButtonCss" Width="53px" />

                                                                                    </ContentTemplate>
                                                                                    <Triggers>
                                                                                        <asp:PostBackTrigger ControlID="BT_Send" />
                                                                                    </Triggers>
                                                                                </asp:UpdatePanel>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </cc1:TabPanel>
                                    <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="模板下载">
                                        <HeaderTemplate>
                                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,WenDangMoBan%>"></asp:Label>
                                        </HeaderTemplate>
                                        <ContentTemplate>

                                            <table style="width: 98%;" cellpadding="0" cellspacing="0" class="tableBorder">

                                                <tr>

                                                    <td style="width: 20%; text-align: left; border-right: solid 1px #d0d0d0;" valign="top">
                                                        <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>
                                                                <asp:TreeView ID="TreeView2" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView2_SelectedNodeChanged"
                                                                    Width="100%" ShowLines="True" Font-Size="10pt" Font-Bold="False" Font-Names="宋体">
                                                                    <RootNodeStyle CssClass="rootNode" />
                                                                    <NodeStyle CssClass="treeNode" />
                                                                    <LeafNodeStyle CssClass="leafNode" />
                                                                    <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                                                </asp:TreeView>
                                                            </ContentTemplate>
                                                            <Triggers>
                                                                <asp:PostBackTrigger ControlID="TreeView2" />
                                                            </Triggers>
                                                        </asp:UpdatePanel>
                                                    </td>

                                                    <td width="80%" class="ItemAlignLeft" style="padding-left: 5px; padding-top: 0px;" valign="top">
                                                        <asp:Label ID="Label286" runat="server" Text="<%$ Resources:lang,MuBanXiangMu%>"></asp:Label>:<asp:Label ID="LB_TemplateProjectID" runat="server"></asp:Label>
                                                        <asp:Label ID="Label299" runat="server" Text="<%$ Resources:lang,JiHuaBanBen%>"></asp:Label>:<asp:Label ID="LB_TemplatePlanVerID" runat="server"></asp:Label>
                                                        <asp:Label ID="Label390" runat="server" Text="<%$ Resources:lang,JiHua%>"></asp:Label>:<asp:Label ID="LB_TemplatePlanID" runat="server"></asp:Label>&#160;&#160;<asp:Label ID="Label3881" runat="server" Text="<%$ Resources:lang,DeWenDangLieBiao%>"></asp:Label>:

                                                    <table width="98%" cellpadding="0" cellspacing="0" class="ItemAlignLeft">

                                                        <tr>

                                                            <td>

                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">

                                                                    <tr>

                                                                        <td width="7">
                                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>

                                                                        <td>

                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                                                                <tr>

                                                                                    <td width="8%" class="ItemAlignLeft">

                                                                                        <strong>
                                                                                            <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,XuHao%>"></asp:Label></strong>
                                                                                    </td>

                                                                                    <td width="10%" class="ItemAlignLeft">

                                                                                        <strong>
                                                                                            <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,DaLei%>"></asp:Label></strong>
                                                                                    </td>

                                                                                    <td width="10%" class="ItemAlignLeft">

                                                                                        <strong>
                                                                                            <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label></strong>
                                                                                    </td>

                                                                                    <td width="33%" class="ItemAlignLeft">

                                                                                        <strong>
                                                                                            <asp:Label ID="Label35" runat="server" Text="<%$ Resources:lang,WenJianMing%>"></asp:Label></strong>
                                                                                    </td>

                                                                                    <td width="10%" class="ItemAlignLeft">

                                                                                        <strong>
                                                                                            <asp:Label ID="Label36" runat="server" Text="<%$ Resources:lang,ZuoZhe%>"></asp:Label></strong>
                                                                                    </td>

                                                                                    <td width="10%" class="ItemAlignLeft">

                                                                                        <strong>
                                                                                            <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,ShangChuanZhe%>"></asp:Label></strong>
                                                                                    </td>

                                                                                    <td width="20%" class="ItemAlignLeft">

                                                                                        <strong>
                                                                                            <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,ShangChuanShiJian%>"></asp:Label></strong>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>

                                                                        <td width="6" align="right">
                                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" /></td>
                                                                    </tr>
                                                                </table>

                                                                <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False"
                                                                    Height="1px" ShowHeader="False"
                                                                    Width="100%" CellPadding="4" ForeColor="#333333" GridLines="None">

                                                                    <Columns>

                                                                        <asp:BoundColumn DataField="DocID" HeaderText="SerialNumber">

                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="8%" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn DataField="RelatedType" HeaderText="MajorCategory">

                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn DataField="DocType" HeaderText="Type">

                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                        </asp:BoundColumn>

                                                                        <asp:HyperLinkColumn DataNavigateUrlField="Address" DataNavigateUrlFormatString="{0}"
                                                                            DataTextField="DocName" HeaderText="文件名" Target="_blank">

                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="33%" />
                                                                        </asp:HyperLinkColumn>

                                                                        <asp:BoundColumn DataField="Author" HeaderText="Author">

                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn DataField="UploadManName" HeaderText="上传者">

                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                                        </asp:BoundColumn>

                                                                        <asp:BoundColumn DataField="UploadTime" HeaderText="上传时间">

                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                                        </asp:BoundColumn>
                                                                    </Columns>

                                                                    <EditItemStyle BackColor="#2461BF" />

                                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />

                                                                    <ItemStyle CssClass="itemStyle" />

                                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />

                                                                    <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                </asp:DataGrid>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </cc1:TabPanel>
                                </cc1:TabContainer>
                                <br />
                            </td>
                        </tr>
                    </table>
                    <asp:Panel ID="Panel3" runat="server" CssClass="modalPopup" Style="display: none;">
                        <div class="modalPopup-text" style="width: 273px; height: 400px; overflow: auto;">
                            <table>
                                <tr>
                                    <td style="width: 220px; padding: 5px 5px 5px 5px;" valign="top" class="ItemAlignLeft">
                                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <asp:TreeView ID="TreeView3" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView3_SelectedNodeChanged"
                                                    ShowLines="True" Width="220px">
                                                    <RootNodeStyle CssClass="rootNode" />
                                                    <NodeStyle CssClass="treeNode" />
                                                    <LeafNodeStyle CssClass="leafNode" />
                                                    <SelectedNodeStyle CssClass="selectNode" ForeColor="Red" />
                                                </asp:TreeView>
                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="TreeView3" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                    </td>
                                    <td style="width: 60px; padding: 5px 5px 5px 5px;" valign="top" class="ItemAlignLeft">
                                        <asp:ImageButton ID="IMBT_Close" ImageUrl="ImagesSkin/Close4.jpg" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </asp:Panel>
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
