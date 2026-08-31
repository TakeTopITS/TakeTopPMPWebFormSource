<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTPersonalSpaceModuleFlowView.aspx.cs" Inherits="TTPersonalSpaceModuleFlowView" %>

<%@ OutputCache Duration="2678400" VaryByParam="*" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Repeater ID="RP_iframeModuleFlow" runat="server">
            <ItemTemplate>

                <iframe id="iframeModuleFlow" src="TTModuleFlowChartViewJS.aspx?Type=UserModule&IdentifyString=<%# DataBinder.Eval(Container.DataItem,"ID") %>" style="width: 100%; height: 315px; border: 0px solid white; overflow: hidden;"></iframe>

            </ItemTemplate>
        </asp:Repeater>
        <asp:Literal ID="litIframeModuleFlowHTML" runat="server"></asp:Literal>
    </form>
</body>
</html>

