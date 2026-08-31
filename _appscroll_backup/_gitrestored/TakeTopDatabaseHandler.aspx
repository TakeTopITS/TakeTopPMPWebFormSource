<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TakeTopDatabaseHandler.aspx.cs" Inherits="TakeTopDatabaseHandler" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <iframe id="IF_DBUpgrade" src="TakeTopDBUpgrade.aspx" runat="server">Upgrade Database,please wait...
            </iframe>
        </div>
    </form>
</body>
</html>
