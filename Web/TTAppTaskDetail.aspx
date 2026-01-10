<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppTaskDetail.aspx.cs" Inherits="TTAppTaskDetail" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
      <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>

    <script type="text/javascript" language="javascript">
        $(function () { initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能

           <%-- var MustInFrame = '<%=Session["MustInFrame"].ToString() %>'.trim();
            if (MustInFrame == 'YES') {
                 /*  if (top.location != self.location) { } else { CloseWebPage(); }*/
            }--%>

        });
    </script>
</head>
<body><div id="swipeFeedback" class="swipe-feedback"><asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" /></div> <!-- 滑动反馈层 -->
    <form id="form1" runat="server" >
    <div>
    
    </div>
    </form>
</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>

</html>
