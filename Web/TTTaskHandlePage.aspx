<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTTaskHandlePage.aspx.cs" Inherits="TTTaskHandlePage" %>


<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>制定计划</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1100px;
            width: expression (document.body.clientWidth <= 1100? "1100px" : "auto" ));
        }
        
        /* 新增优化样式 */
        .formItemBgStyle > div {
            min-height: 400px;
            border: 2px dashed transparent;
            transition: all 0.2s ease;
            padding: 5px;
            border-radius: 6px;
            position: relative;
        }
        
        .formItemBgStyle > div.droppable-hover {
            border: 3px solid LightCoral !important;
            background-color: #f0f8ff;
        }
        
        .bian {
            cursor: move;
            transition: all 0.2s ease;
        }
        
        .bian.dragging-clone {
            position: fixed !important;
            z-index: 10000 !important;
            pointer-events: none !important;
            opacity: 0.9;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            max-width: 250px;
            transform: none !important;
        }
        
        .bian.dragging-original {
            opacity: 0.3;
        }
        
        #div_task {
            background: white;
            padding: 12px;
            margin-bottom: 10px;
            border-left: 4px solid #4CAF50 !important;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: all 0.2s ease;
        }
        
        #div_task:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-left-width: 6px !important;
        }
    </style>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">

        //页面加载完成,ajax回发加载完成后执行的操作，传入一个funtion
        //$load调用示例
        //$load(function () {
        //    //需要页面加载完成执行的代码
        //});
        var $load = function (loadFunc) {
            $(function () {
                if (typeof (Sys) != 'undefined') {
                    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(loadFunc);
                }
                else {
                    loadFunc();
                }
            });
        };

        $load(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }

            // 改进的拖拽功能 - 悬浮跟随鼠标
            $(".bian").draggable({
                revert: "invalid",
                cursor: "move",
                cursorAt: { top: 10, left: 10 },
                zIndex: 10000,
                start: function (event, ui) {
                    // 创建克隆元素用于拖拽显示
                    var $original = $(this);
                    var originalWidth = $original.outerWidth();
                    var originalHeight = $original.outerHeight();

                    var $clone = $original.clone()
                        .addClass('dragging-clone')
                        .css({
                            'width': originalWidth,
                            'height': originalHeight,
                            'left': event.pageX - (originalWidth / 2), // 让鼠标在中间
                            'top': event.pageY - (originalHeight / 2)  // 让鼠标在中间
                        })
                        .appendTo('body');

                    // 原始元素半透明
                    $original.addClass('dragging-original');

                    // 存储克隆元素引用
                    $(this).data('clone', $clone);

                    // 判断如果是AboveTable，则阻止拖拽
                    if ($(this).attr('id') === 'AboveTable') {
                        return false;
                    }
                    $(this).closest("table").parent().css("overflow-y", "visible");
                },
                drag: function (event, ui) {
                    // 更新克隆元素位置，让鼠标在中间
                    var $clone = $(this).data('clone');
                    if ($clone) {
                        var cloneWidth = $clone.outerWidth();
                        var cloneHeight = $clone.outerHeight();

                        $clone.css({
                            'left': event.pageX - (cloneWidth / 2),
                            'top': event.pageY - (cloneHeight / 2)
                        });
                    }
                },
                stop: function (event, ui) {
                    // 移除克隆元素并恢复原始元素
                    var $clone = $(this).data('clone');
                    if ($clone) {
                        $clone.remove();
                        $(this).removeData('clone');
                    }
                    $(this).removeClass('dragging-original');
                    $(this).closest("table").parent().css("overflow-y", "visible");

                    // 移除所有放置区域的悬停样式
                    $(".formItemBgStyle>div").removeClass("droppable-hover").css("border", "2px dashed transparent");
                }
            });

            $(".formItemBgStyle>div").each(function () {
                $(this).droppable({
                    accept: ".formItemBgStyle>div:not(#" + $(this).attr("id") + ") .bian",
                    tolerance: "touch", // 改为touch，只要接触就触发
                    over: function (event, ui) {
                        // 立即显示红色边框，不等待动画
                        $(this).addClass("droppable-hover");
                    },
                    out: function (event, ui) {
                        $(this).removeClass("droppable-hover");
                    },
                    drop: function (event, ui) {
                        var $draggerDiv = $(ui.draggable[0]);

                        // 确保在放置时移除克隆元素
                        var $clone = $draggerDiv.data('clone');
                        if ($clone) {
                            $clone.remove();
                            $draggerDiv.removeData('clone');
                        }

                        $draggerDiv.closest("table").parent().css("overflow-y", "auto");
                        $cloneTr = $draggerDiv.parent().parent().clone();
                        $(this).find("table").find("tr:eq(0)").before($cloneTr);
                        $cloneTr.find("div").css("position", "inherit");
                        $cloneTr.find("div").css("left", "0");
                        $cloneTr.find("div").css("top", "0");

                        $("#LB_SourceID").val(getQueryString("ID", $cloneTr.find("a").attr("href")));
                        $("#LB_TargetStatus").val($(this).prev().find(".StatusCss").text());

                        $draggerDiv.parent().parent().remove()
                        $(this).removeClass("droppable-hover");

                        $("#BT_UpdateStatus").click();
                    }
                });
            });
        });

        function AdjustDivHeight() {

            document.getElementById("Div_ToBeHandled").style.height = document.documentElement.clientHeight - 110 + "px";
            document.getElementById("Div_Handling").style.height = document.documentElement.clientHeight - 110 + "px";
            document.getElementById("Div_FinishedUnAssigned").style.height = document.documentElement.clientHeight - 110 + "px";
            document.getElementById("Div_Assigned").style.height = document.documentElement.clientHeight - 110 + "px";

        }

        //获取url后参数值
        function getQueryString(name, url) {
            if (!url) {
                url = window.location.search.substr(1);
            }
            else {
                url = url.substring(url.indexOf("?") + 1);
            }
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = url.match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
    </script>
</head>
<body onresize="AdjustDivHeight()">
    <center>
        <form id="form1" runat="server">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div id="AboveDiv">
                        <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0">
                            <tr>
                                <td height="31" class="page_topbj">
                                    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="left">
                                                <table width="345" border="0" align="left" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                        </td>
                                                        <td align="center" background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,WoDeRenWu%>"></asp:Label>
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" style="padding-top: 5px; display: none;">
                                                <asp:Button ID="BT_CreateTask" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ChuangJianRenWu%>" OnClick="BT_CreateTask_Click" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" style="padding: 0px 5px 5px 5px;">
                                    <cc2:TabContainer CssClass="ajax_tab_menu" ID="TabContainer2" runat="server" ActiveTabIndex="0" Width="100%">
                                        <cc2:TabPanel ID="TabPanel1" runat="server" HeaderText="正处理的任务:">
                                            <HeaderTemplate>
                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ZhenChuLiDeRenWu%>"></asp:Label>
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="left" class="formItemBgStyle" width="23%">
                                                            <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td align="center" width="100%">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td align="center" style="text-align: center; padding-top: 4px;">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,DaiChuLiDD %>"></asp:Label>
                                                                                                </strong>
                                                                                            </td>
                                                                                            <td style="padding-left: 10px; padding-top: 1px;">
                                                                                                <strong>
                                                                                                    <asp:HyperLink ID="HL_CreateTask" runat="server"> <span style ="font-size:xx-large;color:red;"> +</span> </asp:HyperLink>
                                                                                                </strong>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr style="display: none;">
                                                                                <td align="center" width="100%">
                                                                                    <asp:Label ID="LB_TaskRecordStatus_ToBeHandled" runat="server" CssClass="StatusCss" Text="ToHandle"></asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="right" width="6">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <div id="Div_ToBeHandled" style="overflow-y: auto;">
                                                                <asp:DataList ID="DataList_ToBeHandled" runat="server" Width="100%" CellPadding="0">
                                                                    <ItemTemplate>
                                                                        <div id="div_task" class="bian" style="white-space: collapse; white-space: collapse; border-collapse: collapse; width: 97%; border-left: solid; border-top: dotted; border-right: dotted; border-bottom: dotted; border-radius: 3px 4px; border-left-color: green; border-top-color: lightblue; border-right-color: lightblue; border-bottom-color: lightblue;">

                                                                            <a href='TTTaskDetail.aspx?ID=<%#DataBinder.Eval(Container.DataItem, "ID")%>' target="_blank">
                                                                                <span style="color: red;">#<%#DataBinder.Eval(Container.DataItem, "ID")%></span>&nbsp;&nbsp; <%#DataBinder.Eval(Container.DataItem, "Operation")%><br />
                                                                                <br />
                                                                                <span style="font-size: smaller">
                                                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label>:  <a href="TTUserInforSimple.aspx?UserCode=<%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>" target="_blank" style="font-size: smaller"><%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "AssignManName")%> </a></span>

                                                                            </a>
                                                                        </div>
                                                                        <div style="background-color: white; height: 5px;">
                                                                            &nbsp;
                                                                        </div>
                                                                    </ItemTemplate>
                                                                </asp:DataList>
                                                            </div>
                                                        </td>
                                                        <td width="10px"></td>
                                                        <td align="left" class="formItemBgStyle" width="23%">
                                                            <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0"
                                                                width="100%">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td align="center" width="100%" style="width: 100%; text-align: center; padding-top: 4px;">
                                                                                    <strong>
                                                                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ChuLiZhongDD %>"></asp:Label>
                                                                                    </strong>
                                                                                </td>
                                                                            </tr>
                                                                            <tr style="display: none;">
                                                                                <td align="center" width="100%">
                                                                                    <asp:Label ID="LB_TaskRecordStatus_Handling" CssClass="StatusCss" runat="server" Text="InProgress"></asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="right" width="6">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <div id="Div_Handling" style="overflow-y: auto;">
                                                                <asp:DataList ID="DataList_Handling" runat="server" Width="100%" CellPadding="0">
                                                                    <ItemTemplate>
                                                                        <div id="div_task" class="bian" style="white-space: collapse; border-collapse: collapse; width: 97%; border-left: solid; border-top: dotted; border-right: dotted; border-bottom: dotted; border-radius: 3px 4px; border-left-color: green; border-top-color: lightblue; border-right-color: lightblue; border-bottom-color: lightblue;">
                                                                            <a href='TTTaskDetail.aspx?ID=<%#DataBinder.Eval(Container.DataItem, "ID")%>' target="_blank">
                                                                                <span style="color: red;">#<%#DataBinder.Eval(Container.DataItem, "ID")%></span>&nbsp;&nbsp; <%#DataBinder.Eval(Container.DataItem, "Operation")%><br />
                                                                                <br />
                                                                                <span style="font-size: smaller">
                                                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label>:  <a href="TTUserInforSimple.aspx?UserCode=<%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>" target="_blank" style="font-size: smaller"><%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "AssignManName")%>  </a></span>

                                                                            </a>
                                                                        </div>
                                                                        <div style="background-color: white; height: 5px;">
                                                                            &nbsp;
                                                                        </div>
                                                                    </ItemTemplate>
                                                                </asp:DataList>
                                                            </div>
                                                        </td>
                                                        <td width="10px"></td>
                                                        <td align="left" class="formItemBgStyle" width="23%">
                                                            <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0"
                                                                width="100%">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td align="center" width="100%" style="width: 100%; text-align: center; padding-top: 4px;">
                                                                                    <strong>
                                                                                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,YuWanChengDaiFenPai %>"></asp:Label>
                                                                                    </strong>
                                                                                </td>
                                                                            </tr>
                                                                            <tr style="display: none;">
                                                                                <td align="center" width="100%">
                                                                                    <asp:Label ID="LB_TaskRecordStatus_Finished" CssClass="StatusCss" runat="server" Text="Completed"></asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="right" width="6">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <div id="Div_FinishedUnAssigned" style="overflow-y: auto;">
                                                                <asp:DataList ID="DataList_FinishedUnAssigned" runat="server" Width="100%" CellPadding="0">
                                                                    <ItemTemplate>
                                                                        <div id="div_task" class="bian" style="white-space: collapse; border-collapse: collapse; width: 97%; border-left: solid; border-top: dotted; border-right: dotted; border-bottom: dotted; border-radius: 3px 4px; border-left-color: green; border-top-color: lightblue; border-right-color: lightblue; border-bottom-color: lightblue;">
                                                                            <a href='TTTaskDetail.aspx?ID=<%#DataBinder.Eval(Container.DataItem, "ID")%>' target="_blank">
                                                                                <span style="color: red;">#<%#DataBinder.Eval(Container.DataItem, "ID")%></span>&nbsp;&nbsp; <%#DataBinder.Eval(Container.DataItem, "Operation")%><br />
                                                                                <br />
                                                                                <span style="font-size: smaller">
                                                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label>:  <a href="TTUserInforSimple.aspx?UserCode=<%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>" target="_blank" style="font-size: smaller"><%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "AssignManName")%>  </a></span>


                                                                            </a>
                                                                        </div>
                                                                        <div style="background-color: white; height: 5px;">
                                                                            &nbsp;
                                                                        </div>
                                                                    </ItemTemplate>
                                                                </asp:DataList>
                                                            </div>
                                                        </td>
                                                        <td width="10px"></td>
                                                        <td align="left" class="formItemBgStyle" width="23%">
                                                            <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0"
                                                                width="100%">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td align="center" width="100%" style="width: 100%; text-align: center; padding-top: 4px;">
                                                                                    <strong>
                                                                                        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,YuFenPai %>"></asp:Label>
                                                                                    </strong>
                                                                                </td>
                                                                            </tr>
                                                                            <tr style="display: none;">
                                                                                <td align="center" width="100%">
                                                                                    <asp:Label ID="LB_TaskRecordStatus_Assigned" CssClass="StatusCss" runat="server" Text="Assigned"></asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="right" width="6">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" /></td>
                                                                </tr>
                                                            </table>
                                                            <div id="Div_Assigned" style="overflow-y: auto;">
                                                                <asp:DataList ID="DataList_Assigned" runat="server" Width="100%" CellPadding="0">
                                                                    <ItemTemplate>
                                                                        <div id="div_task" class="bian" style="white-space: collapse; border-collapse: collapse; width: 97%; border-left: solid; border-top: dotted; border-right: dotted; border-bottom: dotted; border-radius: 3px 4px; border-left-color: green; border-top-color: lightblue; border-right-color: lightblue; border-bottom-color: lightblue;">
                                                                            <a href='TTTaskDetail.aspx?ID=<%#DataBinder.Eval(Container.DataItem, "ID")%>' target="_blank">
                                                                                <span style="color: red;">#<%#DataBinder.Eval(Container.DataItem, "ID")%></span>&nbsp;&nbsp; <%#DataBinder.Eval(Container.DataItem, "Operation")%><br />
                                                                                <br />
                                                                                <span style="font-size: smaller">
                                                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label>:  <a href="TTUserInforSimple.aspx?UserCode=<%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>" target="_blank" style="font-size: smaller"><%#DataBinder.Eval(Container.DataItem, "AssignManCode")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "AssignManName")%>  </a></span>

                                                                            </a>
                                                                        </div>
                                                                        <div style="background-color: white; height: 5px;">
                                                                            &nbsp;
                                                                        </div>
                                                                    </ItemTemplate>
                                                                </asp:DataList>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />

                                            </ContentTemplate>
                                        </cc2:TabPanel>
                                        <cc2:TabPanel ID="TabPanel3" runat="server" HeaderText="我建立的任务:">
                                            <HeaderTemplate>
                                                <asp:Label ID="Label42" runat="server" Text="<%$ Resources:lang,WoJianLiDeRenWu%>"></asp:Label>
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <br />
                                                <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td style="width: 100%; text-align: Left;">
                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,BianHao %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label44" runat="server" Text="<%$ Resources:lang,LeiXing %>"></asp:Label></strong></td>
                                                                                <td width="18%" align="center"><strong>
                                                                                    <asp:Label ID="Label45" runat="server" Text="<%$ Resources:lang,RenWuNeiRong %>"></asp:Label></strong></td>
                                                                                <td width="8%" align="center"><strong>
                                                                                    <asp:Label ID="Label46" runat="server" Text="<%$ Resources:lang,YouXianJi %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label47" runat="server" Text="<%$ Resources:lang,KaiShiShiJian %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label48" runat="server" Text="<%$ Resources:lang,JieShuShiJian %>"></asp:Label></strong></td>
                                                                                <td width="100px" align="center"><strong>
                                                                                    <asp:Label ID="Label49" runat="server" Text="<%$ Resources:lang,JinDu %>"></asp:Label></strong></td>
                                                                                <td width="8%" align="center"><strong>
                                                                                    <asp:Label ID="Label50" runat="server" Text="<%$ Resources:lang,FeiYongYuSuan %>"></asp:Label></strong></td>
                                                                                <td width="7%" align="center"><strong>
                                                                                    <asp:Label ID="Label51" runat="server" Text="<%$ Resources:lang,GongShiYuSuan %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label52" runat="server" Text="<%$ Resources:lang,FeiYong %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label53" runat="server" Text="<%$ Resources:lang,GongShi2 %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label54" runat="server" Text="<%$ Resources:lang,ZhuangTai %>"></asp:Label></strong></td>
                                                                                <td align="center"><strong></strong></td>
                                                                                <td align="center"><strong></strong></td>
                                                                                <td align="center"><strong></strong></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td width="6" align="right">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <asp:DataGrid ID="DataGrid4" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                OnPageIndexChanged="DataGrid4_PageIndexChanged" ShowHeader="False" Width="100%" PageSize="25"
                                                                Height="1px" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                                <Columns>
                                                                    <asp:BoundColumn DataField="TaskID" HeaderText="Number">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="Type" HeaderText="Type">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:HyperLinkColumn DataNavigateUrlField="TaskID" DataNavigateUrlFormatString="TTCreateProjectTaskDetail.aspx?TaskID={0}"
                                                                        DataTextField="Task" HeaderText="任务内容" Target="_blank">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="18%" />
                                                                    </asp:HyperLinkColumn>
                                                                    <asp:BoundColumn DataField="Priority" HeaderText="优先级">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="8%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate>
                                                                            <div style="position: relative; height: 25px; width: 100px; overflow: hidden;">
                                                                                <!-- 黄色底层背景 -->
                                                                                <div style="position: absolute; top: 0; left: 0; width: 100px; height: 25px; background-color: yellow; z-index: 1;"></div>

                                                                                <!-- 绿色进度条背景 - 新增控件 -->
                                                                                <div id="ProgressBar4" runat="server" style="position: absolute; top: 0; left: 0; height: 25px; background-color: yellowgreen; z-index: 2; max-width: 100px; overflow: hidden;"></div>

                                                                                <!-- 绿色文字 - 显示百分比数据 -->
                                                                                <div style="position: absolute; top: 0; left: 5px; height: 25px; line-height: 25px; z-index: 3;">
                                                                                    <asp:Label ID="LB_FinishPercent" runat="server"
                                                                                        Text='<%#DataBinder.Eval(Container.DataItem,"FinishPercent") %>'
                                                                                        Style="color: #000; background: transparent !important; font-size: Small;"></asp:Label>
                                                                                </div>
                                                                            </div>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="100px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="Budget" HeaderText="费用预算">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="7%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="ManHour" HeaderText="工时预算">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="7%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate><a href='TTProExpenseView.aspx?TaskID=<%#DataBinder .Eval (Container .DataItem ,"TaskID") %>'><%#DataBinder .Eval (Container .DataItem ,"Expense") %></a></ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="RealManHour" HeaderText="LaborHours">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn HeaderText="Status">
                                                                        <ItemTemplate>
                                                                            <%# ShareClass.GetStatusHomeNameByTaskStatus(Eval("Status").ToString()) %>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="5%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:HyperLinkColumn DataNavigateUrlField="TaskID" DataNavigateUrlFormatString="TTMakeTaskTestCase.aspx?TaskID={0}"
                                                                        Text="&lt;div&gt;&lt;img src=ImagesSkin/TestCase.jpg border=0 alt='用例' /&gt;&lt;/div&gt;" HeaderText="测试用例" Target="_blank">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:HyperLinkColumn>
                                                                    <asp:HyperLinkColumn DataNavigateUrlField="TaskID" DataNavigateUrlFormatString="TTTaskAssignRecord.aspx?TaskID={0}"
                                                                        Text="&lt;div&gt;&lt;img src=ImagesSkin/JiLu.png border=0 alt='分派记录' width=24 height=24 /&gt;&lt;/div&gt;" HeaderText="分派记录" Target="_blank">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:HyperLinkColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate>
                                                                            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.TaskID", "TTProTaskRelatedDoc.aspx?TaskID={0}") %>'
                                                                                Target="_blank"><img src ="ImagesSkin/Doc.gif" class="noBorder" /></asp:HyperLink>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="4%" />
                                                                    </asp:TemplateColumn>
                                                                </Columns>
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="Center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                <ItemStyle CssClass="itemStyle" />
                                                            </asp:DataGrid><asp:Label ID="LB_Sql4" runat="server" Visible="False"></asp:Label><asp:Label ID="LB_TotalNumber4" runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                            </ContentTemplate>
                                        </cc2:TabPanel>
                                        <cc2:TabPanel ID="TabPanel4" runat="server" HeaderText="建立但没分派的任务:">
                                            <HeaderTemplate>
                                                <asp:Label ID="Label55" runat="server" Text="<%$ Resources:lang,JLDWFPDRW%>"></asp:Label>
                                            </HeaderTemplate>
                                            <ContentTemplate>
                                                <br />
                                                <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td style="width: 100%; text-align: Left;">
                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>

                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label56" runat="server" Text="<%$ Resources:lang,BianHao %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label57" runat="server" Text="<%$ Resources:lang,LeiXing %>"></asp:Label></strong></td>
                                                                                <td width="18%" align="center"><strong>
                                                                                    <asp:Label ID="Label58" runat="server" Text="<%$ Resources:lang,RenWuNeiRong %>"></asp:Label></strong></td>
                                                                                <td width="8%" align="center"><strong>
                                                                                    <asp:Label ID="Label59" runat="server" Text="<%$ Resources:lang,YouXianJi %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label60" runat="server" Text="<%$ Resources:lang,KaiShiShiJian %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label61" runat="server" Text="<%$ Resources:lang,JieShuShiJian %>"></asp:Label></strong></td>
                                                                                <td width="100px" align="center"><strong>
                                                                                    <asp:Label ID="Label62" runat="server" Text="<%$ Resources:lang,JinDu %>"></asp:Label></strong></td>
                                                                                <td width="8%" align="center"><strong>
                                                                                    <asp:Label ID="Label63" runat="server" Text="<%$ Resources:lang,FeiYongYuSuan %>"></asp:Label></strong></td>
                                                                                <td width="7%" align="center"><strong>
                                                                                    <asp:Label ID="Label64" runat="server" Text="<%$ Resources:lang,GongShiYuSuan %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label65" runat="server" Text="<%$ Resources:lang,FeiYong %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label66" runat="server" Text="<%$ Resources:lang,GongShi2 %>"></asp:Label></strong></td>
                                                                                <td width="5%" align="center"><strong>
                                                                                    <asp:Label ID="Label67" runat="server" Text="<%$ Resources:lang,ZhuangTai %>"></asp:Label></strong></td>
                                                                                <td align="center"><strong></strong></td>
                                                                                <td align="center"><strong></strong></td>
                                                                                <td align="center"><strong></strong></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td width="6" align="right">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" /></td>
                                                                </tr>
                                                            </table>
                                                            <asp:DataGrid ID="DataGrid6" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                OnPageIndexChanged="DataGrid6_PageIndexChanged" ShowHeader="False" Width="100%" PageSize="25"
                                                                Height="1px" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                                <Columns>
                                                                    <asp:BoundColumn DataField="TaskID" HeaderText="Number">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="Type" HeaderText="Type">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:HyperLinkColumn DataNavigateUrlField="TaskID" DataNavigateUrlFormatString="TTCreateProjectTaskDetail.aspx?TaskID={0}"
                                                                        DataTextField="Task" HeaderText="任务内容" Target="_blank">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="18%" />
                                                                    </asp:HyperLinkColumn>
                                                                    <asp:BoundColumn DataField="Priority" HeaderText="优先级">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="8%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate>
                                                                            <div style="position: relative; height: 25px; width: 100px; overflow: hidden;">
                                                                                <!-- 黄色底层背景 -->
                                                                                <div style="position: absolute; top: 0; left: 0; width: 100px; height: 25px; background-color: yellow; z-index: 1;"></div>

                                                                                <!-- 绿色进度条背景 - 新增控件 -->
                                                                                <div id="ProgressBar6" runat="server" style="position: absolute; top: 0; left: 0; height: 25px; background-color: yellowgreen; z-index: 2; max-width: 100px; overflow: hidden;"></div>

                                                                                <!-- 绿色文字 - 显示百分比数据 -->
                                                                                <div style="position: absolute; top: 0; left: 5px; height: 25px; line-height: 25px; z-index: 3;">
                                                                                    <asp:Label ID="LB_FinishPercent" runat="server"
                                                                                        Text='<%#DataBinder.Eval(Container.DataItem,"FinishPercent") %>'
                                                                                        Style="color: #000; background: transparent !important; font-size: Small;"></asp:Label>
                                                                                </div>
                                                                            </div>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="100px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="Budget" HeaderText="费用预算">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="7%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="ManHour" HeaderText="工时预算">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="7%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate><a href='TTProExpenseView.aspx?TaskID=<%#DataBinder .Eval (Container .DataItem ,"TaskID") %>'><%#DataBinder .Eval (Container .DataItem ,"Expense") %></a></ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="RealManHour" HeaderText="LaborHours">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="5%" />
                                                                    </asp:BoundColumn>
                                                                    <asp:TemplateColumn HeaderText="Status">
                                                                        <ItemTemplate>
                                                                            <%# ShareClass.GetStatusHomeNameByTaskStatus(Eval("Status").ToString()) %>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="5%" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:HyperLinkColumn DataNavigateUrlField="TaskID" DataNavigateUrlFormatString="TTMakeTaskTestCase.aspx?TaskID={0}"
                                                                        Text="&lt;div&gt;&lt;img src=ImagesSkin/TestCase.jpg border=0 alt='用例' /&gt;&lt;/div&gt;" HeaderText="测试用例" Target="_blank">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:HyperLinkColumn>
                                                                    <asp:HyperLinkColumn DataNavigateUrlField="TaskID" DataNavigateUrlFormatString="TTTaskAssignRecord.aspx?TaskID={0}"
                                                                        Text="&lt;div&gt;&lt;img src=ImagesSkin/JiLu.png border=0 alt='分派记录' width=24 height=24 /&gt;&lt;/div&gt;" HeaderText="分派记录" Target="_blank">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:HyperLinkColumn>
                                                                    <asp:TemplateColumn>
                                                                        <ItemTemplate>
                                                                            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.TaskID", "TTProTaskRelatedDoc.aspx?TaskID={0}") %>'
                                                                                Target="_blank">
                                                                                    <img src="ImagesSkin/Doc.gif" class="noBorder" /></asp:HyperLink>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="4%" />
                                                                    </asp:TemplateColumn>
                                                                </Columns>
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="Center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                <ItemStyle CssClass="itemStyle" />
                                                            </asp:DataGrid><asp:Label ID="LB_Sql6" runat="server" Visible="False"></asp:Label><asp:Label ID="LB_TotalNumber6" runat="server" Visible="False"></asp:Label></td>
                                                    </tr>
                                                </table>
                                                <br />
                                            </ContentTemplate>
                                        </cc2:TabPanel>
                                    </cc2:TabContainer>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td>
                                    <asp:Button ID="BT_UpdateStatus" runat="server" Text="UpdateStatus" OnClick="BT_UpdateStatus_Click" />
                                    <asp:HiddenField ID="LB_TargetStatus" runat="server" />
                                    <asp:HiddenField ID="LB_SourceID" runat="server" />
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
    </center>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>