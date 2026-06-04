<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTProRelatedTaskView.aspx.cs"
    Inherits="TTProRelatedTaskView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }



        });


        function preview1() {
            bdhtml = window.document.body.innerHTML;
            sprnstr = "<!--startprint1-->";
            eprnstr = "<!--endprint1-->";
            prnhtml = bdhtml.substr(bdhtml.indexOf(sprnstr) + 18);
            prnhtml = prnhtml.substring(0, prnhtml.indexOf(eprnstr));
            window.document.body.innerHTML = prnhtml;
            window.print();
            document.body.innerHTML = bdhtml;
            return false;
        }


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
                                                        <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                    </td>
                                                    <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XiangMuRenWu%>"></asp:Label>
                                                    </td>
                                                    <td width="5">
                                                        <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="right">
                                            <a href="#" onclick="preview1()">
                                                <img src="ImagesSkin/print.gif" alt="打印" border="0" />
                                            </a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" align="center">
                                <!--startprint1-->
                                <table style="width: 800px;">
                                    <tr>
                                        <td style="width: 100%; height: 80px; font-size: xx-large; text-align: center;">
                                            <br />
                                            <strong>
                                                <asp:Label ID="LB_ReportName" runat="server"></asp:Label>
                                            </strong>
                                            <br />
                                            <br />
                                            <br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center">
                                            <iframe runat="server" id="IFrame_Chart1" src="TTTakeTopAnalystChartSet.aspx" style="width: 800px; height: 295px; border: 1px solid white; overflow: hidden;"></iframe>


                                            <%--<asp:Chart ID="Chart1" Width="980px" runat="server">
                                                <Series>
                                                    <asp:Series Name="Series1" ChartType="Pie" ChartArea="ChartArea1" Legend="Legend1"></asp:Series>
                                                </Series>
                                                <ChartAreas>
                                                    <asp:ChartArea Name="ChartArea1" AlignmentOrientation="Horizontal"></asp:ChartArea>
                                                </ChartAreas>
                                                <Legends>
                                                    <asp:Legend Name="Legend1">
                                                        <CellColumns>
                                                            <asp:LegendCellColumn Name="Column2">
                                                                <Margins Left="15" Right="15" />
                                                            </asp:LegendCellColumn>
                                                            <asp:LegendCellColumn ColumnType="SeriesSymbol" Name="Column3">
                                                                <Margins Left="15" Right="15" />
                                                            </asp:LegendCellColumn>
                                                        </CellColumns>
                                                    </asp:Legend>
                                                </Legends>
                                                <Titles>
                                                    <asp:Title Name="标题" Alignment="TopCenter" IsDockedInsideChartArea="False" DockedToChartArea="ChartArea1"></asp:Title>
                                                </Titles>
                                            </asp:Chart>--%>
                                        </td>
                                    </tr>
                                </table>

                                <table style="width: 90%;" cellpadding="5" cellspacing="5">
                                    <tr>
                                        <td>
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
                                                                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="8%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="15%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,RenWu%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="10%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,YouXianJi%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="5%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="10%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,KaiShiShiJian%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="10%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,JieShuShiJian%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="100px" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,JinDu%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="5%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,YuSuan%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="5%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,GongShi2%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="5%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,FeiYong%>"></asp:Label></strong>
                                                                </td>
                                                                <td width="8%" class="ItemAlignLeft">
                                                                    <strong>
                                                                        <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,ShiJiGongShi%>"></asp:Label></strong>
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
                                            <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False"
                                                ShowHeader="false" Height="1px"
                                                Width="100%" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                <Columns>
                                                    <asp:BoundColumn DataField="TaskID" HeaderText="Number">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Type" HeaderText="Type">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="8%" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Task" HeaderText="Task">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="15%" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Priority" HeaderText="优先级">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                    </asp:BoundColumn>
                                                    <asp:TemplateColumn HeaderText="Status">
                                                        <ItemTemplate>
                                                            <%# ShareClass. GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                        </ItemTemplate>
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="5%" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                    </asp:BoundColumn>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <div style="position: relative; height: 25px; width: 100px; overflow: hidden;">
                                                                <!-- 黄色底层背景 -->
                                                                <div style="position: absolute; top: 0; left: 0; width: 100px; height: 25px; background-color: #eceff1; z-index: 1;"></div>

                                                                <!-- 绿色进度条背景 - 新增控件 -->
                                                                <div id="ProgressBar1" runat="server" style="position: absolute; top: 0; left: 0; height: 25px; background-color: #78909c; z-index: 2; max-width: 100px; overflow: hidden;"></div>

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
                                                    <asp:BoundColumn DataField="Budget" HeaderText="Budget">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ManHour" HeaderText="LaborHours">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Expense" HeaderText="Expense">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="RealManHour" HeaderText="实际工时">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="8%" />
                                                    </asp:BoundColumn>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.TaskID", "TTDocumentTreeView.aspx?RelatedType=ProjectTask&RelatedID={0}") %>'
                                                                Target="_blank"><img src ="ImagesSkin/Doc.gif" class="noBorder" /></asp:HyperLink>
                                                        </ItemTemplate>
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                    </asp:TemplateColumn>

                                                </Columns>
                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                <EditItemStyle BackColor="#2461BF" />
                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                <ItemStyle CssClass="itemStyle" />
                                            </asp:DataGrid>
                                            <asp:Label ID="LB_ProjectID" runat="server" Visible="False"></asp:Label>
                                            <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
                                            <asp:Label ID="LB_Sql" runat="server" Visible="False"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100%; height: 9px; text-align: left">
                                            <span><strong>
                                                <asp:Label ID="LB_TaskName" runat="server" Font-Bold="False"
                                                    Visible="False"></asp:Label></strong></span>
                                        </td>
                                    </tr>

                                </table>

                                <!--endprint1-->
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
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
