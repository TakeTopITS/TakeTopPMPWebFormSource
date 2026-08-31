<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppWorkFlowDetailMainUpDown.aspx.cs" Inherits="TTAppWorkFlowDetailMainUpDown" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
      <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />
  

    <script type="text/javascript">
        var preFrameW = "180px";
        var FrameHide = 0;

        var way;

        function ChangeMenu(way) {

            //alert(this.document.getElementById("divRight").style.height);

            if (FrameHide == 0) {
                preFrameW = this.document.getElementById("divRight").style.height;

                if (preFrameW != "80%") {

                    this.document.getElementById("divRight").style.height = "80%";
                    this.document.getElementById("divLeft").style.height = "180px";

                    FrameHide = 1;
                    return;
                }
                else {

                    this.document.getElementById("divRight").style.height = "180px";
                    this.document.getElementById("divLeft").style.height = "80%";

                    FrameHide = 1;
                    return;
                }
            } else {

                this.document.getElementById("divRight").style.height = "80%";
                this.document.getElementById("divLeft").style.height = "180px";

                FrameHide = 0;
                return;
            }
        }

        function NoChangeMenu(way) {

            preFrameW = this.document.getElementById("divRight").style.height;

            if (preFrameW == "80%") {

                this.document.getElementById("divRight").style.height = "80%";
                this.document.getElementById("divLeft").style.height = "180px";

                FrameHide = 1;
                return;
            }

            if (preFrameW == "180px") {

                this.document.getElementById("divRight").style.height = "180px";
                this.document.getElementById("divLeft").style.height = "80%";

                FrameHide = 1;
                return;
            }

        }
    </script>
</head>
<body onmousemove="NoChangeMenu(0);">

    <div id="divLeft" style="width: 100%; height: 180px; overflow-y: auto;">
        <iframe id="left" name="left" style="width: 100%; height: 100%;"  class="bian"  src="TTAppWorkFlowDetail.aspx?ID=<%=Request.QueryString["ID"].ToString()%>"></iframe>
        <a id="A_LRArrow" name="A_LRArrow" style="display: none;" onclick="javascript:ChangeMenu(0);"></a>
    </div>

    <div id="divRight" style="width: 100%; height: 80%;">
        <iframe id="right" name="right" style="width: 100%; height: 100%;"  class="bian"  src="TTWorkFlowDetailData.aspx?ID=<%=Request.QueryString["ID"].ToString()%>"></iframe>
    </div>

</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>

</html>
