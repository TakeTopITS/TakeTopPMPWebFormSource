<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppInvolvedProjectDetailSAAS.aspx.cs" Inherits="TTAppInvolvedProjectDetailSAAS" %>


<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Import Namespace="System.Globalization" %>

<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />


    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script src="js/exif.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();// ��ʼ���������ع���  initSwipeBack();// ��ʼ���������ع���



            //ѡ��ͼƬ��ѹ��ͼƬ
            $("#AttachFile").change(function () {

                //alert("KKK");

                //console.log(this.files[0]);
                var _ua = window.navigator.userAgent;
                var _simpleFile = this.files[0];
                //�ж��Ƿ�ΪͼƬ
                if (!/\/(?:jpeg|png|gif|png|bmp)/i.test(_simpleFile.type)) return;

                //���exif.js��ȡiosͼƬ�ķ�����Ϣ
                var _orientation;
                //if (_ua.indexOf('iphone') > 0) {
                EXIF.getData(_simpleFile, function () {
                    _orientation = EXIF.getTag(this, 'Orientation');
                });
                //}

                //1.��ȡ�ļ���ͨ��FileReader����ͼƬ�ļ�ת��ΪDataURL����data:img/png;base64����ͷ��url������ֱ�ӷ���image.src��;
                var _reader = new FileReader(),
                    _img = new Image(),
                    _url;

                _reader.onload = function () {
                    _img.onload = function () {
                        var data = compress(_img);
                        $("#imgData").val(compress(_img, _orientation));
                    };
                    _url = this.result;
                    _img.src = _url;
                };
                _reader.readAsDataURL(_simpleFile);
            });

        });



        /**
         * ����ͼƬ�ĳߴ磬���ݳߴ�ѹ��
         * 1. iphone�ֻ�html5�ϴ�ͼƬ�������⣬����exif.js
         * 2. ��׿UC�������֧�� new Blob()��ʹ��BlobBuilder
         * @param {Object} _img     ͼƬ
         * @param {Number} _orientation ��Ƭ��Ϣ
         * @return {String}       ѹ����base64��ʽ��ͼƬ
         */
        function compress(_img, _orientation) {
            //2.�������Ŀ��ߴ����ֵ�����ϴ�ͼƬ�Ŀ��߶�����Ŀ��ͼ����Ŀ��ͼ�ȱ�ѹ���������һ��С�ڣ����ϴ�ͼƬ�ȱȷŴ�
            var _goalWidth = 640,         //Ŀ�����
                _goalHeight = 480,         //Ŀ��߶�
                _imgWidth = _img.naturalWidth,   //ͼƬ����
                _imgHeight = _img.naturalHeight,  //ͼƬ�߶�
                _tempWidth = _imgWidth,      //�Ŵ����С�����ʱ����
                _tempHeight = _imgHeight,     //�Ŵ����С�����ʱ����
                _r = 0;              //ѹ����

            if (_imgWidth > _goalWidth || _imgHeight > _goalHeight) {//����ߴ���Ŀ��ͼ����ȱ�ѹ��
                _r = _imgWidth / _goalWidth;
                if (_imgHeight / _goalHeight < _r) {
                    _r = _imgHeight / _goalHeight;
                }
                _tempWidth = Math.ceil(_imgWidth / _r);
                _tempHeight = Math.ceil(_imgHeight / _r);
            }

            //3.����canvas��ͼƬ���вü����ȱȷŴ����С����о��вü�
            var _canvas = $("#myCanvas")[0];

            var _context = _canvas.getContext('2d');
            _canvas.width = _tempWidth;
            _canvas.height = _tempHeight;
            var _degree;

            //ios bug��iphone�ֻ��Ͽ��ܻ�����ͼƬ�����������
            switch (_orientation) {
                //iphone�������㣬��ʱhome�������
                case 3:
                    _degree = 180;
                    _tempWidth = -_imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone�������㣬��ʱhome�����·�(�������ֻ��ķ���)
                case 6:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 90;
                    _tempWidth = _imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone�������㣬��ʱhome�����Ϸ�
                case 8:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 270;
                    _tempWidth = -_imgWidth;
                    _tempHeight = _imgHeight;
                    break;
            }
            //if (window.navigator.userAgent.indexOf('iphone') > 0 && !!_degree) {
            if (!!_degree) {
                _context.rotate(_degree * Math.PI / 180);
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            } else {
                _context.drawImage(_img, 0, 0, _tempWidth, _tempHeight);
            }
            //toDataURL���������Ի�ȡ��ʽΪ"data:image/png;base64,***"��base64ͼƬ��Ϣ��
            var _data = _canvas.toDataURL('image/jpeg');
            return _data;
        }

        function upload() {
            $.ajax({
                //�ύ���ݵ����� POST GET
                type: "POST",
                //�ύ����ַ
                url: "Handler/UploadPhotoToServerSite.ashx",
                //�ύ������
                data: { FileData: $("#imgData").val(), FileName: $("#AttachFile").val() },
                //�������ݵĸ�ʽ
                //������֮ǰ���õĺ���
                beforeSend: function () {
                    $("#IMG_Waiting").show();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                },
                //�ɹ�����֮����õĺ���             
                success: function (data) {
                    if (data.indexOf("img") > 0) {

                        $(document.getElementsByTagName("iframe")[0]).contents().find("body").append(data);
                    }
                    else {
                        alert(data);
                    }
                },
                //����ִ�к���õĺ���
                complete: function (XMLHttpRequest, textStatus) {
                    $("#IMG_Waiting").hide();
                }
            });
        }
    </script>
</head>
<body class="napbac" data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    <!-- ���������� -->
    <canvas id="myCanvas" style="display: none;"></canvas>
        <form id="form1" runat="server" method="post" enctype="multipart/form-data" class="napf">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0">
                        <tr>
                            <td height="31" class="page_topbj">
                                <table width="94%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <%--<a href="TTAppProject.aspx" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">--%>
                                            <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <img src="ImagesSkin/return.png" alt="" />
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                            <asp:Label runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="���Ժ򣬴�����..." style="display: none;" />
                                            </a>
                                        </td>
                                        <td class="ItemAlignLeft" style="padding-top: 3px;">
                                            <%-- <asp:ImageButton ID="IB_ProPlanGanttNew" CssClass="inpu" ImageUrl="ImagesSkin/plan.png" Width="32px" Height="32px" runat="server" OnClick="IB_ProPlanGanttNew_Click"></asp:ImageButton>--%>

                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <div class="napbox">
                                    <div class="npbx">
                                        <div class="cline"></div>
                                        <div class="npbxs">
                                            <h3>
                                                <asp:Label ID="LB_TodaySummary" runat="server" Text="<%$ Resources:lang,TodaySummary%>" /></h3>

                                            <div class="mline">
                                                <h4>
                                                    <asp:Label ID="LB_Progress" runat="server" Text="<%$ Resources:lang,Progress%>" /></h4>

                                                <NickLee:NumberBox ID="NB_FinishPercent" runat="server" Width="94%" MaxAmount="100" MinAmount="0">0.00</NickLee:NumberBox>
                                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="%"></asp:Label>
                                            </div>
                                            <div class="mline">
                                                <h4>
                                                    <asp:Label ID="LB_ManHour" runat="server" Text="<%$ Resources:lang,ManHour%>" /></h4>

                                                <NickLee:NumberBox MaxAmount="1000000000000" ID="NB_ManHour" runat="server" Width="94%" MinAmount="0">0.00</NickLee:NumberBox>
                                            </div>
                                        </div>

                                        <div class="npbxs">

                                            <h3>
                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZongJie %>"></asp:Label></h3>
                                            <br />
                                            <CKEditor:CKEditorControl ID="HE_TodaySummary" runat="server" Toolbar="" Width="99%" Height="270" Visible="false" />

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
                                                                    <img id="IMG_Uploading" src="Images/Processing.gif" alt="���Ժ򣬴�����..." style="display: none;" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <br />  <br />
                                                    </div>
                                                </ContentTemplate>
                                                <Triggers>
                                                    <%--  <asp:PostBackTrigger ControlID="BtnUP" />--%>
                                                </Triggers>
                                            </asp:UpdatePanel>


                                            <div class="manyspan" style="display: none;">

                                                <asp:CheckBox ID="CB_ReturnMsg" runat="server" Font-Bold="False" Text="<%$ Resources:lang,SendSMS%>" /><asp:CheckBox
                                                    ID="CB_ReturnMail" runat="server" Font-Bold="False" Text="<%$ Resources:lang,SendEMail%>" />
                                                <asp:Label ID="LB_NoticeProjectCreator" runat="server" Text="<%$ Resources:lang,NoticeProjectCreator%>" />
                                                <br />
                                                <asp:TextBox ID="TB_Message" runat="server" Width="45%"></asp:TextBox>

                                                <asp:Button ID="BT_Send" runat="server" CssClass="inpu" OnClick="BT_Send_Click" Text="<%$ Resources:lang,Send%>" />
                                            </div>

                                            <div class="equal-buttons">
                                                <asp:Button ID="BT_Summit" runat="server" CssClass="inpu" OnClick="BT_Summit_Click" Text="<%$ Resources:lang,Submit%>" />

                                                <asp:Button ID="BT_Receive" runat="server" Text="<%$ Resources:lang,ProjectAgree%>"
                                                    CssClass="inpu" OnClick="BT_Receive_Click" Visible="false" />
                                                <asp:Button ID="BT_Refuse" runat="server" Text="<%$ Resources:lang,Refuse%>" OnClick="BT_Refuse_Click"
                                                    CssClass="inpu" Visible="false" />
                                                <asp:Button ID="BT_Activity" runat="server" Text="<%$ Resources:lang,ChuLiZhong%>" CssClass="inpu"
                                                    OnClick="BT_Activity_Click" Visible="false" />
                                            </div>

                                            <div style="width: 100%; text-align: center; vertical-align: bottom;">
                                                <h4>
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <asp:HyperLink ID="HL_DailyWorkReport" runat="server" Text="<%$ Resources:lang,hlDailyWorkReport%>"></asp:HyperLink>

                                                </h4>
                                            </div>

                                        </div>
                                    </div>
                            </td>

                        </tr>




                        <tr>
                            <td class="ItemAlignLeft" style="padding: 2px 2px 2px 2px;">
                                <table cellpadding="0" cellspacing="0" width="100%" class="ItemAlignLeft">

                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>

                                                        <table width="100%" cellpadding="4" cellspacing="0" style="display: none;">
                                                            <tr>
                                                                <td>

                                                                    <table width="80%">
                                                                        <tr>
                                                                            <td width="40px">
                                                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,ChengGuo%>"></asp:Label>:</td>
                                                                            <td style="padding-left: 10px;">
                                                                                <asp:TextBox ID="TB_Achievement" runat="server" Height="40px" TextMode="MultiLine" Width="99%"></asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <asp:HyperLink ID="HL_Expense" runat="server" NavigateUrl="TTProExpense.aspx"
                                                                        Text="<%$ Resources:lang,ExpenseDetailAndReimburse%>"></asp:HyperLink>
                                                                    &nbsp;
                                                                                    <asp:HyperLink ID="HyperLink1" runat="server" Font-Bold="True" Text="<%$ Resources:lang,XiangMuWenKong%>"></asp:HyperLink>
                                                                    &nbsp;
                                                                                <asp:HyperLink ID="HL_RelatedReq" runat="server" NavigateUrl="TTProRelatedReqSummary.aspx"
                                                                                    Font-Bold="True" Text="<%$ Resources:lang,XiangMuXuQiu%>"></asp:HyperLink>
                                                                    &nbsp;
                                                                                <asp:HyperLink ID="HL_AssignTask" runat="server" Font-Bold="True"
                                                                                    Text="<%$ Resources:lang,hlAssignTask%>"></asp:HyperLink>
                                                                    &nbsp;&nbsp;<asp:HyperLink ID="HL_ExpenseApplyWL" runat="server" Font-Bold="True"
                                                                        Text="<%$ Resources:lang,hlApplyFunding%>"></asp:HyperLink>
                                                                    &nbsp;&nbsp;<asp:HyperLink ID="HyperLink2" runat="server" Font-Bold="True" Text="<%$ Resources:lang,XiangMuChengBen%>"></asp:HyperLink>
                                                                    &nbsp;&nbsp;<asp:HyperLink ID="HyperLink3" runat="server" Font-Bold="True" Text="<%$ Resources:lang,XiangMuRenLiZiYuanGuanLi%>"></asp:HyperLink>
                                                                    &nbsp;&nbsp;<asp:HyperLink ID="HL_AssignMeeting" runat="server" Font-Bold="True"
                                                                        Text="<%$ Resources:lang,hlArrangeMeeting%>"></asp:HyperLink>
                                                                    &nbsp;&nbsp;<asp:HyperLink ID="HL_WorkPlan" runat="server" Font-Bold="True"
                                                                        Text="<%$ Resources:lang,hlImplementPlan%>"></asp:HyperLink>
                                                                    &nbsp; &nbsp;<asp:HyperLink ID="HL_MakeCollaborationThirdPart" runat="server" NavigateUrl="~/TTMakeCollaboration.aspx"
                                                                        Font-Bold="True" Text="<%$ Resources:lang,hlMakeCollaboration%>"></asp:HyperLink></td>
                                                            </tr>
                                                            <tr style="height: 15px">
                                                                <td style="text-align: left; height: 5px;">
                                                                    <asp:HyperLink ID="HL_RelatedDoc" runat="server" NavigateUrl="TTProRelatedDoc.aspx" Text="<%$ Resources:lang,ProjectDocument%>"></asp:HyperLink>
                                                                    &nbsp;<asp:HyperLink ID="HL_RelatedRisk" runat="server" NavigateUrl="~/TTProRelatedRisk.aspx" Text="<%$ Resources:lang,ProjectRisk%>"></asp:HyperLink>
                                                                    &nbsp;<asp:HyperLink ID="HL_RelatedUser" runat="server" NavigateUrl="TTProRelatedUser.aspx" Text="<%$ Resources:lang,ProjectMember%>"></asp:HyperLink>
                                                                    &nbsp;
                                                                                    <asp:HyperLink ID="HL_ProjectAssetPurchase" runat="server" Text="<%$ Resources:lang,AssetPurchaseRequest%>"></asp:HyperLink>
                                                                    &nbsp;
                                                                                    <asp:HyperLink ID="HL_ProjectAssetApplication" runat="server" Text="<%$ Resources:lang,AssetApplication%>"></asp:HyperLink>
                                                                    &nbsp;<asp:HyperLink ID="HL_RelatedContactInfor" runat="server" Text="<%$ Resources:lang,ProjectContact%>"></asp:HyperLink>
                                                                    &nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="text-align: left">
                                                                    <asp:HyperLink ID="HL_RelatedConstract" runat="server" NavigateUrl="TTProjectRelatedConstract.aspx"
                                                                        Text="<%$ Resources:lang,Contract%>"></asp:HyperLink>&nbsp; &nbsp;<asp:HyperLink ID="HL_LeadReview" runat="server" NavigateUrl="TTLeadReviewSummary.aspx"
                                                                            Text="<%$ Resources:lang,LeadReviewSummary%>"></asp:HyperLink>
                                                                    &nbsp;<asp:HyperLink ID="HL_StatusChangeRecord" runat="server" NavigateUrl="TTUserFeebackSummary.aspx"
                                                                        Text="<%$ Resources:lang,StatusChangeRecord%>"></asp:HyperLink>
                                                                    &nbsp;<asp:HyperLink ID="HL_TransferProject" runat="server" NavigateUrl="~/TTTransferProjectRecord.aspx"
                                                                        Text="<%$ Resources:lang,PMChangeRecord%>"></asp:HyperLink>&nbsp;<asp:HyperLink
                                                                            ID="HL_ProjectMeeting" runat="server" NavigateUrl="~/TTTransferProjectRecord.aspx"
                                                                            Text="<%$ Resources:lang,ProjectMeetingSummary%>"></asp:HyperLink>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <br />
                                                        <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label><asp:Label
                                                            ID="LB_UserName" runat="server" Visible="False"></asp:Label><asp:Label
                                                                ID="LB_ProjectID" runat="server" Visible="False"></asp:Label>
                                                        <asp:Label ID="LB_PMCode" runat="server" Visible="False"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr style="height: 15px; display: none;">
                                        <td style="text-align: left;" width="100%">
                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td class="ItemAlignLeft">
                                                        <asp:DataList ID="DataList2" runat="server" Height="1px" CellPadding="0"
                                                            Width="100%">
                                                            <ItemTemplate>
                                                                <table width="100%" cellpadding="4" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <%#DataBinder .Eval (Container .DataItem,"WorkDetail") %>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:Label ID="LB_WorkStatus" runat="server" Text="<%$ Resources:lang,WorkStatus%>" />:<span><%#DataBinder .Eval (Container .DataItem,"Status") %></td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemStyle" />
                                                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                            <SelectedItemStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                            <AlternatingItemStyle BackColor="White" ForeColor="#284775" />
                                                        </asp:DataList>
                                                    </td>
                                                </tr>
                                            </table>
                                            <NickLee:NumberBox MaxAmount="1000000000000" ID="TB_Charge" runat="server" Width="67px" Visible="False">0.00</NickLee:NumberBox>&nbsp;
                                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,DiDian%>"></asp:Label>

                                            <asp:TextBox ID="TB_WorkAddress" runat="server" Width="250px"></asp:TextBox>

                                            <asp:DropDownList ID="DL_Authority" runat="server">
                                                <asp:ListItem Value="NO" Text="<%$ Resources:lang,BaoMi%>" />
                                                <asp:ListItem Value="YES" Text="<%$ Resources:lang,GongKai%>" />
                                            </asp:DropDownList>

                                            <asp:Label ID="LB_WorkID" runat="server" Text="-1" Visible="False"></asp:Label>
                                            <asp:DataList ID="DataList1" runat="server" Height="1px" CellPadding="0" ForeColor="#333333"
                                                Width="98%" Style="display: none;">
                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                <HeaderTemplate>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                        <tr>
                                                            <td width="7">
                                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                            </td>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td width="5%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLProjectID" runat="server" Text="<%$ Resources:lang,ProjectID%>" /></strong>
                                                                        </td>
                                                                        <td width="18%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLProjectName" runat="server" Text="<%$ Resources:lang,ProjectName%>" /></strong>
                                                                        </td>
                                                                        <td width="6%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLProjectType" runat="server" Text="<%$ Resources:lang,ProjectType%>" /></strong>
                                                                        </td>
                                                                        <td width="6%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLProjectCreator" runat="server" Text="<%$ Resources:lang,ProjectCreator%>" /></strong>
                                                                        </td>
                                                                        <td width="6%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_CustomerPM" runat="server" Text="<%$ Resources:lang,CustomerPM%>" /></strong>
                                                                        </td>
                                                                        <td width="6%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLBudget" runat="server" Text="<%$ Resources:lang,Budget%>" /></strong>
                                                                        </td>
                                                                        <td width="5%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLManHour" runat="server" Text="<%$ Resources:lang,ManHour%>" /></strong>
                                                                        </td>
                                                                        <td width="5%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLManPower" runat="server" Text="<%$ Resources:lang,ManPower%>" /></strong>
                                                                        </td>
                                                                        <td width="6%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLStartTime" runat="server" Text="<%$ Resources:lang,StartTime%>" /></strong>
                                                                        </td>
                                                                        <td width="6%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLEndTime" runat="server" Text="<%$ Resources:lang,EndTime%>" /></strong>
                                                                        </td>
                                                                        <td width="6%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="LB_DLCreateTime" runat="server" Text="<%$ Resources:lang,CreateTime%>" /></strong>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="6" align="right">
                                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <table cellpadding="4" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td style="width: 5%; text-align: center;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem ,"ProjectID") %>
                                                            </td>
                                                            <td style="width: 18%; text-align: left; padding-left: 5px" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"ProjectName") %>
                                                            </td>
                                                            <td style="width: 6%;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"ProjectType") %>
                                                            </td>
                                                            <td style="width: 6%;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"UserName") %>
                                                            </td>
                                                            <td style="width: 6%;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"CustomerPMName") %>
                                                            </td>
                                                            <td style="width: 6%;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"Budget") %>
                                                            </td>
                                                            <td style="width: 5%;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"ManHour") %>
                                                            </td>
                                                            <td style="width: 5%;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"ManNumber") %>
                                                            </td>
                                                            <td style="width: 6%;" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem, "BeginDate","{0:yyyy/MM/dd}") %>
                                                            </td>
                                                            <td style="width: 6%;" class="tdLeft">
                                                                <%#DataBinder.Eval(Container.DataItem, "EndDate", "{0:yyyy/MM/dd}")%>
                                                            </td>
                                                            <td style="width: 6%; text-align: center" class="tdRight">
                                                                <%#DataBinder.Eval(Container.DataItem, "MakeDate", "{0:yyyy/MM/dd}")%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 5%; text-align: center; font-size: 10pt" class="tdLeft">
                                                                <asp:Label ID="LB_DLDescription" runat="server" Text="<%$ Resources:lang,Description%>" />
                                                            </td>
                                                            <td colspan="10" style="text-align: left; padding-left: 5px" class="tdRight">
                                                                <%#DataBinder .Eval (Container .DataItem,"ProjectDetail") %>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 5%; text-align: center; font-size: 10pt" class="tdLeft">
                                                                <asp:Label ID="LB_DLAcceptanceStandard" runat="server" Text="<%$ Resources:lang,AcceptanceStandard%>" />
                                                            </td>
                                                            <td colspan="10" style="text-align: left; padding-left: 5px" class="tdRight">
                                                                <%#DataBinder .Eval (Container .DataItem,"AcceptStandard") %>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 5%; text-align: center; font-size: 10pt" class="tdLeft">
                                                                <asp:Label ID="LB_DLStatus" runat="server" Text="<%$ Resources:lang,Status%>" />
                                                            </td>
                                                            <td style="text-align: left; padding-left: 5px" class="tdLeft">
                                                                <%#DataBinder .Eval (Container .DataItem,"Status") %>&nbsp;&nbsp;
                                                            </td>
                                                            <td style="width: 5%; text-align: center; font-size: 10pt" class="tdLeft">
                                                                <asp:Label ID="LB_StatusValue" runat="server" Text="<%$ Resources:lang,StatusValue%>" />:
                                                            </td>
                                                            <td colspan="8" style="text-align: left; padding-left: 5px" class="tdRight">
                                                                <%#DataBinder .Eval (Container .DataItem,"StatusValue") %>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />

                                                <ItemStyle CssClass="itemStyle" />
                                            </asp:DataList>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                            </td>
                        </tr>
                    </table>
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
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>
