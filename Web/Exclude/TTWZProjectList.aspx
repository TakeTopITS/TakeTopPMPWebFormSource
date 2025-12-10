<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTWZProjectList.aspx.cs" Inherits="TTWZProjectList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>工程项目列表</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery-1.7.2.min.js"></script>
    <script src="js/allAHandler.js"></script>
    <%--<script src="js/dialog/lhgdialog.min.js"></script>--%>
    
    <script type="text/javascript">
        function AlertStock() {
            var varStockCode = document.getElementById("HF_StockCode");
            if (confirm("本项目库别=" + varStockCode + "，是否一并核销？")) {
                document.getElementById("BT_Cancel").click();
            }
        }


        //项目描述
        function SelectProjectDesc(projectCode) {

            var url = "TTWZSelectorProjectDesc.aspx?strProjectCode=" + projectCode;
            popShowByURLForFixedSize(url, '', 1200, 500);

            return false;
        }

        $(function () { 
           

            ControlStatusCloseChange();

        });



        function ControlStatusChange(objProgress, objIsStatus) {

            $("#BT_NewBrowse").attr("class", "inpu");
            $("#BT_NewBrowse").removeAttr("disabled");
            
            //alert(objProgress);
            if (objProgress == "录入") {
                $("#BT_NewEdit").attr("class", "inpu");
                $("#BT_NewEdit").removeAttr("disabled");                            //编辑
                $("#BT_NewDelete").attr("class", "inpu");
                $("#BT_NewDelete").removeAttr("disabled");                          //删除
                $("#BT_NewProject").attr("class", "inpu");
                $("#BT_NewProject").removeAttr("disabled");                         //立项
                $("#BT_NewNotProject").attr("disabled", "disabled");
                $("#BT_NewNotProject").removeClass("inpu");                         //立项退回
            }
            else if (objProgress == "立项") {
                $("#BT_NewEdit").attr("disabled", "disabled");
                $("#BT_NewEdit").removeClass("inpu");                            //编辑
                $("#BT_NewDelete").attr("disabled", "disabled");
                $("#BT_NewDelete").removeClass("inpu");                          //删除
                $("#BT_NewProject").attr("disabled", "disabled");
                $("#BT_NewProject").removeClass("inpu");                            //立项
                $("#BT_NewNotProject").attr("class", "inpu");
                $("#BT_NewNotProject").removeAttr("disabled");                         //立项退回
            }
            else {
                $("#BT_NewEdit").attr("disabled", "disabled");
                $("#BT_NewEdit").removeClass("inpu");                            //编辑
                $("#BT_NewDelete").attr("disabled", "disabled");
                $("#BT_NewDelete").removeClass("inpu");                          //删除
                $("#BT_NewProject").attr("disabled", "disabled");
                $("#BT_NewProject").removeClass("inpu");                         //立项
                $("#BT_NewNotProject").attr("disabled", "disabled");
                $("#BT_NewNotProject").removeClass("inpu");                      //立项退回
            }
            
            //alert(objIsStatus);
            if (objIsStatus == "正常") {
                $("#BT_NewProjectClose").attr("class", "inpu");
                $("#BT_NewProjectClose").removeAttr("disabled");                      //项目关闭
                $("#BT_NewReturnProject").attr("disabled", "disabled");
                $("#BT_NewReturnProject").removeClass("inpu");                         //关闭退回
            }
            else if (objIsStatus == "关闭") {
                $("#BT_NewProjectClose").attr("disabled", "disabled");
                $("#BT_NewProjectClose").removeClass("inpu");                      //项目关闭
                $("#BT_NewReturnProject").attr("class", "inpu");
                $("#BT_NewReturnProject").removeAttr("disabled");                         //关闭退回
            }
            else {
                $("#BT_NewProjectClose").attr("disabled", "disabled");
                $("#BT_NewProjectClose").removeClass("inpu");                      //项目关闭
                $("#BT_NewReturnProject").attr("class", "inpu");
                $("#BT_NewReturnProject").removeAttr("disabled");                         //关闭退回
            }
        }



        function ControlStatusCloseChange() {
            $("#BT_NewEdit").attr("disabled", "disabled");
            $("#BT_NewEdit").removeClass("inpu");
            $("#BT_NewDelete").attr("disabled", "disabled");
            $("#BT_NewDelete").removeClass("inpu");
            $("#BT_NewProject").attr("disabled", "disabled");
            $("#BT_NewProject").removeClass("inpu");
            $("#BT_NewNotProject").attr("disabled", "disabled");
            $("#BT_NewNotProject").removeClass("inpu");
            $("#BT_NewBrowse").attr("disabled", "disabled");
            $("#BT_NewBrowse").removeClass("inpu");
            $("#BT_NewProjectClose").attr("disabled", "disabled");
            $("#BT_NewProjectClose").removeClass("inpu");
            $("#BT_NewReturnProject").attr("disabled", "disabled");
            $("#BT_NewReturnProject").removeClass("inpu");
        }

        function LoadProjectList() {
            //alert("调用成功");
            document.getElementById("BT_RelaceLoad").click();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <div id="AboveDiv">
                        <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                            <tr>
                                <td height="31" class="page_topbj">
                                    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table width="345" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                        </td>
                                                        <td align="center" background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,LiXiang%>"></asp:Label>
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 5px 5px 5px;" valign="top">
                                    <table width="100%" cellpadding="1" cellspacing="0" style="word-break: break-all; word-wrap: break-word;">
                                        <tr>
                                            <td>
                                                <table class="formBgStyle">
                                                    <tr>
                                                        <td  class="formItemBgStyleForAlignLeft">
                                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,JinDu%>"></asp:Label>:
                                                        </td>
                                                        <td  class="formItemBgStyleForAlignLeft">
                                                            <asp:DropDownList ID="DDL_Progress" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DDL_Progress_SelectedIndexChanged">
                                                                <asp:ListItem Text="<%$ Resources:lang,QuanBu%>" Value=""/>
                                                                <asp:ListItem Text="<%$ Resources:lang,LuRu%>" Value="录入"/>
                                                                <asp:ListItem Text="<%$ Resources:lang,LiXiang%>" Value="立项"/>
                                                                <asp:ListItem Text="<%$ Resources:lang,KaiGong%>" Value="开工"/>
                                                                <asp:ListItem Text="<%$ Resources:lang,HeXiao%>" Value="核销"/>
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td  class="formItemBgStyleForAlignLeft">
                                                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,XiangMuBianMa%>"></asp:Label>:
                                                        </td>
                                                        <td  class="formItemBgStyleForAlignLeft">
                                                            <asp:TextBox ID="TXT_ProjectCode" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td  class="formItemBgStyleForAlignLeft">
                                                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,XiangMuMingCheng%>"></asp:Label>:
                                                        </td>
                                                        <td  class="formItemBgStyleForAlignLeft">
                                                            <asp:TextBox ID="TXT_ProjectName" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="formItemBgStyleForAlignLeft">
                                                            <asp:Button ID="btnSeach" runat="server" Text="<%$ Resources:lang,XiangMuMingCheng%>" CssClass="inpu" OnClick="btnSeach_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td  class="formItemBgStyleForAlignLeft">
                                                <table style="width: 50%;" cellpadding="2" cellspacing="0" class="formBgStyle">
                                                    <tr>
                                                        
                                                        <td  class="formItemBgStyleForAlignLeft" colspan="2">
                                                            &nbsp;&nbsp;
                                                            <input type="button" class="inpuLong" value="新增工程项目" onclick="AlertProjectPage('TTWZProjectAdd.aspx?strProjectCode=');" />&nbsp;
                                                            <asp:Button ID="BT_RepeatMark" runat="server" Text="<%$ Resources:lang,ChongZuoShiYongBiaoJi%>" CssClass="inpuLong" OnClick="BT_RepeatMark_Click" Visible="false" />&nbsp;
                                                            <asp:Button ID="BT_ProjectTotal" runat="server" Text="<%$ Resources:lang,XiangMuTongJi%>" CssClass="inpuLong" OnClick="BT_ProjectTotal_Click" Visible="false" />&nbsp;
                                                            <asp:Button ID="BT_Cancel" runat="server" Text="<%$ Resources:lang,HeXiaoKuBie%>" CssClass="inpu" OnClick="BT_Cancel_Click" Style="display: none;" />&nbsp;
                                                            
                                                            <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,LieBiaoPaiXu%>"></asp:Label>:
                                                            <asp:Button ID="BT_SortProjectCode" CssClass="inpu" runat="server" Text="<%$ Resources:lang,XiangMuBianMa%>" OnClick="BT_SortProjectCode_Click" />&nbsp;
                                                            <asp:Button ID="BT_SortProjectName" CssClass="inpu" runat="server" Text="<%$ Resources:lang,XiangMuMingCheng%>" OnClick="BT_SortProjectName_Click" />&nbsp;
                                                            <asp:Button ID="BT_SortStartTime" CssClass="inpu" runat="server" Text="<%$ Resources:lang,KaiGongRiQi%>" OnClick="BT_SortStartTime_Click" />
                                                            <asp:HiddenField ID="HF_SortProjectCode" runat="server" />
                                                            <asp:HiddenField ID="HF_SortProjectName" runat="server" />
                                                            <asp:HiddenField ID="HF_SortStartTime" runat="server" />


                                                            <asp:Button ID="BT_RelaceLoad" runat="server" Text="<%$ Resources:lang,ChongXinJiaZaiLieBiao%>" OnClick="BT_RelaceLoad_Click" CssClass="inpu" style="display:none;" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td  class="formItemBgStyleForAlignLeft">
                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,GongChengXiangMuJiLuGong%>"></asp:Label><asp:Label ID="LB_RecordCount" runat="server" Text=""></asp:Label><asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,Tiao%>"></asp:Label>&nbsp;&nbsp;
                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,JiLuCaoZuo%>"></asp:Label>:<asp:Button ID="BT_NewEdit" CssClass="inpu" runat="server" Text="<%$ Resources:lang,BianJi%>" OnClick="BT_NewEdit_Click" />&nbsp;
                                                <asp:Button ID="BT_NewDelete" CssClass="inpu" runat="server" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_NewDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"/>&nbsp;
                                                <asp:Button ID="BT_NewProject" CssClass="inpu" runat="server" Text="<%$ Resources:lang,LiXiang%>" OnClick="BT_NewProject_Click" />&nbsp;
                                                <asp:Button ID="BT_NewNotProject" CssClass="inpu" runat="server" Text="<%$ Resources:lang,LiXiangTuiHui%>" OnClick="BT_NewNotProject_Click" />&nbsp;
                                                <asp:Button ID="BT_NewBrowse" CssClass="inpu" runat="server" Text="<%$ Resources:lang,LiuLan%>" OnClick="BT_NewBrowse_Click" />&nbsp;
                                                <asp:Button ID="BT_NewProjectClose" CssClass="inpu" runat="server" Text="<%$ Resources:lang,XiangMuGuanBi%>" OnClick="BT_NewProjectClose_Click" />&nbsp;
                                                <asp:Button ID="BT_NewReturnProject" CssClass="inpu" runat="server" Text="<%$ Resources:lang,GuanBiTuiHui%>" OnClick="BT_NewReturnProject_Click" />&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="padding-top: 5px;">
                                                <div style="width: 3600px;">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                        <tr>
                                                            <td width="7">
                                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                            </td>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td width="1%" align="center">
                                                                            <strong>&nbsp;<%--操作--%></strong></td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,XiangMuBianMa%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="7%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,XiangMuMingCheng%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,XiangMuJingLi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,KaiGongRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,WanGongRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,ShouQuanCaiGou%>"></asp:Label></strong>
                                                                        </td>
                                                                        <%--<td width="3%" align="center">
                                                                            <strong><asp:Label runat="server" Text="<%$ Resources:lang,LingLiaoDanWei%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong><asp:Label runat="server" Text="<%$ Resources:lang,DanWeiBianHao%>"></asp:Label></strong>
                                                                        </td>--%>
                                                                        <%--<td width="3%" align="center">
                                                                            <strong><asp:Label runat="server" Text="<%$ Resources:lang,FeiKongZhuGuan%>"></asp:Label></strong>
                                                                        </td>--%>
                                                                        <td width="3%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,JiaGongGaiSuan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,ZiGouGaiSuan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="4%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,JianSheDanWei%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="4%" class="ItemAlignLeft">
                                                                            <strong>
                                                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,JianLiDanWei%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,XiangMuMiaoShu%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,BianZhiRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,BianZhiRen%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,KuBie%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,WeiTuoDaiLiRen%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,CaiGouJingLi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,CaiGouGongChengShi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,HeTongYuan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,CaiJianYuan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,BaoGuanYuan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,BuChongBianJi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,JiaLingYuSuan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,HeTongJinE%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,ShiGouJinE%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,ShuiJin%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,YunZaFei%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="right">
                                                                            <strong>
                                                                                <asp:Label ID="Label35" runat="server" Text="<%$ Resources:lang,FaLiaoJinE%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label36" runat="server" Text="<%$ Resources:lang,CaiGouJinDu%>"></asp:Label>%</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,JinDu%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,ShiYongBiaoJi%>"></asp:Label></strong>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="6" align="right">
                                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <asp:DataGrid ID="DG_List" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                        CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px" PageSize="20" ShowHeader="false"
                                                        Width="100%" OnItemCommand="DG_List_ItemCommand" OnPageIndexChanged="DG_List_PageIndexChanged">
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="1%" />
                                                                <HeaderTemplate>
                                                                    <%--操作--%>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>

                                                                    <asp:LinkButton runat="server" CommandArgument='<%# Eval("ProjectCode")+"|"+Eval("Progress")+"|"+Eval("IsStatus") %>' CommandName="click" CssClass="notTab">
                                                                        <asp:Label ID="Label46" runat="server" Text="<%$ Resources:lang,CaoZuo%>"></asp:Label></asp:LinkButton>

                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="project" CssClass="notTab" Visible='<%# Eval("Progress").ToString()=="录入" ? true : false %>'>立项</asp:LinkButton>--%>
                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="projectReturn" CssClass="notTab" Visible='<%# Eval("Progress").ToString()=="立项" ? true : false %>'>立项退回</asp:LinkButton>--%>
                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="cancel" CssClass="notTab" Visible='<%# Eval("Progress").ToString()=="开工" ? true : false %>'>核销</asp:LinkButton>--%>
                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="cancelReturn" CssClass="notTab" Visible='<%# Eval("Progress").ToString()=="核销" ? true : false %>'>核销退回</asp:LinkButton>--%>

                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="close" CssClass="notTab" Visible='<%# Eval("IsStatus").ToString()=="正常" ? true : false %>'>项目关闭</asp:LinkButton>--%>
                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="notClose" CssClass="notTab" Visible='<%# Eval("IsStatus").ToString()=="关闭" ? true : false %>'>关闭退回</asp:LinkButton>--%>

                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="del" CssClass="notTab">删除</asp:LinkButton>--%>
                                                                    <%--<asp:LinkButton runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="browse" CssClass="notTab">浏览</asp:LinkButton>--%>
                                                                    
                                                                    <%--<asp:LinkButton ID="LinkButton1" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>' CommandName="edit" CssClass="notTab" Visible='<%# Eval("Progress").ToString()=="录入" ? true : false %>'>编辑</asp:LinkButton>--%>
                                                                    
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="ProjectCode" HeaderText="项目编码">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <%--<asp:BoundColumn DataField="ProjectName" HeaderText="项目名称">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="7%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="7%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,XiangMuMingCheng%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%# ShareClass.StringCutByRequire(Eval("ProjectName").ToString(), 23) %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="ProjectManagerName" HeaderText="项目经理">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <%--<asp:BoundColumn DataField="StartTime" HeaderText="开工日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label40" runat="server" Text="<%$ Resources:lang,KaiGongRiQi%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%#DataBinder.Eval(Container.DataItem, "StartTime", "{0:yyyy/MM/dd}")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <%--<asp:BoundColumn DataField="EndTime" HeaderText="完工日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label41" runat="server" Text="<%$ Resources:lang,WanGongRiQi%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%#DataBinder.Eval(Container.DataItem, "EndTime", "{0:yyyy/MM/dd}")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PowerPurchase" HeaderText="授权采购">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <%--<asp:BoundColumn DataField="PickingUnit" HeaderText="领料单位">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UnitCode" HeaderText="单位编号">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>--%>
                                                            <%--<asp:BoundColumn DataField="FeeManageName" HeaderText="费控主管">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:BoundColumn DataField="ForCost" HeaderText="甲供概算">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="SelfCost" HeaderText="自购概算">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <%--<asp:BoundColumn DataField="BuildUnit" HeaderText="建设单位">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="4%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="4%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label42" runat="server" Text="<%$ Resources:lang,JianSheDanWei%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%# ShareClass.StringCutByRequire(Eval("BuildUnit").ToString(), 11) %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <%--<asp:BoundColumn DataField="SupervisorUnit" HeaderText="监理单位">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="4%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="4%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,JianLiDanWei%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%# ShareClass.StringCutByRequire(Eval("SupervisorUnit").ToString(), 11) %>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <%--<asp:BoundColumn DataField="ProjectDesc" HeaderText="项目描述">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label44" runat="server" Text="<%$ Resources:lang,XiangMuMiaoShu%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <a style="color:blue;cursor:pointer;" onclick='SelectProjectDesc("<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>")' class="notTab" target="_blank">项目描述</a>
                                                                    <%--<b onclick='SelectProjectDesc(<%# DataBinder.Eval(Container.DataItem,"ProjectCode") %>)'>项目描述</b>--%><%--<%# Eval("ProjectDesc")%>--%>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <%--<asp:BoundColumn DataField="MarkTime" HeaderText="编制日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>--%>
                                                            <asp:TemplateColumn>
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label45" runat="server" Text="<%$ Resources:lang,BianZhiRiQi%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%#DataBinder.Eval(Container.DataItem, "MarkTime", "{0:yyyy/MM/dd}")%>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="MarkerName" HeaderText="编制人">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="StoreRoom" HeaderText="库别">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="DelegateAgentName" HeaderText="委托代理人">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PurchaseManagerName" HeaderText="采购经理">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PurchaseEngineerName" HeaderText="采购工程师">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ContracterName" HeaderText="合同员">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CheckerName" HeaderText="材检员">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="SafekeepName" HeaderText="保管员">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="SupplementEditorName" HeaderText="补充编辑">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="TheBudget" HeaderText="甲领预算">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ContractMoney" HeaderText="合同金额">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="AcceptMoney" HeaderText="实购金额">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ProjectTax" HeaderText="税金">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="TheFreight" HeaderText="运杂费">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="SendMoney" HeaderText="发料金额">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Right" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FinishingRate" HeaderText="采购进度%">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Progress" HeaderText="进度">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="IsMark" HeaderText="使用标记">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                        <EditItemStyle BackColor="#2461BF" />
                                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                        <PagerStyle HorizontalAlign="Center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                        
                                                        <ItemStyle CssClass="itemStyle" />
                                                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                                                    </asp:DataGrid>
                                                </div>
                                                <asp:Label ID="LB_ProjectSql" runat="server" Visible="False"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <asp:HiddenField ID="HF_StockCode" runat="server" />
                <asp:HiddenField ID="HF_ProjectCode" runat="server" />
                <asp:HiddenField ID="HF_Progress" runat="server" />
                <asp:HiddenField ID="HF_IsStatus" runat="server" />
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnSeach" />
                <asp:PostBackTrigger ControlID="BT_Cancel" />
            </Triggers>
        </asp:UpdatePanel>
    </form>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script></html>
