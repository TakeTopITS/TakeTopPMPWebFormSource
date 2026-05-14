<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TakeTopLRExLeft.aspx.cs" Inherits="TakeTopLRExLeft" %>

<%--<%@ OutputCache Duration="2678400" VaryByParam="*" %>--%>

<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html id="yanse" xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightleftEx.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="lhgdialog/lhgcore.min.js"></script>
    <script type="text/javascript" src="lhgdialog/lhgdialog.min.js"> </script>

    <script type="text/javascript" language="javascript">

        jQuery.noConflict();

        var varLeftBarExtend = '<%=Session["LeftBarExtend"] != null ? Session["LeftBarExtend"].ToString() : "NO" %>'.trim();

        // 收缩展开效果
        jQuery(document).ready(function () {

            jQuery("span.minusSpan").show();
            jQuery("span.plusSpan").show();

            // 根据 Session 值设置左边栏宽度和箭头方向
            var arrowImg = document.getElementById('toggleArrow');
            var cols = window.parent.document.getElementById("TakeTopLRMDI").cols;
            var leftWidth = parseInt(cols, 10);
            
            // 优先根据实际宽度判断状态，而不是 Session 值
            // 这样可以避免 Session 和实际状态不一致的问题
            if (leftWidth <= 50) {
                // 实际宽度小于50，认为是收缩状态：箭头向右
                if (arrowImg) arrowImg.src = 'ImagesSkin/extend_right.png';
                window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "no");
            } else {
                // 实际宽度大于50，认为是展开状态：箭头向左
                if (arrowImg) arrowImg.src = 'ImagesSkin/extend.png';
                window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");
            }

            $('body').height($(window).height() - 30);

        });


        var i = 0;
        var j = 0;


        var decreaseTimer;
        var creaseTimer;

        var userAgentInfo = navigator.userAgent;

        function ChangeMenu(way) {

            if (way == 1) {
                var cols = window.parent.document.getElementById("TakeTopLRMDI").cols;
                var leftWidth = parseInt(cols, 10);

                if (leftWidth <= 50) {
                    // 当前是收缩状态：展开到180，箭头向左
                    var arrowImg = document.getElementById('toggleArrow');
                    if (arrowImg) arrowImg.src = 'ImagesSkin/extend.png';

                    window.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
                    window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");

                } else {
                    // 当前是展开状态：收缩到45，箭头向右
                    var arrowImg = document.getElementById('toggleArrow');
                    if (arrowImg) arrowImg.src = 'ImagesSkin/extend_right.png';

                    window.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
                    window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "no");
                }
            }

            if (way == 3) {

                window.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';

                window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");

                // 展开状态：箭头向左
                var arrowImg = document.getElementById('toggleArrow');
                if (arrowImg) arrowImg.src = 'ImagesSkin/extend.png';
            }

            if (way == 4) {

                if (this.document.getElementById("HF_IsExtend").value === "NO") {

                    if (varLeftBarExtend === "NO") {

                        window.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
                        window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "no");

                        // 收缩状态：箭头向右
                        var arrowImg = document.getElementById('toggleArrow');
                        if (arrowImg) arrowImg.src = 'ImagesSkin/extend_right.png';
                    }
                    else {

                        window.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
                        window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");

                        // 展开状态：箭头向左
                        var arrowImg = document.getElementById('toggleArrow');
                        if (arrowImg) arrowImg.src = 'ImagesSkin/extend.png';
                    }

                }
                else {

                    if (varLeftBarExtend === "NO") {

                        window.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
                        window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "no");

                        // 收缩状态：箭头向右
                        var arrowImg = document.getElementById('toggleArrow');
                        if (arrowImg) arrowImg.src = 'ImagesSkin/extend_right.png';
                    }
                    else {

                        window.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
                        window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");

                        // 展开状态：箭头向左
                        var arrowImg = document.getElementById('toggleArrow');
                        if (arrowImg) arrowImg.src = 'ImagesSkin/extend.png';
                    }

                }

            }

        }

        //设置左边栏元素的值
        function setExtendValue(extendStatus) {

            this.document.getElementById("HF_IsExtend").value = extendStatus;
            varLeftBarExtend = extendStatus;

            //alert(this.document.getElementById("HF_IsExtend").value);

        }


        function doNothing() {

            ChangeMenu(1);

            window.event.returnValue = false;

            return false;
        }


        function decreaseLeftWidth() {
            i = i - 10;
            if (i >= 45) {
                window.parent.document.getElementById("TakeTopLRMDI").cols = i.toString() + ",*";
            }
        }
        function creaseLeftWidth() {
            j = j + 10;
            if (j <= 250) {
                window.parent.document.getElementById("TakeTopLRMDI").cols = j.toString() + ",*";
            }
        }

        function CreateTab(title, url, obj) {

            /*  parent.frames["rightTopFrame"].reloadPage(url);*/

            scrollHeight = document.documentElement.scrollTop + document.body.scrollTop;

            jQuery("#divload").show();

            if (url.indexOf('TakeTopPersonalSpace') == -1) {


                window.parent.document.getElementById("rightFrame").rows = '40,0,*';
            }
            else {

                window.parent.document.getElementById("rightFrame").rows = '0,0,*';
            }

            parent.frames["rightTabFrame"].addTab(title, url, "new");

            jQuery(obj).parent().parent().parent().parent().parent().find("span").css("color", "");
            jQuery(obj).parent().find("span").css("color", "red");


            jQuery(obj).parent().parent().parent().parent().parent().parent().parent().find("span").removeClass("testBold");
            jQuery(obj).parent().parent().parent().parent().find("span[name='parent1']").addClass("testBold");

            setTimeout("CloseDiv()", 500);

            return false;
        }


        function CreateTabModule(title, url, obj) {

            /*      parent.frames["rightTopFrame"].reloadPage(url);*/

            jQuery("#divload").show();

            if (url.indexOf('TakeTopPersonalSpace') == -1) {


                window.parent.document.getElementById("rightFrame").rows = '40,0,*';
            }
            else {

                window.parent.document.getElementById("rightFrame").rows = '0,0,*';
            }

            parent.frames["rightTabFrame"].addTab(title, url, "new");

            jQuery(obj).parent().parent().parent().parent().parent().parent().parent().find("span").removeClass("testBold");
            jQuery(obj).addClass("testBold");

            jQuery(obj).parent().parent().parent().parent().find("span").css("color", "");

            var clickStyle = jQuery(obj).parent().find(".plusSpan").css("display");
            if (clickStyle == "none") {

            } else {

                jQuery(obj).parent().find(".minusSpan").show();
                jQuery(obj).parent().find(".plusSpan").hide();
                jQuery(obj).parent().next(".text").slideToggle("slow");
            }

            jQuery(obj).parent().parent().find(".minusSpan").show();
            jQuery(obj).parent().parent().find(".plusSpan").hide();
            jQuery(obj).parent().parent().next(".text").slideToggle("slow");

            setTimeout("CloseDiv()", 500);
        }

        function CloseDiv() {
            jQuery("#divload").hide();
        }

        function OnMouseOverEvent(obj) {
            jQuery(obj).addClass("spanHover");
        }

        function OnMouseOutEvent(obj) {
            jQuery(obj).removeClass("spanHover");
        }


        function OnPlusEvent(obj) {
            var clickStyle = jQuery(obj).parent().find(".plusSpan").css("display");
            if (clickStyle == "none") {

                jQuery(obj).parent().find(".minusSpan").show();
                jQuery(obj).parent().find(".plusSpan").show();
                jQuery(obj).parent().next(".text").hide();


            } else {
                jQuery(obj).parent().find(".minusSpan").show();
                jQuery(obj).parent().find(".plusSpan").show();
                jQuery(obj).parent().next(".text").slideToggle("slow");
            }
        }

        function OnMinusEvent(obj) {
            var clickStyle = jQuery(obj).parent().find(".minusSpan").css("display");
            if (clickStyle == "none") {

                jQuery(obj).parent().find(".minusSpan").show();
                jQuery(obj).parent().find(".plusSpan").show();
                jQuery(obj).parent().next(".text").slideToggle("slow");

            } else {
                jQuery(obj).parent().find(".minusSpan").show();
                jQuery(obj).parent().find(".plusSpan").show();
                jQuery(obj).parent().next(".text").hide();
            }
        }

        function OnDoubleClickModule(obj) {
            var clickStyle = jQuery(obj).parent().find(".plus").css("display");
            if (clickStyle == "none") {
                jQuery(obj).parent().find(".minusSpan").show();
                jQuery(obj).parent().find(".plusSpan").show();
                jQuery(obj).parent().next(".text").hide();
            }
        }



        function opdg(id, htmlText) {

            var dg = new J.dialog({ id: id, title: '信息提示', width: 250, height: 300, cancelBtn: false, html: htmlText, autoPos: false, fixed: false, left: 'right', top: 'bottom' });

            dg.ShowDialog();
        }

        function opim(id, htmlText) {

            var dg = new J.dialog({ id: id, title: 'TakeTopIM', width: 455, height: 570, btnBar: false, cancelBtn: false, page: htmlText, autoPos: { left: 'left', top: 'top' }, fixed: false, left: 'left', top: 'top', rang: true });

            dg.ShowDialog();
        }

        function getObject(objectId) {
            if (document.getElementById && document.getElementById(objectId)) {
                // W3C DOM
                return document.getElementById(objectId);
            }
            else if (document.all && document.all(objectId)) {
                // MSIE 4 DOM
                return document.all(objectId);
            }
            else if (document.layers && document.layers[objectId]) {
                // NN 4 DOM.. note: this won't find nested layers
                return document.layers[objectId];
            }
            else {
                return false;
            }
        }

        function showHide(objname) {
            var obj = getObject(objname);
            if (obj.style.display == "none") {
                obj.style.display = "block";
            } else {
                obj.style.display = "none";
            }
        }

        function ReloadPage() {

            window.location.reload();
        }

        // 切换左边栏展开/收缩状态（由后端 BT_Extend_Click 调用）
        function changeLeftBarExtend(isExtend) {
            if (isExtend === "YES") {
                // 展开到 180px
                if (window.parent && window.parent.document.getElementById("TakeTopLRMDI")) {
                    window.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
                }
                // 展开状态：箭头向左（表示点击后收缩）
                var arrowImg = document.getElementById('toggleArrow');
                if (arrowImg) arrowImg.src = 'ImagesSkin/extend.png';
            } else {
                // 收缩到 45px
                if (window.parent && window.parent.document.getElementById("TakeTopLRMDI")) {
                    window.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
                }
                // 收缩状态：箭头向右（表示点击后展开）
                var arrowImg = document.getElementById('toggleArrow');
                if (arrowImg) arrowImg.src = 'ImagesSkin/extend_right.png';
            }
            // 更新隐藏字段值
            var hfIsExtend = document.getElementById('HF_IsExtend');
            if (hfIsExtend) hfIsExtend.value = isExtend;
        }

        // 前端控制左边栏展开/收缩（立即响应，同时触发后端保存）
        function toggleLeftBar() {
            var cols = window.parent.document.getElementById("TakeTopLRMDI").cols;
            var leftWidth = parseInt(cols, 10);
            var arrowImg = document.getElementById('toggleArrow');
            var hfIsExtend = document.getElementById('HF_IsExtend');
            var newStatus;

            if (leftWidth <= 50) {
                // 当前是收缩状态：展开到180，箭头向左
                if (arrowImg) arrowImg.src = 'ImagesSkin/extend.png';
                window.parent.document.getElementById("TakeTopLRMDI").cols = '180,*';
                window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "yes");
                newStatus = "YES";
            } else {
                // 当前是展开状态：收缩到45，箭头向右
                if (arrowImg) arrowImg.src = 'ImagesSkin/extend_right.png';
                window.parent.document.getElementById("TakeTopLRMDI").cols = '45,*';
                window.parent.document.getElementById("leftMiddleFrameID").setAttribute("scrolling", "no");
                newStatus = "NO";
            }

            // 更新隐藏字段
            if (hfIsExtend) hfIsExtend.value = newStatus;

            // 触发后端按钮点击，保存状态到数据库
            // 使用 setTimeout 确保前端 UI 先更新
            setTimeout(function() {
                __doPostBack('BT_Extend', '');
            }, 10);
        }

        // 显示提示信息
        function showAlertAtMouse(message) {
            alert(message);
        }

    </script>

    <style type="text/css">
        /* LinkButton 包裹层 */
        .middle-toggle-link {
            text-decoration: none;
            display: block;
        }
        /* 中间展开/收缩按钮样式 */
        #middleToggleBtn {
            position: fixed;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 70px;
            background-color: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-right: none;
            border-radius: 4px 0 0 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 100;
            box-shadow: -2px 0 5px rgba(0,0,0,0.3);
            transition: all 0.2s ease;
        }
        #middleToggleBtn:hover {
            background-color: rgba(255, 255, 255, 0.25);
            width: 24px;
            box-shadow: -3px 0 8px rgba(0,0,0,0.4);
        }
        #middleToggleBtn img {
            width: 16px;
            height: 16px;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <asp:Timer ID="Timer1" OnTick="Timer1_Tick" runat="server" Interval="1000" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="Timer1" />
            </Triggers>
            <ContentTemplate>

                <div id="divBody" style="height: 100%; width: 100%; overflow-y: auto;">
                    <div class="leftSet" style="overflow: hidden;">
                        <table width="181px" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="25%"></td>
                                <td>

                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ItemAlignLeft">
                                        <tr style="height: 37px;">
                                            <td class="ItemAlignLeft" width="20">
                                                <a href="javascript:ChangeMenu(1)">
                                                </a>
                                            </td>
                                            <td class="title12" style="padding-left: 10px;">
                                                <a href="javascript:ChangeMenu(1)">
                                                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,ModuleName%>"></asp:Label>
                                                </a>
                                            </td>
                                            <td class="ItemAlignLeft" width="12"></td>
                                        </tr>
                                    </table>

                                </td>

                            </tr>
                        </table>
                    </div>


                    <div id="box">
                        <%--<img src="Images/color.gif" id="square_one" style="cursor: pointer" />--%>
                        <!-- 收缩展开效果start -->
                        <asp:Literal ID="LT_Result" runat="server"></asp:Literal>
                        <!-- 收缩展开效果end -->
                    </div>
                    <script type="text/javascript" src="js/jquery.js"></script>
                    <script type="text/javascript" src="js/jquery.colorpicker.js"></script>
                    <script type="text/javascript">
                        $(function () {
                            if (top.location != self.location) { } else { CloseWebPage(); }
                            $("#square_one").colorpicker({
                                fillcolor: true,
                                success: function (o, color) {
                                    $("#box").css("background-color", color);
                                }
                            });

                        });
                    </script>
                </div>

                <!-- 中间展开/收缩按钮 -->
                <div id="middleToggleBtn" title="展开/收缩" onclick="javascript: toggleLeftBar();" class="middle-toggle-link">
                    <img id="toggleArrow" src='<%=Session["LeftBarExtend"].ToString()=="YES" ? "ImagesSkin/extend.png" : "ImagesSkin/extend_right.png" %>' alt="切换" />
                </div>
                <!-- 隐藏的后端按钮，用于异步保存状态 -->
                <asp:LinkButton ID="BT_Extend" runat="server" OnClick="BT_Extend_Click" CssClass="middle-toggle-link" style="display:none;">
                    <div></div>
                </asp:LinkButton>

                <div id="bottomNav">
                    <table width="250" border="0" cellspacing="0" cellpadding="0" onmousemove="document.getElementById('bottomNav').style.zIndex = 999;document.getElementById('topNav').style.zIndex = -2;document.getElementById('toolNav').style.zIndex = -3;">
                        <tr>
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td align="left">
                                            <table width="75%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td height="45" style="padding-left:5px;">

                                                        <a class="titleSpan" href="javascript:CreateTabModule('MainSkinSelect','TakeTopMainSkinSelect.aspx',this)">
                                                            <%-- <img src="Images/color.gif" width="20" height="20" />--%>
                                                            <img src="ImagesSkin/MainSkin.png" width="20" height="20"></a>

                                                    </td>

                                                    <td height="45">
                                                        <a class="titleSpan" href="javascript:CreateTabModule('Address Book','TTContactList.aspx',this)">
                                                            <img src="ImagesSkin/ContactList.png" width="20" height="20"></a>
                                                    </td>
                                                    <td id="ID_MakeIM" runat="server" height="45" class="ItemAlignLeft">

                                                        <a class="titleSpan" href="javascript:CreateTabModule('TakeTopIM','TTTakeTopIM.aspx',this)">
                                                            <img src="ImagesSkin/IM.png" width="20" height="20"></a>
                                                        <%--
                                                        <asp:LinkButton ID="BT_MakeIM" runat="server" ToolTip='即时通' OnClick="BT_MakeIM_Click"> <img src="Images/im.png" width="20" height="20"></asp:LinkButton>--%>
                                                    </td>

                                                    <td id="ID_SMSSend" runat="server" height="45">

                                                        <a runat="server" class="titleSpan" href="javascript:CreateTabModule('Send Message','TTSMSSendDIY.aspx',this)">
                                                            <img src="ImagesSkin/SMS.png" width="22" height="22"></a>
                                                    </td>


                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="ItemAlignLeft" background="ImagesSkin/left_line.png" height="2"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>

                <div id="toolNav">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" onmousemove="document.getElementById('toolNav').style.zIndex = -3;document.getElementById('bottomNav').style.zIndex = 999;document.getElementById('topNav').style.zIndex = -2;">
                        <tr>
                            <td>
                                <table width="87%" border="0" cellspacing="0" cellpadding="0" align="right">
                                    <tr>
                                        <td width="10%" class="ItemAlignLeft" height="3" valign="middle" style="padding-right: 5px;"></td>
                                        <td height="3"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>

                <asp:HiddenField ID="HF_ClickValue" runat="server" Value="" />
                <asp:HiddenField ID="HF_IsExtend" runat="server" Value="NO" />
                <asp:HiddenField ID="HF_IsClickExtend" runat="server" Value="NO" />

                <div id="divload" style="position: absolute; left: 40%; top: 30%; display: none;">
                    <img src="Images/Processing.gif" alt="Loading,please wait..." />
                </div>

            </ContentTemplate>

        </asp:UpdatePanel>
        <div style="position: absolute; left: 40%; top: 30%;">
            <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                 <%--   <img src="Images/Processing.gif" alt="Loading,please wait..." />--%>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </form>

</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); if ((/Safari/.test(navigator.userAgent) && !/Chrome/.test(navigator.userAgent))) { oLink.href = 'css/' + cssDirectory + '/' + 'bluelightleftEx.css'; } else { oLink.href = 'css/' + cssDirectory + '/' + 'bluelightleftEx.css'; };</script>
</html><%--***--%>
<%--***--%>

<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>


<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>

<%--***--%>

<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
<%--***--%>
