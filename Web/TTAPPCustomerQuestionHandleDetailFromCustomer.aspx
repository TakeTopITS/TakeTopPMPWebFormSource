<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPCustomerQuestionHandleDetailFromCustomer.aspx.cs" Inherits="TTAPPCustomerQuestionHandleDetailFromCustomer" %>


<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=0.1; user-scalable=1" />
<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload"
    TagPrefix="Upload" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
       
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script src="js/exif.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript">

        //页面加载完成,ajax回发加载完成后执行的操作，传入一个funtion
        //$load调用示例
        //$load(function () {
        //    //需要页面加载完成执行的代码
        //});
        var $load = function (loadFunc) {
            $(function () {
                initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能
                if (typeof (Sys) != 'undefined') {
                    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(loadFunc);
                }
                else {
                    loadFunc();
                }
            });
        };

        $load(function () {
            /*  if (top.location != self.location) { } else { CloseWebPage(); }*/

            //选择图片后压缩图片
            $("#AttachFile").change(function () {

                //alert("KKK");

                //console.log(this.files[0]);
                var _ua = window.navigator.userAgent;
                var _simpleFile = this.files[0];
                //判断是否为图片
                if (!/\/(?:jpeg|png|gif|png|bmp)/i.test(_simpleFile.type)) return;

                //插件exif.js获取ios图片的方向信息
                var _orientation;
                //if (_ua.indexOf('iphone') > 0) {
                EXIF.getData(_simpleFile, function () {
                    _orientation = EXIF.getTag(this, 'Orientation');
                });
                //}



                //1.读取文件，通过FileReader，将图片文件转化为DataURL，即data:img/png;base64，开头的url，可以直接放在image.src中;
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

            // 移动端初始化
            initMobileUI();

            // 优化弹窗按钮
            enhancePopupButtons();

            // 弹窗适配移动端
            adaptPopupForMobile();

        });



        /**
         * 计算图片的尺寸，根据尺寸压缩
         * 1. iphone手机html5上传图片方向问题，借助exif.js
         * 2. 安卓UC浏览器不支持 new Blob()，使用BlobBuilder
         * @param {Object} _img     图片
         * @param {Number} _orientation 照片信息
         * @return {String}       压缩后base64格式的图片
         */
        function compress(_img, _orientation) {
            //2.计算符合目标尺寸宽高值，若上传图片的宽高都大于目标图，对目标图等比压缩；如果有一边小于，对上传图片等比放大。
            var _goalWidth = 640,         //目标宽度
                _goalHeight = 480,         //目标高度
                _imgWidth = _img.naturalWidth,   //图片宽度
                _imgHeight = _img.naturalHeight,  //图片高度
                _tempWidth = _imgWidth,      //放大或缩小后的临时宽度
                _tempHeight = _imgHeight,     //放大或缩小后的临时宽度
                _r = 0;              //压缩比

            if (_imgWidth > _goalWidth || _imgHeight > _goalHeight) {//宽或高大于目标图，需等比压缩
                _r = _imgWidth / _goalWidth;
                if (_imgHeight / _goalHeight < _r) {
                    _r = _imgHeight / _goalHeight;
                }
                _tempWidth = Math.ceil(_imgWidth / _r);
                _tempHeight = Math.ceil(_imgHeight / _r);
            }

            //3.利用canvas对图片进行裁剪，等比放大或缩小后进行居中裁剪
            var _canvas = $("#myCanvas")[0];

            var _context = _canvas.getContext('2d');
            _canvas.width = _tempWidth;
            _canvas.height = _tempHeight;
            var _degree;

            //ios bug，iphone手机上可能会遇到图片方向错误问题
            switch (_orientation) {
                //iphone横屏拍摄，此时home键在左侧
                case 3:
                    _degree = 180;
                    _tempWidth = -_imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone竖屏拍摄，此时home键在下方(正常拿手机的方向)
                case 6:
                    _canvas.width = _imgHeight;
                    _canvas.height = _imgWidth;
                    _degree = 90;
                    _tempWidth = _imgWidth;
                    _tempHeight = -_imgHeight;
                    break;
                //iphone竖屏拍摄，此时home键在上方
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
            //toDataURL方法，可以获取格式为"data:image/png;base64,***"的base64图片信息；
            var _data = _canvas.toDataURL('image/jpeg');
            return _data;
        }

        function upload() {

            $.ajax({
                //提交数据的类型 POST GET
                type: "POST",
                //提交的网址
                url: "Handler/UploadPhotoToServerSite.ashx",
                //提交的数据
                data: { FileData: $("#imgData").val(), FileName: $("#AttachFile").val() },
                //返回数据的格式
                //在请求之前调用的函数
                beforeSend: function () {
                    $("#IMG_Waiting").show();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log(XMLHttpRequest);
                },
                //成功返回之后调用的函数             
                success: function (data) {

                    if (data.indexOf("img") > 0) {

                        $(document.getElementsByTagName("iframe")[2]).contents().find("body").append(data);
                    }
                    else {
                        alert(data);
                    }
                },
                //调用执行后调用的函数
                complete: function (XMLHttpRequest, textStatus) {
                    $("#IMG_Waiting").hide();
                }
            });
        }

        function displayXuQiu() {
            if (this.document.getElementById('div_xuqiu').style.display == "block") {

                this.document.getElementById('div_xuqiu').style.display = "none";

            }
            else {

                this.document.getElementById('div_xuqiu').style.display = "block"

            }
        }

        function initMobileUI() {
            // 移动端UI初始化
            $('.mobile-button').on('touchstart', function () {
                $(this).css('opacity', '0.8');
            }).on('touchend', function () {
                $(this).css('opacity', '1');
            });
        }

        function showModal(modalId) {
            $('#' + modalId).show();
        }

        function hideModal() {
            $('.mobile-modal').hide();
        }

        function enhancePopupButtons() {
            // 为弹窗按钮添加触摸反馈
            $('.popup-button, .layui-layer-btn a').addClass('touch-feedback');

            // 确保按钮有正确的大小和间距
            $('.layui-layer-btn').css({
                'display': 'flex',
                'justify-content': 'space-between',
                'gap': '10px'
            });

            $('.layui-layer-btn a, .layui-layer-btn .popup-button').css({
                'flex': '1',
                'margin': '0'
            });
        }

        function adaptPopupForMobile() {
            // 弹窗显示时调整位置和大小
            $(document).on('click', '[data-popup]', function () {
                setTimeout(function () {
                    var $popup = $('.layui-layer-iframe:visible');
                    if ($popup.length) {
                        var windowHeight = $(window).height();
                        var popupHeight = Math.min(windowHeight - 40, 600);

                        $popup.css({
                            'top': '20px',
                            'left': '50%',
                            'transform': 'translateX(-50%)',
                            'width': '95%',
                            'height': popupHeight + 'px',
                            'max-width': '500px'
                        });

                        // 确保内容可滚动
                        var contentHeight = popupHeight - 120; // 减去标题和底部按钮的高度
                        $popup.find('.layui-layer-content').css({
                            'max-height': contentHeight + 'px',
                            'overflow-y': 'auto'
                        });
                    }
                }, 100);
            });
        }

        // 确保popClose函数存在
        if (typeof popClose !== 'function') {
            function popClose() {
                $('.layui-layer-iframe:visible').hide();
                $('#popwindow_shade').hide();
                return false;
            }
        }

    </script>
</head>
<body>
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    <!-- 滑动反馈层 -->
    <canvas id="myCanvas" style="display: none;"></canvas>

    <div class="mobile-container">
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>

            <!-- 移动端头部 -->
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
                                                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,Back%>" />
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
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <!-- 服务需求部分 -->
                        <div id="div_xuqiu" runat="server" class="mobile-section">
                            <div style="text-align: right; margin-bottom: 10px;">
                                <asp:Button ID="BT_Create" runat="server" CssClass="inpu" OnClick="BT_Create_Click" Text="<%$ Resources:lang,XuQiu%>" />
                            </div>

                            <!-- 服务需求列表 -->
                            <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False" GridLines="None"
                                OnItemCommand="DataGrid4_ItemCommand"
                                AllowCustomPaging="false" ShowHeader="False"
                                Width="100%">
                                <ItemStyle CssClass="data-item" />
                                <Columns>
                                    <asp:TemplateColumn>
                                        <ItemTemplate>
                                            <div class="data-row">
                                                <div class="data-label">
                                                    <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,BianHao%>" />:
                                                </div>
                                                <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "ID") %></div>
                                            </div>

                                            <div class="data-row">
                                                <div class="data-label">
                                                    <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,LeiBie%>" />:
                                                </div>
                                                <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "Type") %></div>
                                            </div>

                                            <div class="data-row">
                                                <div class="data-label">
                                                    <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,WenTi%>" />:
                                                </div>
                                                <div class="data-value">
                                                    <a href='TTCustomerQuestionHandleDetail.aspx?ID=<%# DataBinder.Eval(Container.DataItem, "ID") %>' target="_blank">
                                                        <%# DataBinder.Eval(Container.DataItem, "Question") %>
                                                    </a>
                                                </div>
                                            </div>

                                            <div class="data-row">
                                                <div class="data-label">
                                                    <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,ShouLiRen%>" />:
                                                </div>
                                                <div class="data-value">
                                                    <a href='TTUserInforSimple.aspx?UserCode=<%# DataBinder.Eval(Container.DataItem, "OperatorCode") %>' target="_blank">
                                                        <%# DataBinder.Eval(Container.DataItem, "OperatorName") %>
                                                    </a>
                                                </div>
                                            </div>

                                            <div class="data-row">
                                                <div class="data-label">
                                                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,ZhuangTai%>" />:
                                                </div>
                                                <div class="data-value status-badge">
                                                    <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("OperatorStatus").ToString()) %>
                                                </div>
                                            </div>

                                            <div class="action-icons" style="display: none;">
                                                <asp:ButtonColumn ButtonType="LinkButton" CommandName="Update" Text="&lt;div class='action-icon'&gt;&lt;img src='ImagesSkin/Update.png' style='width:20px;height:20px;' /&gt;&lt;/div&gt;">
                                                    <itemstyle width="30px" />
                                                </asp:ButtonColumn>
                                                <asp:TemplateColumn>
                                                    <itemtemplate>
                                                        <div onclick="return showSimpleDeleteModal(this, event);" class="action-icon" title="Delete">
                                                            <img src="ImagesSkin/Delete.png" style="width: 20px; height: 20px;" />
                                                        </div>
                                                        <asp:LinkButton ID="LBT_Delete" CommandName="Delete" runat="server" Style="display: none;"></asp:LinkButton>
                                                    </itemtemplate>
                                                    <itemstyle width="30px" />
                                                </asp:TemplateColumn>
                                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ID", "TTCustomerQuestionRelatedDoc.aspx?RelatedID={0}") %>' Target="_blank" CssClass="action-icon">
                                                    <img src="ImagesSkin/UpLoad.jpg" style="width:20px;height:20px;" />
                                                </asp:HyperLink>
                                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ID", "TTDocumentTreeView.aspx?RelatedType=CustomerQuestion&RelatedID={0}") %>' Target="_blank" CssClass="action-icon">
                                                    <img src="ImagesSkin/Doc.gif" style="width:20px;height:20px;" />
                                                </asp:HyperLink>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                            </asp:DataGrid>

                            <!-- 服务处理按钮 -->
                            <div style="margin-top: 15px;">
                                <div class="mobile-form-group">
                                    <div class="mobile-label">
                                        <asp:Label ID="Label48" runat="server" Text="<%$ Resources:lang,FuWuChuLiXiJie%>" />
                                    </div>
                                </div>

                                <div class="mobile-form-group">
                                    <div class="mobile-label">
                                        <asp:Label ID="Label51" runat="server" Text="<%$ Resources:lang,CYHSJ%>" />
                                    </div>
                                    <asp:DropDownList ID="DL_IsImportant" runat="server" CssClass="mobile-dropdown" AutoPostBack="true" OnSelectedIndexChanged="DL_IsImportant_SelectedIndexChanged">
                                        <asp:ListItem>NO</asp:ListItem>
                                        <asp:ListItem>YES</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="mobile-form-group">
                                    <div class="mobile-label">
                                        <asp:Label ID="Label49" runat="server" Text="<%$ Resources:lang,ZhiJieChengYuan%>" />
                                    </div>
                                    <asp:DropDownList ID="DL_Operator" runat="server" CssClass="mobile-dropdown" DataTextField="UserName" DataValueField="UserCode">
                                    </asp:DropDownList>
                                </div>

                                <div class="equal-buttons">
                                    <asp:Button ID="BT_Accept" runat="server" CssClass="inpu" OnClick="BT_Accept_Click" Text="<%$ Resources:lang,ShouLi%>" />
                                    <asp:Button ID="BT_Exit" runat="server" CssClass="inpu" OnClick="BT_Exit_Click" Text="<%$ Resources:lang,TuiChuShouLi%>" />
                                    <asp:Button ID="BT_Finish" runat="server" CssClass="inpu" OnClick="BT_Finish_Click" Text="<%$ Resources:lang,WanCheng%>" />
                                    <asp:Button ID="BT_TransferOperator" runat="server" CssClass="inpu" OnClick="BT_TransferOperator_Click" Text="<%$ Resources:lang,ZhiDingWeiShouLiRen%>" />
                                </div>

                                <div style="margin-top: 10px; display: none;">
                                    <asp:HyperLink ID="HL_RelatedDoc" runat="server" NavigateUrl="TTCollaborationRelatedDoc.aspx" Text="<%$ Resources:lang,XiangGuanWenJian%>"
                                        Target="_blank" CssClass="inpu">
                                    </asp:HyperLink>
                                    <asp:HyperLink ID="HL_Expense" runat="server" NavigateUrl="TTProExpense.aspx" Text="<%$ Resources:lang,FeiYongMingXiYuBaoXiao%>"
                                        Target="_blank" CssClass="inpu">
                                    </asp:HyperLink>
                                    <asp:HyperLink ID="HL_ResoveResultReview"
                                        runat="server" NavigateUrl="TTCustomerQuestionResultReviewWF.aspx" Text="<%$ Resources:lang,TiJiaoPingShen%>"
                                        Target="_blank" CssClass="inpu">
                                    </asp:HyperLink>
                                </div>
                            </div>
                        </div>

                        <!-- 处理记录部分 -->
                        <div class="mobile-section">
                            <div style="text-align: right; margin-bottom: 10px;">
                                <asp:Button ID="BT_CreateRecord" runat="server" Text="<%$ Resources:lang,New%>" CssClass="inpu" OnClick="BT_CreateRecord_Click" />
                                <asp:Label ID="LB_QuestionID" runat="server" Visible="false"></asp:Label>
                            </div>

                            <asp:DataList ID="DataList3" runat="server" CellPadding="0" ForeColor="#333333" OnItemCommand="DataList3_ItemCommand"
                                Height="1px" Width="100%">
                                <ItemTemplate>
                                    <div class="data-item">
                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,BianHao%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "ID") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,LianXiRen%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "CustomerAcceptor") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,LianXiFangShi%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "AcceptorContactWay") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,FuWuFangFa%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "HandleWay") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,ChuLiShiJian%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "HandleTime","{0:yyyy/MM/dd HH:mm}") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,YongShiChangDu%>" />:
                                            </div>
                                            <div class="data-value">
                                                <%# DataBinder.Eval(Container.DataItem, "UsedTime") %>
                                                <%# DataBinder.Eval(Container.DataItem, "TimeUnit") %>
                                            </div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,ZhuangTai%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "HandleStatus") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,ShouLiRen%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "OperatorName") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label35" runat="server" Text="<%$ Resources:lang,KeFangYiJian%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "CustomerComment") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label36" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "HandleDetail") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,XiaCiFuWuShiJian%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "NextServiceTime") %></div>
                                        </div>

                                        <div class="data-row">
                                            <div class="data-label">
                                                <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,TiQianTongZhiTianShu%>" />:
                                            </div>
                                            <div class="data-value"><%# DataBinder.Eval(Container.DataItem, "PreDays") %></div>
                                        </div>

                                        <div style="margin-top: 10px; text-align: center; display: none;">
                                            <asp:LinkButton ID="LinkButton1" runat="server" CssClass="inpu" CommandName="Update">
                                                <img src="ImagesSkin/Update.png" style="width:16px;height:16px;vertical-align:middle;" />
                                                <asp:Label runat="server" Text="<%$ Resources:lang,BaoCun%>" />
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:DataList>
                        </div>

                        <!-- 树形视图 -->
                        <div class="mobile-section" style="display: none;">
                            <div style="max-height: 300px; overflow-y: auto;">
                                <asp:TreeView ID="TreeView1" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged"
                                    ShowLines="True" Width="100%">
                                    <RootNodeStyle CssClass="rootNode" />
                                    <NodeStyle CssClass="treeNode" />
                                    <LeafNodeStyle CssClass="leafNode" />
                                    <SelectedNodeStyle CssClass="selectNode" />
                                </asp:TreeView>
                            </div>
                        </div>

                        <!-- 原有的模态框保持不变 -->
                        <div class="layui-layer layui-layer-iframe" id="popwindow" name="fixedDiv"
                            style="z-index: 9999; width: 98%; height: 500px; position: absolute; overflow: hidden; display: none; border-radius: 10px;">
                            <div class="layui-layer-title" style="background: #e7e7e8;" id="popwindow_title">
                                <asp:Label ID="Label6" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                            </div>
                            <div id="popwindow_content" class="layui-layer-content" style="overflow: auto; padding: 0px 5px 0px 5px;">

                                <table width="100%">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,FuWuXuQiuLeiBie%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <asp:DropDownList ID="DL_CustomerQuestionTypeNew" runat="server" CssClass="DDList" DataTextField="Type" DataValueField="Type" Width="99%">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,CYHSJ%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <asp:DropDownList ID="DL_IsImportantNew" runat="server" Width="99%">
                                                <asp:ListItem>NO</asp:ListItem>
                                                <asp:ListItem>YES</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="15%" class="ItemAlignLeft">
                                            <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,XuQiuShangJiMiaoShu%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ItemAlignLeft">

                                            <CKEditor:CKEditorControl runat="server" ID="HT_Question" Width="90%" Toolbar="" Height="120px" Visible="False" />
                                            <span class="auto-style1">*</span>

                                        </td>
                                    </tr>

                                    </tr>
                                    <tr>
                                        <td style="width: 15%;" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,KeHuMingCheng%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_Company" runat="server" Width="99%"></asp:TextBox><span class="auto-style1">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="15%" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,LianXiRen%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="30%" class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_ContactPerson" runat="server" Width="90%"></asp:TextBox><span class="auto-style1">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="15%" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,LianXiFangFa%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_PhoneNumber" runat="server" Width="99%"></asp:TextBox><span class="auto-style1">*</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,YaoQiuDaFuShiJian%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="DLC_AnswerTime" runat="server" Width="99%"></asp:TextBox>
                                            <ajaxToolkit:CalendarExtender Format="yyyy-MM-dd" ID="CalendarExtender2" runat="server" TargetControlID="DLC_AnswerTime" Enabled="True"></ajaxToolkit:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,LianXiDiZhi%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_Address" runat="server" Width="99%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,EMail%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_EMail" runat="server" Width="99%"></asp:TextBox>&#160;&#160;</td>
                                    </tr>
                                    <tr>

                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,YouBian%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_PostCode" runat="server" Width="99%"></asp:TextBox></td>
                                    </tr>

                                    <tr>
                                        <td style="text-align: center;" colspan="2" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label41" runat="server" Text="<%$ Resources:lang,SHANGJIXINXI%>"></asp:Label>
                                        </td>
                                    </tr>

                                    <tr>

                                        <td style="width: 15%;" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label50" runat="server" Text="<%$ Resources:lang,YIQICHENGJIAOSHIJIAN%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="DLC_ExpectedTime" runat="server" Width="99%"></asp:TextBox>
                                            <cc2:CalendarExtender ID="CalendarExtender3" runat="server" Enabled="True" Format="yyyy-MM-dd" TargetControlID="DLC_ExpectedTime">
                                            </cc2:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 15%;" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,YIQICHENGJIAOJINGE%>"></asp:Label>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <NickLee:NumberBox ID="NB_ExpectedEarnings" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Width="99%">0.00</NickLee:NumberBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="width: 15%;" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,CHENGGONGGANJIANYINGSHU%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="25%" class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_SucessKeyReason" runat="server" Width="99%" />
                                        </td>

                                    </tr>
                                    <tr>
                                        <td style="width: 15%;" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,SHIBAIGANJIANYINGSHU%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_FailedKeyReason" runat="server" Width="99%"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="Label52" runat="server" Text="<%$ Resources:lang,ShangJiJieDuan%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" width="25%">
                                            <asp:DropDownList ID="DL_Stage" runat="server" CssClass="DDList" Width="99%" AutoPostBack="true" DataTextField="Stage" DataValueField="Stage" OnSelectedIndexChanged="DL_Stage_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="Label53" runat="server" Text="<%$ Resources:lang,YingLu%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <NickLee:NumberBox ID="NB_Possibility" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Precision="0" Width="90%">0</NickLee:NumberBox>
                                            %
                                        </td>
                                    </tr>

                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,KeHuShangJiJieDuan%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" width="25%">
                                            <asp:DropDownList ID="DL_CustomerStage" runat="server" CssClass="DDList" DataTextField="Stage" DataValueField="Stage" Width="99%">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,SHANGJIDAILI%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_AgencyName" runat="server" Width="99%" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="width: 15%;" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,SHANGJILAIYUAN%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" colspan="3">
                                            <asp:TextBox ID="TB_BusinessSource" runat="server" Width="99%" />
                                        </td>
                                    </tr>

                                    <tr style="display: none;">
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="Label54" runat="server" Text="<%$ Resources:lang,SHANGJIXINXI%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" width="25%">
                                            <asp:TextBox ID="TB_BusinessName" runat="server" Width="99%"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="Label55" runat="server" Text="<%$ Resources:lang,KeHuMingCheng%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_CustomerName" runat="server" Width="99%" />
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,KeHuJingLi%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_CustomerManager" runat="server" Width="99%"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" style="width: 15%;">
                                            <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft" width="25%">
                                            <asp:Label ID="LB_UserName" runat="server" Visible="False"></asp:Label>
                                            <asp:Label ID="LB_Sql4" runat="server" Visible="False"></asp:Label>
                                            <asp:Label ID="Label56" runat="server" Visible="False"></asp:Label>
                                        </td>
                                    </tr>
                                </table>

                                <table width="100%" style="display: none;">
                                    <tr>
                                        <td width="100px">
                                            <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,FuWuXuQiuLeiBie%>"></asp:Label>
                                        </td>
                                        <td width="205px">
                                            <asp:DropDownList ID="DL_CustomerQuestionType" runat="server" CssClass="DDList" DataTextField="Type" DataValueField="Type" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="DL_CustomerQuestionType_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="100px">
                                            <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,FuWuXuQiuMiaoShu%>"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="LB_Question" runat="server" Width="70%"></asp:Label></td>
                                    </tr>
                                </table>
                                <br />
                                <br />
                            </div>

                            <!-- 修改后的弹窗底部按钮 -->
                            <div id="popwindow_footer" class="layui-layer-btn" style="border-top: 1px solid #ccc; padding: 15px; text-align: center; background: white; position: sticky; bottom: 0;">
                                <asp:LinkButton ID="LinkButton1" runat="server"
                                    OnClick="BT_New_Click"
                                    Text="<%$ Resources:lang,BaoCun%>"
                                    CssClass="popup-button"
                                    Style="margin-right: 4%;">
                                </asp:LinkButton>
                                <a onclick="return popClose();"
                                    class="popup-button cancel">
                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                                </a>
                            </div>
                            <span class="layui-layer-setwin"><a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;"></a></span>
                        </div>

                        <div class="layui-layer layui-layer-iframe" id="popDetailWindow" name="fixedDiv"
                            style="z-index: 9999; width: 98%; height: 500px; position: absolute; overflow: hidden; display: none; border-radius: 10px;">
                            <div class="layui-layer-title" style="background: #e7e7e8;" id="popwindow_title1">
                                <asp:Label ID="Label22" runat="server" Text="&lt;div&gt;&lt;img src=ImagesSkin/Update.png border=0 width=30px height=30px alt='BusinessForm' /&gt;&lt;/div&gt;"></asp:Label>
                            </div>
                            <div id="popwindow_content1" class="layui-layer-content" style="overflow: auto; padding: 0px 5px 0px 5px;">

                                <table style="width: 100%; padding: 5px 0px 0px 5px" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width: 10%;" class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="LB_ID" runat="server" Visible="false"></asp:Label>
                                            <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,KeHuYiJian%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <CKEditor:CKEditorControl ID="HE_CustomerComment" runat="server" Toolbar="" Width="99%" Height="80px" Visible="false" />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,ChuLiFangShi%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_HandleWay" runat="server" Width="60%"></asp:TextBox>
                                            <asp:DropDownList ID="DL_HandleWay" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DL_ContactWay_SelectedIndexChanged">
                                                <asp:ListItem Value="" Text="<%$ Resources:lang,QingXuanZe%>" />
                                                <asp:ListItem Value="Telephone" Text="<%$ Resources:lang,DianHua%>" />
                                                <asp:ListItem Value="IM" Text="<%$ Resources:lang,IM%>" />
                                                <asp:ListItem Value="RemoteControl" Text="<%$ Resources:lang,YuanChengKongZhi%>" />
                                                <asp:ListItem Value="EMail" Text="<%$ Resources:lang,EMail%>" />
                                                <asp:ListItem Value="DoorToDoorVisit" Text="<%$ Resources:lang,ShangMenBaiFang%>" />
                                                <asp:ListItem Value="OtherMethods" Text="<%$ Resources:lang,QiTaFangShi%>" />
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,ChuLiZhuangTai%>"></asp:Label>
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
                                            <asp:Label ID="Label40" runat="server" Text="<%$ Resources:lang,YongShi%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <NickLee:NumberBox MaxAmount="1000000000000" MinAmount="-1000000000000" ID="NB_UsedTime" runat="server" Width="60%" Amount="1">1.00</NickLee:NumberBox>
                                            <asp:DropDownList ID="DL_TimeUnit" runat="server">
                                                <asp:ListItem Value="Minutes" Text="<%$ Resources:lang,FenZhong%>" />
                                                <asp:ListItem Value="Hours" Text="<%$ Resources:lang,XiaoShi%>" />
                                                <asp:ListItem Value="Days" Text="<%$ Resources:lang,Tian%>" />
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label57" runat="server" Text="<%$ Resources:lang,LianLuoRen%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_CustomerAcceptor" runat="server" Width="99%"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label58" runat="server" Text="<%$ Resources:lang,LianXiFangFa%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td s class="formItemBgStyleForAlignLeft">
                                            <asp:TextBox ID="TB_AcceptorContactWay" runat="server" Width="99%"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label59" runat="server" Text="<%$ Resources:lang,ChuLiNeiRong%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <CKEditor:CKEditorControl ID="HE_HandleDetail" runat="server" Toolbar="" Width="90%" Height="80px" Visible="false" />


                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
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
                                                <Triggers>
                                                    <%--  <asp:PostBackTrigger ControlID="BtnUP" />--%>
                                                </Triggers>
                                            </asp:UpdatePanel>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="formItemBgStyleForAlignLeft">
                                            <asp:Label ID="Label60" runat="server" Text="<%$ Resources:lang,XiaCiFuWuShiJian%>"></asp:Label>
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
                                            <asp:Label ID="Label61" runat="server" Text="<%$ Resources:lang,TiQianTongZhiTianShu%>"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td s class="formItemBgStyleForAlignLeft">
                                            <NickLee:NumberBox ID="NB_PreDays" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Width="90%" Precision="0">0</NickLee:NumberBox>
                                            <asp:Label ID="Label62" runat="server" Text="<%$ Resources:lang,Tian%>"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <br />
                            </div>

                            <!-- 修改后的第二个弹窗底部按钮 -->
                            <div id="popwindow_footer1" class="layui-layer-btn" style="border-top: 1px solid #ccc; padding: 15px; text-align: center; background: white; position: sticky; bottom: 0;">
                                <asp:LinkButton ID="BT_NewRecord" runat="server"
                                    OnClick="BT_NewRecord_Click"
                                    Text="<%$ Resources:lang,BaoCun%>"
                                    CssClass="popup-button"
                                    Style="margin-right: 4%;">
                                </asp:LinkButton>
                                <a class="popup-button cancel" onclick="return popClose();">
                                    <asp:Label ID="Label63" runat="server" Text="<%$ Resources:lang,GuanBi%>" />
                                </a>
                            </div>
                            <span class="layui-layer-setwin"><a onclick="return popClose();" class="layui-layer-ico layui-layer-close layui-layer-close1 notTab" href="javascript:;"></a></span>
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
            </div>
        </form>
    </div>
</body>
</html>
