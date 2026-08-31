<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTDocumentTypeSet.aspx.cs" Inherits="TTDocumentTypeSet" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1100px;
            width: expression (document.body.clientWidth <= 1100? "1100px" : "auto" ));
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { if (top.location != self.location) { } else { CloseWebPage(); }

            

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
                    <div id="AboveDiv">
                        <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
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
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,WenDangLeiXingSheZhi%>"></asp:Label>
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
                                <td>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="220px" valign="top" style="padding: 5px 5px 5px 5px; border-right: solid 1px #d0d0d0"
                                                class="ItemAlignLeft">
                                                <table width="220px" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td style="width: 220px; text-align: left;">
                                                            <asp:TreeView ID="TreeView1" runat="server" NodeWrap="True" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged"
                                                                Width="220px" ShowLines="True" Font-Size="10pt" Font-Bold="False" Font-Names="ËÎÌו">
                                                                <RootNodeStyle CssClass="rootNode" /><NodeStyle CssClass="treeNode" /><LeafNodeStyle CssClass="leafNode" /><SelectedNodeStyle CssClass="selectNode" ForeColor ="Red" />
                                                            </asp:TreeView>
                                                           
                                                            <asp:Label ID="LB_UserCode" runat="server"  Visible="False"></asp:Label>
                                                          
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td valign="top" style="padding: 40px 5px 5px 5px">
                                                <table class="ItemAlignLeft" style="width: 98%;">
                                                    <tr>
                                                        <td style="background: #F0F0F0; width: 100%; text-align: left;">
                                                            <table style="width: 99%; height: 12px;">
                                                                <tr>
                                                                    <td width="90px" style="text-align: left;">
                                                                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,JieHaoDian%>"></asp:Label>:<asp:Label ID="LB_DocTypeID" runat="server">0</asp:Label>
                                                                    </td>
                                                                    <td width="80px" align="right">
                                                                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>:
                                                                    </td>
                                                                    <td width="200px" class="ItemAlignLeft">
                                                                        <asp:TextBox ID="TB_DocType" runat="server" Width="200px"></asp:TextBox>
                                                                    </td>
                                                                    <td width="90px" align="right"><span style="font-size: 10pt">
                                                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,QuanXian%>"></asp:Label>:</span></td>
                                                                    <td width="120px">
                                                                        <span style="font-size: 10pt">
                                                                            <asp:DropDownList ID="DL_Authority" runat="server" AutoPostBack="True" CssClass="DDList" DataTextField="HomeName" DataValueField="GroupName" >
                                                                            </asp:DropDownList>
                                                                        </span></td>

                                                                    <td width="60px" align="right">
                                                                        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,ShunXu%>"></asp:Label>: 
                                                                    </td>
                                                                    <td width="50px" class="ItemAlignLeft">
                                                                        <NickLee:NumberBox ID="NB_DocTypeSoft" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Precision="0" Width="40px">00</NickLee:NumberBox>
                                                                    </td>


                                                                       <td class="ItemAlignLeft">
                                                                         <asp:Button ID="BT_NewDocType" runat="server" CssClass="inpu" Height="21px" OnClick="BT_NewDocType_Click" Text="<%$ Resources:lang,ZengJiaZiJieDian%>" />
 &nbsp;&nbsp;
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="background: #F0F0F0; width: 100%; text-align: left;">
                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                    </td>
                                                                    <td>
                                                                       <asp:Button ID="BT_UpdateDocType" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_UpdateDocType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                                        &nbsp;&nbsp;
                                                                        <asp:Button ID="BT_DeleteDocType" runat="server" CssClass="inpu" Enabled="False" OnClick="BT_DeleteDocType_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                                                    </td>
                                                                    <td width="6" align="right">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            &nbsp;&nbsp;
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                            </tr>
                        </table>
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
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script></html>

