<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppCollaboration.aspx.cs" Inherits="TTAppCollaboration" %>



<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
     <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />
   

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { initSwipeBack();// 初始化滑动返回功能 

            //

            SetDataGridTrClickLink();

        });

        //点击DATAGRID行内任何一点，都能触发行内的链接
        function SetDataGridTrClickLink() {

            setTrClickLink("DataGrid2");
            setTrClickLink("DataGrid1");
            setTrClickLink("DataGrid3");
            setTrClickLink("DataGrid4");
        }
    </script>

</head>
<body>
    <div id="swipeFeedback" class="swipe-feedback"><asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" /></div> <!-- 滑动反馈层 -->
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
                                            <a id="aAPPBackPriorPage" href="TakeTopAPPMain.aspx" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                <table width="145" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <img src="ImagesSkin/return.png" alt="" />
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                                            </a>
                                        </td>
                                        <td align="center" style="padding-top: 5px;">
                                            <asp:Button ID="BT_MakeCollaboration" CssClass="inpuLong" runat="server" Text="<%$ Resources:lang,MakeCollaboration%>" OnClick="BT_MakeCollaboration_Click" Visible="false"/>

                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>

                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                    <tr>
                                        <td>

                                            <div class="napbox">
                                                <div class="npb">
                                                    <div class="cline"></div>
                                                    <h3>
                                                        <asp:Label ID="Lbel1" runat="server" Text="<%$ Resources:lang,DaiChuLiDe%>" /></h3>
                                                </div>

                                                <asp:DataGrid ID="DataGrid4" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                    Height="1px" OnPageIndexChanged="DataGrid4_PageIndexChanged" PageSize="5" Width="100%" ShowHeader="false"
                                                    CellPadding="4" ForeColor="#333333" GridLines="None">
                                                    <HeaderStyle Horizontalalign="left" BackColor="#507CD1" Font-Bold="True" ForeColor="White" />


                                                    <Columns>

                                                        <asp:TemplateColumn HeaderText="">

                                                            <ItemTemplate>

                                                               <div class="npb npbs">
                                                                    <div class="nplef">
                                                                        <img src="ImagesSkin/napicon.png" /></div>
                                                                    <div class="nprig">
                                                                        <h4><a href="TTAppCollaborationDetailMain.aspx?CoID=<%# Eval("CoID").ToString() %>"><%# Eval("CoID").ToString() %>  <%# Eval("CollaborationName") %></a></h4>
                                                                        <h5><%# Eval("CreatorName") %>  <sub></sub></h5>
                                                                        <h6><%# DataBinder.Eval(Container.DataItem,"createtime") %></h6>
                                                                        <%--    <label></label>--%>
                                                                    </div>

                                                                </div>


                                                            </ItemTemplate>

                                                        </asp:TemplateColumn>

                                                    </Columns>


                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                </asp:DataGrid>
                                                <asp:Label ID="LB_Sql4" runat="server" Visible="False"></asp:Label>
                                            </div>

                                        </td>
                                    </tr>

                                    <tr>
                                        <td>

                                            <div class="napbox">
                                                <div class="npb">
                                                    <div class="cline"></div>
                                                    <h3>
                                                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,CanYiDe%>" /></h3>
                                                </div>


                                                <asp:DataGrid ID="DataGrid1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                    Height="1px" OnPageIndexChanged="DataGrid1_PageIndexChanged" PageSize="5" Width="100%"
                                                    CellPadding="4" ForeColor="#333333" GridLines="None" ShowHeader="false">
                                                    <HeaderStyle Horizontalalign="left" BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <Columns>

                                                        <asp:TemplateColumn HeaderText="">

                                                            <ItemTemplate>

                                                                <div class="npb npbs">
                                                                    <div class="nplef">
                                                                        <img src="ImagesSkin/napicon.png" /></div>
                                                                    <div class="nprig">
                                                                        <h4><a href="TTAppCollaborationDetailMain.aspx?CoID=<%# Eval("CoID").ToString() %>"><%# Eval("CoID").ToString() %>  <%# Eval("CollaborationName") %></a></h4>
                                                                        <h5><%# Eval("CreatorName") %>  <sub></sub></h5>
                                                                        <h6><%# DataBinder.Eval(Container.DataItem,"createtime") %></h6>
                                                                        <%--    <label></label>--%>
                                                                    </div>

                                                                </div>


                                                            </ItemTemplate>

                                                        </asp:TemplateColumn>

                                                    </Columns>

                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                </asp:DataGrid>
                                                <asp:Label ID="LB_Sql1" runat="server" Visible="False"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>


                                    <tr>
                                        <td>


                                            <div class="napbox">
                                                <div class="npb">
                                                    <div class="cline"></div>
                                                    <h3>
                                                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,ChuangJianDe%>" /></h3>
                                                </div>


                                                <asp:DataGrid ID="DataGrid3" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                    Height="1px" OnPageIndexChanged="DataGrid3_PageIndexChanged" PageSize="5" Width="100%" ShowHeader="false"
                                                    CellPadding="4" ForeColor="#333333" GridLines="None">
                                                    <HeaderStyle Horizontalalign="left" BackColor="#507CD1" Font-Bold="True" ForeColor="White" />

                                                    <Columns>

                                                        <asp:TemplateColumn HeaderText="">

                                                            <ItemTemplate>

                                                                <div class="npb npbs">
                                                                    <div class="nplef">
                                                                        <img src="ImagesSkin/napicon.png" /></div>
                                                                    <div class="nprig">
                                                                        <h4><a href="TTAppCollaborationDetailMain.aspx?CoID=<%# Eval("CoID").ToString() %>"><%# Eval("CoID").ToString() %>  <%# Eval("CollaborationName") %></a></h4>
                                                                        <h5><%# Eval("CreatorName") %>  <sub></sub></h5>
                                                                        <h6><%# DataBinder.Eval(Container.DataItem,"createtime") %></h6>
                                                                        <%--    <label></label>--%>
                                                                    </div>

                                                                </div>


                                                            </ItemTemplate>

                                                        </asp:TemplateColumn>

                                                    </Columns>

                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                </asp:DataGrid>
                                                <asp:Label ID="LB_Sql3" runat="server" Visible="False"></asp:Label>
                                                <asp:Label ID="LB_UserCode" runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="LB_UserName" runat="server" Visible="false"></asp:Label>
                                            </div>

                                        </td>
                                    </tr>
                                </table>

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
    </center>
</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>
