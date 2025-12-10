<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTTakeTopMFChartViewJS.aspx.cs" Inherits="WFDesigner_TTTakeTopMFChartViewJS" %>

<%--<%@ OutputCache Duration="2678400" VaryByParam="*" %>--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" href="lib/jquery-ui-1.8.4.custom/css/smoothness/jquery-ui-1.8.4.custom.css"
        rel="stylesheet" />

    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            text-align: left;
            font-family: Arial, sans-serif, Helvetica, Tahoma;
            font-size: 12px;
            line-height: 1.5;
            color: black;
            background-image: url(img/Backgroud.jpg);
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .node {
            width: 70px;
            text-align: center;
            vertical-align: middle;
            border: 1px solid #fff;
        }

        .mover {
            border: 1px solid #ddd;
            background-color: #ddd;
        }

        .selected {
            background-color: #ddd;
        }

        .state {
        }

        #TakeTopFlow_props table {
        }

        #TakeTopFlow_props th {
            letter-spacing: 2px;
            text-align: left;
            padding: 6px;
            background: #ddd;
        }

        #TakeTopFlow_props td {
            background: #fff;
            padding: 6px;
        }

        #pointer {
            background-repeat: no-repeat;
            background-position: center;
        }

        #path {
            background-repeat: no-repeat;
            background-position: center;
        }

        #task {
            background-repeat: no-repeat;
            background-position: center;
        }

        #state {
            background-repeat: no-repeat;
            background-position: center;
        }

        .context-menu {
            display: none;
            position: absolute;
            background-color: white;
            border: 1px solid gray;
            padding: 5px;
            z-index: 9999;
        }

            .context-menu a {
                display: block;
                padding: 5px;
                text-decoration: none;
                color: black;
            }

                .context-menu a:hover {
                    background-color: #f5f5f5;
                }

        /* 新增样式：右上角设置按钮 */
        .settings-button {
            position: fixed;
            top: 10px;
            right: 10px;
            width: 21px;
            height: 21px;
            cursor: pointer;
            z-index: 1000;
        }
    </style>

    <link type="text/css"
        href="lib/jquery-ui-1.8.4.custom/css/smoothness/jquery-ui-1.8.4.custom.css"
        rel="stylesheet" />
    <script type="text/javascript"
        src="lib/jquery-ui-1.8.4.custom/js/jquery-1.4.2.min.js"></script>
    <script type="text/javascript"
        src="lib/jquery-ui-1.8.4.custom/js/jquery-ui-1.8.4.custom.min.js"></script>

    <script type="text/javascript" src="lib/jquery-ui-1.8.4.custom/js/jquery-ui-1.8.4.custom.min.js"></script>
    <script type="text/javascript" src="lib/TakeTopFlowBase.js"></script>
    <script type="text/javascript" src="TakeTopModuleFlowView.js"></script>
    <script type="text/javascript" src="TakeTopModuleFlow.jpdtd.js"></script>
    <script type="text/javascript" src="TakeTopModuleFlow.editors.js"></script>

    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) {
                // 在iframe中，立即加载图形
                loadChartImmediately();
            } else {
                CloseWebPage();
            }
        });

        function loadChartImmediately() {
            // 立即加载工作流图形
            LoadWFChart();
            displayProcessing('NONE');

            // 延迟调整尺寸以确保图形完全加载
            setTimeout(function () {
                displayScroll();
            }, 500);
        }

        function displayScroll() {
            resizeSvg("auto");
            var svgs = this.document.getElementsByTagName("svg");
            this.document.getElementById("TakeTopFlow").style.width = svgs[0].style.width;
            document.getElementById("TakeTopFlow").style.overflow = "auto";
        }

        function hideScroll() {
            this.document.getElementById("TakeTopFlow").style.width = "100%";
            document.getElementById("TakeTopFlowe").style.overflow = "hidden";
        }

        function resizeSvg(varSvgStatus) {
            var svgs = this.document.getElementsByTagName("svg");
            for (i = 0; i < svgs.length; i++) {
                svgs[i].style.height = "2148px";
                svgs[i].style.overflow = varSvgStatus;
                var maxX = findMaxXOfChildRects(svgs[i]);
                svgs[i].style.width = (maxX + 216) + "px";
            }
        }

        //取得rect的最大x值
        function findMaxXOfChildRects(parentElement) {
            let maxX = 0;
            const childElements = parentElement.querySelectorAll('*');
            childElements.forEach(child => {
                const rect = child.getBoundingClientRect();
                if (rect.x > maxX) {
                    maxX = rect.x;
                }
            });
            return maxX;
        }

        function printDiv(obj) {
            var newWindow = window.open("Print Window", "_blank");
            var docStr = obj.innerHTML;
            newWindow.document.write(docStr);
            newWindow.document.close();
            newWindow.print();
            newWindow.close();
        }

        function displayProcessing(varStatus) {
            parent.parent.parent.window.document.getElementById("loading").style.display = varStatus;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divMFDesign" runat="server" class="settings-button">
            <img src="img/Set.jpg" alt="Design" width="21px" height="21px" />
        </div>

        <div id="TakeTopFlow_tools"
            style="top: 10; right: 10; background-color: #fff; width: 21px; cursor: default; padding: 3px; display: none;"
            class="ui-widget-content">
            <div class="node print" id="TakeTopFlow_print" onclick="printDiv(document.getElementById('TakeTopFlow'))" style="width: 21px; height: 21px;">
                <img src="img/print.png" alt="Print" width="21px" height="21px" />
            </div>
        </div>

        <div id="TakeTopFlow" style="padding-top: 0px; text-align: center;" onmousemove="javascript:displayScroll();">
        </div>

        <%------右键菜单------%>
        <div id="contextMenu" class="context-menu">
            <!-- Context menu items will be dynamically added here -->
        </div>
    </form>

</body>
</html>