<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTGDIsomJointList.aspx.cs" Inherits="TTGDIsomJointList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>单线图接头列表</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function ClickAddRedict()
        {
            var varIsom_no = document.getElementById("HF_Isom_no").value;
            var varUrl = "TTGDIsomJointEdit.aspx?Isom_no=" + varIsom_no;
            window.location.href = varUrl;
        }

        function LoadProjectList() {
           
            document.getElementById("BT_RelaceLoad").click();
        }


    </script>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { 

            

        });

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
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,DanXianTuJieTouLieBiao%>"></asp:Label>
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
                                <td style="padding: 0px 5px 5px 5px;" valign="top">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td  class="formItemBgStyleForAlignLeft">
                                                <%--<input type="button" class="inpuLong" value="新增单线图接头" onclick="AlertProjectPage('TTGDIsomJointEdit.aspx?Isom_no=');" />--%>
                                                <asp:Button ID="BT_Add" CssClass="inpuLong" runat="server" Text="<%$ Resources:lang,XZDXTJT%>" OnClick="BT_Add_Click" />

                                                <asp:Button ID="BT_RelaceLoad" runat="server" Text="<%$ Resources:lang,ChongXinJiaZaiLieBiao%>" OnClick="BT_RelaceLoad_Click" CssClass="inpu" style="display:none;" />

                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" style="padding-top: 5px;">
                                                <div style="width: 3400px;">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                        <tr>
                                                            <td width="7">
                                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                            </td>
                                                            <td>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,CaoZuo%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,JieTouHao%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,BianGeng%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,ChiCun%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>S/F</strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,JieZhiDaiHao%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,GuanJianHao%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,AnZhuangRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,DaDiHanGongYi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,DaDiHanGongEr%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,DaDiRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,GaiMianHanGongYi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,GaiMianHanGongEr%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="3%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,GaiMianRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>WPSNo</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,ShiYaBaoHao%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>FRI1</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>FRI2</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>FRI3</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>FRI4</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,FitUpRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>Fit-Up</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,WaiGuanRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,WaiGuan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,RTRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>RT</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,PTRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>PT</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,ReChuLiRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,ReChuLi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,PMIRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>PMI</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,MTRiQi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>MT</strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,LiShiYe%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,YaLiShiYan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,ChouQianXiangQingYi%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,ChouQianXiangQingEr%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,ChouQianXiangQingSan%>"></asp:Label></strong>
                                                                        </td>
                                                                        <td width="2%" align="center">
                                                                            <strong>
                                                                                <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,ChouQianXiangQingSi%>"></asp:Label></strong>
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
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                                <HeaderTemplate>
                                                                    <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,CaoZuo%>"></asp:Label>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <%--<a href='TTGDIsomJointEdit.aspx?id=<%# DataBinder.Eval(Container.DataItem,"ID") %>&Isom_no=<%# DataBinder.Eval(Container.DataItem,"Isom_no") %>'>编辑</a>--%>

                                                                    <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument='<%# Eval("ID")+"|"+Eval("Isom_no") %>' CommandName="edit" CssClass="notTab">
                                                                        <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,BianJi%>"></asp:Label></asp:LinkButton>

                                                                    <asp:LinkButton ID="LB_Del" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="del" CssClass="notTab">
                                                                        <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,ShanChu%>"></asp:Label></asp:LinkButton>
                                                                    <%--<asp:Button ID="Button1" CssClass="inpu" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="del" Text="删除" />--%>
                                                                    
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="JointNo" HeaderText="接头号">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Rev" HeaderText="变更">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Size" HeaderText="尺寸">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Mold" HeaderText="类型">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="SF" HeaderText="S/F">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MediumCode" HeaderText="介质代号">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Pipefittings" HeaderText="管件号">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="InstallationTime" HeaderText="安装日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RanderWelderName1" HeaderText="打底焊工1">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RanderWelderName2" HeaderText="打底焊工2">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RanderTime" HeaderText="打底日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CoveringWelderName1" HeaderText="盖面焊工1">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CoveringWelderName2" HeaderText="盖面焊工2">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CoveringTime" HeaderText="盖面日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="3%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="WPSNo" HeaderText="WPSNo">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PressurePackNo" HeaderText="试压包号">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FRI1" HeaderText="FRI1">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FRI2" HeaderText="FRI2">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FRI3" HeaderText="FRI3">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FRI4" HeaderText="FRI4">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FitUpTime" HeaderText="Fit-Up日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FitUp" HeaderText="Fit-Up">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="VisualTime" HeaderText="外观日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Visual" HeaderText="外观">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RTTime" HeaderText="RT日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RT" HeaderText="RT">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PTTime" HeaderText="PT日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PT" HeaderText="PT">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PWHTTime" HeaderText="热处理日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PWHT" HeaderText="热处理">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PMITime" HeaderText="PMI日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PMI" HeaderText="PMI">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MTTime" HeaderText="MT日期">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MT" HeaderText="MT">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="HistorySheet" HeaderText="历史页">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PressTest" HeaderText="压力试验">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RTLotDetailsRT1" HeaderText="抽签详情1">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RTLotDetailsRT2" HeaderText="抽签详情2">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RTLotDetailsRT3" HeaderText="抽签详情3">
                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" Width="2%" />
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="RTLotDetailsRT4" HeaderText="抽签详情4">
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
                                                    <asp:Label ID="LB_Sql" runat="server" Visible="False"></asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <asp:HiddenField ID="HF_Isom_no" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script></html>
