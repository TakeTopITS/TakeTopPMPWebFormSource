<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppTask.aspx.cs" Inherits="TTAppTask" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
     <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />
  
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { initSwipeBack();// 初始化滑动返回功能 

            //

            SetDataGridTrClickLink();

        });

        //点击DATAGRID行内任何一点，都能触发行内的链接
        function SetDataGridTrClickLink() {

            setTrClickLink("TabContainer1_TabPanel1_DataGrid1");
            setTrClickLink("TabContainer1_TabPanel2_DataGrid2");
            setTrClickLink("DataGrid3");
            setTrClickLink("DataGrid5");
            setTrClickLink("DataGrid4");

        }
    </script>
</head>
<body><div id="swipeFeedback" class="swipe-feedback"><asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" /></div> <!-- 滑动反馈层 -->

    <form id="form1" class="napf" runat="server">
        <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" class="napbac" runat="server">
            <ContentTemplate>

                <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                    <tr>
                        <td height="31" class="page_topbj">
                            <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="ItemAlignLeft">
                                        <a id="aAPPBackPriorPage" href="TakeTopAPPMain.aspx" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                            <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
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
                                    <td align="right" style="padding-top: 5px; padding-right: 8px;">
                                        <asp:Button ID="BT_CreateTask" runat="server" CssClass="inpu" Text="<%$ Resources:lang,MakeTask%>" OnClick="BT_CreateTask_Click" Visible="false" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="ItemAlignLeft">
                            <cc2:TabContainer CssClass="ajax_tab_menu" ID="TabContainer1" runat="server" ActiveTabIndex="0" Width="99%">
                                <cc2:TabPanel ID="TabPanel1" runat="server" HeaderText="我要处理的任务:">
                                    <HeaderTemplate>
                                        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,WoYaoChuLiDeRenWu%>" ToolTip="<%$ Resources:lang,WoYaoChuLiDeRenWu%>"></asp:Label>
                                    </HeaderTemplate>
                                    <ContentTemplate>

                                        <table style="width: 100%;" cellpadding="0" cellspacing="0">

                                            <tr>

                                                <td>

                                                    <div class="napbox">
                                                        <div class="npb">
                                                            <div class="cline"></div>
                                                            <h3>
                                                                <asp:Label ID="Lbel1" runat="server" Text="<%$ Resources:lang,ChuLiZhongDe%>" /></h3>
                                                        </div>


                                                        <asp:DataGrid ID="DataGrid1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                            CellPadding="4" Font-Bold="False" ForeColor="#333333" GridLines="None" Height="1px"
                                                            ShowHeader="False" OnPageIndexChanged="DataGrid1_PageIndexChanged" PageSize="5"
                                                            Width="100%">

                                                            <Columns>


                                                                <%--  <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTAppTaskDetail.aspx?ID={0}"
                                                                DataTextField="Operation" HeaderText="">

                                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="28%" />
                                                            </asp:HyperLinkColumn>--%>

                                                                <asp:TemplateColumn HeaderText="">

                                                                    <ItemTemplate>

                                                                        <div class="npb npbs">
                                                                            <div class="nplef">
                                                                                <img src="ImagesSkin/napicon.png" />
                                                                            </div>
                                                                            <div class="nprig">
                                                                                <h4><a href="TTAppTaskDetail.aspx?ID=<%# Eval("ID").ToString() %>"><%# Eval("ID").ToString() %>  <%# Eval("Operation") %></a></h4>
                                                                                <h5><%# Eval("assignmanname").ToString() %><sub></sub></h5>
                                                                                <h6><%# DataBinder.Eval(Container.DataItem,"begindate") %> --- <%# DataBinder.Eval(Container.DataItem,"enddate") %>  </h6>
                                                                                <label><%# ShareClass. GetStatusHomeNameByTaskStatus(Eval("Status").ToString()) %></label>
                                                                            </div>

                                                                        </div>


                                                                    </ItemTemplate>

                                                                </asp:TemplateColumn>
                                                            </Columns>

                                                            <EditItemStyle BackColor="#2461BF" />

                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />


                                                            <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                        </asp:DataGrid><asp:Label ID="LB_Sql1" runat="server" Visible="False"></asp:Label>

                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </cc2:TabPanel>
                                <cc2:TabPanel ID="TabPanel2" runat="server" HeaderText="分配的任务">
                                    <HeaderTemplate>
                                        <asp:Label ID="Label68" runat="server" Text="<%$ Resources:lang,YCLDMFPDRW%>" ToolTip="<%$ Resources:lang,YCLDMFPDRW%>"></asp:Label>
                                    </HeaderTemplate>
                                    <ContentTemplate>
                                        <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                            <tr>

                                                <td>

                                                    <div class="napbox">
                                                        <div class="npb">
                                                            <div class="cline"></div>
                                                            <h3>
                                                                <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,MeiFeiPaiDe%>" /></h3>
                                                        </div>


                                                        <asp:DataGrid ID="DataGrid2" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                            ShowHeader="False" CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px"
                                                            OnPageIndexChanged="DataGrid2_PageIndexChanged" PageSize="5" Width="100%">

                                                            <Columns>

                                                                <%--  <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTAppTaskDetail.aspx?ID={0}"
                                                            DataTextField="Operation" HeaderText="受理人的工作">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="28%" />
                                                        </asp:HyperLinkColumn>--%>

                                                                <asp:TemplateColumn HeaderText="">

                                                                    <ItemTemplate>

                                                                        <div class="npb npbs">
                                                                            <div class="nplef">
                                                                                <img src="ImagesSkin/napicon.png" />
                                                                            </div>
                                                                            <div class="nprig">
                                                                                <h4><a href="TTAppTaskDetail.aspx?ID=<%# Eval("ID").ToString() %>"><%# Eval("ID").ToString() %>  <%# Eval("Operation") %></a></h4>
                                                                                <h5><%# Eval("assignmanname").ToString() %><sub></sub></h5>
                                                                                <h6><%# DataBinder.Eval(Container.DataItem,"begindate") %> --- <%# DataBinder.Eval(Container.DataItem,"enddate") %>  </h6>
                                                                                <label><%# ShareClass. GetStatusHomeNameByTaskStatus(Eval("Status").ToString()) %></label>
                                                                            </div>

                                                                        </div>


                                                                    </ItemTemplate>

                                                                </asp:TemplateColumn>
                                                            </Columns>

                                                            <EditItemStyle BackColor="#2461BF" />

                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />


                                                            <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                        </asp:DataGrid><asp:Label ID="LB_Sql2" runat="server" Visible="False"></asp:Label>

                                                    </div>


                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </cc2:TabPanel>
                            </cc2:TabContainer>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 100%;">
                            <table style="width: 100%;" cellpadding="0" cellspacing="0">

                                <tr>
                                    <td>

                                        <div class="napbox">
                                            <div class="npb">
                                                <div class="cline"></div>
                                                <h3>
                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,YiChuLiBinYiFenPaiDe%>" /></h3>
                                            </div>


                                            <asp:DataGrid ID="DataGrid5" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                CellPadding="4" Font-Bold="False" ForeColor="#333333" GridLines="None" Height="1px"
                                                ShowHeader="False" OnPageIndexChanged="DataGrid5_PageIndexChanged" PageSize="5"
                                                Width="100%">

                                                <Columns>
                                                    <%--<asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTAppTaskDetail.aspx?ID={0}"
                                                DataTextField="Operation" HeaderText="受理人的工作">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="28%" />
                                            </asp:HyperLinkColumn>--%>

                                                    <asp:TemplateColumn HeaderText="">

                                                        <ItemTemplate>

                                                            <div class="npb npbs">
                                                                <div class="nplef">
                                                                    <img src="ImagesSkin/napicon.png" />
                                                                </div>
                                                                <div class="nprig">
                                                                    <h4><a href="TTAppTaskDetail.aspx?ID=<%# Eval("ID").ToString() %>"><%# Eval("ID").ToString() %>  <%# Eval("Operation") %></a></h4>
                                                                    <h5><%# Eval("assignmanname").ToString() %><sub></sub></h5>
                                                                    <h6><%# DataBinder.Eval(Container.DataItem,"begindate") %> --- <%# DataBinder.Eval(Container.DataItem,"enddate") %>  </h6>
                                                                    <label><%# ShareClass. GetStatusHomeNameByTaskStatus(Eval("Status").ToString()) %></label>
                                                                </div>

                                                            </div>

                                                        </ItemTemplate>

                                                    </asp:TemplateColumn>
                                                </Columns>

                                                <EditItemStyle BackColor="#2461BF" />

                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />


                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                            </asp:DataGrid><asp:Label ID="LB_Sql5" runat="server" Visible="False"></asp:Label>

                                        </div>


                                    </td>
                                </tr>

                                <tr>
                                    <td>


                                        <div class="napbox">
                                            <div class="npb">
                                                <div class="cline"></div>
                                                <h3>
                                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,FenPaiGuDe%>" /></h3>
                                            </div>


                                            <asp:DataGrid ID="DataGrid3" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                ShowHeader="false" CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px"
                                                OnPageIndexChanged="DataGrid3_PageIndexChanged" PageSize="5" Width="100%">

                                                <Columns>
                                                    <%--<asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTAppTaskDetail.aspx?ID={0}"
                                                DataTextField="Operation" HeaderText="我的工作">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="28%" />
                                            </asp:HyperLinkColumn>--%>

                                                    <asp:TemplateColumn HeaderText="">

                                                        <ItemTemplate>

                                                            <div class="npb npbs">
                                                                <div class="nplef">
                                                                    <img src="ImagesSkin/napicon.png" />
                                                                </div>
                                                                <div class="nprig">
                                                                    <h4><a href="TTAppTaskDetail.aspx?ID=<%# Eval("ID").ToString() %>"><%# Eval("ID").ToString() %>  <%# Eval("Operation") %></a></h4>
                                                                    <h5><%# Eval("assignmanname").ToString() %><sub></sub></h5>
                                                                    <h6><%# DataBinder.Eval(Container.DataItem,"begindate") %> --- <%# DataBinder.Eval(Container.DataItem,"enddate") %>  </h6>
                                                                    <label><%# ShareClass. GetStatusHomeNameByTaskStatus(Eval("Status").ToString()) %></label>
                                                                </div>

                                                            </div>


                                                        </ItemTemplate>

                                                    </asp:TemplateColumn>
                                                </Columns>

                                                <EditItemStyle BackColor="#2461BF" />

                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />


                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                            </asp:DataGrid><asp:Label ID="LB_Sql3" runat="server" Visible="False"></asp:Label>

                                        </div>



                                    </td>
                                </tr>


                                <tr>
                                    <td>

                                        <div class="napbox">
                                            <div class="npb">
                                                <div class="cline"></div>
                                                <h3>
                                                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ChuangJianDe%>" /></h3>
                                            </div>


                                            <asp:DataGrid ID="DataGrid4" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                OnPageIndexChanged="DataGrid4_PageIndexChanged" ShowHeader="false" Width="100%"
                                                Height="1px" CellPadding="4" ForeColor="#333333" GridLines="None">

                                                <Columns>
                                                    <%--<asp:HyperLinkColumn DataNavigateUrlField="TaskID" DataNavigateUrlFormatString="TTAppCreateProjectTaskDetail.aspx?TaskID={0}"
                                                    DataTextField="Task" HeaderText="任务内容">
                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="18%" />
                                                </asp:HyperLinkColumn>--%>

                                                    <asp:TemplateColumn HeaderText="">

                                                        <ItemTemplate>

                                                            <div class="npb npbs">
                                                                <div class="nplef">
                                                                    <img src="ImagesSkin/napicon.png" />
                                                                </div>
                                                                <div class="nprig">
                                                                    <h4><a href="TTAppCreateProjectTaskDetail.aspx?TaskID=<%# Eval("TaskID").ToString() %>"><%# Eval("TaskID").ToString() %><%# Eval("Task") %></a></h4>
                                                                    <h5><%# Eval("finishpercent").ToString() %>%<sub></sub></h5>
                                                                    <h6><%# DataBinder.Eval(Container.DataItem,"makedate") %></h6>
                                                                    <label><%# ShareClass. GetStatusHomeNameByTaskStatus(Eval("Status").ToString()) %></label>
                                                                </div>

                                                            </div>


                                                        </ItemTemplate>

                                                    </asp:TemplateColumn>
                                                </Columns>

                                                <EditItemStyle BackColor="#2461BF" />

                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />


                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                            </asp:DataGrid>
                                            <asp:Label ID="LB_Sql4" runat="server" Visible="False"></asp:Label>
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
</body>
<%--<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>
